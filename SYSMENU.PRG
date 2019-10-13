SET DEVI TO SCRE
SET TALK OFF
SET ECHO OFF
SET HELP OFF
SET SCOREBOARD OFF
SET ESCAPE OFF
SET DELIMITER OFF
SET BELL OFF
SET STATUS OFF
SET SAFETY OFF
SET DELETED ON
SET CONFIRM ON
SET EXACT OFF
SET DATE ITALIAN
*ON ERROR DO ERRCON
SET PROCEDURE TO SYSPROC
CLOSE DATA
CLOSE INDEX

USE SYSDATE
IF DATE() <> CTOD("01-01-80")
   REPLACE FECHASIST WITH DATE()
ENDIF
STORE FECHASIST TO WFECACT
USE
STORE "Cargando sistema, favor esperar ..." to T8
@ 12,40-(len(t8)/2) say t8
STORE "Instalacion no autorizada" to pppq
STORE SPACE(40) TO QQWW
DO INFORMA
SET COLOR TO W/N/,,
CLEAR
SET COLOR TO R+/N
@ 0,0 TO 3,79 DOUBLE
@ 5,0 TO 22,79 DOUBLE
@ 7,1 TO 21,25
@ 7,26 TO 21,52
@ 7,53 TO 21,78
SET COLOR TO G/N
@ 6,7 SAY "MENU PRINCIPAL"
@ 6,35 SAY "SUBMENU"
@ 6,62 SAY "OPCIONES"
SET COLOR TO G/N
STORE "SISTEMA ADMINISTRATIVO." TO T1
STORE "                             " TO T2
*STORE "Realizado por MERCASISTEMA   " TO T2
STORE "REMAS, C.A.                             " TO T3
STORE "Fecha: "+DTOC(WFECACT) TO T4
STORE "Use las flechas para moverse, seleccione con <ENTER>, salga con <ESC>" to T7
@ 2,63 SAY T4
@ 2,2 SAY  T1
@ 4,50 SAY T2
SET COLOR TO G+/N
@ 1,2 SAY T3
STORE .T. TO ILP
DO WHILE ILP
***************************************************
   store t7 to mes
   do mensaje with mes
   store 0 to ppp
   if qqww<>t3
       store 1 to ppp
    endif
    STORE "INVENTARIO             " TO X_1
    STORE "VENTAS y CTAS x COBRAR " TO X_2
    STORE "COMPRAS y CTAS x PAGAR " TO X_3
*   STORE "CAJA y BANCOS          " TO X_4
    SET COLOR TO G/N
    @ 8,2  PROMPT X_1
    @ 9,2  PROMPT X_2
    @ 10,2 PROMPT X_3
*   @ 11,2 PROMPT X_4
    MENU TO WPRINCIPAL
    if ppp = 1
       store pppq to mes
       do aviso with mes
       close all
       quit
    endif
    save scre to s1
    do case
       case wprincipal = 1
            DO INVMENU
       case wprincipal = 2
            DO FACMENU
       case wprincipal = 3
            DO COMMENU
       case wprincipal = 4
          * DO XXXXXXX
       case wprincipal = 0
            store "Salir al DOS ?" TO TEX
            STORE "NS" TO WCH
            DO PREGUNTA
            IF WCH = "N"
               LOOP
            ENDIF
            CLOSE ALL
            CLEAR ALL
            RELEASE ALL
            QUIT
   endcase
   if ppp = 1
      store pppq to mes
      do aviso with mes
      close all
      quit
   endif
   restore scre from s1
enddo
 
