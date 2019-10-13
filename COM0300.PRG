           SELECT 9
           USE SYSDATE
           store LTRIM(str(COMSERINOT+1,7)) to wnumero
           STORE REPLICATE("0",7-LEN(WNUMERO))+WNUMERO TO WNUMERO
           STORE "NOT" TO WTIPODOC
           STORE "NOTA DE ENTREGA" TO WDOCDES
           STORE SPACE(10) TO  WNUMERO2
           STORE 0 TO WMONTODOC
           STORE SPACE(5) TO WCLIENTE
           STORE DATE() TO WELABORADO

           STORE .F. TO WFLAGELA
           do COMELADC
           IF .NOT. WFLAGELA
              CLOSE DATA
              CLOSE INDEX
              RETURN
           ENDIF

           STORE "FORMA DE PAGO: C(R)EDITO, (C)ONTADO" TO TEX
           STORE "RC" TO WCH
           DO PREGUNTA
           STORE WCH TO WFORMAPAGO
           IF WCH = "R"
              STORE .T. TO WACTCXP
              STORE WELABORADO+30 TO WVENCE
              STORE CTOD("  -  -  ") TO WCANCELADO
              STORE "FECHA DE VENCIMIENTO:" TO MES
              DO MENSAJE WITH MES
              @ 23,55 GET WVENCE
              READ
              IF WVENCE < WELABORADO
                 STORE "ERROR EN FECHA DE VENCIMIENTO, SE ASUMIRAN 30 DIAS" TO MES
                 DO AVISO WITH MES
                 STORE WELABORADO+30 TO WVENCE
              ENDIF
           ELSE
              STORE .F. TO WACTCXP
              STORE WELABORADO TO WVENCE
              STORE WELABORADO TO WCANCELADO
           ENDIF
           SELECT 5
           USE COMDCGE INDEX COMDCGE
           FIND &WNUMERO2
           IF EOF()
              STORE "ERROR, DESAPARECIO LA NOTA" TO MES
              DO AVISO WITH MES
              CLOSE DATA
              CLOSE INDEX
              RETURN
           ENDIF
           REPLACE ELABORADO WITH WELABORADO
           REPLACE VENCE WITH WVENCE
           REPLACE CANCELADO WITH WCANCELADO
           CLOSE DATA
           CLOSE INDEX
*          STORE "DESEA IMPRIMIR LA NOTA ? (S/N)" TO TEX
*          STORE "SN" TO WCH
*          DO PREGUNTA
*          IF WCH = "S"
*             DO FACIMPDC
*          ENDIF

           STORE "OPCIONES: (G)RABAR NOTA, (B)ORRAR NOTA" TO TEX
           STORE "GB" TO WCH
           DO PREGUNTA
           STORE WCH TO WCG
           IF WCG = "B"
             * SELECT 5
             * USE COMDCGE INDEX COMDCGE
             * FIND &WNUMERO2
             * IF EOF()
             *   STORE "ERROR INTERNO, DESAPARECIO LA NOTA" TO MES
             *   DO AVISO WITH MES
             *   RETURN
             * ENDIF
             * DELETE
              SELECT 6
              USE COMDCDE INDEX COMDCDE
              DELETE ALL FOR NUMERO = WNUMERO2
              CLOSE DATA
              CLOSE INDEX
           ENDIF
           IF WCG = "G"
              DO COMACTIN
              select 9
              USE SYSDATE
              if COMSERINOT +1 = val(wnumero) .AND. WFLAGELA
                 replace COMSERINOT with val(wnumero)
              endif
              use
              IF WACTCXP
                 ***************************
                 *** ACTUALIZA LAS CTAS X PAGAR
                 SELECT 7
                 USE COMCXP INDEX COMCXP, COMCXP2
                 GO TOP
                 LOCATE FOR REFERENCIA = WNUMERO2
                 IF .NOT. FOUND()
                    SELECT 9
                    USE SYSDATE
                    store LTRIM(str(COMSERICXP+1,7)) to wnumcxP
                    STORE REPLICATE("0",7-LEN(WNUMCXP))+WNUMCXP TO WNUMCXP
                    STORE "CXP" TO WTIPODOC
                    STORE WTIPODOC+WNUMCXP TO WCODCXP
                    REPLACE COMSERICXP WITH COMSERICXP + 1
                    SELECT 7
                    APPEND BLANK
                    REPLACE CODCXP WITH WCODCXP
                 ENDIF
                 REPLACE REFERENCIA WITH WNUMERO2
           *     REPLACE REFERENCI2 WITH WNUMER2
                 REPLACE ELABORADA WITH WELABORADO
                 REPLACE VENCE WITH WVENCE
                 REPLACE CANCELADA WITH WCANCELADO
                 REPLACE MONTO WITH WMONTODOC
                 REPLACE CLIENTE WITH WCLIENTE
                 SELECT 7
                 FLUSH
              ELSE
                 *** ACTUALIZA LAS CAJAS Y BANCOS
              ENDIF
           ENDIF
           CLOSE DATA
           CLOSE INDEX
           RETURN

