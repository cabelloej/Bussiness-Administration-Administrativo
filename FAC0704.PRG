

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
USE FACDCGE INDEX FACDCGE
STORE .T. TO R0205
DO WHILE R0205
   GO TOP
   @ 04,0 CLEAR
   @ 04,30 SAY "RESUMEN DE VENTAS"
   @ 05,1 TO 5,78
   STORE "4" TO WDOC
   STORE SPACE(3) TO WVENDE
   STORE SPACE(3) TO WDESDE
   STORE CTOD("  -  -  ") TO WFECHA1
   STORE CTOD("  -  -  ") TO WFECHA2
   STORE CTOD("01-01-80") TO WWFEC1
   STORE CTOD("31-12-99") TO WWFEC2

   @ 08,5 SAY    "**INTERVALO**"
   @ 09,5 SAY    "CODIGO CLTE.:"

   @ 11,5 SAY    "*CRITERIO*"
   @ 12,5 SAY    "DOCUMENTO  :"
   @ 13,5 SAY    "DESDE FECHA:"
   @ 14,5 SAY    "HASTA FECHA:"
   @ 15,5 SAY    "VENDEDOR   :"

   @ 08,50 SAY    "* SALIDA *"
   @ 09,50 say    "MONITOR ...1"
   @ 10,50 say    "IMPRESORA..2"
   @ 11,50 say    "          [ ]"
   store 1 to wsalida

   STORE "OPRIMA <ESC> PARA SALIR" to mes
   do mensaje with mes

   @ 09,20 GET WDESDE
   READ
   IF READKEY() = 12 .OR READKEY() = 268
      RETURN
   ENDIF
   @ 23,0
   IF WDESDE = SPACE(3)
      STORE "TODOS                 " TO WMES1
      @ 09,20 SAY WMES1
   ENDIF

   STORE .T. TO WWW
   DO WHILE WWW
      STORE "1=PRESUPUESTO, 2=ORDENES DE COMP., 3=NOTAS DE ENTRG., 4=FACTURAS" TO MES
      DO MENSAJE WITH MES
      @ 12,20 GET WDOC
      READ
      STORE .F. TO WWW
      IF WDOC = "1"
         STORE "PRE" TO WDOC
         STORE "PRESUPUESTOS" TO WDOCDES
      ELSE
         IF WDOC = "2"
            STORE "ORD" TO WDOC
            STORE "ORDENES DE COMPRA" TO WDOCDES
         ELSE
            IF WDOC = "3"
               STORE "NOT" TO WDOC
               STORE "NOTAS DE ENTREGA" TO WDOCDES
            ELSE
               IF WDOC = "4"
                  STORE "FAC" TO WDOC
                  STORE "FACTURAS" TO WDOCDES
               ELSE
                  STORE .T. TO WWW
               ENDIF
            ENDIF
         ENDIF
      ENDIF
   ENDDO

   @ 13,20 GET WFECHA1
   @ 14,20 GET WFECHA2
   READ
   IF WFECHA1= CTOD("  -  -  ")
      STORE WWFEC1  TO WFECHA1
      STORE "PRIMERA         " TO WMES1
      @ 13,20 SAY WMES1
   ENDIF
   IF WFECHA2= CTOD("  -  -  ")
      STORE WWFEC2  TO WFECHA2
      STORE "ULTIMA          " TO WMES2
      @ 14,20 SAY WMES2
   ENDIF
   IF WFECHA2< WFECHA1
      STORE "VERIFIQUE CRITERIO DE FECHAS (Ù)" TO MES
      DO AVISO WITH MES
      LOOP
   ENDIF
   @ 15,20 GET WVENDE
   READ
   @ 11,61 get wsalida picture "#" range 1,2
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
   FIND &WDOC
   IF EOF()
      SET DEVI TO SCRE
      STORE "NO HAY "+WDOC+" EN EL SISTEMA" TO MES
      DO AVISO WITH MES
      CLOSE DATA
      CLOSE INDEX
      RETURN
   ENDIF
   STORE 0 TO WTOTALINF
   STORE 0 TO WTOTALCOM

   DO WHILE .NOT. EOF()
      IF SUBSTR(NUMERO,1,3) <> WDOC
         EXIT
      ENDIF
      IF WDESDE <> SPACE(3) .AND. CLIENTE <> WDESDE
         SKIP
         LOOP
      ENDIF
      IF WVENDE <> SPACE(3) .AND. WVENDE <> VENDEDOR
         SKIP
         LOOP
      ENDIF
      IF ELABORADO >= WFECHA1 .AND. ELABORADO <= WFECHA2
         *** REGISTRO APROBADO
      ELSE
         SKIP
         LOOP
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
         @ 2,0   SAY  "RESUMEN DE VENTAS"
         @ 2,60  SAY "PAGINA:"+STR(PAGINA,2)
         @ 3,0 SAY "DOCUMENTO: "+WDOCDES
         @ 04,0 SAY "+-------+--------+--------+--------+-----------+-----+----+-----------+"
         @ 05,0 SAY "|No.DOC.|EMISION | VENCTO.| CANCEL.|COSTO TOTAL|CLTE.|VEN.| COMISION  |"
         @ 06,0 SAY "+-------+--------+--------+--------+-----------+-----+----+-----------+"
         STORE 7 TO LINE
      ENDIF
      @ LINE,1 SAY SUBSTR(NUMERO,4,7)
      @ LINE,09 SAY DTOC(ELABORADO)
      @ LINE,18 SAY DTOC(VENCE)
      @ LINE,27 SAY DTOC(CANCELADO)
      @ LINE,35 SAY STR(MONTO,12,2)
      @ LINE,48 SAY CLIENTE
      @ LINE,54 SAY VENDEDOR
      STORE (MONTO*COMVEN)/100 TO WMONTOCOM
      @ LINE,59 SAY STR(WMONTOCOM,11,2)
      STORE WTOTALINF+MONTO TO WTOTALINF
      STORE WTOTALCOM+WMONTOCOM TO WTOTALCOM
      SKIP
   ENDDO
   IF WTOTALINF > 0 .OR. WTOTALCOM > 0
      STORE LINE+1 TO LINE
      @ LINE,5 SAY "T O T A L E S:"
      @ LINE,35 SAY STR(WTOTALINF,12,2)
      @ LINE,59 SAY STR(WTOTALCOM,11,2)
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