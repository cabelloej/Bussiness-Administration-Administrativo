SELECT 5
USE facdcge INDEX facdcge
SELECT 6
USE facdcde INDEX facdcde
STORE .T. TO presupuesto
SELECT 5
FIND &wnumero2
IF EOF()
   STORE "ERROR, DESAPARECIO EL DOCUMENTO A IMPRIMIR" TO mes
   DO aviso WITH mes
   RETURN
ENDIF
STORE referencia TO wreferencia
STORE refcli     TO wrefcli
STORE cliente    TO wcodcli
STORE vendedor   TO wcodven
STORE elaborado  TO welaborado
STORE vence      TO wvence
STORE cancelado  TO wcancelado
STORE IVA        TO WIVA
STORE MONTOIVA   TO WMONTOIVA
IF SUBSTR(wnumero2,1,3) = "FAC" .OR. SUBSTR(wnumero2,1,3) = "PRE"
   STORE wvence - welaborado TO wdias
   IF welaborado = wvence
      STORE "CONTADO" TO wcondicion
   ELSE
      STORE "CREDITO A "+STR(wdias,3)+" DIAS" TO wcondicion
   ENDIF
ELSE
   STORE 0 TO wdias
   STORE SPACE(10) TO wcondicion
ENDIF
SELECT 1
USE faccli INDEX faccli
FIND &wcodcli
IF EOF()
   STORE "NO REGISTRADO" TO wdescli
   STORE SPACE(20) TO wdircli1
   STORE SPACE(20) TO wdircli2
ELSE
   STORE descli TO wdescli
   STORE descli2 TO wdescli2
   STORE descli3 TO wdescli3
   STORE dircli1 TO wdircli1
   STORE dircli2 TO wdircli2
ENDIF
SELECT 1
USE facven INDEX facven
FIND &wcodven
IF EOF()
   STORE "NO REGISTRADO" TO wdesven
ELSE
   STORE desven TO wdesven
ENDIF
SELECT 6
FIND &wnumero2
IF EOF()
   STORE "ERROR, DOCUMENTO SIN DETALLE" TO mes
   DO aviso WITH mes
   RETURN
