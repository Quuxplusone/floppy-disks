PROGRAM Ascii_Artwork_Studio_by_AO;

{$I standard.lib}

{  NOTE: All procedure calls have line numbers in brackets next to them.
  The line numbers can be used to find the procedure in the source.}

var
  ChrArray   : array[1..47,1..16] of CHAR;
  ColArray   : array[1..47,1..16] of BYTE;
  CurColor   : BYTE;
  CursorX,CursorY : BYTE;
  CursorMode : BOOLEAN; {on=move while typing; off=stationary}
  InsertMode : BOOLEAN; {on=insert mode; off=type-over}
  AutoSave   : BOOLEAN; {on=prompt when clearing, quitting; off=no}


(************************************************************************
                             Help Procedures
************************************************************************)

PROCEDURE DoDrawHelp;
  BEGIN
    ClrScr;
    WriteLN;WriteLN;
WriteLN('    The main screen (drawing board) of ASCII Artwork Studio is');
WriteLN('  used to edit the current picture.  The arrow keys are used to');
WriteLN('  change the cursor''s position inside the editing field, and the');
WriteLN('  keyboard is used to add to or change the picture in the field.');
WriteLN('  The edit window is 47 by 16 characters.');
WriteLN('    The <escape> key is used to bring up the options window, where');
WriteLN('  the current text color can be altered or the file saved (see the');
WriteLN('  relevant Help topics).  The options menu <X> key also clears the');
WriteLN('  screen so you can start with a fresh slate.');
WriteLN('    Notice that by default the cursor does not move to the right');
WriteLN('  as you type in the edit window.  This means you must use the');
WriteLN('  right-arrow to move the cursor when typing left to right, but');
WriteLN('  in fact saves time when typing in vertical or right-to-left rows.');
WriteLN('  Cursor movement can be toggled with <Alt-C> during edit mode.');
WriteLN('    The Page Up/Down keys move the cursor straight up and down to');
WriteLN('  the top and bottom of the screen, and <Home> moves you to the');
WriteLN('  first column of the screen.  The <tab> key jumps eight spaces to');
  WriteLN;
  WriteLN('  (press any key to continue...)');
  WriteLN;
  WaitForKeyPressed;
  WriteLN;
WriteLN('  the right, and <shift-tab> jumps eight to the left.  <End> moves');
WriteLN('  the cursor after the last non-blank character on the line.');
WriteLN('    <Backspace> removes the character to the cursor''s left, and');
WriteLN('  <Del> removes the character at the cursor''s current position;');
WriteLN('  both actions shift the rest of the line to the left.  <Ctrl-D>');
WriteLN('  deletes the current line, and <Ctrl-I> inserts a new line at the');
WriteLN('  cursor.  <Ins> toggles Insert mode, allowing characters to be');
WriteLN('  inserted into the current line.');
WriteLN('    For an explanation of the AutoSave feature, see "Saving and ');
WriteLN('  Loading Files" in the Help menu.');
    WriteLN;
    WriteLN('    Press any key to return to the options menu now...');
    WriteLN;
    WaitForKeyPressed;
  END;

PROCEDURE DoColorHelp;
  BEGIN
    ClrScr;
    WriteLN;WriteLN;
WriteLN('    From the options menu (accessed with the <escape> key), the <C>');
WriteLN('  option changes the color, and the <E> option edits the current');
WriteLN('  color.');
WriteLN('    Capital <C> (shifted) changes the color to the next highest');
WriteLN('  color in the scale (shown down the right side of the edit');
WriteLN('  window).  Lowercase <C> (unshifted) changes the color in the');
WriteLN('  opposite direction (down the scale).');
WriteLN('    The <E> option is used to edit the r/g/b values for a certain');
WriteLN('  color; however, this option is only available for colors 1, 2, 3,');
WriteLN('  4, 5, and 7.  You should find six custom colors to be more than');
WriteLN('  enough for your artistic efforts.  In the Edit Color window, the');
WriteLN('  R, G, and B keys (shifted) are used to increment the correspond-');
WriteLN('  ing color values, and the r, g, and b keys (unshifted) are used');
WriteLN('  to decrement the values.  There is a built-in rollover at 0 and');
WriteLN('  63.  Once you are done changing the color, press <escape> or');
WriteLN('  <enter> to return to the main options window.');
WriteLN('    Note that the color values are saved when the picture is saved,');
WriteLN('  and reloaded when a new picture is opened.  Clearing the screen');
WriteLN('  does not reset the color values.');
    WriteLN;
    WriteLN('    Press any key to return to the options menu now...');
    WriteLN;
    WaitForKeyPressed;
  END;

