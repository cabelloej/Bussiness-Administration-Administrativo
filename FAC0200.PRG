           select 9
           USE SYSDATE
           store LTRIM(str(facseripre+1,7)) to wnumero
           STORE REPLICATE("0",7-LEN(WNUMERO))+WNUMERO+SPACE(13) TO WNUMERO
           STORE "PRE" TO WTIPODOC
           STORE "PRESUPUESTO" TO WDOCDES
           STORE WTIPODOC+WNUMERO TO WNUMERO2
           STORE .F. TO WFLAGELA
           STORE DATE() TO WELABORADO
           do FACELADC
           *********************
           STORE "FORMA DE PAGO DEL PRESUPUESTO: C(R)EDITO, (C)ONTADO" TO TEX
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
              STORE "ERROR, DESAPARECIO EL PRESUPUESTO." TO MES
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
           ****************************************
           select 9
           USE SYSDATE
           if WFLAGELA
              replace facseripre with val(wnumero)
           endif
           use
