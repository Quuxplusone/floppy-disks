PROGRAM Ascii_Animator_Editor;

{$I standard.lib}

{
           An editor program to go with Ascii Animator V5.11.
           Only does 1..255 frames at a time; only 9x20 character
             frame size.  Only the speed of the frames can be changed.
           Therefore, the first line of each file is ignored.
           Frames are edited one at a time.
        Window:

.----------------------.  .----.  .-----------------------.
|                      |  | /\ |  | Cur num frames:   255 |
|                      |  |PgUp|  | <F>ilename:  animator |
|     Edit window      |  |    |  | Cur f<R>ame speed: 11 |
|                      | /|____|\ | <I>ns / <D>el frame   |
|                      |< Escape >| C<O>py frame          |
|      9x20 chars      | \|~~~~|/ | Mo<V>e block...       |
|                      |  |    |  | <S>ave / <L>oad file  |
|                      |  |PgDn|  | <P>lay animation .----|
|                      |  | \/ |  | <Q>uit editor   / 255 |
`----------------------'  `----'  `----------------'------'
            Press <F1> for pop-up help...

        Edit window - active: white with green border
                    inactive: dark with gray border
        Menu window - active: white/lt blue with green border
                    inactive: dark with gray border
        Ctrl-key is synonymous with Esc+key.
}

{
                            Hotkeys:

          EDIT                            MENU
        Esc           27                Esc     27
        F1            27+59             F1      27+59
        Ctrl-F         6                F      102    / 70
        Ctrl-R        18                R      114    / 82
        Ctrl-I         9                I      105    / 73
        Ctrl-D         4                D      100    / 68
        Ctrl-S        19                S      115    / 83
        Ctrl-L        12                L      108    / 76
        Ctrl-P        16                P      112    / 80
        Ctrl-Q        17                Q      113    / 81
        Ctrl-O        15                O      111    / 79
        Ctrl-V        22                V      118    / 86
                      PgUp          27+73
                      PgDn          27+81
                      Home          27+71
                      End           27+83
        Left          27+75
        Right         27+77
        Up            27+72
        Down          27+80
}

type
  PicType  = array[1..9,1..20] of CHAR;
  FramePtr = ^FrameRec;
  FrameRec = record
    Pic     : PicType;
    Next    : FramePtr;
  end;

var
  FrameNum  : BYTE;
  Spd       : BYTE;
  FileName  : String[20];
  NumFrames : BYTE;
  FirstFrame: FramePtr;

const FPSDef = 11;

PROCEDURE InitVars;
  BEGIN
    FrameNum:=0;
    NumFrames:=0;
    FirstFrame:=nil;
    Spd:=11;
  END;

PROCEDURE ClearFrames;
var CurFrame:FramePtr;
  BEGIN
    WHILE FirstFrame<>nil DO
      BEGIN
        CurFrame:=FirstFrame^.Next;
        Dispose(FirstFrame);
        FirstFrame:=CurFrame;
      END;
    NumFrames:=0;
    FrameNum:=0;
  END;

FUNCTION GetFrame(X:BYTE):FramePtr;
var CurFrame: FramePtr;
    LCV     : BYTE;
  BEGIN
    CurFrame:=FirstFrame;
    FOR LCV:=1 TO X-1 DO
      IF CurFrame<>nil THEN
        CurFrame:=CurFrame^.Next;
    GetFrame:=CurFrame;
    IF X=0 THEN GetFrame:=nil;
  END;

PROCEDURE MakeNewFrame(var CurFrame:FramePtr);
var NewFrame:FramePtr;
  BEGIN
    IF CurFrame=nil THEN                {add frame to start}
      BEGIN
        New(CurFrame);
        CurFrame^.Next:=FirstFrame;
        FirstFrame:=CurFrame;
      END
    ELSE                                {CurFrame points to something}
      BEGIN
        New(NewFrame);
        NewFrame^.Next:=CurFrame^.Next;
        CurFrame^.Next:=NewFrame;
        CurFrame:=NewFrame;
      END;
    NumFrames:=NumFrames+1;
  END;

