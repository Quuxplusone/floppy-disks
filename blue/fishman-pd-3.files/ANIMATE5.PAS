Program ASCII_Animation (Input,Output);

{  Version 5.11 }

{
   Command line reads as follows:
     ANIMATE5 < AnimateFile > | < \h > [ , <FPS> ]
   The \h option prints to screen a message with this content
    and an explanation of the program.

   Source file lines will automatically be continued if the prgm runs out of
    frame lines on the current line.  Frames can be broken like this:

        ABC         ABCDEF               ABCD               ABC
        DEF   ==>   GHI        but not   EFGHI  <== this    EFG
        GHI                                         means:  HI


  The next line may need to be uncommented.
}

(* USES CRT; *)

const
  FPSdefault : BYTE = 10;

var
  Xmax,Ymax    : INTEGER;
  X,Y          : INTEGER; {Loop vars}
  CurrentLine  : STRING[255];
  AnimateFile  : TEXT;
  R            : INTEGER;
  FPS          : REAL;
  FPSAuto      : INTEGER;  {default FPS gotten from line 1 of .so2 file}


{/////////////////////////////////////////////////////////////////////}

PROCEDURE PrintHelpFile;
  BEGIN
    WriteLN;
    WriteLN(' Thank you for using ASCII Animator Version 5.11');
    WriteLN;
    WriteLN(' The command line should read:');
    WriteLN;
    WriteLN(' ANIMATE5 [filename] [fps]');
    WriteLN;
    WriteLN(' [filename] is optional.  It is the name of the animation file.');
    WriteLN(' [fps] is also optional.  It is a real number (frames/second).');
    WriteLN(' The command line option /h, or <enter>, prints this message.');
    WriteLN(' The program will prompt you for the variables you do not');
    WriteLN('  input.');
    WriteLN;
    Halt;
  END;

PROCEDURE CheckIOError; {custom error messages}
  BEGIN
    {$I-}  {turn off internal checking}
    Reset(AnimateFile);
    {$I+} {turn it on again}
    IF not(IOResult=0) THEN
      BEGIN
        WriteLN(' ERROR: File not found.');
        Halt;
      END;
  END;

PROCEDURE GetFile;
var FileName:STRING[255];
  BEGIN
    ClrScr;
    Write('Filename (/h)? ');ReadLN(FileName);
    IF (FileName='') or (FileName='/h') or (FileName='/H') THEN
      PrintHelpFile;
    IF (Pos('.',FileName)=0) THEN
      FileName:=FileName+'.so2';
    Assign(AnimateFile,FileName);
    CheckIOError;
    Reset(AnimateFile);
  END;

PROCEDURE DoAutomaticFile; {from cmdline params}
var FileName:STRING[255];
  BEGIN
    FileName:=ParamStr(1);
    IF (FileName='/h') or (FileName='/H') THEN PrintHelpFile;
    IF (Pos('.',FileName)=0) THEN
      FileName:=FileName+'.so2';
    Assign(AnimateFile,FileName);
    CheckIOError;
    Reset(AnimateFile);
  END;

PROCEDURE GetFrameSpeed;
var TempS : STRING[255];
    Temp1 : INTEGER;
  BEGIN
    TempS:='';
    FPS:=0;
    Write(' Frames/sec (default ',FPSAuto,')? ');
    ReadLN(TempS);
    VAL(TempS,FPS,Temp1);
    IF (Temp1>0) or (FPS=0) THEN
      FPS := FPSAuto;
  END;

PROCEDURE DoAutomaticFPS; {from cmdline params}
var TempS : STRING[255];
    Temp1 : INTEGER;
  BEGIN
    TempS:='';
    FPS:=0;
    TempS := ParamStr(2);
    VAL(TempS,FPS,Temp1);
    IF (Temp1>0) or (FPS=0) THEN
      FPS := FPSAuto;
  END;

PROCEDURE GetXYMax;
var Comma : BYTE;
    Temp  : INTEGER;
  BEGIN
    FPSAuto:=FPSdefault;
    ReadLN(AnimateFile,CurrentLine);
    Comma:=POS(',',CurrentLine);
    VAL(Copy(CurrentLine,1,Comma-1),Xmax,Temp);  {get Xmax}
    CurrentLine:=Copy(CurrentLine,Comma+1,LENGTH(CurrentLine)-Comma);
    Comma:=POS(',',CurrentLine);
    IF Comma=0 THEN Comma:=LENGTH(CurrentLine)+1;
    IF Temp>0 THEN
      BEGIN
        WriteLN(' ERROR: No valid Xmax in source file.');
        Close(AnimateFile);
        Halt;
      END;
    VAL(Copy(CurrentLine,1,Comma-1),Ymax,Temp);  {get Ymax}
    IF Temp>0 THEN
      BEGIN
        WriteLN(' ERROR: No valid Ymax in source file.');
        Close(AnimateFile);
        Halt;
      END;
    IF Comma<LENGTH(CurrentLine) THEN
      VAL(Copy(CurrentLine,Comma+1,LENGTH(CurrentLine)-Comma),FPSAuto,Temp);
        {get frames per second default}
    IF Temp>0 THEN
      BEGIN
        WriteLN;
        WriteLN(' WARNING: Invalid FPS number in source file.');
        Delay(750);
      END;
    IF (FPSAuto=0) or (Temp>0) THEN FPSAuto:=FPSdefault;
  END;

PROCEDURE WriteThisLine;
var LCV:BYTE;
  BEGIN
    IF Length(CurrentLine) >= Ymax THEN
      WriteLN(Copy(CurrentLine,1,Ymax))
    ELSE
      BEGIN
        Write(CurrentLine);
        FOR LCV:=Length(CurrentLine)+1 TO Ymax DO
          Write(' ');
        WriteLN;
      END;
  END;

BEGIN  {  Main  }
  TextColor(7);
  IF (ParamCount=0) THEN GetFile        {no parameter passed}
    ELSE DoAutomaticFile;               {one or more parameters passed}
  GetXYMax;                            {-- and FPSAuto, if provided}
  IF (ParamCount<2) THEN GetFrameSpeed  {ditto}
    ELSE DoAutomaticFPS;                {two parameters passed}
  ClrScr;
  Window(37-Ymax div 2, 11-Xmax div 2, 39+Ymax div 2, 13+Ymax div 2);
  ClrScr;
  WHILE not(EOF(AnimateFile)) DO
    BEGIN
      ReadLN(AnimateFile,CurrentLine);
      FOR X:=1 to Xmax DO
        BEGIN
          IF Length(CurrentLine)=0 THEN
            ReadLN(AnimateFile,CurrentLine);
          WriteThisLine;
          CurrentLine:=Copy(CurrentLine,Ymax+1,Length(CurrentLine)-Ymax);
        END {for Xmax};
      Delay(ROUND(1000/FPS));       {FPS frames per second}
      GotoXY(1,1);
    END {while};
  GotoXY(1,Xmax+1);
END.

