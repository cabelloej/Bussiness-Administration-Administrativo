
***
** ON ERROR DO ERRCON
*STORE SPACE(40) TO QQWW
*STORE "CONSTRUCTORA LA ESTANCIA DORADA, C.A.   " TO T3
*STORE 0 TO PPP
*DO INFORMA
*if qqww<>t3
*    store 1 to ppp
*endif
*if ppp = 1
*   store "ERROR DE INSTALACION" to mes
*   do aviso with mes
*   close all
*   quit
*endif
***
SET TALK OFF
SET ECHO OFF
STORE .F. TO WFLAGACT
STORE .F. TO FLAGASK
SAVE SCRE TO S4
@ 11,54 CLEAR TO 14,77
@ 11,54 TO 14,77
@ 12,55 PROMPT "EDICION NORMAL        "
@ 13,55 PROMPT "EDICION AVANZADA      "
MENU TO WSUBOP4
STORE "INV" TO WRESPALDO
DO CASE
   CASE WSUBOP4 = 1
        DO INV0103A
   CASE WSUBOP4 = 2
        DO INV0103B
ENDCASE
restore scre from s4
IF WFLAGACT
   DO INV0301
ENDIF
RETURN

