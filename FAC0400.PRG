           SELECT 9
           USE SYSDATE
           store LTRIM(STR(FACSERINOT+1,7)) TO WNUMERO
           STORE REPLICATE("0",7-LEN(WNUMERO))+WNUMERO+SPACE(13) TO WNUMERO
           STORE "NOT" TO WTIPODOC
           STORE "NOTA DE ENTREGA" TO WDOCDES

           STORE SPACE(23) TO  WNUMERO2
           STORE .F. TO WFLAGELA
           do FACELADC
           IF .NOT. WFLAGELA
              CLOSE DATA
              CLOSE INDEX
              RETURN
           ENDIF
           SELECT 5
           STORE "DESEA IMPRIMIR LA NOTA ? (S/N)" TO TEX
           STORE "SN" TO WCH
           DO PREGUNTA
           IF WCH = "S"
              DO FACIMPDC
           ENDIF
           select 9
           USE SYSDATE
           if WFLAGELA
              replace facserinot with val(wnumero)
           endif
           DO FACACTIN
           CLOSE DATA
           CLOSE INDEX
           RETURN