ENDIF
STORE .T. TO actualiza
STORE 100 TO wline
STORE 0 TO pagina
STORE 0 TO wmontodoc
SET DEVI TO PRINT
DO WHILE .NOT. EOF() .AND. numero = wnumero2
   STORE wline + 1 TO wline
   IF wline >=48
      STORE pagina + 1 TO pagina
      IF pagina <> 1
         STORE wline - 1 TO wline
         DO WHILE wline < 55
            STORE wline + 1 TO wline
            @ wline,0 SAY "|     |           |                                        |                   |                 |                   |               |"
         ENDDO
         @ 56,0 SAY "+-----+-----------+----------------------------------------+-------------------+-----------------+-------------------+---------------+"
         * @ 57,00 say qqww
         @ 57,60 SAY "SUBTOTAL    D O C U M E N T O   Bs.  |                                   |"
         @ 57,60 SAY "SUBTOTAL    D O C U M E N T O   Bs.  |                                   |"
         @ 57,120 SAY STR(wmontodoc,12,2)
         @ 57,120 SAY STR(wmontodoc,12,2)
         @ 58,97 SAY "+-----------------------------------+"
         @ 58,97 SAY "+-----------------------------------+"
         @ 59,01 SAY "RECIBIDO POR:______________________________"
         @ 61,01 SAY "FECHA:_____________________________________"
         @ 61,60 SAY "_____________________________"
         @ 62,60 SAY "    FIRMA Y SELLO CLIENTE    "
      ENDIF
      @ 01,00 SAY CHR(14)+QQWW
      @ 02,00 SAY "AV. MUNICIPAL, C.C. REGINA P.B. # 19                 "
      @ 03,00 SAY "PUERTO LA CRUZ, Edo. ANZOATEGUI                      "
      @ 04,00 SAY "Telefonos: 081-631143, 082-251615                    "
      @ 05,00 SAY "R.I.F.                                               "
      @ 07,00 SAY CHR(18)+" "
      @ 08,0 SAY "+---------------------------------------------+ +------------------------------+"
      @ 09,0 SAY "|SE¥OR(ES):                                   | |                              |"
      @ 09,11 SAY wdescli
      @ 09,52 SAY wdocdes
      @ 09,52 SAY wdocdes
      @ 10,0 SAY "|                                             | |   No.                        |"
      @ 10,11 SAY wdescli2
      @ 10,55 SAY wnumero
      @ 11,0 SAY "|                                             | |------------------------------|"
      @ 11,11 SAY wdescli3
      @ 12,0 SAY "|---------------------------------------------| |   FECHA:                     |"
      @ 12,64 SAY DTOC(welaborado)
      @ 13,0 SAY "|DIRECCION:                                   | |------------------------------|"
      @ 13,11 SAY wdircli1
      @ 14,0 SAY "|                                             | |   REFERENCIA DEL DOCUMENTO   |"
      @ 14,11 SAY wdircli2
      IF SUBSTR(wreferencia,1,3) = "PRE"
         STORE "PRESUPUESTO No." TO wdesref
      ELSE
         IF SUBSTR(wreferencia,1,3) = "ORD"
            STORE "O/C " TO wdesref
         ELSE
            IF SUBSTR(wreferencia,1,3) = "NOT"
               STORE "NOT.ENTREG.No." TO wdesref
            ELSE
               IF SUBSTR(wreferencia,1,3) <> SPACE(3)
                  STORE "REQ." TO wdesref
               ELSE
                  STORE SPACE(10) TO wdesref
               ENDIF
            ENDIF
         ENDIF
      ENDIF
      @ 15,0 SAY "|---------------------------------------------| |                              |"
      IF wtipodoc = "PRE"
         IF pagina = 1
            STORE "XXX"+wreferencia TO wreferencia
         ENDIF
      ENDIF
      IF SUBSTR(wrefcli,1,3) <> "ORD"
         IF pagina = 1
            STORE "XXX"+wrefcli     TO wrefcli
         ENDIF
      ENDIF
      @ 15,49 SAY wdesref+SUBSTR(wreferencia,4,25)
      @ 16,0 SAY "|REF.CLTE.:                                   | |------------------------------|"
      IF wtipodoc = "NOT" .OR. wtipodoc = "FAC"
         @ 16,11 SAY "O/C "+SUBSTR(wrefcli,4,25)
      ELSE
         @ 16,11 SAY "REQ."+SUBSTR(wrefcli,4,25)
      ENDIF
      @ 17,0 SAY "|---------------------------------------------| |   CONDICIONES DE PAGO        |"
      @ 18,0 SAY "|VENDEDOR :                                   | |                              |"
      @ 18,11 SAY wdesven
      @ 18,52 SAY wcondicion
      @ 19,0 SAY "+---------------------------------------------+ +------------------------------+"
      @ 20,0 SAY CHR(15)+"."
      @ 20,0 SAY "+-----+-----------+----------------------------------------+-------------------+-----------------+-------------------+-----------------+"
      @ 21,0 SAY "|RENG.|CANTIDAD   | DESCRIPCION                            |  PRECIO UNITARIO  |      TOTAL      |   DESCUENTO (%)   |  TOTAL RENGLON  |"
      @ 22,0 SAY "+-----+-----------+----------------------------------------+-------------------+-----------------+-------------------+-----------------+"
      STORE 23 TO wline
   ENDIF
   @ wline,0 SAY "|     |           |                                        |                   |                 |                   |                 |"
   @ wline,1 SAY renglon
   @ wline,8 SAY STR(cantidad,10,2)
   STORE item TO wclaveitem
   IF SUBSTR(wclaveitem,1,1) <> "\"
      SELECT 1
      USE invart INDEX invart
      FIND &wclaveitem
      IF EOF()
         STORE "NO DEFINIDO EN MAESTRO DE INV." TO wartdes
      ELSE
         STORE descri TO wartdes
         STORE descri2 TO wartdes2
         STORE descri3 TO wartdes3
         STORE descri4 TO wartdes4
      ENDIF
   ELSE
      SELECT 1
      USE facser INDEX facser
      FIND &wclaveitem
      IF EOF()
         STORE "NO DEFINIDO EN MAESTRO DE SER." TO wartdes
      ELSE
         STORE desser TO wartdes
         STORE SPACE(40) TO wartdes2
         STORE SPACE(40) TO wartdes3
         STORE SPACE(40) TO wartdes4
      ENDIF
   ENDIF
   SELECT 6
   @ wline,19 SAY wartdes
   IF wartdes2 <> SPACE(40)
      STORE wline+1 TO wline
      @ wline,0 SAY "|     |           |                                        |                   |                 |                   |                 |"
      @ wline,19 SAY wartdes2
   ENDIF
   IF wartdes3 <> SPACE(40)
      STORE wline+1 TO wline
      @ wline,0 SAY "|     |           |                                        |                   |                 |                   |                 |"
      @ wline,19 SAY wartdes3
   ENDIF
   IF wartdes4 <> SPACE(40)
      STORE wline+1 TO wline
      @ wline,0 SAY "|     |           |                                        |                   |                 |                   |                 |"
      @ wline,19 SAY wartdes4
   ENDIF
   IF SUBSTR(wnumero2,1,3) <> "NOT"
      @ wline,67 SAY STR(precio,12,2)
      @ wline,85 SAY STR((precio*cantidad),12,2)
      @ wline,112 SAY STR(descuento,5,2)
      STORE (cantidad*precio) - ((cantidad*precio)*(descuento/100)) TO wtotal
      @ wline,121 SAY STR(wtotal,12,2)
      STORE wmontodoc + wtotal TO wmontodoc

   ENDIF
   SELECT 6
   SKIP
