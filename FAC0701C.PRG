
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
*SELECT 3
*USE FACVEN INDEX FACVEN
STORE .T. TO R0201
DO WHILE R0201
   GO TOP
   @ 04,0 CLEAR
   @ 04,30 SAY "VENDEDORES"
   @ 05,1 TO 5,78
   STORE SPACE(3) TO WWDESDE
   STORE SPACE(3) TO WDESDE
   STORE REPLICATE("Z",3) TO WWHASTA
   STORE SPACE(3) TO WHASTA

   @ 10,5 SAY    "* VENDEDORES *"
   @ 11,5 SAY    "DESDE CODIGO :"
   @ 12,5 SAY    "HASTA CODIGO :"

   @ 14,5 SAY    "* SALIDA *"
   @ 15,5 say    "MONITOR ...1"
   @ 16,5 say    "IMPRESORA..2"
   @ 17,5 say    "          [ ]"
   STORE "OPRIMA <ESC> PARA SALIR" TO MES
   DO MENSAJE WITH MES
   @ 11,20 GET WDESDE
   READ
   IF READKEY() = 12 .OR READKEY() = 268
      RETURN
   ENDIF
   @ 12,20 GET WHASTA
   READ
   IF READKEY() = 12 .OR READKEY() = 268
      RETURN
   ENDIF
   IF WDESDE = SPACE(3)
      STORE WWDESDE TO WDESDE
      STORE "PRIMERO                        " TO WMES1
      @ 11,20 SAY WMES1
   ENDIF
   IF WHASTA = SPACE(3)
      STORE WWHASTA TO WHASTA
      STORE "ULTIMO                         " TO WMES2
      @ 12,20 SAY WMES2
   ENDIF
   IF WHASTA < WDESDE
      STORE "VERIFIQUE INTERVALO. (Ù)" TO MES
      DO AVISO WITH MES
      LOOP
   ENDIF
   store 1 to wsalida
   @ 17,16 get wsalida picture "#" range 1,2
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
   LOCATE FOR CODVEN >= WDESDE
   DO WHILE .NOT. EOF() .AND. CODVEN <= WHASTA
      STORE LINE+1 TO LINE
      IF LINE >= WSALTO
         STORE PAGINA + 1 TO PAGINA
         IF WSALIDA=1 .AND. PAGINA<>1
            STORE "CONTINUAR ? (S/N)" TO TEX
            STORE "SN" TO WCH
            DO PREGUNTA
            IF WCH = "N"
               CLOSE DATA
               CLOSE INDEX
               RETURN
            ENDIF
            @ 0,0 CLEAR
         ENDIF
         @ 1,0   SAY QQWW
         @ 1,60  SAY "FECHA :"+DTOC(DATE())
         @ 2,0   SAY  "LISTADO DE VENDEDORES"
         @ 2,60  SAY "PAGINA:"+STR(PAGINA,2)
         @ 04,0  SAY "CODIGO"
         @ 04,27 SAY "NOMBRE     "
         @ 04,70 SAY "COMISION"
         @ 5,0   SAY REPLICATE("-",80)
         STORE 6 TO LINE
      ENDIF
      @ LINE,0 SAY CODVEN
      @ LINE,27 SAY DESVEN
      @ LINE,70 SAY COMVEN
      SKIP
   ENDDO
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