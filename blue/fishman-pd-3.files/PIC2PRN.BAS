10 '    Basic Pic2Prn  ====  .pic to .art File
20 CLS:KEY OFF:COLOR 15,0,0
30 INPUT "Input File";INFILE$
40 INPUT "Output File";OUTFILE$
50 OPEN INFILE$ FOR INPUT AS #1
60 OPEN OUTFILE$ FOR APPEND AS #2
70 LINE INPUT #1,I$
80 LINE INPUT #1,II$
90 FOR X=1 TO LEN(I$) STEP 2
100 LET A$=MID$(I$,X,2)+MID$(II$,X,2)
110 GOSUB 150
120 NEXT X
130 IF NOT EOF(1) THEN PRINT #2,"":GOTO 70
140 CLOSE #1:CLOSE #2:CHAIN "Menu"
150 LET E=0
160 IF NOT MID$(A$,1,1)="0" THEN LET E=E+1000          '
170 IF NOT MID$(A$,2,1)="0" THEN LET E=E+100           '   1 2
180 IF NOT MID$(A$,3,1)="0" THEN LET E=E+10            '   3 4
190 IF NOT MID$(A$,4,1)="0" THEN LET E=E+1             '
200 IF E=0 THEN LET E$=" "
210 IF E=1 THEN LET E$=","
220 IF E=10 THEN LET E$="."
230 IF E=11 THEN LET E$="w"
240 IF E=100 THEN LET E$="`"
250 IF E=101 THEN LET E$="]"
260 IF E=110 THEN LET E$="/"
270 IF E=111 THEN LET E$="d"
280 IF E=1000 THEN LET E$="'"
290 IF E=1001 THEN LET E$="\"
300 IF E=1010 THEN LET E$="["
310 IF E=1011 THEN LET E$="b"
320 IF E=1100 THEN LET E$=CHR$(34)
330 IF E=1101 THEN LET E$="Y"
340 IF E=1110 THEN LET E$="P"
350 IF E=1111 THEN LET E$="@"
360 PRINT #2,E$;:RETURN
