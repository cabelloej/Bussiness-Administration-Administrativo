SELECT 1
USE COMCXP INDEX COMCXP, COMCXP2
SELECT 2
USE SYSDATE
SELECT 1
SET COLOR TO G/N
@ 4,0 CLEAR
SET COLOR TO W+/B
STORE "CUENTAS X PAGAR" TO WHEADER
@ 4,40 - (LEN(WHEADER)/2) SAY WHEADER
SET COLOR TO W+/B
@ 5,0
@ 5,01 SAY "CODIGO"
@ 5,12 SAY "REFERENCIA"
@ 5,24 SAY "ELABORADA"
@ 5,34 SAY "VENCE"
@ 5,44 SAY "CANCELADA"
@ 5,54 SAY "MONTO"
@ 5,68 SAY "PROVEEDOR"

@ 21,0 SAY "³PgUp=Pag.Arr³PgDn=Pag.Abj³Home=Inic³End=Final³=Ant.³=Sig.³ESC=Salir³Ù=Acep.³"
SET COLOR TO B+/N
@ 6,0 TO 19,79
SET COLOR TO G/N
STORE  "INCLUIR    " TO XMENU1
STORE  "MODIFICAR  " TO XMENU2
STORE  "CANC./ELIM." TO XMENU3
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
         @ WSCRELIN ,01  SAY CODCXP
         @ WSCRELIN ,12  SAY REFERENCIA
         @ WSCRELIN ,24  SAY ELABORADA
         @ WSCRELIN ,34  SAY VENCE
         @ WSCRELIN ,44  SAY CANCELADA
         @ WSCRELIN ,54  SAY MONTO PICTURE "########.##"
         @ WSCRELIN ,68  SAY CLIENTE
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
   @ WSCRELIN ,01  SAY CODCXP
   @ WSCRELIN ,12  SAY REFERENCIA
   @ WSCRELIN ,24  SAY ELABORADA
   @ WSCRELIN ,34  SAY VENCE
   @ WSCRELIN ,44  SAY CANCELADA
   @ WSCRELIN ,54  SAY MONTO PICTURE "########.##"
   @ WSCRELIN ,68  SAY CLIENTE
   ** PARA MARCAR EL REGISTRO ACTUAL
   SET COLOR TO N+/G
   GO WREVERSE
   STORE WEDILIN TO WSCRELIN
   @ WSCRELIN ,01  SAY CODCXP
   @ WSCRELIN ,12  SAY REFERENCIA
   @ WSCRELIN ,24  SAY ELABORADA
   @ WSCRELIN ,34  SAY VENCE
   @ WSCRELIN ,44  SAY CANCELADA
   @ WSCRELIN ,54  SAY MONTO PICTURE "########.##"
   @ WSCRELIN ,68  SAY CLIENTE
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
      STORE CODCXP TO WSELCXP
      CLOSE DATA
      CLOSE INDEX
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
                 SELECT 2
                 store LTRIM(str(COMseriCXP+1,7)) to wnumcxP
                 STORE REPLICATE("0",7-LEN(WNUMCXP))+WNUMCXP TO WNUMCXP
                 STORE "CXP"+WNUMCXP TO WCODCXP
                 SELECT 1
                 STORE SPACE(LEN(REFERENCIA)) TO WREF
                 STORE CTOD("  -  -  ") TO WELABORADA
                 STORE CTOD("  -  -  ") TO WVENCE
                 STORE CTOD("  -  -  ") TO WCANCELADA
                 STORE 0 TO WMONTO
                 STORE SPACE(5) TO WCLIENTE
                 IF WSCRELIN > 18
                    SET COLOR TO G/N
                    @ 7,1 CLEAR TO 18,78
                    STORE 7 TO WSCRELIN
                 ENDIF
                 @ WSCRELIN ,01  GET WCODCXP
                 @ WSCRELIN ,12  GET WREF
                 @ WSCRELIN ,24  GET WELABORADA
                 @ WSCRELIN ,34  GET WVENCE
                 @ WSCRELIN ,44  GET WCANCELADA
                 @ WSCRELIN ,54  GET WMONTO PICTURE "########.##"
                 @ WSCRELIN ,68  GET CLIENTE
                 READ
                 IF WCODCXP = SPACE(LEN(CODCXP)) .OR. READKEY() = 12 .OR. READKEY() = 268
                    STORE .F. TO WACT
                    GO TOP
                    STORE RECNO() TO WINICIO
                    STORE .T. TO FLAGJUMP
                    STORE 0 TO WREVERSE
                    LOOP
                 ENDIF
                 FIND &WCODCXP
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
                 REPLACE CODCXP WITH WCODCXP
                 REPLACE REFERENCIA WITH WREF
                 REPLACE ELABORADA WITH WELABORADA
                 REPLACE VENCE WITH WVENCE
                 REPLACE CANCELADA WITH WCANCELADA
                 REPLACE MONTO WITH WMONTO
                 REPLACE CLIENTE WITH WCLIENTE
                 SELECT 2
                 REPLACE COMSERICXP WITH COMSERICXP + 1
                 SELECT 1
                 FLUSH
              ENDDO
         CASE WMENU = 2
              STORE .T. TO WACT
              STORE CODCXP TO WCODCXP
              STORE REFERENCIA TO WREF
              STORE ELABORADA TO WELABORADA
              STORE VENCE TO WVENCE
              STORE CANCELADA TO WCANCELADA
              STORE MONTO TO   WMONTO
              STORE CLIENTE TO WCLIENTE
              DO WHILE WACT
                 @ WSCRELIN ,12  GET WREF
                 @ WSCRELIN ,24  GET WELABORADA
                 @ WSCRELIN ,34  GET WVENCE
      *          @ WSCRELIN ,44  GET WCANCELADA
                 @ WSCRELIN ,54  GET WMONTO PICTURE "########.##"
                 @ WSCRELIN ,68  GET WCLIENTE
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
                 REPLACE REFERENCIA WITH WREF
                 REPLACE ELABORADA WITH WELABORADA
                 REPLACE VENCE WITH WVENCE
                 REPLACE CANCELADA WITH WCANCELADA
                 REPLACE MONTO WITH WMONTO
                 REPLACE CLIENTE WITH WCLIENTE
                 FLUSH
                 STORE .F. TO WACT
              ENDDO
         CASE WMENU = 3
              @ 23,10 PROMPT "CANCELAR CTA."
              @ 23,30 PROMPT "ELIMINAR CTA."
              @ 23,50 PROMPT "SALIR        "
              MENU TO W0600
              IF W0600 =  2
                 STORE "ESTA USTED SEGURO? (S/N)" TO TEX
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
              ENDIF
              IF W0600 = 1
                 REPLACE CANCELADA WITH WFECACT
                 IF REFERENCIA <> SPACE(10) .AND. SUBSTR(REFERENCIA,1,3) = "FAC"
                    STORE REFERENCIA TO WREF
                    SELECT 5
                    USE FACDCGE INDEX FACDCGE
                    FIND &WREF
                    IF EOF()
                       STORE "LA FACTURA No. "+WREF+" NO ESTA REGISTRADA" TO MES
                       DO AVISO WITH MES
                    ELSE
                       REPLACE CANCELADO WITH WFECACT
                    ENDIF
                    SELECT 1
                 ENDIF
              ENDIF
         CASE WMENU = 4
              CLOSE DATA
              CLOSE INDEX
              RETURN
         CASE WMENU = 5
              SAVE SCRE TO S9
              STORE SPACE(LEN(CODCXP)) TO WCODCXP
              @ WSCRELIN, 01 GET WCODCXP
              READ
              IF WCODCXP <> SPACE(LEN(CODCXP))
                 FIND &WCODCXP
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