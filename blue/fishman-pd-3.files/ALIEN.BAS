10 CLS:KEY OFF:COLOR 7,0,1:DIM SHOT(8)
20 RANDOMIZE TIMER:LOCATE 17,67:PRINT "|` '|"
30 LOCATE 5,27:PRINT "/'\      \,/              \,/           \   /"
40 LOCATE 6,43:PRINT "/'\              /'\"
50 LOCATE 7,67:PRINT "/   \"
60 LOCATE 9,63:PRINT "/V\       /V\"
70 LOCATE 10,64:PRINT "'         `"
80 LOCATE 15,67:PRINT "| A |"
90 LOCATE 16,67:PRINT "|_X_|"
100 COLOR 15:LOCATE 6,8:PRINT ",_           __."
110 LOCATE 7,5:PRINT "_mA^             ^^~":LOCATE 5,69:PRINT "|"
120 LOCATE 6,66:PRINT "-- + --":LOCATE 7,69:PRINT "|"
130 LOCATE 8,4:PRINT "Z`P                ~~^PN        #           #"
140 LOCATE 9,4:PRINT "N.Vs_              ,_Z\Z   mm,  # mm,  ;we a#` ! ;we"
150 LOCATE 9,69:PRINT "|":LOCATE 10,5:PRINT "~+s2Vf'*========'~XgY~   `bw#. #";
160 PRINT "`bw#. Sea  #  # Sea":LOCATE 11,8:PRINT "'~~Vmm===emzf~~`"
170 LOCATE 11,69:PRINT "|":LOCATE 13,69:PRINT "|"
180 LOCATE 13,27:PRINT "uae":LOCATE 14,27:PRINT "Eue  naen  nes  !  ae, egg"
190 LOCATE 15,27:PRINT "#ue  #AO@  #aV  #  #   Sw%"
200 LOCATE 16,38:PRINT "8":COLOR 4:LOCATE 5,11:PRINT ",mA^^^Mm."
210 LOCATE 6,10:PRINT "gA`     'Ms":LOCATE 7,9:PRINT "YP         Y@"
220 LOCATE 8,9:PRINT "|[          @":LOCATE 8,64:PRINT "_         _"
230 LOCATE 9,9:PRINT "]b          @":LOCATE 16,16:PRINT "--+=================-"
240 LOCATE 11,25:PRINT "--+=============================`"
250 LOCATE 16,40:PRINT "-================+--":LOCATE 17,69:PRINT "v"
260 LOCATE 14,68:PRINT ". .":LOCATE 12,12:PRINT "`=+==+'"
270 FOR X=1 TO 100000!:NEXT X:COLOR 15
280 CLS
290 LET POSITION=24
300 LET SHOTS=75
310 LET SHIPS=3
320 LET SCORE=0:LET NLEV=4000
330 DIM ALIEN(20,4):DIM INTERVAL(19):DIM ATTACK(20)
340 LET LEVEL=1
350 INPUT "Game File";IN$:CLS
360 OPEN IN$ FOR INPUT AS #1
370 LET SEARCH$=CHR$(INT(LEVEL/10)+48)+CHR$(LEVEL-INT(LEVEL/10)*10+48)
380 LINE INPUT #1,S$
390 IF NOT MID$(S$,1,2)=SEARCH$ AND NOT EOF(1) THEN 380
400 IF EOF(1) THEN GOTO 2510
410 INPUT #1,U,ALIENS,PROB
420 FOR X=1 TO ALIENS
430 INPUT #1,U,alien(x,3),alien(x,4),INTERVAL(X-1)
440 LET ALIEN(X,0)=0-INTERVAL(X-1):let alien(x,2)=0
450 NEXT X
460 CLS
470 PRINT ".--------------------------------------------------r-----------------."
480 PRINT "|######Y                                   `Y######| L e v e l       |"
490 PRINT "|#####P'                                   .d######|##&##$@#@#$@##&@#|"
500 PRINT "l#####l                                    !#######l&#&#&###&##$#&@#$|"
510 PRINT "l#####b                                    `S######l&Galactic Empire#|"
520 PRINT "l######|                                   _!######l#@@&##@&#&##@#$&@|"
530 PRINT "l#####P                                    l#######l#@$#&$##@##@&##$#|"
540 PRINT "l#####b                                    ~S######l#@#&###&@$####$&#|"
550 PRINT "l#####P                                     `S#####l##&##$@#@#$@##&@#|"
560 PRINT "l#####b.                                     d#####l&#&#&###&##$#&@#$|"
570 PRINT "l######!                                   .d#####P'                 |"
580 PRINT "l#####P'                                   l######                   |"
590 PRINT "l#####l                                    `S####|                   |"
600 PRINT "l####P'                                    .d####|                   |"
610 PRINT "l####b                                      S####|                   |"
620 PRINT "l#####b.                                    `S###|                   |"
630 PRINT "l######!                                    d####|                   |"
640 PRINT "l#####P'                                   !#####|                   |"
650 PRINT "l####|                                      S####|                   |"
660 PRINT "l####l                                     .d####|                   |"
670 PRINT "l#####b                                    d#####|                   |"
680 PRINT "`================================================:==================='"
690 LET TURN=TURN+1:IF TURN=6 THEN LET TURN=1
700 LOCATE 17,(POSITION-3):PRINT "  . .  "
710 LOCATE 18,(POSITION-3):PRINT " | A | "
720 LOCATE 19,(POSITION-3):PRINT " |_X_| "
730 LOCATE 20,(POSITION-3):PRINT " |`v'| "
740 LOCATE 2,65:PRINT INT(LEVEL/10)
750 LOCATE 2,67:PRINT LEVEL-(INT(LEVEL/10)*10)
760 LOCATE 19,54:IF SHOTS>4 THEN PRINT "l";
770 FOR X=9 TO 74 STEP 5
780 IF SHOTS>X THEN PRINT "l";
790 NEXT X
800 IF SHOTS/5=INT(SHOTS/5) THEN PRINT " "
810 IF SHOTS-(INT(SHOTS/5)*5)=1 THEN PRINT "."
820 IF SHOTS-(INT(SHOTS/5)*5)=2 THEN PRINT ":"
830 IF SHOTS-(INT(SHOTS/5)*5)=3 THEN PRINT "i"
840 IF SHOTS-(INT(SHOTS/5)*5)=4 THEN PRINT "|"
850 LOCATE 21,54
860 FOR X=1 TO 5
870 IF NOT SHIPS<X THEN PRINT "|O|";
880 NEXT X
890 PRINT "   "
900 LOCATE 20,54
910 FOR X=1 TO 5
920 IF NOT SHIPS<X THEN PRINT " . ";
930 NEXT X
940 PRINT "   "
950 IF TURN=5 THEN GOSUB 1550  ' Alien Update
960 GOSUB 1110  ' Score Update
970 GOSUB 1370  ' Shots Update
980 REM ******************************* End Setup Process ************
990 LET Y=Y+1
1000 A$=INKEY$:IF A$="" AND Y<100 THEN 990
1010 LET Y=0:IF A$="" THEN 1090
1020 IF A$=CHR$(0)+CHR$(75) THEN LET A$="4"
1030 IF A$=CHR$(0)+CHR$(77) THEN LET A$="6"
1040 IF A$="q" OR A$="Q" THEN SYSTEM
1050 IF A$="4" AND POSITION>12 THEN LET POSITION=POSITION-1:GOTO 1090
1060 IF A$="6" AND POSITION<40 THEN LET POSITION=POSITION+1:GOTO 1090
1070 IF A$=" " THEN GOSUB 1310:GOTO 1090
1075 if a$="d" or a$="D" then gosub 2430:GOTO 1090
1080 BEEP
1090 IF TEMP=1 THEN CLOSE #1:LET TEMP=0:GOTO 360
1100 GOTO 690
1110 '                  Print Score Routine
1120 color 12:if score=pscore then 1200
1130 if score-pscore>999 then let s(4)=s(4)+1:let pscore=pscore+1000:goto 1130
1140 if score-pscore>99 then let s(3)=s(3)+1:let pscore=pscore+100:goto 1140
1150 if score-pscore>9 then let s(2)=s(2)+1:let pscore=pscore+10:goto 1150
1160 if score-pscore>0 then let s(1)=s(1)+1:let pscore=pscore+1:goto 1160
1170 for xx=1 to 4
1180 if s(xx)>9 then let s(xx+1)=s(xx+1)+1:let s(xx)=s(xx)-10
1190 next xx
1193 locate 11,53:print "               "
1195 locate 12,51:print "                  "
1197 locate 13,51:print "                  "
1200 if s(5)=1 then locate 12,52:print "|":locate 13,52:print "|"
1210 for xx=1 to 4
1220 if not s(xx)=1 and not s(xx)=4 then locate 11,(71-4*xx):print "_"
1230 if not s(xx)=2 and not s(xx)=3 and not s(xx)=7 then locate 12,(70-4*xx):print "|"
1240 if not s(xx)=1 and not s(xx)=7 and not s(xx)=0 then locate 12,(71-4*xx):print "_"
1250 if not s(xx)=1 and not s(xx)=5 and not s(xx)=6 then locate 12,(72-4*xx):print "|"
1260 if s(xx)<3 or s(xx)=6 or s(xx)=8 or s(xx)=0 then locate 13,70-4*xx:print "|"
1270 if not s(xx)=1 and not s(xx)=4 and not s(xx)=7 then locate 13,(71-4*xx):print "_"
1280 if not s(xx)=1 and not s(xx)=2 then locate 13,(72-4*xx):print "|"
1290 next xx
1300 color 15:RETURN
1310 REM                   SHOOT AT ALIEN
1320 IF SCRSHOT=5 THEN BEEP:RETURN
1330 IF SHOTS=0 THEN BEEP:RETURN
1340 LET SHOT(1)=POSITION:LET SCRSHOT=SCRSHOT+1
1350 LET SHOTS=SHOTS-1
1360 RETURN
1370 REM                   SHOTS UPDATE
1380 IF SHOT(8)>0 THEN LET SCRSHOT=SCRSHOT-1:LOCATE 3,SHOT(8):PRINT " "
1390 LET SHOT(8)=SHOT(7)
1400 LET SHOT(7)=SHOT(6)
1410 LET SHOT(6)=SHOT(5)
1420 LET SHOT(5)=SHOT(4)
1430 LET SHOT(4)=SHOT(3)
1440 LET SHOT(3)=SHOT(2)
1450 LET SHOT(2)=SHOT(1)
1460 LET SHOT(1)=0
1470 IF SHOT(8)>0 THEN LOCATE 3,SHOT(8):PRINT "|":LOCATE 5,SHOT(8):PRINT " "
1480 IF SHOT(7)>0 THEN LOCATE 5,SHOT(7):PRINT "|":LOCATE 7,SHOT(7):PRINT " "
1490 IF SHOT(6)>0 THEN LOCATE 7,SHOT(6):PRINT "|":LOCATE 9,SHOT(6):PRINT " "
1500 IF SHOT(5)>0 THEN LOCATE 9,SHOT(5):PRINT "|":LOCATE 11,SHOT(5):PRINT " "
1510 IF SHOT(4)>0 THEN LOCATE 11,SHOT(4):PRINT "|":LOCATE 13,SHOT(4):PRINT " "
1520 IF SHOT(3)>0 THEN LOCATE 13,SHOT(3):PRINT "|":LOCATE 15,SHOT(3):PRINT " "
1530 IF SHOT(2)>0 THEN LOCATE 15,SHOT(2):PRINT "|"
1540 RETURN
1550 REM  ALIEN EVERYTHING
1560 '  Move aliens up one; if alien is ready to appear set alien position
1570 FOR X=1 TO ALIENS
1580 IF ALIEN(X,0)<1 THEN LET ALIEN(X,0)=ALIEN(X,0)+1
1590 IF ALIEN(X,0)=1 THEN LET ALIEN(X,0)=12:LET ALIEN(X,1)=42
1600 NEXT X
1610 ' Move & Show Aliens & Attackers
1620 GOSUB 1720 ' Delete Old Aliens
1630 GOSUB 1870 ' Move Old-New Aliens
1640 GOSUB 2040 ' Show Aliens
1650 GOSUB 2200 ' Shoot Aliens in Range of Missile
1660 LET TEMP=1
1670 FOR X=1 TO ALIENS
1680 IF ALIEN(X,0)<100 THEN LET TEMP=0
1690 NEXT X
1700 IF TEMP=1 THEN LET LEVEL=LEVEL+1
1710 RETURN
1720 '    DELETING OLD ALIENS
1730 FOR X=1 TO ALIENS
1740 IF ALIEN(X,0)<1 THEN 1850
1750 IF ALIEN(X,0)>99 THEN 1850
1760 IF ATTACK(X)=1 THEN 1820
1770 IF ALIEN(X,0)=2 THEN 1790
1780 LOCATE ALIEN(X,0)-1,ALIEN(X,1):PRINT " "
1790 LOCATE ALIEN(X,0),ALIEN(X,1)-1:PRINT "   "
1800 LOCATE ALIEN(X,0)+1,ALIEN(X,1):PRINT " "
1810 GOTO 1850
1820 IF ALIEN(X,0)>2 THEN LOCATE ALIEN(X,0)-1,ALIEN(X,1)-2:PRINT "     "
1830 LOCATE ALIEN(X,0),ALIEN(X,1)-2:PRINT "     "
1840 IF ALIEN(X,0)<21 THEN LOCATE ALIEN(X,0)+1,ALIEN(X,1):PRINT " "
1850 NEXT X
1860 RETURN
1870 '    MOVING ALIENS
1880 FOR X=1 TO ALIENS
1890 IF ALIEN(X,0)<1 THEN 2020
1900 IF ALIEN(X,0)=100 THEN 2020
1905 if alien(x,0)=200 then let alien(x,0)=3:let alien(x,1)=int(rnd*3)+25
1910 IF INT(RND*PROB)=0 AND 12<ALIEN(X,1) AND ALIEN(X,1)<39 THEN LET ATTACK(X)=1
1920 IF ATTACK(X)=1 THEN 1980
1930 if alien(x,2)=0 then LET ALIEN(X,1)=ALIEN(X,1)-INT(RND*2)-1
1940 if alien(x,2)=0 then LET ALIEN(X,0)=ALIEN(X,0)-INT(RND*1.25)
1941 if alien(x,2)=0 then 1950
1942 if alien(x,0)=alien(x,3) and alien(x,1)=alien(x,4) then 1950
1943 if alien(x,0)-alien(x,3)>1 then let alien(x,0)=alien(x,0)-2:goto 1946
1944 if alien(x,3)-alien(x,0)>1 then let alien(x,0)=alien(x,0)+2:goto 1946
1945 let alien(x,0)=alien(x,3)
1946 if alien(x,1)-alien(x,4)>0 then let alien(x,1)=alien(x,1)-1
1947 if alien(x,4)-alien(x,1)>0 then let alien(x,1)=alien(x,1)+1
1950 IF ALIEN(X,0)<2 THEN LET ALIEN(X,0)=200
1955 IF ALIEN(X,1)<9 THEN LET ALIEN(X,0)=200
1960 if alien(x,0)<8 then let alien(x,2)=1
1970 GOTO 2020
1980 LET ALIEN(X,0)=ALIEN(X,0)+INT(RND*2)+1
1990 IF ALIEN(X,0)>21 THEN LET ALIEN(X,0)=2
2000 IF ALIEN(X,0)=6 THEN LET ATTACK(X)=0
2010 IF ALIEN(X,0)>16 AND ABS(ALIEN(X,1)-POSITION)<3 THEN BEEP:GOSUB 2430
2020 NEXT X
2030 RETURN
2040 '    SHOWING ALIENS
2050 FOR X=1 TO ALIENS
2060 IF ALIEN(X,0)>99 THEN 2180
2070 IF ALIEN(X,0)<1 THEN 2180
2080 IF ATTACK(X)=1 THEN 2140
2090 IF ALIEN(X,0)>2 THEN LOCATE ALIEN(X,0)-1,ALIEN(X,1):COLOR 4:PRINT "_"
2100 COLOR 7:LOCATE ALIEN(X,0),ALIEN(X,1)-1:PRINT "/V\"
2110 LOCATE ALIEN(X,0)+1,ALIEN(X,1):PRINT "'"
2120 IF RND*2>1 THEN LOCATE ALIEN(X,0)+1,ALIEN(X,1):PRINT "`"
2130 GOTO 2180
2140 COLOR 7
2150 IF ALIEN(X,0)>2 THEN LOCATE ALIEN(X,0)-1,ALIEN(X,1)-2:PRINT ". : ."
2160 LOCATE ALIEN(X,0),ALIEN(X,1)-2:PRINT ".-A-.":COLOR 4
2170 IF ALIEN(X,0)<21 THEN LOCATE ALIEN(X,0)+1,ALIEN(X,1):PRINT "^"
2180 COLOR 15:NEXT X
2190 RETURN
2200 '    SHOOTING ALIENS
2210 FOR X=1 TO ALIENS
2220 FOR Y=1 TO 8
2230 IF ALIEN(X,0)>99 THEN 2250
2240 IF ABS(ALIEN(X,1)-SHOT(Y))<2 AND ABS(ALIEN(X,0)-19+2*Y)<3 THEN GOSUB 2280
2250 NEXT Y
2260 NEXT X
2270 RETURN
2280 IF ALIEN(X,0)>2 THEN LOCATE ALIEN(X,0)-1,ALIEN(X,1)-2:PRINT "\ | /"
2290 IF ALIEN(X,0)>1 THEN LOCATE ALIEN(X,0),ALIEN(X,1)-3:PRINT "--   --"
2300 LOCATE ALIEN(X,0)+1,ALIEN(X,1)-2:PRINT "/ | \"
2310 IF ATTACK(X)=0 THEN LET SCORE=SCORE+100
2320 IF ATTACK(X)=0 THEN LOCATE ALIEN(X,0),ALIEN(X,1)-1:PRINT "100"
2330 IF ATTACK(X)=1 THEN LET SCORE=SCORE+300
2340 IF ATTACK(X)=1 THEN LOCATE ALIEN(X,0),ALIEN(X,1)-1:PRINT "300"
2350 FOR N=1 TO 300
2360 NEXT N
2370 IF NOT SCORE<NLEV THEN LET SHIPS=SHIPS+1:LET NLEV=INT(NLEV*1.5/1000)*1000
2380 IF ALIEN(X,0)>2 THEN LOCATE ALIEN(X,0)-1,ALIEN(X,1)-2:PRINT "     "
2390 IF ALIEN(X,0)>1 THEN LOCATE ALIEN(X,0),ALIEN(X,1)-3:PRINT "       "
2400 LOCATE ALIEN(X,0)+1,ALIEN(X,1)-2:PRINT "     "
2410 LET ALIEN(X,0)=100:LET ATTACK(X)=0
2420 RETURN
2430 '  You're Dead!
2440 LOCATE 17,(POSITION-1):PRINT "   "
2450 LOCATE 18,(POSITION-2):PRINT "     "
2460 LOCATE 19,(POSITION-2):PRINT "     "
2470 LOCATE 20,(POSITION-2):PRINT "     "
2480 LET SHIPS=SHIPS-1:LET SHOTS=75:LET POSITION=24
2490 IF SHIPS=-1 THEN SYSTEM
2500 RETURN
2510 '  You Win!
2520 COLOR 15,0,14
2530 CLS
2540 LOCATE 10,20:PRINT "You Win!"
2550 PRINT:PRINT "Hit any key to continue..."
2560 A$=INKEY$:IF A$="" THEN 2560
2570 SYSTEM