PROCEDURE DoSaveHelp;
  BEGIN
    ClrScr;
    WriteLN;WriteLN;
WriteLN('    ASCII Artwork Studio files can be saved and reloaded using the');
WriteLN('  and <L> commands from the options menu.  <S> allows you to save');
WriteLN('  your work to disk in any of three formats:');
WriteLN;
WriteLN('    ASCII Artwork Studio    1.4 - 1.7 Kb    custom colors');
WriteLN('    ColorWrite format       0.8 - 2.3 Kb    default colors');
WriteLN('    plain text                 0.8 Kb       monocolor');
WriteLN;
WriteLN('    <L> loads a file of any of these types into the edit window.');
WriteLN('  When either command is chosen, ASCII Studio will ask you for a');
WriteLN('  file name.  If no extension is given, the extension ".pic" is');
WriteLN('  assumed.  If you want to open a file with no extension, enter the');
WriteLN('  name as "FILENAME." (no extension after the dot).  When the');
WriteLN('  Autosave feature (toggled with Alt-A) is on, ASCII Artwork Studio');
WriteLN('  will ask you if you want to save your work before each exit');
WriteLN('  (Esc-Q) or clear screen (Esc-X).  This option is on by default.');
    WriteLN;
    WriteLN('    Press any key to return to the options menu now...');
    WriteLN;
    WaitForKeyPressed;
  END;

PROCEDURE DoVersionInfo;
  BEGIN
    ClrScr;
    WriteLN;
    WriteLN;
    WriteLN;
    WriteLN;
    WriteLN('                     ASCII Artwork Studio Version 5.3');
    WriteLN('                  written and directed by Arthur O''Dwyer');
    WriteLN('                                 (c) 1999');
    WriteLN;
    WriteLN('                       Latest upgrade: 13 Oct 1999');
    WriteLN;
    WriteLN;
    WriteLN;
    WriteLN('           Press any key to return to the options menu now...');
    WriteLN;
    WaitForKeyPressed;
  END;

PROCEDURE DoHelpFile;
var C:CHAR;
  BEGIN
    TextColor(15);
    GotoXY(10,3);
    Write(' .-------------------------------------------------. ');
    GotoXY(10,4);
    Write(' |  ASCII Artwork Studio V5.3 Help                 | ');
    GotoXY(10,5);
    Write(' |-------------------------------------------------| ');
    GotoXY(10,6);
    Write(' |                                                 | ');
    GotoXY(10,7);
    Write(' |     Help on which topic:                        | ');
    GotoXY(10,8);
    Write(' |   1)  Using the Drawing Board                   | ');
    GotoXY(10,9);
    Write(' |   2)  Using the Color Options                   | ');
    GotoXY(10,10);
    Write(' |   3)  Saving and Loading Files                  | ');
    GotoXY(10,11);
    Write(' |   4)  Version Information/Copyright Notice      | ');
    GotoXY(10,12);
    Write(' `-------------------------------------------------'' ');
    REPEAT
      Read(KBD,C);
    UNTIL C in ['1'..'4',''];
    CASE C OF
      '1' : DoDrawHelp; {22}
      '2' : DoColorHelp; {64}
      '3' : DoSaveHelp; {93}
      '4' : DoVersionInfo; {119}
      END {case};
  END;

(************************************************************************
                             Load Procedures
************************************************************************)

PROCEDURE GetLoadFile(var InFile:TEXT);
var Error : BOOLEAN;
    Name  : String[40];
  BEGIN
    ClrScr;
    Error:=FALSE;
    REPEAT
      Write(' Name of file (default extension .pic): > ');
      ReadLN(Name);
      IF POS('.',Name)=0 THEN
        Name:=Name+'.pic';     {add default extension}
      {$I-}
        Assign(InFile,Name);
        Reset(InFile);
      {$I+}
      IF IOResult<>0 THEN
        BEGIN
          WriteLN(' File error: File does not exist.');
          WriteLN;
          Error:=TRUE;
        END
      ELSE Error:=FALSE;
    UNTIL Error=FALSE;
  END;

