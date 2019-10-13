***********************
PROCEDURE PREGUNTA
STORE .T. TO WPREG
DO WHILE WPREG
   @ 23,0
   STORE SUBSTR(WCH,1,1) TO WCHOICE
   @ 23,40- (LEN(TEX)/2) SAY TEX GET WCHOICE
   READ
   IF AT(WCHOICE,WCH) > 0
      STORE .F. TO WPREG
      EXIT
   ENDIF
ENDDO
@ 23,0
STORE WCHOICE TO WCH
RETURN
*************************
 *****************
 PROCEDURE MENSAJE
 PARAMETERS MES
 SET COLOR TO g/n
 @ 23,1 SAY SPACE(78)
 @ 23,40-(LEN(MES)/2) SAY MES
 RETURN
 **************************************************
 PROCEDURE AVISO
 PARAMETERS MES
 STORE " " TO X
 SET COLOR TO W+/B
 ?? CHR(7)
 @ 23,1 SAY SPACE(78)
 @ 23,40-(LEN(MES)/2) SAY MES GET X
 READ
 @ 23,1 SAY SPACE(78)
 RETURN
 **************************************************
 procedure informa
 store " " to qw1
 store " " to qw2
 store " " to qw3
 store " " to qw4
 store " " to qw5
 store " " to qw6
 store " " to qw7
 store " " to qw8
 store " " to qw9
 store " " to qw10
 store " " to qw11
 store " " to qw12
 store " " to qw13
 store " " to qw14
 store " " to qw15
 store " " to qw16
 store " " to qw17
 store " " to qw18
 store " " to qw19
 store " " to qw20
 store " " to qw21
 store " " to qw22
 store " " to qw23
 store " " to qw24
 store " " to qw25
 store " " to qw26
 store " " to qw27
 store " " to qw28
 store " " to qw29
 store "." to qw30
 store "A" to qw31
 store "." to qw32
 store "C" to qw33
 store " " to qw34
 store "," to qw35
 store "S" to qw36
 store "A" to qw37
 store "M" to qw38
 store "E" to qw39
 store "R" to qw40
 STORE QW40+QW39+QW38+QW37+QW36+QW35+QW34+QW33+QW32+QW31+QW30+QW29+QW28 TO QQWW
 STORE QQWW+QW27+QW26+QW25+QW24+QW23+QW22+QW21+QW20+QW19+QW18+QW17+QW16 TO QQWW
 STORE QQWW+QW15+QW14+QW13+QW12+QW11+QW10+QW9+QW8+QW7+QW6+QW5+QW4+QW3+QW2+QW1 TO QQWW
 RETURN
 ******************
PROCEDURE ERRCON
STORE "ERROR IRRECUPERABLE, EL SISTEMA FINALIZARA. <ENTER>" TO MES
DO AVISO WITH MES
SELECT 10
USE SYSERR
APPEND BLANK
REPLACE NUMERO WITH ERROR()
REPLACE MENSAJE WITH MESSAGE()
REPLACE PROGRAMA WITH SYS(16,4)
REPLACE FECHA WITH WFECACT
REPLACE HORA WITH TIME()
CLOSE ALL
QUIT
RETURN
