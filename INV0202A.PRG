**N ERROR DO ERRCON
*STORE SPACE(40) TO qqww
*STORE "CONSTRUCTORA                     " TO t3
*STORE 0 TO ppp
*DO INFORMA
*IF qqww<>t3
*   STORE 1 TO ppp
*ENDIF
*IF ppp = 1
*   STORE "ERROR DE INSTALACION" TO mes
*   DO aviso WITH mes
*   CLOSE ALL
*   QUIT
*ENDIF
****
SELECT 2
STORE .T. TO r0201
DO WHILE r0201
   GO TOP
   @ 04,0 CLEAR
   @ 04,30 SAY "LISTA DE PRECIOS"
   @ 05,1 TO 5,78
   STORE SPACE(3) TO wlin
   STORE SPACE(20) TO wwdesde
   STORE SPACE(20) TO wdesde
   STORE REPLICATE("Z",20) TO wwhasta
   STORE SPACE(20) TO whasta
   @ 08,5 SAY    "LINEA DE VTA.:"
   
   @ 10,5 SAY    "* ARTICULOS *"
   @ 11,5 SAY    "DESDE CODIGO :"
   @ 12,5 SAY    "HASTA CODIGO :"
   
   @ 14,5 SAY    "* SALIDA *"
   @ 15,5 SAY    "MONITOR ...1"
   @ 16,5 SAY    "IMPRESORA..2"
   @ 17,5 SAY    "          [ ]"
   STORE "OPRIMA <ESC> PARA SALIR" TO mes
   DO mensaje WITH mes
   @ 8,20 GET wlin
   READ
   IF READKEY() = 12 .or READKEY() = 268
      RETURN
   ENDIF
   @ 11,20 GET wdesde
   READ
   IF READKEY() = 12 .or READKEY() = 268
      RETURN
   ENDIF
   @ 12,20 GET whasta
   READ
   IF READKEY() = 12 .or READKEY() = 268
      RETURN
   ENDIF
   IF wdesde = SPACE(20)
      STORE wwdesde TO wdesde
      STORE "PRIMERO                        " TO wmes1
      @ 11,20 SAY wmes1
   ENDIF
   IF whasta = SPACE(20)
      STORE wwhasta TO whasta
      STORE "ULTIMO                         " TO wmes2
      @ 12,20 SAY wmes2
   ENDIF
   IF whasta < wdesde
      STORE "VERIFIQUE INTERVALO. (Ù)" TO mes
      DO aviso WITH mes
      LOOP
   ENDIF
   STORE 1 TO wsalida
   @ 17,16 GET wsalida PICTURE "#" RANGE 1,2
   READ
   SAVE SCRE TO inf1
   STORE "CONTINUAR ? (S/N)" TO tex
   STORE "SN" TO wch
   DO pregunta
   IF wch = "N"
      RETURN
   ENDIF
   
   STORE 0 TO pagina
   STORE 100 TO LINE
   IF wsalida = 1
      STORE 18 TO wsalto
      @ 0,0 CLEAR
   ELSE
      SET DEVI TO PRINT
      STORE 50 TO wsalto
   ENDIF
   LOCATE FOR codigo >= wdesde
   DO WHILE .NOT. EOF() .AND. codigo <= whasta
      IF wlin <> SPACE(3) .AND. wlin <> linea
         SKIP
         LOOP
      ENDIF
      STORE LINE+1 TO LINE
      IF LINE >= wsalto
         STORE pagina + 1 TO pagina
         IF wsalida=1 .AND. pagina<>1
            STORE "CONTINUAR ? (S/N)" TO tex
            STORE "SN" TO wch
            DO pregunta
            IF wch = "N"
               RETURN
            ENDIF
            @ 0,0 CLEAR
         ENDIF
         *@ 1,0   SAY qqww
         @ 1,0   SAY "MERCASISTEMAS, C.A."
         @ 1,60  SAY "FECHA :"+DTOC(DATE())
         @ 2,0   SAY  "LISTADO DE PRECIOS  "
         @ 2,60  SAY "PAGINA:"+STR(pagina,2)
         @ 04,0  SAY "CODIGO"
         @ 04,21 SAY "DESCRIPCION"
         @ 04,62 SAY "LIN."
         @ 04,68 SAY "PRECIO VENTA"
         @ 5,0   SAY REPLICATE("-",80)
         STORE 6 TO LINE
      ENDIF
      @ LINE,0 SAY codigo
      @ LINE,21 SAY descri
      @ LINE,62 SAY linea
      @ LINE,69 SAY STR(PVP1,10,2)
      IF descri2 <> SPACE(40)
         STORE LINE+1 TO LINE
         @ LINE,21 SAY descri2
      ENDIF
      IF descri3 <> SPACE(40)
         STORE LINE+1 TO LINE
         @ LINE,21 SAY descri3
      ENDIF
      IF descri4 <> SPACE(40)
         STORE LINE+1 TO LINE
         @ LINE,21 SAY descri4
      ENDIF
      STORE LINE + 1 TO LINE
      @ LINE,0 SAY REPLICATE("-",80)
      SKIP
   ENDDO
   IF wsalida = 2
      SET DEVI TO SCRE
      EJECT
   ELSE
      STORE "OPRIMA (Ù) PARA FINALIZAR" TO mes
      DO aviso WITH mes
      RESTORE SCRE FROM inf1
   ENDIF
ENDDO
RETURN
*: EOF: INV0202.PRG