PROCEDURE LoadFromFile;
var InFile : TEXT;
    X,Y    : BYTE;      {dimensions of pic}
    L      : BYTE;
    TChar  : CHAR;
    LCV,LCV2 : BYTE;
    Rd,Gn,Bl : BYTE;
  BEGIN
    GetLoadFile(InFile); {178}
    ReadLN(InFile,X,Y);
    FOR LCV:=1 TO 7 DO          {get color codes}
      BEGIN
        ReadLN(InFile,L,Rd,Gn,Bl);
        SetColor(LCV,Rd,Gn,Bl);
      END;
    FOR LCV:=1 TO Y DO          {get color array}
      BEGIN
        FOR LCV2:=1 TO X DO
          BEGIN
            Read(InFile,TChar);
            ColArray[LCV2,LCV]:=Ord(TChar)-64;
          END;
        ReadLN(InFile);
      END;
    FOR LCV:=1 TO Y DO          {get character array}
      BEGIN
        FOR LCV2:=1 TO X DO
          Read(InFile,ChrArray[LCV2,LCV]);
        ReadLN(InFile);
      END;
    Close(InFile);
  END {procedure};

PROCEDURE LoadFromText;
var InFile : TEXT;
    X,Y    : BYTE;      {1 thru 47, 1 thru 16}
  BEGIN
    GetLoadFile(InFile); {178}
    Y:=1;
    WHILE (Y<=16) and not(EOF(InFile)) DO      {read first 16 lines of file}
      BEGIN                                    {with a pseudo-for loop}
        FOR X:=1 TO 47 DO
          BEGIN
            ColArray[X,Y]:=7;              {set colors while we're in here}
            ChrArray[X,Y]:=Chr(0);
            IF not(EOLN(InFile)) THEN
              Read(InFile, ChrArray[X,Y]);
          END;
        ReadLN(InFile);
        Y:=Y+1;
      END;
    Close(InFile);
  END;

PROCEDURE LoadFromColorWrite;
var Infile : TEXT;
      X, Y : BYTE;
       Col : BYTE;
        Ch : CHAR;
     Line1 : AnyString;
const ColorCode : CHAR = '#';

  PROCEDURE DefColorCode;
    BEGIN
      Line1:=Copy(Line1,8,LENGTH(Line1)-7);
      WHILE Line1[1]=' ' DO Line1:=Copy(Line1,2,LENGTH(Line1)-1);
      ColorCode:=Line1[1];
    END;

  PROCEDURE GetNewColor;
  var C:CHAR;
    BEGIN                       {colors in form #n, where n is hex 0..F}
      Read(InFile,C);
      IF C in ['0'..'9'] THEN Col:=Ord(C)-48
        ELSE Col:=Ord(UpCase(C))-55;
    END;

  BEGIN {LoadFromColorWrite main proc}
    GetLoadFile(InFile); {178}
    Col:=7;
    Y:=1;
    ReadLN(InFile, Line1);
    IF UpString(Copy(Line1, 1, 7)) = '#DEFINE' THEN
      DefColorCode
    ELSE
      Reset(InFile);
    WHILE (not EOF(InFile)) and (Y<=16) DO
      BEGIN
        X:=1;
        WHILE X <= 47 DO
          BEGIN
            ChrArray[X,Y]:=Chr(0);
            ColArray[X,Y]:=Col;
            IF not EOLN(InFile) THEN
              BEGIN
                Read(InFile,Ch);
                IF Ch=ColorCode THEN
                  BEGIN
                    GetNewColor;
                    X:=X-1;
                  END
                ELSE
                  ChrArray[X,Y]:=Ch;
              END;
            X:=X+1;
          END;
        ReadLN(InFile);
        Y:=Y+1;
      END;
    Close(InFile);
  END;

PROCEDURE LoadMenu;
var C:CHAR;
  BEGIN
    TextColor(15);
    GotoXY(23,5);
    WriteLN('.----------------------.');
    GotoXY(23,6);
    WriteLN('| Load from...         |');
    GotoXY(23,7);
    WriteLN('|----------------------|');
    GotoXY(23,8);
    WriteLN('| 1. ASCII Artwork     |');
    GotoXY(23,9);
    WriteLN('|    Studio save file  |');
    GotoXY(23,10);
    WriteLN('|                      |');
    GotoXY(23,11);
    WriteLN('| 2. ColorWrite format |');
    GotoXY(23,12);
    WriteLN('|                      |');
    GotoXY(23,13);
    WriteLN('| 3. Plain text        |');
    GotoXY(23,14);
    WriteLN('`----------------------''');
    REPEAT
      Read(KBD,C);
    UNTIL C in ['1'..'3',''];
    CASE C OF
     '1' : LoadFromFile; {203}
     '2' : LoadFromColorWrite; {257}
     '3' : LoadFromText; {236}
     END {case};
  END;

(************************************************************************
                             Save Procedures
************************************************************************)

PROCEDURE GetSaveName(var OutFile:TEXT);
var Name:String[40];
    C       : CHAR;
    Error   : BOOLEAN;
  BEGIN
    ClrScr;
    REPEAT
      Write(' Name of file (default extension .pic): > ');
      ReadLN(Name);
      IF POS('.',Name)=0 THEN
        Name:=Name+'.pic';     {add default extension}
      {$I-}
        Assign(OutFile,Name);
        Reset(OutFile);
      {$I+}
      Error:=FALSE;
      IF IOResult=0 THEN {can reset file, so it exists}
        BEGIN
          Write(' Warning: File already exists.  Overwrite (y/n)? > ');
          ReadLN(C);
          WriteLN;
          Error:=TRUE;
        END;
    UNTIL (Error=FALSE) or (UpCase(C)='Y');
    Rewrite(OutFile);
  END;

PROCEDURE SaveAsFile;
var OutFile : TEXT;
    X, Y    : BYTE;
    Rd,Gn,Bl: BYTE;
  BEGIN
    GetSaveName(OutFile); {353}
    WriteLN(OutFile,'47 16');
    FOR X:=1 TO 7 DO
      BEGIN
        GetColor(X,Rd,Gn,Bl);
        WriteLN(OutFile,X,' ',Rd,' ',Gn,' ',Bl);
      END;
    FOR X:=1 TO 16 DO
      BEGIN
        FOR Y:=1 TO 47 DO
          Write(OutFile,Chr(ColArray[Y,X]+64)); {0=@, 1=A, 2=B, etc.}
        WriteLN(OutFile);
      END;
    FOR X:=1 TO 16 DO
      BEGIN
        FOR Y:=1 TO 47 DO
          Write(OutFile,ChrArray[Y,X]);
        WriteLN(OutFile);
      END;
    Close(OutFile);
  END;

PROCEDURE SaveAsText;
var OutFile : TEXT;
    X, Y    : BYTE;
  BEGIN
    GetSaveName(OutFile); {353}
    FOR X:=1 TO 16 DO
      BEGIN
        FOR Y:=1 TO 47 DO
          Write(OutFile,ChrArray[Y,X]);
        WriteLN(OutFile);
      END;
    Close(OutFile);
  END;

PROCEDURE SaveAsColorWrite;
var OutFile : TEXT;
    X,Y,Col : BYTE;
const ColorCode = '';
  BEGIN
    GetSaveName(OutFile); {353}
    WriteLN(OutFile, '#define ',ColorCode);
    Col:=16;
    FOR Y:=1 TO 16 DO
      BEGIN
        FOR X:=1 TO 47 DO
          BEGIN
            IF ColArray[X,Y]<>Col THEN
              BEGIN
                Col:=ColArray[X,Y];
                Write(OutFile,ColorCode);
                IF Col<10 THEN Write(OutFile, Chr(Col+48))
                  ELSE Write(OutFile, Chr(Col+55));
              END;
            Write(OutFile,ChrArray[X,Y]);
          END;
        WriteLN(OutFile);
      END;
    Close(OutFile);
  END;

PROCEDURE SaveMenu;
var C:CHAR;
  BEGIN
    TextColor(15);
    GotoXY(23,5);
    WriteLN('.----------------------.');
    GotoXY(23,6);
    WriteLN('| Save as...           |');
    GotoXY(23,7);
    WriteLN('|----------------------|');
    GotoXY(23,8);
    WriteLN('| 1. ASCII Artwork     |');
    GotoXY(23,9);
    WriteLN('|    Studio save file  |');
    GotoXY(23,10);
    WriteLN('|                      |');
    GotoXY(23,11);
    WriteLN('| 2. ColorWrite format |');
    GotoXY(23,12);
    WriteLN('|                      |');
    GotoXY(23,13);
    WriteLN('| 3. Plain text        |');
    GotoXY(23,14);
    WriteLN('`----------------------''');
    REPEAT
      Read(KBD,C);
    UNTIL C in ['1'..'3',''];
    CASE C OF
     '1' : SaveAsFile; {380}
     '2' : SaveAsColorWrite; {421}
     '3' : SaveAsText; {407}
     END {case};
  END;

(************************************************************************
                            Color Procedures
************************************************************************)

PROCEDURE CycleColors(Fward:BOOLEAN);
  BEGIN
    IF Fward THEN
      CurColor:=(CurColor+1) MOD 16
    ELSE
      CurColor:=(CurColor-1) MOD 16;
    IF CurColor=255 THEN CurColor:=15;    {checks against overflow}
  END;

PROCEDURE EditCurrentColor;
var C     : CHAR;
 Rd,Gn,Bl : BYTE;
  BEGIN
    GetColor(CurColor,Rd,Gn,Bl);
    REPEAT
      TextColor(15);
      GotoXY(26,9);
      Write(' .--------------. ');
      GotoXY(26,10);
      Write(' | ');
      TextColor(CurColor);Write('лл');
      TextColor(15);Write(Rd:4,Gn:3,Bl:3,' |');
      GotoXY(26,11);
      Write(' `--------------'' ');
      GotoXY(26,12);Write(' .----------------------------. ');
      GotoXY(26,13);Write(' | Use R/G/B/r/g/b to add or  | ');
      GotoXY(26,14);Write(' | remove the corresponding   | ');
      GotoXY(26,15);Write(' | color from the current one | ');
      GotoXY(26,16);Write(' `----------------------------'' ');
      Read(KBD,C);
      CASE C OF
       'R' : rd:=rd+1;
       'r' : rd:=rd-1;
       'G' : gn:=gn+1;
       'g' : gn:=gn-1;
       'B' : bl:=bl+1;
       'b' : bl:=bl-1;
       END;
      Rd:=Rd mod 64;
      Gn:=Gn mod 64;
      Bl:=Bl mod 64;
      SetColor(CurColor,rd,gn,bl);
    UNTIL (C=Chr(13)) or (C=Chr(27));
  END;

(************************************************************************
                          Printing Procedures
************************************************************************)

PROCEDURE PrintOptions;
  BEGIN
    IF CursorMode=TRUE THEN TextColor(10) ELSE TextColor(8);
    GotoXY(30,21);
    Write('[Cursor]');
    IF InsertMode=TRUE THEN TextColor(10) ELSE TextColor(8);
    Write('  [Insert]');
    IF AutoSave=TRUE THEN TextColor(10) ELSE TextColor(8);
    Write('  [AutoSave]');
  END;

PROCEDURE PrintChars;
var X,Y:BYTE;
  BEGIN
    FOR X:=1 TO 47 DO
      FOR Y:=1 TO 16 DO
        BEGIN
          TextColor(ColArray[X,Y]);
          GotoXY(X+2,Y+3);
          Write(ChrArray[X,Y]);
        END;
    TextColor(ColArray[CursorX,CursorY]+Blink);
    GotoXY(CursorX+2,CursorY+3);
    Write(ChrArray[CursorX,CursorY]);
    GotoXY(CursorX+2,CursorY+3);     {put cursor back on space}
  END;

PROCEDURE PrintMainBox;
  BEGIN
    ClrScr;
    TextColor(15);
    WriteLN('.-----------------------------------------------------------.');
    WriteLN('| Press <esc> for menu selections...                        |');
    WriteLN('|.-----------------------------------------------.          |');
    Write('||                                               |  0 - ');
    TextColor(0);Write('лл');TextColor(15);WriteLN('  |');
    Write('||                                               |  1 - ');
    TextColor(1);Write('лл');TextColor(15);WriteLN('  |');
    Write('||                                               |  2 - ');
    TextColor(2);Write('лл');TextColor(15);WriteLN('  |');
    Write('||                                               |  3 - ');
    TextColor(3);Write('лл');TextColor(15);WriteLN('  |');
    Write('||                                               |  4 - ');
    TextColor(4);Write('лл');TextColor(15);WriteLN('  |');
    Write('||                                               |  5 - ');
    TextColor(5);Write('лл');TextColor(15);WriteLN('  |');
    Write('||                                               |  6 - ');
    TextColor(6);Write('лл');TextColor(15);WriteLN('  |');
    Write('||                                               |  7 - ');
    TextColor(7);Write('лл');TextColor(15);WriteLN('  |');
    Write('||                                               |  8 - ');
    TextColor(8);Write('лл');TextColor(15);WriteLN('  |');
    Write('||                                               |  9 - ');
    TextColor(9);Write('лл');TextColor(15);WriteLN('  |');
    Write('||                                               | 10 - ');
    TextColor(10);Write('лл');TextColor(15);WriteLN('  |');
    Write('||                                               | 11 - ');
    TextColor(11);Write('лл');TextColor(15);WriteLN('  |');
    Write('||                                               | 12 - ');
    TextColor(12);Write('лл');TextColor(15);WriteLN('  |');
    Write('||                                               | 13 - ');
    TextColor(13);Write('лл');TextColor(15);WriteLN('  |');
    Write('||                                               | 14 - ');
    TextColor(14);Write('лл');TextColor(15);WriteLN('  |');
    WriteLN('||                                               | 15 - лл  |');
    WriteLN('|`-----------------------------------------------''          |');
    WriteLN('| ASCII Artwork Studio V5.3                                 |');
    WriteLN('`-----------------------------------------------------------''');
  END;

PROCEDURE PrintMenuOptions;
  BEGIN
    TextColor(15);
    GotoXY(10,6);
    Write(' .----------------------------. ');
    GotoXY(10,7);
    Write(' |  ASCII Editor Menu System  | ');
    GotoXY(10,8);
    Write(' |----------------------------| ');
    GotoXY(10,9);
    Write(' |  ');
    TextColor(CurColor); Write('Color ',CurColor:2);
    TextColor(15); Write('                  | ');
    GotoXY(10,10);
    Write(' |  X : Clear Screen          | ');
    GotoXY(10,11);
    Write(' |  C : Cycle Colors          | ');
    GotoXY(10,12);
    Write(' |  ');
    IF not (CurColor in [1,2,3,4,5,7]) THEN TextColor(8);
    Write('E : Edit current color');
    TextColor(15); Write('    | ');
    GotoXY(10,13);
    Write(' |  S : Save work in progress | ');
    GotoXY(10,14);
    Write(' |  L : Load picture file     | ');
    GotoXY(10,15);
    Write(' |  Q : Quit ASCII Editor     | ');
    GotoXY(10,16);
    Write(' |  H : Help on Topic         | ');
    GotoXY(10,17);
    Write(' |  <esc> : Return to Editor  | ');
    GotoXY(10,18);
    Write(' `----------------------------'' ');
  END;

(************************************************************************
                       Miscellaneous Procedures
************************************************************************)

PROCEDURE InitStuff;
var X,Y:BYTE;
  BEGIN
    CurColor:=15;
    TextColor(15);
    CursorX:=10;
    CursorY:=10;
    CursorMode:=FALSE; {stationary}
    InsertMode:=FALSE; {replace mode}
    AutoSave:=FALSE;   {do not ask}
     {NOTE: AutoSave will be set to TRUE after the call to ClearScreen}
  END;

PROCEDURE PromptForSave(var Really:BOOLEAN);
var C:CHAR;
  BEGIN
    TextColor(15);
    GotoXY(21,6);
    WriteLN('.----------------------.');
    GotoXY(21,7);
    WriteLN('|----------------------|');
    GotoXY(21,8);
    WriteLN('| Do you want to save  |');
    GotoXY(21,9);
    WriteLN('|  your work now?      |');
    GotoXY(21,10);
    WriteLN('|  <Y>es               |');
    GotoXY(21,11);
    WriteLN('|  <N>o                |');
    GotoXY(21,12);
    WriteLN('|  <C>ancel            |');
    GotoXY(21,13);
    WriteLN('`----------------------''');
    REPEAT
      Read(KBD,C);
      C:=UpCase(C);
    UNTIL C in ['Y','N','C',''];
    Really:=TRUE;
    CASE C OF
     'Y'     : SaveMenu; {447}
     '','C' : Really:=FALSE;
     END {case};
  END;

PROCEDURE ClearDrawingBoard;
var X,Y:BYTE; Really:BOOLEAN;
  BEGIN
    Really:=TRUE;
    IF AutoSave THEN PromptForSave(Really); {657}
    IF Really THEN
      FOR X:=1 TO 47 DO
        FOR Y:=1 TO 16 DO
          BEGIN
            ChrArray[X,Y]:=Chr(0);
            ColArray[X,Y]:=7;
          END;
  END;

PROCEDURE GetCommand(var Command:CHAR; var EscapeFlag:BOOLEAN);
  BEGIN
    Read(KBD,Command);
    IF Command=Chr(27) THEN EscapeFlag:=TRUE else EscapeFlag:=FALSE;
    IF KeyPressed THEN
      Read(KBD,Command);
  END;

PROCEDURE DoQuitSequence;
var Really:BOOLEAN;
  BEGIN
    Really:=TRUE;
    IF AutoSave THEN PromptForSave(Really); {657}
    IF Really THEN
      BEGIN
        TextColor(7);
        ClrScr;
        Halt;
      END;
  END;

(************************************************************************
                          Character Procedures
************************************************************************)

PROCEDURE LineFeed; {carriage return/linefeed}
  BEGIN
    CursorX:=1;
    IF CursorY<16 THEN
      CursorY:=CursorY+1;
  END;

PROCEDURE DeleteLine;  {pull up entire array below CursorY}
var X,Y:BYTE;
  BEGIN
    FOR X:=1 TO 47 DO
      BEGIN
        FOR Y:=CursorY TO 15 DO
          BEGIN
            ChrArray[X,Y]:=ChrArray[X,Y+1];
            ColArray[X,Y]:=ColArray[X,Y+1];
          END;
        ChrArray[X,16]:=' ';
      END;
  END;

PROCEDURE InsertLine;  {push down entire array below CursorY}
var X,Y:BYTE;
  BEGIN
    FOR X:=1 TO 47 DO
      BEGIN
        FOR Y:=16 DOWNTO CursorY+1 DO
          BEGIN
            ChrArray[X,Y]:=ChrArray[X,Y-1];
            ColArray[X,Y]:=ColArray[X,Y-1];
          END;
        ChrArray[X,CursorY]:=' ';
      END;
  END;

PROCEDURE DeleteChar;
var LCV:BYTE;
  BEGIN
    FOR LCV:=CursorX TO 46 DO
      BEGIN
        ChrArray[LCV,CursorY]:=ChrArray[LCV+1,CursorY]; {move chars a space}
        ColArray[LCV,CursorY]:=ColArray[LCV+1,CursorY]; {move colors}
      END;
    ChrArray[47,CursorY]:=' ';
  END;

PROCEDURE InsertChar(Command:CHAR);
var LCV:BYTE;
  BEGIN
    FOR LCV:=47 DOWNTO CursorX+1 DO
      BEGIN
        ChrArray[LCV,CursorY]:=ChrArray[LCV-1,CursorY]; {move chars a space}
        ColArray[LCV,CursorY]:=ColArray[LCV-1,CursorY]; {move colors}
      END;
    ChrArray[CursorX,CursorY]:=Command;
    ColArray[CursorX,CursorY]:=CurColor;
    IF (CursorMode) and (CursorX < 47) THEN
      CursorX:=CursorX+1;
  END;

PROCEDURE AddCharacter(Char1:CHAR);
  BEGIN
    ChrArray[CursorX,CursorY]:=Char1;
    ColArray[CursorX,CursorY]:=CurColor;
    IF (CursorMode) and (CursorX < 47) THEN {move cursor to right}
      CursorX:=CursorX+1;
  END;

PROCEDURE EndOfLine;
var X:BYTE;
  BEGIN
    CursorX:=0;
    FOR X:=1 TO 47 DO
      IF (ChrArray[X,CursorY]>' ') THEN CursorX:=X;
    IF CursorX < 47 THEN CursorX:=CursorX+1;
  END;

(************************************************************************
                        Control Procedures
************************************************************************)

PROCEDURE DoMenus;
var Comm:CHAR;Temp:BOOLEAN;
  BEGIN
    Comm:=Chr(0);
    REPEAT
      IF UpCase(Comm) <> 'C' THEN PrintMainBox; {561}
      IF UpCase(Comm) <> 'C' THEN PrintOptions; {534}
      PrintMenuOptions; {604}
      Read(KBD,Comm);
       CASE UpCase(Comm) OF
        'Q' : DoQuitSequence; {710}
        'C' : IF Comm='C' THEN CycleColors(True)  {485}
              ELSE CycleColors(False);
        'E' : IF CurColor IN [1..5,7] THEN EditCurrentColor; {494}
        'S' : SaveMenu; {447}
        'L' : LoadMenu; {315}
        'X' : ClearDrawingBoard; {688}
        'H' : DoHelpFile; {139}
        END {case};
    UNTIL Comm=Chr(27);
    PrintMainBox; {561}
    PrintOptions; {534}
    PrintChars; {545}
  END;

PROCEDURE ActOnCommand(Command:CHAR;EscapeFlag:BOOLEAN);
  BEGIN
    IF EscapeFlag THEN  {two-key command}
      CASE Command OF
        'H' : IF CursorY>1 THEN CursorY:=CursorY-1;   {up arrow}
        'K' : IF CursorX>1 THEN CursorX:=CursorX-1;   {left arrow}
        'M' : IF CursorX<47 THEN CursorX:=CursorX+1;  {right arrow}
        'P' : IF CursorY<16 THEN CursorY:=CursorY+1;  {down arrow}
        'G' : CursorX:=1;                             {home}
        'O' : EndOfLine; {795}                        {end}
        'I' : CursorY:=1;                             {pgup}
        'Q' : CursorY:=16;                            {pgdown}
        'S' : DeleteChar; {762}                       {del}
        'R' : BEGIN                                   {insert}
                InsertMode:=not InsertMode;
                PrintOptions; {534}
              END;
        '.' : BEGIN                                   {Alt-C}
                CursorMode:=not CursorMode;
                PrintOptions; {534}
              END;
        '' : BEGIN                                   {Alt-A}
                AutoSave:=not AutoSave;
                PrintOptions; {534}
              END;
        '' : InsertLine; {748}                       {Ctrl-I}
        '' : DeleteLine; {734}                       {Ctrl-D}
        '' : DoMenus; {808}                          {Escape}
        ';' : BEGIN                                   {F1}
                DoHelpFile; {139}
                PrintMainBox; {561}
                PrintOptions; {534}
              END;
        '' : IF CursorX-8 < 1 THEN CursorX:=1        {shift-tab}
                ELSE CursorX:=CursorX-8;
      END {case}
    ELSE
      BEGIN
        CASE Command OF
          '' : BEGIN                                 {backspace}
                  IF CursorX>1 THEN CursorX:=CursorX-1;
                  DeleteChar; {762}
                END;
     ' '..'~' : IF InsertMode THEN InsertChar(Command) {773}
                  ELSE AddCharacter(Command); {787}   {ASCII character}
          END {case};
        IF Command=Chr(9) THEN                        {tab}
          IF (CursorX+8) > 47 THEN CursorX:=47
          ELSE CursorX:=CursorX+8;
        IF Command=Chr(13) THEN LineFeed; {727}       {enter}
      END {else};
  END {procedure};

PROCEDURE DoEditor; {main program}
var Command:CHAR; EscapeFlag:BOOLEAN;
  BEGIN
    InitStuff; {644}
    ClearDrawingBoard; {688}
    AutoSave:=TRUE;
    PrintMainBox; {561}
    PrintOptions; {534}
    REPEAT
      PrintChars; {545}                     {drawing board}
      GetCommand(Command,EscapeFlag);       {ASCII keypress or <ESC>}
      ActOnCommand(Command, EscapeFlag);    {this references all other stuff}
    UNTIL 1=0;                              {indefinite; halts inside}
  END;

BEGIN
  DoEditor;
END.

