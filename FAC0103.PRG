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
SELECT 3
USE FACVEN INDEX FACVEN
SET COLOR TO G/N
@ 4,0 CLEAR
SET COLOR TO W+/B
STORE "VENDEDORES" TO WHEADER
@ 4,40 - (LEN(WHEADER)/2) SAY WHEADER
SET COLOR TO W+/B
@ 5,0
@ 5,01 SAY "CODIGO"
@ 5,12 SAY "DESCRIPCION"
@ 5,45 SAY "COMISION"
@ 21,0 SAY "�PgUp=Pag.Arr�PgDn=Pag.Abj�Home=Inic�End=Final�=Ant.�=Sig.�ESC=Salir��=Acep.�"
SET COLOR TO B+/N
@ 6,0 TO 19,79
SET COLOR TO G/N
STORE  "INCLUIR    " TO XMENU1
STORE  "MODIFICAR  " TO XMENU2
STORE  "ELIMINAR   " TO XMENU3
STORE  "SELECCIONAR" TO XMENU4
STORE  "BUSCAR     " TO XMENU5
STORE 4 TO WMENU
STORE .T. TO XFLAG

STORE 12 TO WRANGO
GO TOP
STORE RECNO() TO WINICIO
STORE 0 TO WREVERSE
STORE 0 TO WEDILIN
STORE .T. TO FLAGJUMP
STORE .T. TO WEDITAR
DO WHILE WEDITAR
   IF FLAGJUMP
      STORE 0       TO WCONT
      STORE 07      TO WLINE
      GO WINICIO
      SET COLOR TO G/N
      @ 7,1 CLEAR TO 18,78
      DO WHILE .NOT. EOF() .AND. WCONT < WRANGO
         STORE WLINE+WCONT TO WSCRELIN
         STORE WLINE+WCONT TO WLASTLIN
         STORE RECNO() TO WLASTREC
         @ WSCRELIN ,01  SAY CODVEN
         @ WSCRELIN ,12  SAY DESVEN
         @ WSCRELIN ,45  SAY COMVEN
         STORE WCONT + 1 TO WCONT
         SKIP
      ENDDO
      STORE .F. TO FLAGJUMP
   ENDIF

   IF WREVERSE = 0
      STORE WLASTREC TO WREVERSE
      STORE WLASTLIN TO WEDILIN
      STORE WINICIO  TO WCLEARREC
      STORE WLINE    TO WCLEARLIN
   ENDIF

   ** PARA BORRAR EL REGISTRO ANTERIOR
   SET COLOR TO G/N
   GO WCLEARREC
   STORE WCLEARLIN TO WSCRELIN
   @ WSCRELIN ,01  SAY CODVEN
   @ WSCRELIN ,12  SAY DESVEN
   @ WSCRELIN ,45  SAY COMVEN

   ** PARA MARCAR EL REGISTRO ACTUAL
   SET COLOR TO N+/G
   GO WREVERSE
   STORE WEDILIN TO WSCRELIN
   @ WSCRELIN ,01  SAY CODVEN
   @ WSCRELIN ,12  SAY DESVEN
   @ WSCRELIN ,45  SAY COMVEN
   STORE WREVERSE TO WCLEARREC
   STORE WSCRELIN TO WCLEARLIN
   SET COLOR TO G/N

   *** PARA INDICAR LA ROTACION DEL MENU (SI LA HUBO)
   IF XFLAG
      SET COLOR TO G/N
      @ 20,05 SAY  XMENU1
      @ 20,20 SAY  XMENU2
      @ 20,35 SAY  XMENU3
      @ 20,50 SAY  XMENU4
      @ 20,65 SAY  XMENU5
      SET COLOR TO N/G
      STORE "XMENU"+STR(WMENU,1) TO WMACRO
      @ 20,5+((WMENU-1)*15)  SAY &WMACRO
      STORE .F. TO XFLAG
      SET COLOR TO G/N
   ENDIF

   *** CAPTURA DE INTERACTIVIDAD
   CLEAR TYPEAHEAD
   STORE INKEY(0) TO WMUEVE
   *** PAGE DOWN
   IF WMUEVE = 3
      GO WINICIO
      SKIP +12
      IF .NOT. EOF()
         STORE RECNO() TO WINICIO
         STORE .T.     TO FLAGJUMP
         STORE WINICIO TO WREVERSE
         STORE WLINE   TO WEDILIN
         STORE WINICIO TO WCLEARREC
         STORE WLINE   TO WCLEARLIN
      ENDIF
   ENDIF
   *** PAGE UP
   IF WMUEVE =  18
      GO WINICIO
      SKIP -12
      STORE RECNO() TO WINICIO
      STORE .T. TO FLAGJUMP
      STORE 0 TO WREVERSE
   ENDIF
   *** HOME
   IF WMUEVE = 1
      GO TOP
      IF .NOT. EOF()
         STORE RECNO() TO WINICIO
         STORE .T. TO FLAGJUMP
         STORE WINICIO TO WREVERSE
         STORE WLINE   TO WEDILIN
         STORE WINICIO TO WCLEARREC
         STORE WLINE   TO WCLEARLIN
      ENDIF
   ENDIF
   *** END
   IF WMUEVE = 6
      GO BOTT
      SKIP -11
      STORE RECNO() TO WINICIO
      STORE 0 TO WREVERSE
      STORE .T. TO FLAGJUMP
   ENDIF
   *** DOWN ARROW
   IF WMUEVE = 24
      SKIP +1
      IF WEDILIN < (WLINE+(WCONT-1))
         STORE WREVERSE    TO WCLEARREC
         STORE RECNO()     TO WREVERSE
         STORE WEDILIN     TO WCLEARLIN
         STORE WEDILIN + 1 TO WEDILIN
      ENDIF
   ENDIF
   *** UP ARROW
   IF WMUEVE = 5
      SKIP -1
      IF WEDILIN > WLINE
         STORE WREVERSE    TO WCLEARREC
         STORE RECNO()     TO WREVERSE
         STORE WEDILIN     TO WCLEARLIN
         STORE WEDILIN - 1 TO WEDILIN
      ENDIF
   ENDIF
   *** RIGHT ARROW
   IF WMUEVE = 4
      STORE .T. TO XFLAG
      STORE WMENU+1 TO WMENU
      IF WMENU > 5
         STORE 1 TO WMENU
      ENDIF
   ENDIF
   *** LEFT ARROW
   IF WMUEVE = 19
      STORE .T. TO XFLAG
      STORE WMENU-1 TO WMENU
      IF WMENU < 1
         STORE 5 TO WMENU
      ENDIF
   ENDIF
   *** ESCAPE
   IF WMUEVE = 27
      STORE CODVEN TO WSELGRU
      RETURN
   ENDIF
   *** ENTER (INICIO DE OPERACIONES DE ACTUALIZACION DE DATOS
   IF WMUEVE = 13
      DO CASE
         CASE WMENU = 1
              STORE 100 TO WSCRELIN
              STORE .T. TO WACT
              DO WHILE WACT
                 STORE WSCRELIN + 1 TO WSCRELIN
                 STORE SPACE(LEN(CODVEN)) TO WCODVEN
                 STORE SPACE(LEN(DESVEN)) TO WDESVEN
                 STORE 0                  TO WCOMVEN
                 IF WSCRELIN > 18
                    SET COLOR TO G/N
                    @ 7,1 CLEAR TO 18,78
                    STORE 7 TO WSCRELIN
                 ENDIF
                 @ WSCRELIN ,01  GET WCODVEN
                 @ WSCRELIN ,12  GET WDESVEN
                 @ WSCRELIN ,45  GET WCOMVEN
                 READ
                 IF WCODVEN = SPACE(LEN(CODVEN)) .OR. READKEY() = 12 .OR. READKEY() = 268
                    STORE .F. TO WACT
                    GO TOP
                    STORE RECNO() TO WINICIO
                    STORE .T. TO FLAGJUMP
                    STORE 0 TO WREVERSE
                    LOOP
                 ENDIF
                 FIND &WCODVEN
                 IF .NOT. EOF()
                    STORE "CODIGO YA EXISTE EN EL FICHERO. <ENTER>" TO MES
                    DO AVISO WITH MES
                    STORE WSCRELIN - 1 TO WSCRELIN
                    LOOP
                 ENDIF
                 STORE "CONFORME ? (S/N)" TO TEX
                 STORE "SN" TO WCH
                 DO PREGUNTA
                 IF WCH = "N"
                    STORE WSCRELIN - 1  TO WSCRELIN
                    LOOP
                 ENDIF
                 APPEND BLANK
                 REPLACE CODVEN WITH WCODVEN
                 REPLACE DESVEN WITH WDESVEN
                 REPLACE COMVEN WITH WCOMVEN
                 FLUSH
              ENDDO
         CASE WMENU = 2
              STORE .T. TO WACT
              STORE CODVEN TO WCODINI
              STORE DESVEN TO WDESVEN
              STORE COMVEN TO WCOMVEN
              DO WHILE WACT
                 @ WSCRELIN ,12  GET WDESVEN
                 @ WSCRELIN ,45  GET WCOMVEN PICTURE "##.##"
                 READ
                 IF READKEY() = 12 .OR. READKEY() = 268
                    STORE .F. TO WACT
                    LOOP
                 ENDIF
                 STORE "CONFORME ? (S/N)" TO TEX
                 STORE "SN" TO WCH
                 DO PREGUNTA
                 IF WCH = "N"
                    LOOP
                 ENDIF
                 REPLACE DESVEN WITH WDESVEN
                 REPLACE COMVEN WITH WCOMVEN
                 FLUSH
                 STORE .F. TO WACT
              ENDDO
         CASE WMENU = 3
              STORE "ESTA SEGURO QUE DESEA ELIMINAR (S/N)" TO TEX
              STORE "NS" TO WCH
              DO PREGUNTA
              IF WCH = "S"
                 DELETE
                 SKIP
                 IF .NOT. EOF()
                    STORE RECNO() TO WINICIO
                    STORE .T. TO FLAGJUMP
                    STORE RECNO() TO WREVERSE
                    STORE RECNO() TO WCLEARREC
                    STORE WLINE   TO WEDILIN
                    STORE WLINE   TO WCLEARLIN
                 ELSE
                    GO TOP
                    STORE RECNO() TO WINICIO
                    STORE .T. TO FLAGJUMP
                    STORE 0 TO WREVERSE
                 ENDIF
              ENDIF
         CASE WMENU = 4
              RETURN
         CASE WMENU = 5
              SAVE SCRE TO S9
              STORE SPACE(LEN(CODVEN)) TO WCODVEN
              @ WSCRELIN, 01 GET WCODVEN
              READ
              IF WCODVEN <> SPACE(LEN(CODVEN))
                 FIND &WCODVEN
                 IF .NOT. EOF()
                    STORE RECNO() TO WINICIO
                    STORE .T. TO FLAGJUMP
                    STORE RECNO() TO WREVERSE
                    STORE RECNO() TO WCLEARREC
                    STORE WLINE   TO WEDILIN
                    STORE WLINE   TO WCLEARLIN
                 ELSE
                    RESTORE SCRE FROM S9
                 ENDIF
              ELSE
                 RESTORE SCRE FROM S9
              ENDIF
      ENDCASE
   ENDIF
ENDDO
RETURN
