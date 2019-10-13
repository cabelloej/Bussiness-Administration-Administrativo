              STORE 100 TO WSCRELIN
              STORE .T. TO WACT
              DO WHILE WACT
                 STORE WSCRELIN + 1 TO WSCRELIN
                 *** VALORES INICIALES
                 STORE WFECACT TO WFECHA
                 STORE SPACE(LEN(CODIGO)) TO WCODIGO
                 STORE SPACE(2) TO WOPERA
                 STORE SPACE(10) TO WREFEREN
                 STORE "INV" TO WORIGEN
                 STORE SPACE(5) TO WPROCLI
                 STORE 0 TO WUNIDADES
                 STORE 0 TO WCOSTO
                 ***
                 IF WSCRELIN > 18
                    SET COLOR TO G/N
                    @ 7,1 CLEAR TO 18,78
                    STORE 7 TO WSCRELIN
                 ENDIF

                 STORE .F. TO FLAGING
                 STORE .T. TO WINGRESAR
                 DO WHILE WINGRESAR
                    DO DAGE0301
                    IF WCODIGO = SPACE(LEN(CODIGO)) .OR. READKEY() = 12 .OR. READKEY() = 268
                       STORE .F. TO Wingresar
                       STORE .F. TO WACT
                       STORE .T. TO FLAGING
                       STORE .T. TO FLAGJUMP
                       GO TOP
                       STORE RECNO() TO WINICIO
                       STORE 0 TO WREVERSE
                       LOOP
                    ENDIF
                    STORE .F. TO WFLAGART
                    *** VALIDACION DE LOS DATOS INGRESADOS
                    *** ALTERACION CRONOLOGICA
                    IF WFECHA < WFECACT
                       STORE "ADVERTENCIA LA FECHA DE LA OPERACION ES MENOR A LA FECHA ACTUAL" TO MES
                       DO AVISO WITH MES
                       STORE .T. TO WFLAGACT
                       STORE .T. TO WFLAGART
                    ENDIF
                    *** CODIGO INVALIDO
                    SELECT 2
                    FIND &WCODIGO
                    IF EOF()
                       STORE "CODIGO NO REGISTRADO. <ENTER>" TO MES
                       DO AVISO WITH MES
                       SELECT 3
                       LOOP
                    ENDIF
                    SELECT 3
                    *** OPERACION INVALIDA
                    IF WOPERA="EN" .OR. WOPERA="SA" .OR. WOPERA="AE" .OR. WOPERA="AS" .OR. WOPERA="AC"
                       ***PASO
                    ELSE
                       STORE "TIPO DE MOVIMIENTO NO VALIDO, VERIFIQUE EL MOVIMIENTO. <ENTER>" TO MES
                       DO AVISO WITH MES
                       LOOP
                    ENDIF
                    *** REFERENCIA INVALIDA
                    IF WREFEREN = SPACE(10)
                       STORE "DEBE EXISTIR UNA REFERENCIA. <ENTER>" TO MES
                       DO AVISO WITH MES
                       LOOP
                    ENDIF
                    *** UNIDADES
                    IF WOPERA <> "AC"
                       IF WUNIDADES = 0
                          STORE "DEBEN EXISTIR UNIDADES EN ESTA OPERACION. <ENTER>" TO MES
                          DO AVISO WITH MES
                          LOOP
                       ENDIF
                    ELSE
                       STORE 0 TO WUNIDADES
                       @ WSCRELIN,47 SAY WUNIDADES PICTURE "#######.##"
                    ENDIF
                    *** COSTO
                    IF WOPERA="EN" .OR. WOPERA="AC"
                       IF WCOSTO = 0
                          STORE "DEBE EXISTIR COSTO EN LA OPERACION. <ENTER>" TO MES
                          DO AVISO WITH MES
                          LOOP
                       ENDIF
                    ELSE
                       STORE INVART->COSEXI*WUNIDADES TO WCOSTO
                       @ WSCRELIN,58 SAY WCOSTO PICTURE "########.##"
                    ENDIF
                    STORE .F. TO WINGRESAR
                 ENDDO
                 IF FLAGING
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
                 REPLACE SERIAL WITH SYSDATE->SERIAL+1
                 DO DARE0301
                 SELECT 9
                 REPLACE SERIAL WITH SERIAL+1
                 IF INVART->LOTE = "S"
                    SAVE SCRE TO S4
                    STORE WOPERA TO WOPE
                    STORE WFECHA TO WFECHAOP
                    DO INV0103L
                    RESTORE SCRE FROM S4
                 ENDIF
                 FLUSH
                 SELECT 2
                 IF WFLAGART
                    REPLACE FLAGREPRO WITH "S"
                 ENDIF
                 DO CASE
                    CASE WOPERA = "EN"
                         SELECT 2
                         REPLACE COSEXI WITH ((COSEXI*UNIEXI)+(WCOSTO)) / (UNIEXI+WUNIDADES)
                         REPLACE UNIEXI WITH UNIEXI + WUNIDADES
                         REPLACE ULTCOMPRA WITH WFECHA
                         REPLACE ULTCANTI WITH WUNIDADES
                         REPLACE ULTCOSTO WITH WCOSTO
                         FLUSH
                    CASE WOPERA = "SA"
                         SELECT 2
                         REPLACE UNIEXI WITH UNIEXI - WUNIDADES
                         FLUSH
                    CASE WOPERA = "AE"
                         SELECT 2
                         REPLACE UNIEXI WITH UNIEXI + WUNIDADES
                         FLUSH
                    CASE WOPERA = "AS"
                         SELECT 2
                         REPLACE UNIEXI WITH UNIEXI - WUNIDADES
                         FLUSH
                    CASE WOPERA = "AC"
                         SELECT 2
                         REPLACE COSEXI WITH ((COSEXI*UNIEXI)+(WCOSTO)) / (UNIEXI)
                         FLUSH
                 ENDCASE
                 SELECT 3
              ENDDO
