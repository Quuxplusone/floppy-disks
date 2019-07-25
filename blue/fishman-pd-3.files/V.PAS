
PROGRAM VolleyBall;

{$I standard.lib}

{
                                                |
                11 pxls wide                    |
                 |     o                        | 120 pxls high
                 v           | <-- 40 pxls high |
                ===          |     ===          |
              ----------------------------------|
               10..150           170..310

}

var
  BallHoriz : INTEGER;
  BallVert  : INTEGER;
  BallHSpeed: INTEGER;
  BallVSpeed: INTEGER;
  CPaddlePos: INTEGER;
  UPaddlePos: INTEGER;
  Command   : CHAR;
  Time      : INTEGER;
  WinCondition : (Win, Lose, Quit, No);

const Count : INTEGER = 50;
   SubCount : INTEGER = 25;
      Grav  : BYTE = 1;
      Power : BYTE = 4;
   PadWidth : BYTE = 27;
  NetHeight : BYTE = 40;
   BallSize : BYTE = 4;
       Step : BYTE = 3;

PROCEDURE WriteNet; FORWARD;
PROCEDURE WriteScreen(N:BYTE); FORWARD;

PROCEDURE DoHelp;
  BEGIN
    GraphMode;
    ColorWriteFile('vollhelp.txt');
    WaitForKeyPressed;
    Command:=' ';
    GraphMode;
    WriteNet;
    WriteScreen(1);
  END;

PROCEDURE ChangeStats;
var T:BYTE;
    C:CHAR;
  BEGIN
    TextMode;
    ClrScr;
    TextColor(7);
    REPEAT
      T:=255; Write('   Grav: ',Grav,' .> ');
      ReadLN(T); IF T<255 THEN Grav:=T;
      T:=0; Write('  Power: ',Power,' .> ');
      ReadLN(T); IF T>0 THEN Power:=T;
      T:=0; Write('  Width: ',PadWidth,' .> ');
      ReadLN(T); IF T>0 THEN PadWidth:=T;
      T:=0; Write('    Net: ',NetHeight,' .> ');
      ReadLN(T); IF T>0 THEN NetHeight:=T;
      T:=0; Write('   Ball: ',BallSize,' .> ');
      ReadLN(T); IF T>0 THEN BallSize:=T;
      T:=0; Write('   Step: ',Step,' .> ');
      ReadLN(T); IF T>0 THEN Step:=T;
      WriteLN(' Changes accepted: ',Grav,' ',Power,' ',PadWidth,' ',NetHeight,
              ' ',BallSize,' ',Step);
      Write(' Are these correct (y/n)? .> ');
      ReadLN(C);
    UNTIL UpCase(C)='Y';
    GraphMode;
    Command:=' ';
    WriteNet;
    WriteScreen(1);
  END;

PROCEDURE InitVars;
  BEGIN
    Command:=' ';
    CPaddlePos:=50;
    UPaddlePos:=210;
    BallHoriz:=100;
    BallVert:=51;
    BallHSpeed:=-4;
    BallVSpeed:=2;
    Time:=0;
    WinCondition:=No;
  END;

PROCEDURE TranslateCommand;
  BEGIN
    CASE UpCase(Command) OF
      'A','Z','4','K' : Command:='L';
      'D','X','6','M' : Command:='R';
      'Q',''         : WinCondition:=Quit;
      'H',';','?'     : Command:='H';
      '<' {F2}        : Command:='C';
      END;
  END;

PROCEDURE GetCommand;
  BEGIN
    REPEAT
      Time:=Time+1;
      Delay(1);
    UNTIL (Time mod SubCount=0) or (KeyPressed);
    IF Time=Count THEN Time:=0;
    IF KeyPressed THEN
      BEGIN
        Read(KBD,Command);
        IF KeyPressed THEN Read(KBD,Command);
        TranslateCommand;
      END;
  END;

PROCEDURE ActOnIt;
  BEGIN
    CASE Command OF
      'L' : IF UPaddlePos-Step>170 THEN UPaddlePos:=UPaddlePos-Step
              ELSE UPaddlePos:=170;
      'R' : IF UPaddlePos+Step<310 THEN UPaddlePos:=UPaddlePos+Step
              ELSE UPaddlePos:=310;
      'H' : DoHelp;
      'C' : ChangeStats;
      END;
  END;

PROCEDURE BounceBall(PadNum:INTEGER);
  BEGIN
    BallHSpeed:= BallHSpeed + PadNum * Power div 2;
    BallVSpeed:= -1 * BallVSpeed div 2 + 2*Power;
  END;

