           SELECT 9
           USE SYSDATE
           store LTRIM(str(facserifac+1,7)) to wnumero
           STORE REPLICATE("0",7-LEN(WNUMERO))+WNUMERO+SPACE(13) TO WNUMERO
           STORE "FAC" TO WTIPODOC
           STORE "FACTURA" TO WDOCDES
           STORE SPACE(23) TO  WNUMERO2
           STORE 0 TO WMONTODOC
           STORE SPACE(5) TO WCLIENTE
           STORE DATE() TO WELABORADO

           STORE .F. TO WFLAGELA
           STORE .F. TO WFLAGACT
           do FACELADC
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
              STORE WELABORADO TO WVENCE
              STORE WELABORADO TO WCANCELADO
           ENDIF
           SELECT 5
           USE FACDCGE INDEX FACDCGE
           FIND &WNUMERO2
           IF EOF()
              STORE "ERROR, DESAPARECIO LA FACTURA" TO MES
              DO AVISO WITH MES
              CLOSE DATA
              CLOSE INDEX
              RETURN
           ENDIF
           REPLACE ELABORADO WITH WELABORADO
           REPLACE VENCE WITH WVENCE
           REPLACE CANCELADO WITH WCANCELADO
           STORE REFERENCIA TO WEDDY
           CLOSE DATA
           CLOSE INDEX

           STORE "DESEA IMPRIMIR LA FACTURA ? (S/N)" TO TEX
           STORE "SN" TO WCH
           DO PREGUNTA
           IF WCH = "S"
              DO FACIMPDC
           ENDIF
           STORE "OPCIONES: (G)RABAR FACTURA, (A)NULAR FACTURA" TO TEX
           STORE "GA" TO WCH
           DO PREGUNTA
           STORE WCH TO WCG
           IF WCG = "A"
              IF SUBSTR(WNUMERO2,1,3) = "FAC" .AND. WEDDY <> SPACE(23)
                 STORE "USTED NO PUEDE ANULAR LA FACTURA CON REF., REMITASE AL LA NOTA No. "+SUBSTR(WREFIERE,4,7) TO MES
                 DO AVISO WITH MES
                 CLOSE DATA
                 CLOSE INDEX
              ELSE
                 SELECT 6
                 USE FACDCDE INDEX FACDCDE
                 REPLACE ALL CANTIDAD WITH 0 FOR NUMERO = WNUMERO2
                 REPLACE ALL PRECIO WITH 0 FOR NUMERO = WNUMERO2
                 CLOSE DATA
                 CLOSE INDEX
              ENDIF
           ENDIF
           IF WCG = "G"
              IF WEDDY = SPACE(23)
                 select 9
                 USE SYSDATE
                 DO FACACTIN
              ENDIF
              select 9
              USE SYSDATE
              if facserifac +1 = val(wnumero) .AND. WFLAGELA
                replace facserifac with val(wnumero)
              endif
              use

              *** ACTUALIZA LAS CTAS X COBRAR
              SELECT 7
              USE FACCXC INDEX FACCXC, FACCXC2
              GO TOP
              LOCATE FOR REFERENCIA = SUBSTR(WNUMERO2,1,10)
              IF .NOT. FOUND()
                 IF WFORMAPAGO = "R"
                    SELECT 9
                    USE SYSDATE
                    store LTRIM(str(facseriCXC+1,7)) to wnumcxc
                    STORE REPLICATE("0",7-LEN(WNUMCXC))+WNUMCXC TO WNUMCXC
                    STORE "CXC" TO WTIPODOC
                    STORE WTIPODOC+WNUMCXC TO WCODCXC
                    REPLACE FACSERICXC WITH FACSERICXC + 1
                    SELECT 7
                    APPEND BLANK
                    REPLACE CODCXC WITH WCODCXC
                    REPLACE REFERENCIA WITH WNUMERO2
                    REPLACE ELABORADA WITH WELABORADO
                    REPLACE VENCE WITH WVENCE
                    REPLACE CANCELADA WITH WCANCELADO
                    REPLACE MONTO WITH WMONTODOC
                    REPLACE SALDO WITH WMONTODOC
                    REPLACE CLIENTE WITH WCLIENTE
                 ENDIF
              ELSE
                 IF WFORMAPAGO = "R"
                    REPLACE ELABORADA WITH WELABORADO
                    REPLACE VENCE WITH WVENCE
                    REPLACE CANCELADA WITH WCANCELADO
                    REPLACE MONTO WITH WMONTODOC
                    REPLACE CLIENTE WITH WCLIENTE
                 ELSE
                    DELETE
                 ENDIF
              ENDIF
              *** ACTUALIZA LAS CAJAS Y BANCOS
           ENDIF
           CLOSE DATA
           CLOSE INDEX
           RETURN