PROCEDURE PutDataInFrame(var InFile:TEXT; var CurFrame:FramePtr);
var CurLine:String[255];
    X,Y    :BYTE;
  BEGIN
    ReadLN(InFile,CurLine);
    FOR X:=1 TO 9 DO
      BEGIN
        IF CurLine='' THEN ReadLN(InFile, CurLine);
        FOR Y:=1 TO 20 DO
          IF Length(CurLine)>0 THEN
            BEGIN
              CurFrame^.Pic[X,Y]:=CurLine[1];
              CurLine:=Copy(CurLine,2,Length(CurLine)-1);
            END
          ELSE CurFrame^.Pic[X,Y]:=' ';
      END;
  END;

PROCEDURE LoadAnimation(Toggle:BOOLEAN); FORWARD;

PROCEDURE LoadCmdLine;
var InFile:TEXT;
  BEGIN
    FileName:=ParamStr(1);
    IF POS('.',FileName)=0 THEN FileName:=FileName+'.so2';
    {$I-}
      Assign(InFile,Filename);
      Reset(InFile);
    {$I+}
    IF IOResult<>0 THEN
      BEGIN
        WriteLN;
        WriteLN(' File error: File does not exist.');
        Close(InFile);
        CursorOn;
        Halt;
      END
    ELSE
      BEGIN
        Close(InFile);
        LoadAnimation(TRUE);
      END;
  END;

PROCEDURE WriteBoxes(Toggle:BOOLEAN);
  BEGIN
    GotoXY(1,1);
    IF Toggle THEN  {edit window active}
      BEGIN
        SetColor(1, 0,63,0);   {lt green / edit window frame}
        SetColor(2, 42,42,42); {lt gray / menu window frame}
        SetColor(3, 16,16,16); {dk gray / menu window text}
        SetColor(4, 0,32,63);  {med blue / menu window hotkeys}
      END
    ELSE            {menu window active}
      BEGIN
        SetColor(1, 42,42,42); {lt gray / edit window frame}
        SetColor(2, 0,63,0);   {lt green / menu window frame}
        SetColor(3, 63,63,63); {white / menu window text}
        SetColor(4, 0,63,63);  {lt blue / menu window hotkeys}
      END;
    ColorWriteFile('anim_win.txt');
    TextColor(3); GotoXY(54,2); Write(NumFrames:4);
    TextColor(3); GotoXY(50,3); Write(Copy(FileName,1,POS('.',FileName)-1):8);
                                { just the first part; no extension }
    TextColor(3); GotoXY(55,4); Write(Spd:3);
    TextColor(4); GotoXY(55,10); Write(FrameNum:3);
  END;


PROCEDURE WriteFrame(Toggle:BOOLEAN);
var CurFrame:FramePtr;
     X, Y   : BYTE;
  BEGIN
    IF NumFrames>0 THEN
      BEGIN
        CurFrame:=GetFrame(FrameNum);
        IF Toggle THEN TextColor(15) ELSE TextColor(8);
        FOR X:=1 TO 9 DO
          BEGIN
            GotoXY(3,X+1);
            FOR Y:=1 TO 20 DO
              Write(CurFrame^.Pic[X,Y]);
          END;
      END;
  END;

PROCEDURE WriteCursor(CurX,CurY:BYTE; On:BOOLEAN);
var    C    : CHAR;
   CurFrame : FramePtr;
  BEGIN
    GotoXY(CurY+2,CurX+1);
    IF On THEN TextBackground(7) ELSE TextBackGround(0);
    CurFrame:=GetFrame(FrameNum);
    C:=CurFrame^.Pic[CurX,CurY];
    Write(C);
    TextBackground(0);
  END;

(************************************************************************
                       DIRECTLY CONTROLLED OPTIONS
************************************************************************)

PROCEDURE SwitchWindows(var Toggle:BOOLEAN);
  BEGIN
    Toggle:=not Toggle;
    WriteBoxes(Toggle);
    WriteFrame(Toggle);
  END;

PROCEDURE GetName(Toggle:BOOLEAN);
var FN:String[8];
  BEGIN
    TextColor(13);
    GotoXY(50,3);
    Write('        ');
    GotoXY(50,3);
    CursorBig;
    ReadLN(FN);
    IF (Length(FN)>0) THEN FileName:=FN+'.so2';
    CursorOff;
    WriteBoxes(Toggle);
    WriteFrame(Toggle);
  END;

