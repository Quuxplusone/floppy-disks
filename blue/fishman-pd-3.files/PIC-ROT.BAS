10 '    Basic Pic-Rot  ====  Rotate .pic File
20 CLS:KEY OFF:COLOR 15,0,0
30 INPUT "Input File";INFILE$
40 INPUT "Output File";OUTFILE$
50 OPEN INFILE$ FOR INPUT AS #1
60 OPEN OUTFILE$ FOR APPEND AS #2
70 dim array$(159,75)
80 let t=t+1
90 line input #1,a$
100 for x=1 to len(a$)
110 let array$(x,t)=mid$(a$,x,1)
120 next x
130 if not eof(1) then 80
135 '
140 for x=1 to 159
150 for t=1 to 75
160 if not array$(x,t)="" then print #2,array$(x,t);
165 if array$(x,t)="" then print #2,"0";
170 next t
180 print #2,""
190 next x
200 close #1:close #2
210 chain "menu"
220 end
