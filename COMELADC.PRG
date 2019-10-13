***
STORE WNUMERO TO WORIGINAL
SELECT 2
USE INVART INDEX INVART
SELECT 8
USE COMPRO INDEX COMPRO
SELECT 5
USE COMDCGE INDEX COMDCGE
SELECT 6
USE COMDCDE INDEX COMDCDE
STORE .F. TO WFLAGGEN
STORE .T. TO PRESUPUESTO
DO WHILE PRESUPUESTA
   @ 0,0 CLEAR
   STORE "ACTULIZAR "+WDOCDES TO WHEADER
   @ 00,40 - (LEN(WHEADER)/2) SAY WHEADER
   @ 01,0 SAY "+--------------+-------------+---------------+---------------------------------+"
   @ 02,0 SAY "|NUMERO:       |PROVEEDOR:   |FECHA:         |                                 |"
   @ 03,0 SAY "+-------+------+-------------+-----+----+----+-------------+-----+-------------+"
   @ 04,0 SAY "|RENGLON|CODIGO DE ARTICULO  |     | CANTIDAD|       PRECIO|DCTO.|        TOTAL|"
   @ 05,0 SAY "+-------+--------------------+-----+---------+-------------+-----+-------------+"
   @ 06,0 SAY "|       |                    |     |         |             |     |             |"
   @ 07,0 SAY "|       |                    |     |         |             |     |             |"
   @ 08,0 SAY "|       |                    |     |         |             |     |             |"
   @ 09,0 SAY "|       |                    |     |         |             |     |             |"
   @ 10,0 SAY "|       |                    |     |         |             |     |             |"
   @ 11,0 SAY "|       |                    |     |         |             |     |             |"
   @ 12,0 SAY "|       |                    |     |         |             |     |             |"
   @ 13,0 SAY "|       |                    |     |         |             |     |             |"
   @ 14,0 SAY "|       |                    |     |         |             |     |             |"
   @ 15,0 SAY "|       |                    |     |         |             |     |             |"
   @ 16,0 SAY "|       |                    |     |         |             |     |             |"
   @ 17,0 SAY "+-------+--------------------+-----+---------+-------------+-----+-------------+"
   @ 18,0 SAY "|       |                    |     |         |             |     |             |"
   @ 19,0 SAY "+-------+--------------------+-----+---------+-------------+-----+-------------+"
   STORE "NUMERO DEL "+WDOCDES+" A PROCESAR. <ESC> PARA SALIR" TO MES
   DO MENSAJE WITH MES
   @ 2,8 GET WNUMERO picture "#######"
   READ
   IF WNUMERO = SPACE(7)
      LOOP
   ENDIF
   IF READKEY()=12 .OR. READKEY()=268
      CLOSE DATA
      CLOSE INDEX
      RETURN
   ENDIF

   SELECT 5
   STORE WTIPODOC+WNUMERO TO WNUMERO2
   FIND &WNUMERO2
   IF EOF()
      STORE WDOCDES+" NO EXISTE, INGRESAR? (S/N)" TO TEX
      STORE "SN" TO WCH
      DO PREGUNTA
      IF WCH = "N"
         CLOSE DATA
         CLOSE INDEX
         RETURN
      ENDIF
      STORE SPACE(3) TO WCLIENTE
      STORE WFECACT TO WELABORADO
      ***
      DO COMGENDC
      ***
      STORE .T. TO VIENDOCLI
      DO WHILE VIENDOCLI
         @ 2,26 GET WCLIENTE
         READ
         IF WCLIENTE = SPACE(3)
            RETURN
         ENDIF
         IF WCLIENTE = "?  "
            SAVE SCRE TO S99
            SELECT 8
            GO TOP
            DO COM0502
            SELECT 5
            RESTORE SCRE FROM S99
            @ 2,26 SAY WCLIENTE
            LOOP
         ELSE
            SELECT 8
            FIND &WCLIENTE
            IF EOF()
               STORE "CODIGO NO REGISTRADO" TO MES
               DO AVISO WITH MES
               LOOP
            ELSE
               STORE CODCLI TO WCLIENTE
            ENDIF
         ENDIF
         STORE .F. TO VIENDOCLI
      ENDDO

      @ 2,36 GET WELABORADO
      READ
      STORE "CONFORME ? (S/N)" TO TEX
      STORE "SN" TO WCH
      DO PREGUNTA
      IF WCH = "N"
         LOOP
      ENDIF
      SELECT 5
      if .not. wflaggen
         APPEND BLANK
         REPLACE NUMERO WITH WNUMERO2
         REPLACE CLIENTE WITH WCLIENTE
         REPLACE ELABORADO WITH WELABORADO
      endif
      STORE .T. TO WFLAGELA
   ELSE
      STORE CLIENTE TO WCLIENTE
      STORE ELABORADO TO WELABORADO
      @ 2,26 SAY WCLIENTE
      @ 2,36 SAY WELABORADO
      STORE "OPCIONES: (P)ROCESAR, (E)LIMINAR, (C)ONTINUAR" TO TEX
      STORE "CEP" TO WCH
      DO PREGUNTA
      STORE WCH TO RESP
      IF RESP = "E"
         STORE "ESTA USTED SEGURO QUE DESEA ELIMINAR ? (N/S)" TO TEX
         STORE "NS" TO WCH
         DO PREGUNTA
         IF WCH = "N"
            LOOP
         ENDIF
     *    SELECT 5
     *    DELETE
         SELECT 6
         DELETE ALL FOR NUMERO = WNUMERO2
         LOOP
      ENDIF
      IF RESP = "P"
         STORE .T. TO VIENDOCLI
         DO WHILE VIENDOCLI
            @ 2,26 GET WCLIENTE
            READ
            IF WCLIENTE = SPACE(5)
               RETURN
            ENDIF
            IF WCLIENTE = "?    "
               SAVE SCRE TO S99
               SELECT 8
               GO TOP
               DO COM0502
               SELECT 5
               RESTORE SCRE FROM S99
               @ 2,26 SAY WCLIENTE
               LOOP
            ELSE
               SELECT 8
               FIND &WCLIENTE
               IF EOF()
                  STORE "CODIGO NO REGISTRADO" TO MES
                  DO AVISO WITH MES
                  LOOP
               ELSE
                  STORE CODCLI TO WCLIENTE
               ENDIF
            ENDIF
            STORE .F. TO VIENDOCLI
         ENDDO

         @ 2,36 GET WELABORADO
         READ
         STORE "CONFORME ? (S/N)" TO TEX
         STORE "SN" TO WCH
         DO PREGUNTA
         IF WCH = "N"
            LOOP
         ENDIF
         SELECT 5
         REPLACE CLIENTE WITH WCLIENTE
         REPLACE ELABORADO WITH WELABORADO
         STORE .T. TO WFLAGELA
      ENDIF
   ENDIF

   STORE .T. TO ACTUALIZA
   DO WHILE ACTUALIZA
      STORE 100 TO WLINE
      STORE 0 TO PAGINA
      STORE 0 TO WMONTODOC
      SELECT 6
      FIND &WNUMERO2
      DO WHILE .NOT. EOF() .AND. NUMERO = WNUMERO2
         STORE WLINE + 1 TO WLINE
         IF WLINE >=17
            STORE 6 TO WCLEANER
            STORE PAGINA + 1 TO PAGINA
            IF PAGINA > 1
               STORE "OPRIMA <ENTER> PARA CONTINUAR" TO MES
               DO AVISO WITH MES
            ENDIF
            DO WHILE WCLEANER <=16
               @ WCLEANER,0 SAY "|       |                    |     |         |             |     |             |"
               STORE WCLEANER + 1 TO WCLEANER
            ENDDO
            STORE 6 TO WLINE
         ENDIF
         @ WLINE,1 SAY RENGLON
         @ WLINE,9 SAY ITEM
         @ WLINE,36 SAY CANTIDAD PICTURE "######.##"
         @ WLINE,48 SAY PRECIO   PICTURE "########.##"
         @ WLINE,60 SAY DESCUENTO PICTURE "##.##"
         STORE (CANTIDAD*PRECIO) - ((CANTIDAD*PRECIO)*(DESCUENTO/100)) TO WTOTAL
         @ WLINE,68 SAY WTOTAL PICTURE "########.##"
         STORE WMONTODOC + WTOTAL TO WMONTODOC
         SELECT 6
         SKIP
      ENDDO
      SELECT 5
      REPLACE MONTO WITH WMONTODOC
      @ 20,0
      @ 21,0
      @ 22,0

      STORE .T. TO VERITEM
      STORE SPACE(20) TO WITEM
      DO WHILE VERITEM
         SELECT 6
         @ 18,9  SAY SPACE(20)
         @ 18,30 SAY SPACE(5)
         @ 18,36 SAY SPACE(9)
         @ 18,48 SAY SPACE(11)
         @ 18,60 SAY SPACE(5)
         @ 18,68 SAY SPACE(11)
         @ 18,68 SAY WMONTODOC PICTURE "########.##"

         STORE "INGRESE EL CODIGO DE RENGLON A PROCESAR, OPRIMA <ESC> PARA SALIR" TO MES
         DO MENSAJE WITH MES
         STORE SPACE(5) TO WRENGLON
         @ 18,1 GET WRENGLON
         READ
         IF WRENGLON = SPACE(5) .OR. READKEY() = 12 .OR. READKEY() = 268
            STORE .F. TO VERITEM
            STORE .F. TO ACTUALIZA
            LOOP
         ENDIF
         STORE WNUMERO2+WRENGLON TO WCLAVE
         SELECT 6
         FIND &WCLAVE
         IF EOF()
            STORE "RENGLON NO REGISTRADO EN "+WDOCDES+", INGRESAR ? (S/N)" TO TEX
            STORE "SN" TO WCH
            DO PREGUNTA
            IF WCH = "N"
               LOOP
            ENDIF
            STORE SPACE(20) TO WITEM
            STORE "ARTICULO A PROCESAR. (?=VER ART.), (<ESC>=SALIR)" TO MES
            DO MENSAJE WITH MES
            @ 18,9 GET WITEM
            READ
            IF WITEM = SPACE(20) .OR. READKEY() = 12 .OR. READKEY() = 268
               STORE .F. TO VERITEM
               STORE .F. TO ACTUALIZA
               LOOP
            ENDIF
            IF WITEM = "?"+SPACE(19)
               SELECT 2
               GO TOP
               SAVE SCRE TO S99
               DO INV0202
               SELECT 6
               RESTORE SCRE FROM S99
               LOOP
            ENDIF
            SELECT 2
            FIND &WITEM
            IF EOF()
               STORE "CODIGO NO REGISTRADO EN BASE DE DATOS. <ENTER>" TO MES
               DO AVISO WITH MES
               LOOP
            ENDIF
            STORE DESCRI TO WDESCRI
            STORE UNIMED TO WUNIMED
            STORE UNIEXI TO WUNIEXI
            STORE MAXIMO TO WMAXIMO
            @ 20,1 SAY "DESCRIPCION :"+WDESCRI
            @ 21,1 SAY "UNID./ MED. :"+WUNIMED
            STORE 0 TO WCANTIDAD
            STORE 0 TO WPRECIO
            STORE 0 TO WDESCUENTO
            STORE SPACE(5) TO WLOTE
            STORE .T. TO WFLAGCANT
            DO WHILE WFLAGCANT
               @ 18,36 GET WCANTIDAD PICTURE "######.##"
               READ
               IF WCANTIDAD > 0
                  STORE .F. TO WFLAGCANT
               ENDIF
               IF WCANTIDAD+WUNIEXI > WMAXIMO
                  STORE "ADVERTENCIA: COMPRA EXEDE MAXIMO ESTABLECIDO. <ENTER>" TO MES
                  DO AVISO WITH MES
               ENDIF
            ENDDO
            @ 18,48 GET WPRECIO   PICTURE "########.##"
            READ
            @ 18,60 GET WDESCUENTO PICTURE "##.##"
            READ
            STORE (WCANTIDAD*WPRECIO) - ((WCANTIDAD*WPRECIO)*(WDESCUENTO/100)) TO WTOTAL
            @ 18,68 SAY WTOTAL PICTURE "########.##"
            STORE "CONFORME ? (S/N)" TO TEX
            STORE "SN" TO WCH
            DO PREGUNTA
            IF WCH = "N"
               LOOP
            ENDIF
            SELECT 6
            APPEND BLANK
            REPLACE NUMERO WITH WNUMERO2
            REPLACE RENGLON WITH WRENGLON
            REPLACE ITEM WITH WITEM
            REPLACE CANTIDAD WITH WCANTIDAD
            REPLACE PRECIO WITH WPRECIO
            REPLACE DESCUENTO WITH WDESCUENTO
         ELSE
            STORE ITEM TO WITEM
            STORE CANTIDAD  TO WCANTIDAD
            STORE PRECIO    TO WPRECIO
            STORE DESCUENTO TO WDESCUENTO
            SELECT 2
            FIND &WITEM
            IF EOF()
               STORE "CODIGO NO REGISTRADO EN MAESTRO DE ARTICULOS. <ENTER>" TO MES
               DO AVISO WITH MES
               LOOP
            ENDIF
            STORE UNIEXI TO WUNIEXI
            STORE MAXIMO TO WMAXIMO
            SELECT 6
            @ 18,9 SAY WITEM
            @ 18,36 SAY WCANTIDAD PICTURE "######.##"
            @ 18,48 SAY WPRECIO   PICTURE "########.##"
            @ 18,60 SAY WDESCUENTO PICTURE "##.##"
            STORE (WCANTIDAD*WPRECIO) - ((WCANTIDAD*WPRECIO)*(WDESCUENTO/100)) TO WTOTAL
            @ 18,68 SAY WTOTAL PICTURE "########.##"
            STORE "OPCIONES: (M)ODIFICAR, (E)LIMINAR, (S)ALIR" TO TEX
            STORE "SME" TO WCH
            DO PREGUNTA
            STORE WCH TO WSME
            IF WSME = "S"
               EXIT
            ENDIF
            IF WSME = "E"
              STORE "ESTA USTED SEGURO ? (S/N)" TO TEX
              STORE "NS" TO WCH
              DO PREGUNTA
              IF WCH = "S"
                 DELETE
                 EXIT
              ENDIF
            ENDIF
            IF WSME = "M"
               STORE .T. TO WFLAGCANT
               store WCANTIDAD TO WLASTCANT
               DO WHILE WFLAGCANT
                  @ 18,36 GET WCANTIDAD PICTURE "######.##"
                  READ
                  IF WCANTIDAD > 0
                     STORE .F. TO WFLAGCANT
                  ENDIF
                  IF (WCANTIDAD-WLASTCANT)+WUNIEXI > WMAXIMO
                     STORE "ADVERTENCIA: COMPRA EXEDE EL MAXIMO ESTABLECIDO. <ENTER>" TO MES
                     DO AVISO WITH MES
                  ENDIF
               ENDDO
               @ 18,48 GET WPRECIO   PICTURE "########.##"
               READ
               @ 18,60 GET WDESCUENTO PICTURE "##.##"
               READ
               STORE (WCANTIDAD*WPRECIO) - ((WCANTIDAD*WPRECIO)*(WDESCUENTO/100)) TO WTOTAL
               @ 18,68 SAY WTOTAL PICTURE "########.##"
               STORE "CONFORME ? (S/N)" TO TEX
               STORE "SN" TO WCH
               DO PREGUNTA
               IF WCH = "S"
                  REPLACE CANTIDAD WITH WCANTIDAD
                  REPLACE PRECIO WITH WPRECIO
                  REPLACE DESCUENTO WITH WDESCUENTO
               ENDIF
            ENDIF
         ENDIF
         EXIT
      ENDDO
   ENDDO
ENDDO
RETURN