PROCEDURE GetSpeed(Toggle:BOOLEAN);
var S:BYTE;
  BEGIN
    TextColor(13);
    GotoXY(55,4);
    Write('   ');
    GotoXY(56,4);
    CursorBig;
    ReadLN(S);
    IF (S>0) THEN Spd:=S;
    CursorOff;
    WriteBoxes(Toggle);
    WriteFrame(Toggle);
  END;

PROCEDURE InsFrame(Toggle:BOOLEAN);
var CurFrame:FramePtr;
      X,Y   : BYTE;
  BEGIN
    IF NumFrames<255 THEN
      BEGIN
        CurFrame:=GetFrame(FrameNum);
        MakeNewFrame(CurFrame);
        FrameNum:=FrameNum+1;
        FOR X:=1 TO 9 DO
          FOR Y:=1 TO 20 DO
            CurFrame^.Pic[X,Y]:=' ';
        WriteBoxes(Toggle);
        WriteFrame(Toggle);
      END;
  END;

PROCEDURE DelFrame(Toggle:BOOLEAN);
var NextFrame:FramePtr;
    ThisFrame:FramePtr;
     CurFrame:FramePtr;
  BEGIN
    IF NumFrames>1 THEN
      BEGIN
        IF FrameNum=1 THEN
          BEGIN
            NextFrame:=FirstFrame^.Next;
            Dispose(FirstFrame);
            FirstFrame:=NextFrame;
          END
        ELSE
          BEGIN
            CurFrame:=GetFrame(FrameNum-1);    {one before this one}
            ThisFrame:=CurFrame^.Next;
            NextFrame:=ThisFrame^.Next;
            Dispose(ThisFrame);
            CurFrame^.Next:=NextFrame;
          END;
        NumFrames:=NumFrames-1;
        IF FrameNum>NumFrames THEN FrameNum:=FrameNum-1;
      END;
    WriteBoxes(Toggle);
    WriteFrame(Toggle);
  END;

PROCEDURE CopyFrame(Toggle:BOOLEAN);
var CurFrame:FramePtr;
   LastFrame:FramePtr;
      X,Y   : BYTE;
  BEGIN
    IF NumFrames<255 THEN
      BEGIN
        CurFrame:=GetFrame(FrameNum);
        LastFrame:=CurFrame;
        MakeNewFrame(CurFrame);
        FrameNum:=FrameNum+1;
        FOR X:=1 TO 9 DO
          FOR Y:=1 TO 20 DO
            CurFrame^.Pic[X,Y]:=LastFrame^.Pic[X,Y];
        WriteBoxes(Toggle);
        WriteFrame(Toggle);
      END;
  END;

PROCEDURE MoveBlock(Toggle:BOOLEAN);
var StartFrame, EndFrame, DestFrame:BYTE;
    S1, S, E, D, D1 : FramePtr;
  BEGIN
    GotoXY(13,12); TextColor(15); Write('Start: '); TextColor(13); ClrEOL;
    CursorBig; ReadLN(StartFrame);
    GotoXY(13,12); TextColor(15); Write('End: '); TextColor(13); ClrEOL;
    ReadLN(EndFrame);
    GotoXY(13,12); TextColor(15); Write('Move to: '); TextColor(13); ClrEOL;
    ReadLN(DestFrame);
    CursorOff;
    IF (StartFrame<=EndFrame) and (not (DestFrame in [StartFrame..EndFrame]))
                             THEN
      BEGIN                            {everything checks out OK}
        S:=GetFrame(StartFrame);
        S1:=GetFrame(StartFrame-1);
        E:=GetFrame(EndFrame);
        D:=GetFrame(DestFrame);
        D1:=GetFrame(DestFrame-1);
        IF S1=nil THEN FirstFrame:=E^.Next
          ELSE S1^.Next:=E^.Next;      {cut loose starting end of S-E}
        E^.Next:=D;                    {reattach ending end of S-E}
        IF D1=nil THEN FirstFrame:=S
          ELSE D1^.Next:=S;            {reattach starting end of S-E}
      END;
    WriteFrame(Toggle);
  END;


