PROGRAM DragonFlight_Game;

{$I standard.lib}

type
  SpriteType = (UpFlap, MidFlap, DownFlap,  {flying}
                Run1, Run2, Run3, Run4, Run5, Run6, {running}
                Jump, {transition}
                Still, Dead);
  DPtr   = ^Debris;
  Debris = record
    X,Y : BYTE;
    Typ : (Good, Bad);
    Next: DPtr;
  end {record};

var Deb1   : DPtr;       {first debris ptr}
  Height   : BYTE;       {dragon altitude}
  Health   : BYTE;       {dragon health}
  Sprite   : SpriteType; {current sprite}
  Command  : CHAR;
  T        : BYTE;       {number of ticks since last update}
  Ground   : String[70]; {ground ( ~'"`'~'`'~'~' )}
  Moving   : BOOLEAN;    {true if running, or flying from a running start}

const
  SprArr   : array[SpriteType,1..4] of STRING[13] =
              ( ( '   ,_       ',
                  ' .-\|(./o__ ',       {UpFlap}
                  ' _.(\`(_^^'' ',
                  '            '),
                ( '            ',
                  '`-.===./o__ ',       {MidFlap}
                  '_.(`^''(_^^'' ',
                  '            '),
                ( '            ',
                  ' -.,,-./o__ ',       {DownFlap}
                  ' _./|<(_^^'' ',
                  '    ```     '),
                ( '            ',
                  '_  .==./o__ ',       {Run1}
                  ' `-(/|(/^^'' ',
                  '  ~-''\(_    '),
                ( '   ,_       ',
                  '   \|(./o__ ',       {Run2}
                  '~`-(\`_/^^'' ',
                  '  `~\)_     '),
                ( '            ',
                  '   .==./o__ ',       {Run3}
                  '_.-(/|(/^^'' ',
                  '    )>~-    '),
                ( '   ,_       ',
                  '   \|(./o__ ',       {Run4}
                  '-..(\`(/^^'' ',
                  '   ~-"(_    '),
                ( '            ',
                  '_  .==./o__ ',       {Run5}
                  ' `-(/|(/^^'' ',
                  '   `\7~     '),
                ( '   ,_       ',
                  '   \|(./o__ ',       {Run6}
                  '~`-(\`_/^^'' ',
                  '   ./"=.    '),
                ( '   ,_       ',
                  '   \|(./o__ ',       {Jump}
                  '_.-(\`(/^^'' ',
                  '  -~'' ''     '),
                ( '            ',
                  '   /\_./o__ ',       {Still}
                  '  (/^/(_^^'' ',
                  '._.(_.)_    '),
                ( '   _    ,_  ',
                  ',..))--/(_  ',       {Dead}
                  '`~~o/-)|\''~-',
                  '       ''~   ') );


(**********************************************************************
 ***                       STARTUP PROCEDURES                       ***
 **********************************************************************)


PROCEDURE DoInstructions;
var C:CHAR;
  BEGIN
    ClrScr;
    ColorWriteFile('draginst.txt');
    WaitForKeyPressed;
  END;

PROCEDURE OpeningScreen;
var C:CHAR;
  BEGIN
    ClrScr;
    ColorWriteFile('dragopen.txt');
    WaitForKeyPressed;
    IF KeyPressed THEN
      BEGIN
        Read(KBD,C);
        IF C=';' THEN {F1 pressed so} DoInstructions;
      END;
  END;

PROCEDURE Credits;
  BEGIN
    ClrScr;
    ColorWriteFile('dragcred.txt');
    WaitForKeyPressed;
  END;

PROCEDURE Init;
  BEGIN
    Sprite:=Still;
    Moving:=FALSE;
    Height:=0;
    Deb1:=nil;
    Health:=10;
    T:=0;
  END;

PROCEDURE GetCommand;
  BEGIN;
    Command:=Chr(0);
    REPEAT
      IF KeyPressed THEN Read(KBD,Command);
      IF KeyPressed THEN Read(KBD,Command); {get significant part of esc seq}
      Delay(1);
      T:=T+1;
    UNTIL (T=166) or (Command>Chr(0));
    IF T=166 THEN T:=0;
  END;


(**********************************************************************
 ***                   DRAGON HANDLING PROCEDURES                   ***
 **********************************************************************)


