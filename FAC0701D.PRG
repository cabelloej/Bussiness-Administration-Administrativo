
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
SELECT 4
USE FACSER INDEX FACSER
STORE .T. TO R0201
DO WHILE R0201
   GO TOP
   @ 04,0 CLEAR
   @ 04,30 SAY "SERVICIOS"
   @ 05,1 TO 5,78
   STORE SPACE(20) TO WWDESDE
   STORE SPACE(20) TO WDESDE
   STORE REPLICATE("þ",20) TO WWHASTA
   STORE SPACE(20) TO WHASTA

   @ 10,5 SAY    "* SERVICIOS  *"
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
      close data
      close index
      RETURN
   ENDIF
   @ 12,20 GET WHASTA
   READ
   IF READKEY() = 12 .OR READKEY() = 268
      close data
      close index
      RETURN
   ENDIF
   IF WDESDE = SPACE(20)
      STORE WWDESDE TO WDESDE
      STORE "PRIMERO                        " TO WMES1
      @ 11,20 SAY WMES1
   ENDIF
   IF WHASTA = SPACE(20)
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
      close data
      close index
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
   LOCATE FOR CODSER >= WDESDE
   DO WHILE .NOT. EOF() .AND. CODSER <= WHASTA
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
         @ 2,0   SAY  "LISTADO DE SERVICIOS"
         @ 2,60  SAY "PAGINA:"+STR(PAGINA,2)
         @ 04,0  SAY "CODIGO"
         @ 04,21 SAY "DESCRIPCION"
         @ 04,43 SAY "PRECIO 1"
         @ 04,55 SAY "PRECIO 2"
         @ 04,70 SAY "PRECIO 3"
         @ 5,0   SAY REPLICATE("-",80)
         STORE 6 TO LINE
      ENDIF
      @ LINE,0 SAY CODSER
      @ LINE,21 SAY DESSER
      @ LINE,43 SAY PVP1 PICTURE "#######.##"
      @ LINE,55 SAY PVP2 PICTURE "#######.##"
      @ LINE,70 SAY PVP3 PICTURE "#######.##"
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
close data
close index
RETURN
