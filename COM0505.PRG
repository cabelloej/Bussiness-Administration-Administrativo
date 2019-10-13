
***
*ON ERROR DO ERRCON
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
SELECT 1
USE COMCXP
STORE .T. TO R0205
DO WHILE R0205
   GO TOP
   STORE SPACE(3)  TO WCLI
   STORE SPACE(10) TO WDOC
   STORE SPACE(10) TO WREF
   STORE CTOD("  -  -  ") TO WELA1
   STORE CTOD("  -  -  ") TO WELA2
   STORE CTOD("  -  -  ") TO WVEN1
   STORE CTOD("  -  -  ") TO WVEN2
   STORE CTOD("  -  -  ") TO WCAN1
   STORE CTOD("  -  -  ") TO WCAN2

   @ 04,0 CLEAR
   @ 04,25 SAY "RESUMEN DE CTAS. X PAGAR"
   @ 05,1 TO 5,78
   @ 07,5 SAY    "CODIGO PROV.:"
   @ 08,5 SAY    "No.DOCUMENTO:"
   @ 09,5 SAY    "REFERENCIA  :"

   @ 11,5 SAY    "*ELABORACION*"
   @ 12,5 SAY    "DESDE FECHA :"
   @ 13,5 SAY    "HASTA FECHA :"

   @ 15,5 SAY    "*VENCIMIENTO*"
   @ 16,5 SAY    "DESDE FECHA :"
   @ 17,5 SAY    "HASTA FECHA :"

   @ 07,50 SAY   "*  ESTADO   *"
   @ 08,50 SAY   "POR PAGAR  .1"
   @ 09,50 SAY   "CANCELADO ..2"
   @ 10,50 say   "           [ ]"

   @ 12,50 SAY   "*  SALIDA   *"
   @ 13,50 say   "MONITOR ....1"
   @ 14,50 say   "IMPRESORA...2"
   @ 15,50 say   "           [ ]"
   store 1 to WESTADO
   store 1 to wsalida
   STORE "OPRIMA <ESC> PARA SALIR" to mes
   do mensaje with mes

   @ 07,18 GET WCLI
   READ
   IF READKEY() = 12 .OR READKEY() = 268
      RETURN
   ENDIF
   @ 08,18 GET WDOC
   READ
   IF READKEY() = 12 .OR READKEY() = 268
      RETURN
   ENDIF
   @ 09,18 GET WREF
   READ
   IF READKEY() = 12 .OR READKEY() = 268
      RETURN
   ENDIF

   @ 12,18 GET WELA1
   @ 13,18 GET WELA2
   READ
   IF WELA2<WELA1
      STORE "VERIFIQUE CRITERIO DE FECHAS DE ELABORACION (Ù)" TO MES
      DO AVISO WITH MES
      LOOP
   ENDIF
   @ 16,18 GET WVEN1
   @ 17,18 GET WVEN2
   READ
   IF WVEN2<WVEN1
      STORE "VERIFIQUE CRITERIO DE FECHAS DE VENCIMIENTO (Ù)" TO MES
      DO AVISO WITH MES
      LOOP
   ENDIF
   @ 10,62 get wESTADO picture "#" range 1,2
   READ
   @ 15,62 get wsalida picture "#" range 1,2
   read

   SAVE SCRE TO INF1
   STORE "CONTINUAR ? (S/N)" TO TEX
   STORE "SN" TO WCH
   DO PREGUNTA
   IF WCH = "N"
      CLOSE DATA
      CLOSE INDEX
      RETURN
   ENDIF

   STORE 0 TO PAGINA
   STORE 100 TO LINE
   IF WSALIDA = 1
      STORE 22 TO WSALTO
      @ 0,0 CLEAR
   ELSE
      SET DEVI TO PRINT
      STORE 55 TO WSALTO
   ENDIF
   STORE 0 TO FLAGSAL
   STORE 0 TO WTOTALINF
   STORE 0 TO WTOTALCOM

   DO WHILE .NOT. EOF()
      IF WCLI <> SPACE(3) .AND. CLIENTE <> WCLI
         SKIP
         LOOP
      ENDIF
      IF WDOC <> SPACE(10) .AND.  CODCXC <> WDOC
         SKIP
         LOOP
      ENDIF
      IF WREF <> SPACE(10) .AND.  REFERENCIA <> WREF
         SKIP
         LOOP
      ENDIF

      IF WELA1 = CTOD("  -  -  ")
         *** REGISTRO APROBADO
      ELSE
         IF ELABORADA >= WELA1 .AND. ELABORADA <=WELA2
            *** REGISTRO APROBRADO
         ELSE
            SKIP
            LOOP
         ENDIF
      ENDIF

      IF WVEN1 = CTOD("  -  -  ")
         *** REGISTRO APROBADO
      ELSE
         IF VENCE     >= WVEN1 .AND. VENCE     <=WVEN2
            *** REGISTRO APROBRADO
         ELSE
            SKIP
            LOOP
         ENDIF
      ENDIF
      IF WESTADO = 1
         IF CANCELADA <> CTOD("  -  -  ")
            SKIP
            LOOP
         ENDIF
      ELSE
         IF CANCELADA = CTOD("  -  -  ")
            SKIP
            LOOP
         ENDIF
      ENDIF

      STORE LINE+1 TO LINE
      IF LINE >= WSALTO
         STORE PAGINA + 1 TO PAGINA
         IF WSALIDA=1 .AND. PAGINA<>1
            STORE "CONTINUAR ? (S/N)" TO TEX
            STORE "SN" TO WCH
            DO PREGUNTA
            IF WCH = "N"
               STORE 1 TO FLAGSAL
               EXIT
            ENDIF
            @ 0,0 CLEAR
         ENDIF
         @ 1,0   SAY QQWW
         @ 1,60  SAY "FECHA :"+DTOC(DATE())
         @ 2,0   SAY  "RESUMEN DE CTAS. X PAGAR"
         @ 2,60  SAY "PAGINA:"+STR(PAGINA,2)
         @ 04,0 SAY "+-------+--------+--------+--------+-----------+-----+----------+"
         @ 05,0 SAY "|No.DOC.|EMISION | VENCTO.| CANCEL.|MONTO TOTAL|PROV.|REFERENCIA|"
         @ 06,0 SAY "+-------+--------+--------+--------+-----------+-----+----------+"
         STORE 7 TO LINE
      ENDIF
      @ LINE,1 SAY SUBSTR(CODCXP,4,7)
      @ LINE,09 SAY DTOC(ELABORADA)
      @ LINE,18 SAY DTOC(VENCE)
      @ LINE,27 SAY DTOC(CANCELADA)
      @ LINE,35 SAY STR(MONTO,12,2)
      @ LINE,48 SAY CLIENTE
      @ LINE,54 SAY REFERENCIA
      STORE WTOTALINF+MONTO TO WTOTALINF
      SKIP
   ENDDO
   IF WTOTALINF > 0
      STORE LINE+1 TO LINE
      @ LINE,5 SAY "T O T A L E S:"
      @ LINE,35 SAY STR(WTOTALINF,12,2)
   ENDIF
   IF FLAGSAL = 1
      LOOP
   ENDIF
   IF WSALIDA = 2
      SET DEVI TO SCRE
      EJECT
   ELSE
      STORE "OPRIMA (Ù) PARA FINALIZAR" TO MES
      DO AVISO WITH MES
      RESTORE SCRE FROM INF1
   ENDIF
ENDDO
RETURN