PROCEDURE Flap;
  BEGIN
    IF Height<15 THEN
      CASE Sprite OF
        UpFlap   : Height:=Height+0;
        MidFlap  : Height:=Height+0;
        DownFlap : Height:=Height+1;
      END {case};
    Sprite:=UpFlap;
  END;

PROCEDURE Up;
  BEGIN
    IF (Sprite<Run1) or (Sprite=Jump) THEN Flap  {flying}
    ELSE Sprite:=Jump;                           {transition}
  END;

PROCEDURE FlapDown;
  BEGIN
    Height:=Height-1;          {come down a bit}
    IF Height=0 THEN           {if on ground then}
      IF Moving THEN
        CASE Sprite OF
          UpFlap   : Sprite:=Run1;
          MidFlap  : Sprite:=Run5;  {start running}
          DownFlap : Sprite:=Run3;
        END {case}
      ELSE Sprite:=Still
    ELSE                          {if not, coast down}
      BEGIN
        IF Sprite=UpFlap THEN
          BEGIN
            GotoXY(28,17-Height);
            Write('  ');
          END;
        Sprite:=DownFlap;
      END;
  END;

PROCEDURE Down;
  BEGIN
    CASE Sprite OF
      UpFlap     : FlapDown;
      MidFlap    : FlapDown;       {come down a bit}
      DownFlap   : FlapDown;
      Run1..Run6 : ;               {nothing happens}
      Jump       : Sprite:=Run3;   {falter in leap}
      Still      : ;               {nothing happens}
    END;
  END;

PROCEDURE Left;
  BEGIN
    CASE Sprite OF
      UpFlap..DownFlap : FlapDown;       {stall}
      Run1..Jump       : Sprite:=Still;  {stop running}
      Still            : ;               {nothing happens}
    END;
    Moving:=FALSE;
  END;

PROCEDURE Right;
  BEGIN
    CASE Sprite OF
      UpFlap..DownFlap : Flap;           {flying faster}
      Run1..Run6       : ;               {nothing happens}
      Jump             : Sprite:=Run3;   {falter in leap}
      Still            : Sprite:=Run1;   {start running}
    END;
    Moving:=TRUE;
  END;

PROCEDURE ChangeSprite;
  BEGIN
    CASE Sprite OF
      UpFlap     : BEGIN
                     Sprite:=MidFlap;         {coasting on momentum}
                     IF (Height<15) and (Moving) THEN Height:=Height+1;
                   END;
      MidFlap    : BEGIN
                     IF (Height in [4..14]) and (Moving) THEN Height:=Height+1;
                     IF Height>0 THEN
                       Sprite:=DownFlap       {finish flap}
                     ELSE Sprite:=Run1;
                   END;
      DownFlap   : BEGIN
                     Height:=Height-1;
                     IF Height<4 THEN Sprite:=MidFlap;
                     IF Height=0 THEN Sprite:=Run3;
                   END;
      Run1..Run5 : Sprite:=Succ(Sprite);      {running}
      Run6 : Sprite:=Run1;                    {running}
      Jump : BEGIN
               Sprite:=MidFlap;                 {transition to flight}
               Height:=Height+1;
               IF Moving THEN
                 BEGIN
                   Height:=Height+1;
                   GotoXY(27,21);
                   Write('     ');
                   GotoXY(35,20);
                   Write(' ');
                 END;
             END;
      {Still remains Still, of course}
    END;
    IF (not Moving) and (Sprite>DownFlap) THEN {not flying}
      Sprite:=Still;
  END;

PROCEDURE WriteSprite;
  BEGIN
    GotoXY(29,17-Height); Write('  ');
    GotoXY(25,18-Height); Write(SprArr[Sprite,1]);
    GotoXY(25,19-Height); Write(SprArr[Sprite,2]);
    GotoXY(25,20-Height); Write(SprArr[Sprite,3]);
    GotoXY(25,21-Height); Write(SprArr[Sprite,4]);
    IF Height>0 THEN
      BEGIN
        GotoXY(25,22-Height);
        Write('          ');
      END;
  END;

PROCEDURE WriteHealth;
  BEGIN
    GotoXY(75,7);
    TextColor(15);
    Write(Health:3);
  END;


(**********************************************************************
 ***                   DEBRIS HANDLING PROCEDURES                   ***
 **********************************************************************)


PROCEDURE EraseDebris(var CurPtr:DPtr);
  BEGIN
    GotoXY(CurPtr^.X, 19-CurPtr^.Y); Write('    ');
    GotoXY(CurPtr^.X+1, 18-CurPtr^.Y); Write('  ');
  END;