PROCEDURE SaveAnimation;
var OutFile : TEXT;
   CurFrame : FramePtr;
      X,Y   : BYTE;
  BEGIN
    IF FileName<>'' THEN
      BEGIN
        Assign(OutFile,FileName);
        Rewrite(OutFile);
        WriteLN(OutFile,'9,20,',Spd);
        CurFrame:=FirstFrame;
        WHILE CurFrame<>nil DO
          BEGIN
            FOR X:=1 TO 9 DO
              FOR Y:=1 TO 20 DO
                Write(OutFile,CurFrame^.Pic[X,Y]);
            WriteLN(OutFile);
            CurFrame:=CurFrame^.Next;
          END;
        Close(OutFile);
      END;
  END;

PROCEDURE LoadAnimation; {Toggle:BOOLEAN}
var CurFrame: FramePtr;
    InFile  : TEXT;
  BEGIN
    ClearFrames;
    Assign(InFile,FileName);
    {$I-}
      Reset(InFile);
    {$I+}
    IF IOResult=0 THEN
      BEGIN
        ReadLN(InFile);
        CurFrame:=nil;
        WHILE (not EOF(InFile)) and (NumFrames<255) DO
          BEGIN
            MakeNewFrame(CurFrame);
            PutDataInFrame(InFile,CurFrame);
          END;
        Close(InFile);
        FrameNum:=1;
        WriteBoxes(Toggle);
        WriteFrame(Toggle);
      END;
  END;

PROCEDURE PlayAnimation(Toggle:BOOLEAN);
var CurFrame : FramePtr;
    OldNum   : BYTE;
    X, Y     : BYTE;
  BEGIN
    TextColor(7);
    OldNum:=FrameNum;
    FrameNum:=0;
    CurFrame:=FirstFrame;
    WHILE (CurFrame<>nil) and (not KeyPressed) DO
      BEGIN
        FOR X:=1 TO 9 DO
          BEGIN
            GotoXY(3,X+1);
            FOR Y:=1 TO 20 DO
              Write(CurFrame^.Pic[X,Y]);
          END;
        FrameNum:=FrameNum+1;
        CurFrame:=CurFrame^.Next;
        Delay(round(1000/Spd));
      END;
    IF not KeyPressed THEN FrameNum:=OldNum;
    WriteFrame(Toggle);
  END;

PROCEDURE PageUp(Toggle:BOOLEAN);
  BEGIN
    IF FrameNum>1 THEN FrameNum:=FrameNum-1;
    WriteBoxes(Toggle);
    WriteFrame(Toggle);
  END;

PROCEDURE PageDown(Toggle:BOOLEAN);
  BEGIN
    IF FrameNum<NumFrames THEN FrameNum:=FrameNum+1;
    WriteBoxes(Toggle);
    WriteFrame(Toggle);
  END;

PROCEDURE Home(Toggle:BOOLEAN);
  BEGIN
    IF NumFrames>0 THEN FrameNum:=1;
    WriteBoxes(Toggle);
    WriteFrame(Toggle);
  END;

PROCEDURE GoToEnd(Toggle:BOOLEAN);
  BEGIN
    FrameNum:=NumFrames;
    WriteBoxes(Toggle);
    WriteFrame(Toggle);
  END;

PROCEDURE AddChar(Command:CHAR; CurX,CurY:BYTE; Toggle:BOOLEAN);
var CurFrame:FramePtr;
  BEGIN
    IF (NumFrames>0) and (Command in [' '..'~']) THEN
      BEGIN
        CurFrame:=GetFrame(FrameNum);
        CurFrame^.Pic[CurX,CurY]:=Command;
      END;
    WriteFrame(Toggle);
  END;

PROCEDURE QuitEditor;
  BEGIN
    ClearFrames;
    Window(1,1,80,25);
    TextColor(7);
    TextBackground(0);
    ClrScr;
  END;

PROCEDURE DoHelpTop;
  BEGIN
    ClrScr;
    TextBackground(7);
    ClrEol;
    TextColor(0);
    Write('Ascii Animator Studio Version 1.0 Help':53);
    TextBackground(5);
    WriteLN;
    ClrEol;
    TextColor(12);
    Write('    Help on: ');
    TextColor(15);
    Write('  <T>op    <E>dit window       <M>enu window     <O>peration');
    TextBackground(0);
    TextColor(15);
    WriteLN;
  END;

