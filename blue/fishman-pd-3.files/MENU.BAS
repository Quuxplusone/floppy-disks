10 CLS:KEY OFF:COLOR 15,0,3
20 PRINT:PRINT:PRINT:PRINT
30 PRINT "   1 -- Ascii  .ill --> Binary .pic                 "
40 PRINT "   2 -- Binary .pic --> Ascii  .ill                 "
50 PRINT "   3 -- Binary .pic --> Ascii  .art                 "
60 PRINT "   4 -- Binary .pic --> Binary .pic (Inverted)      "
65 PRINT "   5 -- Binary .pic --> Binary .pic (Flipped about \ axis)"
70 PRINT
80 PRINT "   6 -- EXIT
90 PRINT:PRINT
100 INPUT "Which number";NUMBER
110 ON NUMBER GOTO 130,150,170,190,210,230
120 PRINT "I don't understand...":GOTO 100
130 CHAIN "asc2pic"
140 GOTO 30
150 CHAIN "pic2asc"
160 GOTO 30
170 CHAIN "pic2prn"
180 GOTO 30
190 CHAIN "pic-inv"
200 GOTO 30
210 chain "pic-rot"
220 goto 30
230 SYSTEM
240 END