PROCEDURE MoveBall;
  BEGIN
    BallVSpeed:=BallVSpeed-Grav;
    BallVert:=BallVert+BallVSpeed;
    BallHoriz:=BallHoriz+BallHSpeed;
    IF BallVert < 1 THEN                {below paddles}
      BEGIN
        IF abs(BallHoriz-CPaddlePos) < (PadWidth div 2) THEN
          BounceBall(BallHoriz-CPaddlePos)
        ELSE IF abs(BallHoriz-UPaddlePos) < (PadWidth div 2) THEN
               BounceBall(BallHoriz-UPaddlePos)
        ELSE IF BallHoriz<160 THEN WinCondition:=Win
        ELSE WinCondition:=Lose;
      END;
    IF (BallHoriz-BallHSpeed<160)=(BallHoriz>160) THEN {ball has crossed net}
      IF BallVert<NetHeight THEN                       {ball hits net}
        BEGIN
          IF BallHSpeed>0 THEN WinCondition:=Win
          ELSE WinCondition:=Lose;
        END;
    IF (BallHoriz<1) or (BallHoriz>320) THEN           {ball bounces off wall}
      BEGIN
        BallHSpeed := -1*BallHSpeed div 2;
        IF BallHoriz<1 THEN BallHoriz:=1 ELSE BallHoriz:=320;
      END;
    IF BallVert>120 THEN BallVSpeed:=0;                  {bounces off ceiling}
  END;

PROCEDURE MoveCPaddle; {currently linked to UPaddlePos}
  BEGIN
    CPaddlePos:=UPaddlePos-160;
  END;

PROCEDURE WriteScreen;  {N:BYTE}
var LCV:BYTE;
  BEGIN

      {write paddles}

    Draw(UPaddlePos-PadWidth div 2, 170, UPaddlePos+PadWidth div 2, 170, 1*N);
    Draw(CPaddlePos-PadWidth div 2, 170, CPaddlePos+PadWidth div 2, 170, 1*N);

      {write ball}

    FOR LCV:=1 TO 24 DO
      Plot(BallHoriz + trunc(BallSize*cos(LCV/12*PI)),
           170-BallVert + trunc(BallSize*sin(LCV/12*PI)), 2*N);
  END;

PROCEDURE WriteNet;
  BEGIN
    Draw(160,170,160,170-NetHeight, 3);
  END;

PROCEDURE TitleScreen;
  BEGIN
    GraphMode;
    WriteLN;
    WriteLN;
    WriteLN;
    TextColor(1);
    WriteLN(' M    M   MM    MMMM MMMMM MMMMM MMMM');
    WriteLN(' MM  MM  M  M  M       M   M     M   M');
    WriteLN(' M MM M M    M  MMM    M   MMMM  MMMM');
    WriteLN(' M    M MMMMMM     M   M   M     M   M');
    WriteLN(' M    M M    M MMMM    M   MMMMM M   M');
    WriteLN;
    WriteLN('  # # ### #  #  ### # # ##   #  #  #');
    WriteLN('  # # # # #  #  ##   #  ### ### #  #');
    WriteLN('   #  ### ## ## ###  #  ### # # ## ##');
    TextColor(3);
    WriteLN;
    WriteLN;
    WriteLN('          Beta Version 2.0');
    WriteLN('    Programming by Arthur O''Dwyer');
    WriteLN('          29 September 1999');
    WriteLN;
    WriteLN(' Press <F1> for help during the game.');
    WaitForKeyPressed;
  END;

PROCEDURE DoGame;
  BEGIN
    WriteNet;
    REPEAT
      WriteScreen(1);
      GetCommand;
      WriteScreen(0); {erase screen}
      ActOnIt;
      IF Time=0 THEN
        MoveBall;
      IF Time mod SubCount=0 THEN
        MoveCPaddle;
    UNTIL WinCondition<>No;
    TextMode;
  END;

FUNCTION Again:BOOLEAN;
var C:CHAR;
  BEGIN
    ClrScr;
    WriteLN;
    WriteLN;
    WriteLN;
    TextColor(7);
    CASE WinCondition OF
      Win  : WriteLN(' You have lost!');
      Lose : WriteLN(' You have lost!');
      Quit : WriteLN(' You have quit the game.');
    END {case};
    WriteLN;
    WriteLN;
    Write(' Would you like to try again? .> ');
    ReadLN(C);
    IF UpCase(C)='Y' THEN Again:=TRUE
      ELSE Again:=FALSE;
  END;


BEGIN
  TitleScreen;
  REPEAT
    InitVars;
    GraphMode;
    DoGame;
  UNTIL not Again;
  ClrScr;
END.

