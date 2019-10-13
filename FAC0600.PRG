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
SELECT 1
USE FACCXC INDEX FACCXC, FACCXC2
SELECT 2
USE SYSDATE
SELECT 3
USE FACCXCTR INDEX FACCXCTR
SELECT 1
SET COLOR TO G/N
@ 4,0 CLEAR
SET COLOR TO W+/B
STORE "CUENTAS X COBRAR" TO WHEADER
@ 4,40 - (LEN(WHEADER)/2) SAY WHEADER
SET COLOR TO W+/B
@ 5,0
@ 5,01 SAY "CODIGO"
@ 5,09 SAY "REFERENCIA"
@ 5,21 SAY "ELABORADA"
@ 5,33 SAY "VENCE"
@ 5,39 SAY "CANCELADA"
@ 5,54 SAY "MONTO"
@ 5,66 SAY "SALDO"
@ 5,75 SAY "CLTE."

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
         @ WSCRELIN ,01  SAY SUBSTR(CODCXC,4,7)
         @ WSCRELIN ,09  SAY REFERENCIA
         @ WSCRELIN ,21  SAY ELABORADA
         @ WSCRELIN ,30  SAY VENCE
         @ WSCRELIN ,39  SAY CANCELADA
         @ WSCRELIN ,48  SAY MONTO PICTURE "########.##"
         @ WSCRELIN ,60  SAY SALDO PICTURE "########.##"
         @ WSCRELIN ,74  SAY CLIENTE
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
   @ WSCRELIN ,01  SAY SUBSTR(CODCXC,4,7)
   @ WSCRELIN ,09  SAY REFERENCIA
   @ WSCRELIN ,21  SAY ELABORADA
   @ WSCRELIN ,30  SAY VENCE
   @ WSCRELIN ,39  SAY CANCELADA
   @ WSCRELIN ,48  SAY MONTO PICTURE "########.##"
   @ WSCRELIN ,60  SAY SALDO PICTURE "########.##"
   @ WSCRELIN ,74  SAY CLIENTE
   ** PARA MARCAR EL REGISTRO ACTUAL
   SET COLOR TO N+/G
   GO WREVERSE
   STORE WEDILIN TO WSCRELIN
   @ WSCRELIN ,01  SAY SUBSTR(CODCXC,4,7)
   @ WSCRELIN ,09  SAY REFERENCIA
   @ WSCRELIN ,21  SAY ELABORADA
   @ WSCRELIN ,30  SAY VENCE
   @ WSCRELIN ,39  SAY CANCELADA
   @ WSCRELIN ,48  SAY MONTO PICTURE "########.##"
   @ WSCRELIN ,60  SAY SALDO PICTURE "########.##"
   @ WSCRELIN ,74  SAY CLIENTE
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
      STORE CODCXC TO WSELCXC
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
                 store LTRIM(str(facseriCXC+1,7)) to wnumcxc
                 STORE REPLICATE("0",7-LEN(WNUMCXC))+WNUMCXC TO WNUMCXC
                 STORE WNUMCXC TO WCODCXC
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
                 @ WSCRELIN ,01  GET WCODCXC
                 @ WSCRELIN ,09  GET WREF
                 @ WSCRELIN ,21  GET WELABORADA
                 @ WSCRELIN ,30  GET WVENCE
                 @ WSCRELIN ,48  GET WMONTO PICTURE "########.##"
                 @ WSCRELIN ,74  GET WCLIENTE
                 READ
                 IF WCODCXC = SPACE(LEN(CODCXC)) .OR. READKEY() = 12 .OR. READKEY() = 268
                    STORE .F. TO WACT
                    GO TOP
                    STORE RECNO() TO WINICIO
                    STORE .T. TO FLAGJUMP
                    STORE 0 TO WREVERSE
                    LOOP
                 ENDIF
                 STORE "CXC"+WCODCXC TO WCLAVE
                 FIND &WCLAVE
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
                 REPLACE CODCXC WITH WCLAVE
                 REPLACE REFERENCIA WITH WREF
                 REPLACE ELABORADA WITH WELABORADA
                 REPLACE VENCE WITH WVENCE
                 REPLACE MONTO WITH WMONTO
                 REPLACE SALDO WITH WMONTO
                 REPLACE CLIENTE WITH WCLIENTE
                 SELECT 2
                 REPLACE FACSERICXC WITH FACSERICXC + 1
                 SELECT 1
                 FLUSH
              ENDDO
         CASE WMENU = 2
              STORE .T. TO WACT
              STORE CODCXC TO WCODCXC
              STORE REFERENCIA TO WREF
              STORE ELABORADA TO WELABORADA
              STORE VENCE TO WVENCE
              STORE CANCELADA TO WCANCELADA
              STORE MONTO TO   WMONTO
              STORE CLIENTE TO WCLIENTE
              DO WHILE WACT
                 @ WSCRELIN ,09  GET WREF
                 @ WSCRELIN ,21  GET WELABORADA
                 @ WSCRELIN ,30  GET WVENCE
                 @ WSCRELIN ,74  GET WCLIENTE
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
                 REPLACE CLIENTE WITH WCLIENTE
                 FLUSH
                 STORE .F. TO WACT
              ENDDO
         CASE WMENU = 3
              @ 23,10 PROMPT "CANCELAR CTA."
              @ 23,30 PROMPT "ELIMINAR CTA."
              @ 23,50 PROMPT "SALIR        "
              MENU TO W0600
              @ 23,0
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
                 SAVE SCRE TO SCXC
                 STORE RECNO() TO WWREGI
                 STORE .T. TO CANCELING
                 DO WHILE CANCELING
                    SELECT 1
                    @ 6,0 CLEAR TO 21,79
                    @ 7,0 TO 21,79
                    STORE CODCXC TO WCODCXC
                    @ 6,01  SAY SUBSTR(CODCXC,4,7)
                    @ 6,09  SAY REFERENCIA
                    @ 6,21  SAY ELABORADA
                    @ 6,30  SAY VENCE
                    @ 6,39  SAY CANCELADA
                    @ 6,48  SAY MONTO PICTURE "########.##"
                    @ 6,74  SAY CLIENTE
                  * @ 7,1 SAY REPLICATE("-",78)
                    SET COLOR TO N/W
                    @ 8,01 SAY "LIN"
                    @ 8,05 SAY "FECHA"
                    @ 8,15 SAY "REF. CAJA Y BANCO"
                    @ 8,40 SAY "       DEBE"
                    @ 8,60 SAY "      HABER"
                    SET COLOR TO W/N
                    @ 9,01 SAY "  0"
                    @ 9,05 SAY DTOC(ELABORADA)
                    @ 9,15 SAY "FACTURA No."+SUBSTR(WCODCXC,4,7)
                    @ 9,40 SAY STR(MONTO,12,2)
                    SELECT 3
                    STORE 0 TO WPAGADO
                    STORE 0 TO WRENG
                    STORE 10 TO WLINE
                    FIND &WCODCXC
                    DO WHILE .NOT. EOF() .AND. NUMERO = WCODCXC
                       STORE WRENG+1 TO WRENG
                       STORE WLINE+1 TO WLINE
                       IF WLINE>20
                          STORE "OPRIMA <ENTER> PARA CONTINUAR" TO MES
                          DO AVISO WITH MES
                          @ 6,0 CLEAR TO 21,79
                          @ 7,0 TO 21,79
                          STORE 9 TO WLINE
                       ENDIF
                       @ WLINE,01  SAY STR(WRENG,3)
                       @ WLINE,05  SAY DTOC(FECHA)
                       @ WLINE,15  SAY REFERENCIA
                       @ WLINE,60  SAY MONTO PICTURE "########.##"
                       STORE WPAGADO + MONTO TO WPAGADO
                       SKIP
                    ENDDO
                    *** ACTUALIZAR VALORES EN DOCUMENTO X COBRAR
                    SELECT 1
                    REPLACE SALDO WITH MONTO - WPAGADO
                    @ 6,60  SAY SALDO PICTURE "########.##"
                    STORE SALDO TO WSALDO
                    IF SALDO > 0
                       REPLACE CANCELADA WITH CTOD("  -  -  ")
                    ENDIF
                    SELECT 3
                    STORE WRENG + 1 TO WCHOICE
                    STORE "INGRESE LA LINEA A PROCESAR " TO MES
                    DO MENSAJE WITH MES
                    @ 23,70 GET WCHOICE PICTURE "##"
                    READ
                    IF READKEY() = 12 .OR. READKEY() = 268 .OR. WCHOICE = 0
                       STORE .F. TO CANCELING
                       LOOP
                    ENDIF
                    *** BUSQUEDA DE LA LINEA SELECCIONADA
                    STORE 0 TO WSEL
                    STORE .F. TO WENCONTRADO
                    FIND &WCODCXC
                    DO WHILE .NOT. EOF() .AND. NUMERO = WCODCXC
                       STORE WSEL+1 TO WSEL
                       IF WSEL = WCHOICE
                          STORE .T. TO WENCONTRADO
                          EXIT
                       ENDIF
                       SKIP
                    ENDDO
                    STORE " " TO WENTRA
                    IF WENCONTRADO
                       STORE MONTO TO WLASTMONTO
                    ELSE
                       *** INCLUYENDO PAGO
                       STORE "I" TO WENTRA
                       APPEND BLANK
                       REPLACE NUMERO WITH WCODCXC
                       REPLACE FECHA WITH WFECACT
                       REPLACE MONTO WITH WSALDO
                       STORE 0 TO WLASTMONTO
                    ENDIF
                    @ WLINE+1,01  SAY STR(WCHOICE,3)
                    @ WLINE+1,05  GET FECHA
                    @ WLINE+1,15  GET REFERENCIA
                    @ WLINE+1,60  GET MONTO PICTURE "#########.##"
                    READ
                    IF MONTO > WSALDO+WLASTMONTO
                       STORE "MONTO A PAGAR EXEDE EL SALDO. EL MONTO SERA AJUSTADO A :"+STR((WSALDO+WLASTMONTO),12,2) TO MES
                       DO AVISO WITH MES
                       REPLACE MONTO WITH WSALDO+WLASTMONTO
                    ENDIF
                    STORE "CONFORME? (S/N)" TO TEX
                    STORE "SN" TO WCH
                    DO PREGUNTA
                    IF WCH = "S"
                       SELECT 1
                       IF WENTRA = "I"
                          IF SALDO = FACCXCTR->MONTO
                             REPLACE CANCELADA WITH FACCXCTR->FECHA
                             REPLACE SALDO WITH 0
                             IF REFERENCIA <> SPACE(23) .AND. SUBSTR(REFERENCIA,1,3) = "FAC"
                                STORE REFERENCIA TO WREF
                                SELECT 5
                                USE FACDCGE INDEX FACDCGE
                                FIND &WREF
                                IF EOF()
                                   STORE "LA FACTURA No. "+WREF+" NO ESTA REGISTRADA" TO MES
                                   DO AVISO WITH MES
                                ELSE
                                   REPLACE CANCELADA WITH WDATEPAY
                                ENDIF
                             ENDIF
                          ENDIF
                       ENDIF
                    ELSE
                       SELECT 3
                       DELETE
                    ENDIF
                    SELECT 1
                 ENDDO
                 SELECT 1
                 GO WWREGI
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
                 RESTORE SCRE FROM SCXC
                 SELECT 1
              ENDIF
              GO TOP
              STORE RECNO() TO WINICIO
              STORE .T. TO FLAGJUMP
              STORE 0 TO WREVERSE
         CASE WMENU = 4
              CLOSE DATA
              CLOSE INDEX
              RETURN
         CASE WMENU = 5
              SAVE SCRE TO S9
              STORE SPACE(LEN(SUBSTR(CODCXC,4,7))) TO WCODCXC
              @ WSCRELIN, 01 GET WCODCXC
              READ
              IF WCODCXC <> SPACE(LEN(CODCXC))
                 STORE "CXC"+WCODCXC TO WCLAVE
                 FIND &WCLAVE
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