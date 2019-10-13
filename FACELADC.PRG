STORE wnumero TO woriginal
SELECT 2
USE invart INDEX invart
SELECT 8
USE faccli INDEX faccli
SELECT 3
USE facven INDEX facven
SELECT 4
USE facser INDEX facser
SELECT 5
USE facdcge INDEX facdcge
SELECT 6
USE facdcde INDEX facdcde
STORE .F. TO wflaggen
STORE .T. TO pres
DO WHILE pres
   @ 0,0 CLEAR
   STORE "ACTUALIZAR "+wdocdes TO wheader
   @ 00,40 - (LEN(wheader)/2) SAY wheader
   @ 01,0 SAY "+--------------+-----------+------------+--------------+--------------+--------+"
   @ 02,0 SAY "|NUMERO:       |CLIENTE:   |VENDEDOR:   |COMISION:     |FECHA:        |LISTA:  |"
   @ 03,0 SAY "+-------+------+-----------+-------+----+----+---------+---+-----+----+--------+"
   @ 04,0 SAY "|RENGLON|CODIGO DE ART/SERV.       | CANTIDAD|       PRECIO|DCTO.|        TOTAL|"
   @ 05,0 SAY "+-------+--------------------------+---------+-------------+-----+-------------+"
   @ 06,0 SAY "|       |                          |         |             |     |             |"
   @ 07,0 SAY "|       |                          |         |             |     |             |"
   @ 08,0 SAY "|       |                          |         |             |     |             |"
   @ 09,0 SAY "|       |                          |         |             |     |             |"
   @ 10,0 SAY "|       |                          |         |             |     |             |"
   @ 11,0 SAY "|       |                          |         |             |     |             |"
   @ 12,0 SAY "|       |                          |         |             |     |             |"
   @ 13,0 SAY "|       |                          |         |             |     |             |"
   @ 14,0 SAY "|       |                          |         |             |     |             |"
   @ 15,0 SAY "|       |                          |         |             |     |             |"
   @ 16,0 SAY "|       |                          |         |             |     |             |"
   @ 17,0 SAY "+-------+--------------------------+---------+-------------+-----+-------------+"
   @ 18,0 SAY "|       |                          |         |             |     |             |"
   @ 19,0 SAY "+-------+--------------------------+---------+-------------+-----+-------------+"
   IF wtipodoc <> "ORD"
      STORE "NUMERO DEL "+wdocdes+" A PROCESAR. <ESC> PARA SALIR" TO mes
      DO mensaje WITH mes
      @ 2,8 GET wnumero PICTURE "#######"
      READ
   ELSE
      SAVE SCRE TO sx1
      STORE wdocdes+" A PROCESAR. (<ESC> PARA SALIR)" TO mes
      DO mensaje WITH mes
      @ 1,7 CLEAR TO 3,30
      @ 1,7 TO 3,30
      @ 2,8 GET wnumero
      READ
      RESTORE SCRE FROM sx1
   ENDIF
   IF wnumero = SPACE(7) .OR. wnumero = SPACE(20)
      LOOP
   ENDIF
   IF READKEY()=12 .OR. READKEY()=268
      STORE .F. TO pres
      LOOP
   ENDIF
   
   SELECT 5
   STORE wtipodoc+wnumero TO wnumero2
   FIND &wnumero2
   IF EOF()
      STORE wdocdes+" NO EXISTE, INGRESAR? (S/N)" TO tex
      STORE "SN" TO wch
      DO pregunta
      IF wch = "N"
         STORE .F. TO pres
         LOOP
      ENDIF
      IF wtipodoc <> "NOT" .AND. wtipodoc <> "PRE"
         STORE SPACE(7) TO wreferencia
      ELSE
         STORE SPACE(20) TO wreferencia
      ENDIF
      STORE SPACE(3) TO wcliente
      STORE SPACE(3) TO wvendedor
      STORE 0 TO wcomision
      STORE wfecact TO welaborado
      STORE 1 TO wlista
      ***
      DO facgendc
      STORE VAL(wlista) TO wlista
      ***
      STORE .T. TO viendocli
      DO WHILE viendocli
         @ 2,24 GET wcliente
         READ
         IF wcliente = SPACE(3)
            STORE .F. TO pres
            LOOP
         ENDIF
         IF wcliente = "?  "
            SAVE SCRE TO s99
            SELECT 8
            GO TOP
            DO fac0701b
            SELECT 5
            RESTORE SCRE FROM s99
            @ 2,24 SAY wcliente
            LOOP
         ELSE
            SELECT 8
            FIND &wcliente
            IF EOF()
               STORE "CODIGO NO REGISTRADO" TO mes
               DO aviso WITH mes
               LOOP
            ELSE
               STORE codcli TO wcliente
            ENDIF
         ENDIF
         STORE .F. TO viendocli
      ENDDO
      
      STORE .T. TO viendoven
      DO WHILE viendoven
         @ 2,37 GET wvendedor
         READ
         IF wvendedor= SPACE(3)
            STORE .F. TO pres
            LOOP
         ENDIF
         IF wvendedor= "?  "
            SAVE SCRE TO s99
            SELECT 3
            DO fac0701c
            SELECT 5
            RESTORE SCRE FROM s99
            @ 2,37 SAY wvendedor
            LOOP
         ELSE
            SELECT 3
            FIND &wvendedor
            IF EOF()
               STORE "CODIGO NO REGISTRADO" TO mes
               DO aviso WITH mes
               LOOP
            ELSE
               STORE codven TO wvendedor
               STORE comven   TO wcomision
            ENDIF
         ENDIF
         STORE .F. TO viendoven
      ENDDO
      
      @ 2,50 GET wcomision PICTURE "##.##"
      READ
      @ 2,62 GET welaborado
      READ
      @ 2,78 GET wlista PICTURE "#" RANGE 1,3
      READ
      STORE STR(wlista,1) TO wlista
      STORE "CONFORME ? (S/N)" TO tex
      STORE "SN" TO wch
      DO pregunta
      IF wch = "N"
         LOOP
      ENDIF
      SELECT 5
      IF .NOT. wflaggen
         APPEND BLANK
         REPLACE numero WITH wnumero2
         REPLACE cliente WITH wcliente
         REPLACE vendedor WITH wvendedor
         REPLACE comven   WITH wcomision
         REPLACE elaborado WITH welaborado
         REPLACE lista WITH wlista
      ENDIF
      STORE .T. TO wflagela
   ELSE
      STORE cliente TO wcliente
      STORE vendedor TO wvendedor
      STORE comven   TO wcomision
      STORE elaborado TO welaborado
      STORE VAL(lista) TO wlista
      STORE referencia TO wreferencia
      
      @ 2,24 SAY wcliente
      @ 2,37 SAY wvendedor
      @ 2,50 SAY wcomision PICTURE "##.##"
      @ 2,62 SAY welaborado
      @ 2,78 SAY STR(wlista,1)
      STORE "OPCIONES: (P)ROCESAR, (E)LIMINAR, (C)ONTINUAR" TO tex
      STORE "PEC" TO wch
      DO pregunta
      STORE wch TO resp
      IF resp = "E"
         STORE "ESTA USTED SEGURO QUE DESEA ELIMINAR ? (N/S)" TO tex
         STORE "NS" TO wch
         DO pregunta
         IF wch = "N"
            LOOP
         ENDIF
         *    SELECT 5
         *    DELETE
         SELECT 6
         DELETE ALL FOR numero = wnumero2
         LOOP
      ENDIF
      IF resp = "P"
         STORE .T. TO viendocli
         DO WHILE viendocli
            @ 2,24 GET wcliente
            READ
            IF wcliente = SPACE(5)
               STORE .F. TO pres
               LOOP
            ENDIF
            IF wcliente = "?    "
               SAVE SCRE TO s99
               SELECT 8
               GO TOP
               DO fac0701b
               SELECT 5
               RESTORE SCRE FROM s99
               @ 2,24 SAY wcliente
               LOOP
            ELSE
               SELECT 8
               FIND &wcliente
               IF EOF()
                  STORE "CODIGO NO REGISTRADO" TO mes
                  DO aviso WITH mes
                  LOOP
               ELSE
                  STORE codcli TO wcliente
               ENDIF
            ENDIF
            STORE .F. TO viendocli
         ENDDO
         
         STORE .T. TO viendoven
         DO WHILE viendoven
            @ 2,37 GET wvendedor
            READ
            IF wvendedor= SPACE(5)
               STORE .F. TO pres
               LOOP
            ENDIF
            IF wvendedor= "?    "
               SAVE SCRE TO s99
               SELECT 3
               DO fac0103
               STORE codven TO wvendedor
               STORE comven   TO wcomision
               SELECT 5
               RESTORE SCRE FROM s99
               @ 2,37 SAY wvendedor
            ELSE
               SELECT 3
               FIND &wvendedor
               IF EOF()
                  STORE "CODIGO NO REGISTRADO" TO mes
                  DO aviso WITH mes
                  LOOP
               ELSE
                  STORE codven TO wvendedor
                  STORE comven   TO wcomision
               ENDIF
            ENDIF
            STORE .F. TO viendoven
         ENDDO
         
         @ 2,50 GET wcomision PICTURE "##.##"
         READ
         
         @ 2,62 GET welaborado
         READ
         @ 2,78 GET wlista PICTURE "#" RANGE 1,3
         READ
         STORE STR(wlista,1) TO wlista
         
         STORE "CONFORME ? (S/N)" TO tex
         STORE "SN" TO wch
         DO pregunta
         IF wch = "N"
            LOOP
         ENDIF
         SELECT 5
         REPLACE cliente WITH wcliente
         REPLACE vendedor WITH wvendedor
         REPLACE comven   WITH wcomision
         REPLACE elaborado WITH welaborado
         REPLACE lista WITH wlista
         STORE .T. TO wflagela
      ENDIF
      IF resp = "C"
         STORE lista TO wlista
      ENDIF
   ENDIF
   SELECT 5
   IF wtipodoc = "PRE"
      STORE "INGRESE EL Nro. DE LICITACION:" TO mes
      DO mensaje WITH mes
      @ 23,55 GET wreferencia
      READ
      REPLACE referencia WITH wreferencia
      REPLACE refcli     WITH wreferencia
   ENDIF
   STORE referencia TO wrefiere
   STORE "PVP"+wlista TO wlista
   STORE .T. TO actualiza
   DO WHILE actualiza
      STORE 100 TO wline
      STORE 0 TO pagina
      STORE 0 TO wmontodoc
      STORE 0 TO WIVA
      STORE 0 TO WMONTOIVA
      SELECT 6
      FIND &wnumero2
      DO WHILE .NOT. EOF() .AND. numero = wnumero2
         STORE wline + 1 TO wline
         IF wline >=17
            STORE 6 TO wcleaner
            STORE pagina + 1 TO pagina
            IF pagina > 1
               STORE "OPRIMA <ENTER> PARA CONTINUAR" TO mes
               DO aviso WITH mes
            ENDIF
            DO WHILE wcleaner <=16
               @ wcleaner,0 SAY "|       |                          |         |             |     |             |"
               STORE wcleaner + 1 TO wcleaner
            ENDDO
            STORE 6 TO wline
         ENDIF
         @ wline,1 SAY renglon
         @ wline,9 SAY item
         @ wline,36 SAY cantidad PICTURE "######.##"
         @ wline,48 SAY precio   PICTURE "########.##"
         @ wline,60 SAY descuento PICTURE "##.##"
         STORE (cantidad*precio) - ((cantidad*precio)*(descuento/100)) TO wtotal
         @ wline,68 SAY wtotal PICTURE "########.##"
         STORE wmontodoc + wtotal TO wmontodoc
         STORE WMONTODOC*.165 TO WIVA
         STORE WMONTODOC+WIVA TO WMONTOIVA
         *STORE WMONTOIVA TO WMONTODOC
         SELECT 6
         SKIP
      ENDDO
      SELECT 5
      REPLACE monto WITH WMONTODOC
      REPLACE IVA WITH WIVA
      REPLACE MONTOIVA WITH WMONTOIVA
      @ 20,0
      @ 21,0
      @ 22,0
      
      STORE SPACE(5) TO wrenglon
      STORE SPACE(20) TO witem
      STORE .T. TO veritem
      DO WHILE veritem
         SELECT 6
         @ 18,9  SAY SPACE(20)
         @ 18,30 SAY SPACE(5)
         @ 18,36 SAY SPACE(9)
         @ 18,48 SAY SPACE(11)
         @ 18,60 SAY SPACE(5)
         @ 18,68 SAY SPACE(11)
         @ 18,68 SAY wmontodoc PICTURE "########.##"
         
         STORE "INGRESE EL CODIGO DE RENGLON A PROCESAR, OPRIMA <ESC> PARA SALIR" TO mes
         DO mensaje WITH mes
         @ 18,1 GET wrenglon
         READ
         IF wrenglon = SPACE(5) .OR. READKEY() = 12 .OR. READKEY() = 268
            STORE .F. TO veritem
            STORE .F. TO actualiza
            LOOP
         ENDIF
         IF SUBSTR(wnumero2,1,3) = "FAC" .AND. wrefiere <> SPACE(23)
            STORE "USTED NO PUEDE ALTERAR LA FACTURA, REMITASE AL LA NOTA No. "+SUBSTR(wrefiere,4,7) TO mes
            DO aviso WITH mes
            STORE .F. TO pres
            LOOP
         ENDIF
         
         STORE wnumero2+wrenglon TO wclave
         SELECT 6
         FIND &wclave
         IF EOF()
            STORE "RENGLON NO REGISTRADO EN "+wdocdes+", INGRESAR ? (S/N)" TO tex
            STORE "SN" TO wch
            DO pregunta
            IF wch = "N"
               STORE .F. TO veritem
               LOOP
            ENDIF
            STORE "ARTIC./SERV. A PROCESAR. (?=VER ART.), (\=VER SERV.), (<ESC>=SALIR)" TO mes
            DO mensaje WITH mes
            @ 18,9 GET witem
            READ
            IF witem = SPACE(20) .OR. READKEY() = 12 .OR. READKEY() = 268
               STORE .F. TO veritem
               STORE .F. TO actualiza
               LOOP
            ENDIF
            IF witem = "?"+SPACE(19)
               SELECT 2
               GO TOP
               SAVE SCRE TO s99
               DO facwinar
               SELECT 6
               RESTORE SCRE FROM s99
               LOOP
            ENDIF
            IF witem = "\"+SPACE(19)
               SELECT 4
               SAVE SCRE TO s99
               DO fac0104
               STORE codser TO witem
               SELECT 6
               RESTORE SCRE FROM s99
               LOOP
            ENDIF
            IF SUBSTR(witem,1,1) = "\"
               SELECT 4
            ELSE
               SELECT 2
            ENDIF
            FIND &witem
            IF EOF()
               STORE "CODIGO NO REGISTRADO EN BASE DE DATOS. <ENTER>" TO mes
               DO aviso WITH mes
               LOOP
            ENDIF
            IF SUBSTR(witem,1,1) = "\"
               STORE desser TO wdescri
               STORE unimed TO wunimed
               STORE &wlista TO wprecio
               STORE 9999999999 TO wuniexi
            ELSE
               STORE descri TO wdescri
               STORE unimed TO wunimed
               STORE &wlista TO wprecio
               STORE uniexi TO wuniexi
            ENDIF
            @ 20,1 SAY "DESCRIPCION :"+wdescri
            @ 21,1 SAY "UNID./ MED. :"+wunimed
            @ 22,1 SAY "PRECIO LISTA:"+STR(wprecio,12,2)
            STORE 0 TO wcantidad
            STORE 0 TO wdescuento
            STORE SPACE(5) TO wlote
            STORE .T. TO wflagcant
            DO WHILE wflagcant
               @ 18,36 GET wcantidad PICTURE "######.##"
               READ
               IF wcantidad > 0
                  STORE .F. TO wflagcant
               ENDIF
               IF wcantidad > wuniexi
                  STORE "ADVERTENCIA: EXISTENCIAS NO CUBREN UNIDADES. <ENTER>" TO mes
                  DO aviso WITH mes
               ENDIF
            ENDDO
            @ 18,48 GET wprecio   PICTURE "########.##"
            READ
            @ 18,60 GET wdescuento PICTURE "##.##"
            READ
            STORE (wcantidad*wprecio) - ((wcantidad*wprecio)*(wdescuento/100)) TO wtotal
            @ 18,68 SAY wtotal PICTURE "########.##"
            STORE "CONFORME ? (S/N)" TO tex
            STORE "SN" TO wch
            DO pregunta
            IF wch = "N"
               LOOP
            ENDIF
            SELECT 6
            APPEND BLANK
            REPLACE numero WITH wnumero2
            REPLACE renglon WITH wrenglon
            REPLACE item WITH witem
            REPLACE cantidad WITH wcantidad
            REPLACE precio WITH wprecio
            REPLACE descuento WITH wdescuento
         ELSE
            STORE item TO witem
            STORE cantidad  TO wcantidad
            STORE precio    TO wprecio
            STORE descuento TO wdescuento
            *  STORE LOTE TO WLOTE
            IF SUBSTR(witem,1,1) = "\"
               SELECT 4
            ELSE
               SELECT 2
            ENDIF
            FIND &witem
            IF EOF()
               STORE "CODIGO NO REGISTRADO EN MAESTRO DE ARTICULOS. <ENTER>" TO mes
               DO aviso WITH mes
               LOOP
            ENDIF
            IF SUBSTR(witem,1,1) = "\"
               STORE 9999999999 TO wuniexi
            ELSE
               STORE uniexi TO wuniexi
            ENDIF
            
            SELECT 6
            @ 18,9 SAY witem
            @ 18,36 SAY wcantidad PICTURE "######.##"
            @ 18,48 SAY wprecio   PICTURE "########.##"
            @ 18,60 SAY wdescuento PICTURE "##.##"
            STORE (wcantidad*wprecio) - ((wcantidad*wprecio)*(wdescuento/100)) TO wtotal
            @ 18,68 SAY wtotal PICTURE "########.##"
            STORE "OPCIONES: (M)ODIFICAR, (E)LIMINAR, (S)ALIR" TO tex
            STORE "SME" TO wch
            DO pregunta
            STORE wch TO wsme
            IF wsme = "S"
               STORE .F. TO veritem
               LOOP
            ENDIF
            IF wsme = "E"
               STORE "ESTA USTED SEGURO ? (S/N)" TO tex
               STORE "NS" TO wch
               DO pregunta
               IF wch = "S"
                  DELETE
                  STORE .F. TO veritem
                  LOOP
               ENDIF
            ENDIF
            IF wsme = "M"
               STORE .T. TO wflagcant
               STORE wcantidad TO wlastcant
               DO WHILE wflagcant
                  @ 18,36 GET wcantidad PICTURE "######.##"
                  READ
                  IF wcantidad > 0
                     STORE .F. TO wflagcant
                  ENDIF
                  IF (wcantidad-wlastcant) > wuniexi
                     STORE "ADVERTENCIA: EXISTENCIAS NO CUBREN UNIDADES A FACTURAR. <ENTER>" TO mes
                     DO aviso WITH mes
                  ENDIF
               ENDDO
               @ 18,48 GET wprecio   PICTURE "########.##"
               READ
               @ 18,60 GET wdescuento PICTURE "##.##"
               READ
               STORE (wcantidad*wprecio) - ((wcantidad*wprecio)*(wdescuento/100)) TO wtotal
               @ 18,68 SAY wtotal PICTURE "########.##"
               STORE "CONFORME ? (S/N)" TO tex
               STORE "SN" TO wch
               DO pregunta
               IF wch = "S"
                  REPLACE cantidad WITH wcantidad
                  REPLACE precio WITH wprecio
                  REPLACE descuento WITH wdescuento
               ENDIF
            ENDIF
         ENDIF
         STORE .F. TO veritem
         LOOP
      ENDDO
   ENDDO
ENDDO
IF wflagela
   SELECT 5
   SAVE SCRE TO ejc
   @ 15,38 CLEAR TO 21,79
   @ 15,38 TO 21,79
   @ 15,55 SAY " OBSERVACIONES "
   @ 16,39 GET coment1
   @ 17,39 GET coment2
   @ 18,39 GET coment3
   @ 19,39 GET coment4
   @ 20,39 GET coment5
   READ
   RESTORE SCRE FROM ejc
   DO facprodc
ENDIF
CLOSE DATA
CLOSE INDEX
RETURN

*: EOF: FACELADC.PRG