PROCEDURE DoTopHelp;
  BEGIN
    GotoXY(1,5);
    TextColor(15);
    WriteLN('               Welcome to Ascii Animator Studio!');
    WriteLN;
    WriteLN('      This program is an editor for constructing and viewing');
    WriteLN('    Ascii Animator (Version 5.11) animation files.  Ascii');
    WriteLN('    Animator is not required to view the files created with');
    WriteLN('    this editor; the editor has a built-in animation player.');
    WriteLN;
    WriteLN('      Navigate through the help topics using the keys "T", "E",');
    WriteLN('    "M", "O", and "Q" (to quit).  Help can be re-entered at any');
    WriteLN('    time by pressing <F1>.');
    WriteLN;
    WriteLN;
    WriteLN;
    WriteLN('                     Ascii Animator Studio V1.0');
    WriteLN('                     was created and programmed');
    WriteLN('                         by Arthur O''Dwyer');
    WriteLN('                          17 October 1999');
  END;

PROCEDURE DoEditHelp;
  BEGIN
    GotoXY(1,5);
    TextColor(15);
    WriteLN('      The edit window shows the frame currently being worked on.');
    WriteLN('    You can move the cursor around the window with the arrow');
    WriteLN('    keys, and place characters by typing.  The cursor will not');
    WriteLN('    move automatically to the right after each keystroke; this');
    WriteLN('    must be done manually.');
    WriteLN('      A complete set of commands is below:');
    WriteLN;
    WriteLN('    Left arrow : move cursor left    Ctrl - F : change filename');
    WriteLN('   Right arrow : move cursor right   Ctrl - R : change speed');
    WriteLN('      Up arrow : move cursor up      Ctrl - I : insert frame');
    WriteLN('    Down arrow : move cursor down    Ctrl - D : delete frame');
    WriteLN('      Home key : go to first frame   Ctrl - O : copy frame');
    WriteLN('       End key : go to last frame    Ctrl - V : move block');
    WriteLN('       Page Up : previous frame      Ctrl - S : save animation');
    WriteLN('     Page Down : next frame          Ctrl - L : load animation');
    WriteLN('            F1 : show help file      Ctrl - P : play animation');
    WriteLN('        Escape : switch windows      Ctrl - Q : quit editor');
  END;

PROCEDURE DoMenuHelp;
  BEGIN
    GotoXY(1,5);
    TextColor(15);
    WriteLN('      The menu window displays a list of commands, along with');
    WriteLN('    vital information about the file: number of frames, frame');
    WriteLN('    speed, and the frame currently being displayed.  These');
    WriteLN('    options can be accessed by typing the letter in angle');
    WriteLN('    brackets in the option.');
    WriteLN('      A complete set of commands is below:');
    WriteLN;
    WriteLN('             F : change filename      S : save animation');
    WriteLN('             R : change speed         L : load animation');
    WriteLN('             I : insert frame         P : play animation');
    WriteLN('             D : delete frame         Q : quit editor');
    WriteLN('             O : copy frame        Home : go to first frame');
    WriteLN('             V : move block         End : go to last frame');
    WriteLN('       Page Up : previous frame      F1 : show help file');
    WriteLN('     Page Down : next frame      Escape : switch windows');
  END;

PROCEDURE DoOperationHelp;
  BEGIN
    GotoXY(1,5);
    TextColor(15);
    WriteLN('      This section contains notes on important items which may');
    WriteLN('    be unclear, puzzling, or simply overlooked in the other');
    WriteLN('    sections.');
    WriteLN;
    WriteLN('    * The borders of the two windows change to reflect which one');
    WriteLN('       is active; green means active, gray means inactive.');
    WriteLN('    * Ascii Animator Studio V1.0 cannot edit more than 255');
    WriteLN('       frames at one time, so large files must be broken into');
    WriteLN('       smaller pieces, concatenated, and viewed with Ascii');
    WriteLN('       Animator V5.11 or greater.');
    WriteLN('    * Ascii Animator Studio only supports 9 by 20 character');
    WriteLN('       frames, which are the most popular format.  Ascii');
    WriteLN('       Animator, however, can display any size animations.');
    WriteLN('    * The Frame Speed variable is a number from 1 to 255, and');
    WriteLN('       represents how many frames per second are displayed when');
    WriteLN('       the animation is played.  A reasonably smooth animation');
    WriteLN('       appears around 10 to 20 frames per second; "real life"');
    WriteLN('       movies display at 30 to 60 frames per second.');
  END;

