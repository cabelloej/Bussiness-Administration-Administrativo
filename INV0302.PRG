
***
* ON ERROR DO ERRCON
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
STORE SPACE(3) TO WLINEA
STORE 0 TO WLISTA
STORE 0 TO WFACTOR
@ 10,54 CLEAR TO 18,77
@ 10,54 TO 18,77
@ 11,55  SAY "LINEA DE VENTA:" GET WLINEA
@ 12,55  SAY "LISTA (1,2,3) :" GET WLISTA PICTURE "#" RANGE 1,3
@ 13,55  SAY "FACTOR (x PVP):" GET WFACTOR PICTURE "##.##" RANGE 0.1, 99.99
READ
IF WLINEA = SPACE(3)
   @ 11,70 SAY "TODAS"
ELSE
   SELECT 1
   FIND &WLINEA
   IF EOF()
      STORE "LINEA DE VENTA NO REGISTRADA. <ENTER>" TO MES
      DO AVISO WITH MES
      RETURN
   ENDIF
ENDIF
IF WLISTA = 0 .OR. WFACTOR = 0 .OR. READKEY() = 12 .OR. READKEY() = 268
   RETURN
ENDIF
STORE "CONFORME ? (S/N)" TO TEX
STORE "NS" TO WCH
DO PREGUNTA
IF WCH = "N"
   RETURN
ENDIF
STORE "REPRECIANDO ARTICULOS SELECCIONADOS. FAVOR ESPERAR..." TO MES
DO MENSAJE WITH MES

SELECT 2
DO WHILE .NOT. EOF()
   IF WLINEA <> SPACE(3) .AND. WLINEA <> LINEA
      SKIP
      LOOP
   ENDIF
   STORE "PVP"+STR(WLISTA,1) TO WLISTNAME
   STORE &WLISTNAME*WFACTOR TO WNEWVAL
   REPLACE &WLISTNAME WITH WNEWVAL
   SKIP
ENDDO
RETURN