ENDDO
DO WHILE wline < 48
   STORE wline + 1 TO wline
   @ wline,0 SAY "|     |           |                                        |                   |                 |                   |                 |"
ENDDO
SELECT 5
IF SUBSTR(wnumero2,1,3) <> "NOT"
        @ wline+1,0 SAY "|--------------------------------------------------------------------------------------------------------------------------------------|"
        @ wline+2,0 SAY "|      OBSERVACIONES:                                      |          T O T A L    D O C U M E N T O   Bs:|                            |"
        @ WLINE+2,120 SAY STR(WMONTODOC,12,2)
        @ WLINE+2,120 SAY STR(WMONTODOC,12,2)
        @ wline+3,0 SAY "|                                                          |                                              |----------------------------|"
        @ wline+3,7 SAY coment1
        @ wline+4,0 SAY "|                                                          |                                 16.5%  ICSVM |                            |"
        @ wline+4,7 SAY coment2
        STORE wmontodoc*16.5/100 TO WIVA
        @ WLINE+4,120 SAY STR(WIVA,12,2)
        @ WLINE+4,120 SAY STR(WIVA,12,2)
        @ wline+5,0 SAY "|                                                          |                                              |----------------------------|"
        @ WLINE+5,7 SAY COMENT3
        @ wline+6,0 SAY "|                                                          |          T O T A L   A   C A N C E L A R  Bs:|                            |"
        @ WLINE+6,7 SAY COMENT4
        STORE WMONTODOC + WIVA TO WMONTOIVA
        @ WLINE+6,120 SAY STR(WMONTOIVA,12,2)
        @ WLINE+6,120 SAY STR(WMONTOIVA,12,2)
       *@ WLINE+6,120 SAY STR(WMONTODOC,12,2)
       *@ WLINE+6,120 SAY STR(WMONTODOC,12,2)

        @ 55,0 SAY      "|                                                          |                                              |----------------------------|"
        @ 55,7 SAY COMENT5
        @ 56,0 SAY      "+--------------------------------------------------------------------------------------------------------------------------------------+"
        @ 57,0 SAY      "| SON :                                                                                                                                |"

        @ 58,0 SAY      "+--------------------------------------------------------------------------------------------------------------------------------------+"
        @ 59,01 SAY "RECIBIDO POR:______________________________"
        @ 60,80 SAY "_____________________________"
        @ 61,01 SAY "FECHA:_____________________________________"
        @ 61,80 SAY "    FIRMA Y SELLO "
        *@ 62,0 SAY "SISTEMA REALIZADO POR: MERCASISTEMAS, C.A."
 ELSE
        @ wline+1,0 SAY "|--------------------------------------------------------------------------------------------------------------------------------------|"
        @ wline+2,0 SAY "|      OBSERVACIONES:                                      |                                                                           |"
        @ wline+3,0 SAY "|                                                          |                                                                           |"
        @ wline+3,7 SAY coment1
        @ wline+4,0 SAY "|                                                          |                                                                           |"
        @ wline+4,7 SAY coment2
        @ wline+5,0 SAY "|                                                          |                                                                           |"
        @ WLINE+5,7 SAY COMENT3
        @ wline+6,0 SAY "|                                                          |                                                                           |"
        @ WLINE+6,7 SAY COMENT4
        @ 55,0 SAY      "|                                                          |                                                                           |"
        @ 55,7 SAY COMENT5
        @ 56,0 SAY      "+--------------------------------------------------------------------------------------------------------------------------------------+"
        @ 57,0 SAY      "|                                                                                                                                      |"
        @ 58,0 SAY      "+--------------------------------------------------------------------------------------------------------------------------------------+"
        @ 59,01 SAY "RECIBIDO POR:______________________________"
        @ 60,80 SAY "_____________________________"
        @ 61,01 SAY "FECHA:_____________________________________"
        @ 61,80 SAY "    FIRMA Y SELLO "
        *@ 62,0 SAY "SISTEMA REALIZADO POR: MERCASISTEMAS, C.A."


ENDIF

EJECT
SET DEVI TO SCRE
CLOSE DATA
CLOSE INDEX
RETURN
*: EOF: FACIMPDC.PRG
