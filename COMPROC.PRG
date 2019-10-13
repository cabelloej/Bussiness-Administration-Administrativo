
PROCEDURE INDICES
store "DESEA REORGANIZAR LOS INDICES (S/N)" TO TEX
STORE "SN" TO WCH
DO PREGUNTA
IF WCH = "N"
   RETURN
ENDIF
@ 0,0 CLEAR
@ 08,5 SAY "REORGANIZANDO INDICES DEBIDO A INTERRUPCION DEL SISTEMA, FAVOR ESPERAR"
SELECT 1
USE COMGRU
INDEX ON CODGRU TO COMGRU
SELECT 2
USE COMPRO
INDEX ON CODCLI TO COMPRO
SELECT 5
USE COMDCGE
INDEX ON NUMERO TO COMDCGE
SELECT 5
USE COMDCDE
INDEX ON NUMERO+RENGLON TO COMDCDE
SELECT 6
USE COMCXP
INDEX ON CODCXP TO COMCXP
INDEX ON CLIENTE TO COMCXP2
RETURN
****************************************
PROCEDURE RECLOC
SAVE SCRE TO SCRE1
STORE .T. TO WRECLOC
DO WHILE WRECLOC
   IF RLOCK()
      EXIT
   ELSE
      @ 12,20 CLEAR TO 18,60
      @ 12,20 TO 18,60
      @ 14,30 SAY "REGISTRO OCUPADO POR OTRO USUARIO, REINTENTANDO ..."
      @ 16,30 SAY "          OPRIMA [ESC] PARA ABANDONAR              "
      WVALUE = INKEY()
      IF WVALUE = 27
         RETURN TO MASTER
      ENDIF
   ENDIF
ENDDO
RESTORE SCRE FROM SCRE1
RETURN
****************************************
PROCEDURE FILLOC
SAVE SCRE TO SCRE1
STORE .T. TO WFILLOC
DO WHILE WFILLOC
   IF FLOCK()
      EXIT
   ELSE
      @ 12,20 CLEAR TO 18,60
      @ 12,20 TO 18,60
      @ 14,30 SAY "ARCHIVO OCUPADO POR OTRO USUARIO, REINTENTANDO ..."
      @ 16,30 SAY "          OPRIMA [ESC] PARA ABANDONAR             "
      WVALUE = INKEY()
      IF WVALUE = 27
         RETURN TO MASTER
      ENDIF
   ENDIF
ENDDO
RESTORE SCRE FROM SCRE1
RETURN
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
 PROCEDURE MENSAJE
 PARAMETERS MES
 SET COLOR TO g/n
 @ 23,1
 @ 23,40-(LEN(MES)/2) SAY MES
 RETURN
 **************************************************
 PROCEDURE AVISO
 PARAMETERS MES
 STORE " " TO X
 SET COLOR TO g/n
* ?? CHR(7)
 @ 23,1 SAY SPACE(78)
 @ 23,40-(LEN(MES)/2) SAY MES GET X
 READ
 @ 23,1
 RETURN
 *****************
 PROCEDURE CHKPRINT
 PARAMETERS SALTAR
 store .t. to wprinting
 do while wprinting
    store "Prepare la impresora y oprima (Ù) para continuar o (R)echazar" to Qmes
    @ 23,1 
    @ 23,40-(len(Qmes)/2) say Qmes
    store " " to wstat
    @ 23,78 get wstat
    read
    if upper(wstat) = "R"
       store 1 to saltar
       store .f. to wprinting
    else
       store 0 to saltar
       if sys(13) = "READY"
          store .f. to wprinting
       endif
    endif
    @ 23,1
 enddo
 RETURN
 ******************************************************************
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
 store "E" to qw27
 store "D" to qw28
 store "N" to qw29
 store "O" to qw30
 store "C" to qw31
 store " " to qw32
 store "L" to qw33
 store "E" to qw34
 store " " to qw35
 store "O" to qw36
 store "E" to qw37
 store "D" to qw38
 store "I" to qw39
 store "V" to qw40
 STORE QW40+QW39+QW38+QW37+QW36+QW35+QW34+QW33+QW32+QW31+QW30+QW29+QW28 TO QQWW
 STORE QQWW+QW27+QW26+QW25+QW24+QW23+QW22+QW21+QW20+QW19+QW18+QW17+QW16 TO QQWW
 STORE QQWW+QW15+QW14+QW13+QW12+QW11+QW10+QW9+QW8+QW7+QW6+QW5+QW4+QW3+QW2+QW1 TO QQWW
 RETURN
 ***********************
PROCEDURE ERRCON
STORE "ERROR IRRECUPERABLE No "+STR(ERROR(),5)+" , EL SISTEMA SE REINICIALIZARA. <ENTER>" TO MES
DO AVISO WITH MES
SELECT 10
USE SYSERR
APPEND BLANK
REPLACE NUMERO WITH ERROR()
REPLACE MENSAJE WITH MESSAGE()
REPLACE PROGRAMA WITH SYS(16,4)
REPLACE FECHA WITH WFECACT
REPLACE HORA WITH TIME()
CLOSE DATA
CLOSE INDEX
RETURN TO MASTER