PROCEDURE DeleteFirst;
var CurPtr:DPtr;
  BEGIN
    EraseDebris(Deb1);
    CurPtr:=Deb1^.Next;
    Dispose(Deb1);
    Deb1:=CurPtr;
  END;

PROCEDURE GetRidOfDebris(var CurPtr:DPtr);
var WorkPtr:DPtr;
  BEGIN
    EraseDebris(CurPtr);
    WorkPtr:=Deb1;
    WHILE WorkPtr^.Next<>CurPtr DO WorkPtr:=WorkPtr^.Next;
    WorkPtr^.Next:=CurPtr^.Next;
    Dispose(CurPtr);
    CurPtr:=WorkPtr;
  END;

PROCEDURE MakeDebris;
var CurPtr:DPtr;
   LastPtr:DPtr;
  BEGIN
    IF Deb1=nil THEN
      BEGIN
        New(Deb1);
        LastPtr:=Deb1;
      END
    ELSE
      BEGIN
        LastPtr:=Deb1;
        WHILE LastPtr^.Next<>nil DO
          LastPtr:=LastPtr^.Next;
        New(LastPtr^.Next);
        LastPtr:=LastPtr^.Next;
      END;
    WITH LastPtr^ DO
      BEGIN
        X:=68;
        Y:=Random(11)+5;        { 5 through 15 }
        IF Random(10)=1 THEN Typ:=Good ELSE Typ:=Bad;
        Next:=nil;
      END;
  END;

PROCEDURE MoveDebris;
var CurPtr:DPtr;
  BEGIN
    CurPtr:=Deb1;
    WHILE CurPtr<>nil DO
      BEGIN
        CurPtr^.X:=CurPtr^.X-1;
        CurPtr:=CurPtr^.Next;
      END;
    IF (Deb1<>nil) THEN IF (Deb1^.X < 3) THEN DeleteFirst;
    IF (Random(6)=1) THEN MakeDebris;
  END;

PROCEDURE WriteDebris;
var CurPtr:DPtr;
  BEGIN
    CurPtr:=Deb1;
    WHILE CurPtr<>nil DO
      BEGIN
        GotoXY(CurPtr^.X, 19-CurPtr^.Y);
        IF CurPtr^.Typ=Bad THEN
          BEGIN
            TextColor(14);
            Write('(_) ');
          END
        ELSE
          BEGIN
            TextColor(11);
            Write('<+> ');
          END;
        GotoXY(CurPtr^.X+1, 18-CurPtr^.Y);
        Write('_ ');
        CurPtr:=CurPtr^.Next;
      END;
  END;

PROCEDURE CollisionCheckAir;
var CurPtr:DPtr;
  BEGIN
    CurPtr:=Deb1;
    WHILE CurPtr<>nil DO
      BEGIN
        IF (CurPtr^.X in [25..36]) and (abs(CurPtr^.Y - Height) < 3) THEN
          BEGIN
            IF CurPtr^.Typ=Good THEN Health:=Health+5
              ELSE Health:=Health-1;
            IF CurPtr=Deb1 THEN DeleteFirst
              ELSE GetRidOfDebris(CurPtr);
            WriteHealth;
          END;
        IF CurPtr<>nil THEN CurPtr:=CurPtr^.Next;
      END;
    WriteDebris;
  END;


(**********************************************************************
 ***                    DEATH SEQUENCE PROCEDURE                    ***
 **********************************************************************)


PROCEDURE DeathSequence;
  BEGIN
    TextColor(12);
    WriteSprite;
    TextColor(3);
    Delay(100);
    IF Sprite<=DownFlap THEN
      BEGIN
        Sprite:=DownFlap;
        REPEAT
          Height:=Height-1;
          WriteSprite;
          Delay(100);
        UNTIL Height=0;
      END
    ELSE
      BEGIN
        WriteSprite;
        Delay(100);
        GotoXY(28,18); Write('  ');
      END;
    Sprite:=Dead;
    GotoXY(25,19); Write('           ');
    GotoXY(25,20); Write(SprArr[Sprite,1]);
    GotoXY(25,21); Write(SprArr[Sprite,2]);
    GotoXY(25,22); Write(SprArr[Sprite,3]);
    GotoXY(25,23); Write(SprArr[Sprite,4]);
    Delay(500);
    GotoXY(26,11); TextColor(12);
    WriteLN('*** GAME OVER ***');
    REPEAT UNTIL KeyPressed;
  END;