PROCEDURE DoHelp(Toggle:BOOLEAN);
var C :CHAR;
  BEGIN
    Window(1,1,80,25);
    DoHelpTop;
    DoTopHelp;
    REPEAT
      C:=ReadDouble;
      ClrScr;
      DoHelpTop;
      CASE Ord(C) OF
        20, 84, 116 : DoTopHelp;
         5, 69, 101 : DoEditHelp;
        13, 77, 109 : DoMenuHelp;
        15, 79, 111 : DoOperationHelp;
        ELSE          DoTopHelp;
        END;
    UNTIL C in ['Q','q','€'..'þ'];
    ClrScr;
    Window(10,6,80,25);
    WriteBoxes(Toggle);
    WriteFrame(Toggle);
  END;


PROCEDURE ActOnCommand(var Command:CHAR; var Toggle:BOOLEAN;
                       var CurX,CurY:BYTE);
  BEGIN
    WriteCursor(CurX,CurY,FALSE);
    IF Toggle THEN {in edit window}
      CASE Ord(Command) OF
       128    : SwitchWindows(Toggle);
       187    : DoHelp(Toggle);
         6    : GetName(Toggle);
        18    : GetSpeed(Toggle);
         9    : InsFrame(Toggle);
        15    : CopyFrame(Toggle);
         4    : DelFrame(Toggle);
        19    : SaveAnimation;
        12    : LoadAnimation(Toggle);
        16    : PlayAnimation(Toggle);
        17    : QuitEditor;
        22    : MoveBlock(Toggle);
       199    : Home(Toggle);
       201    : PageUp(Toggle);
       209    : PageDown(Toggle);
       207    : GoToEnd(Toggle);
       203    : IF CurY>1 THEN CurY:=CurY-1;
       205    : IF CurY<20 THEN CurY:=CurY+1;
       200    : IF CurX>1 THEN CurX:=CurX-1;
       208    : IF CurX<9 THEN CurX:=CurX+1;
       ELSE {Ascii character} AddChar(Command, CurX,CurY, Toggle);
      END {case}
    ELSE
      CASE Ord(Command) OF
       128     : SwitchWindows(Toggle);
       187     : DoHelp(Toggle);
       102, 70 : GetName(Toggle);
       114, 82 : GetSpeed(Toggle);
       105, 73 : InsFrame(Toggle);
       100, 68 : DelFrame(Toggle);
       111, 79 : CopyFrame(Toggle);
       118, 86 : MoveBlock(Toggle);
       115, 83 : SaveAnimation;
       108, 76 : LoadAnimation(Toggle);
       112, 80 : PlayAnimation(Toggle);
       113, 81 : QuitEditor;
       199     : Home(Toggle);
       201     : PageUp(Toggle);
       209     : PageDown(Toggle);
       207     : GoToEnd(Toggle);
      END;
    WriteCursor(CurX,CurY,TRUE);
  END;


PROCEDURE DoEditor;
var Command  : CHAR;
    CurX,CurY: BYTE;     {where the cursor is}
    Toggle   : BOOLEAN;  {True=edit window; False=option menu}
  BEGIN
    Command:=Chr(0);
    CurX:=1;
    CurY:=1;
    IF ParamCount>0 THEN LoadCmdLine ELSE FileName:='';
    IF FrameNum>0 THEN   {animation loaded; go to edit window}
      Toggle:=TRUE
    ELSE Toggle:=FALSE;  {no animation loaded; get file from menu window}
    WriteBoxes(Toggle);
    WriteFrame(Toggle);  {print frame 1 of animation}
    WriteCursor(CurX,CurY,TRUE);
    REPEAT
      Command:=ReadDouble;      {get keypress}
      ActOnCommand(Command, Toggle, CurX, CurY);
    UNTIL Command in ['Q','q',''];
  END;


BEGIN
  InitVars;
  ClrScr;
  Window(10,6,80,25);
  CursorOff;
  DoEditor;
  CursorOn;
  ClrScr;
END.