(**********************************************************************
 ***                       GROUND PROCEDURES                        ***
 **********************************************************************)


PROCEDURE MakeGround;
var X:BYTE; C:CHAR;
  BEGIN
    Ground:='';
    FOR X:=1 TO 70 DO
      BEGIN
        CASE Random(5) OF
          0 : C:='''';
          1 : C:='`';
          2 : C:='"';
          3 : C:='~';
          4 : C:='^';
        END {case};
        Ground:=Ground+C;
      END;
  END;

PROCEDURE WriteGround;
var C:CHAR; X:BYTE;
  BEGIN
    IF Ground[1]='[' THEN
      BEGIN
        GotoXY(2,21); Write(' ');
      END;
    CASE Random(11) OF
      0..1 : C:='''';
      2..3 : C:='`';
      4..5 : C:='"';
      6..7 : C:='~';
      8..9 : C:='^';
      10   : C:='[';
    END {case};
    Ground:=Copy(Ground,2,69)+C;
    GotoXY(2,22);
    TextColor(2);
    FOR X:=1 TO 70 DO
      BEGIN
        IF Ground[X] in ['7','['] THEN
          TextColor(12);
        Write(Ground[X]);
        IF (Ground[X]='[') and (X<70) THEN
          BEGIN
            GotoXY(X+1,21);
            Write('i ');
            GotoXY(X+2,22);
          END;
        TextColor(2);
      END;
  END;

PROCEDURE WriteBKGround;
var X:BYTE;
  BEGIN
    ClrScr;
    TextColor(14);
    Write('.-----------------------------------');
    WriteLN('-----------------------------------.');
    FOR X:=2 TO 23 DO
      BEGIN
        Write('|');
        GotoXY(72,X);
        WriteLN('|');
      END;
    Write('`-----------------------------------');
    Write('-----------------------------------''');
    TextColor(11);
    GotoXY(74,5); Write('Health');
    TextColor(9);
    GotoXY(74,6); Write('.----.');
    GotoXY(74,7); Write('|    |');
    GotoXY(74,8); Write('`----''');
  END;

PROCEDURE CollisionCheckGround;
var X:BYTE;
  BEGIN
    FOR X:=28 TO 34 DO
      IF Ground[X]='[' THEN
        BEGIN
          Ground[X]:='7';
          GotoXY(X+3,21); Write(' ');
          Health:=Health-1;
          WriteHealth;
          WriteGround;
        END;
  END;

PROCEDURE CloseAllPointers;
var CurPtr:DPtr;
   LastPtr:DPtr;
  BEGIN
    CurPtr:=Deb1;
    WHILE CurPtr<>nil DO
      BEGIN
        LastPtr:=CurPtr^.Next;
        Dispose(CurPtr);
        CurPtr:=LastPtr;
      END;
  END;


(**********************************************************************
 ***                         MAIN PROGRAM                           ***
 **********************************************************************)

PROCEDURE ActOnCommand;
  BEGIN
    CASE UpCase(Command) OF
      'W','H' : Up;
      'A','K' : Left;
      'D','M' : Right;
      'X','P' : Down;
      'Q'     : Command:='Q';
      ';'     : BEGIN                    {F1}
                  DoInstructions;
                  WriteBKGround;
                  WriteGround;
                  WriteDebris;
                  WriteHealth;
                END;
    END;
  END;


BEGIN {main}
  Init;
  OpeningScreen;
  MakeGround;
  WriteBkGround;
  MakeGround;
  WriteGround;
  WriteHealth;
  REPEAT
    GetCommand;
    IF Command>Chr(0) THEN
      ActOnCommand;
    IF Command=Chr(0) THEN
      BEGIN
        ChangeSprite; {also changes position}
        IF Moving THEN MoveDebris;
        IF Sprite in [UpFlap..DownFlap] THEN CollisionCheckAir
          ELSE CollisionCheckGround;
        IF Moving THEN
          BEGIN
            WriteDebris;
            WriteGround;
          END;
      END;
    TextColor(10);
    WriteSprite;
    IF Health=0 THEN DeathSequence;
  UNTIL (Command='Q') or (Sprite=Dead);
  CloseAllPointers;
  Credits;
END.

