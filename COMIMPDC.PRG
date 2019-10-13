SELECT 5
USE COMDCGE INDEX COMDCGE
SELECT 6
USE COMDCDE INDEX COMDCDE
STORE .T. TO PRESUPUESTO
   SELECT 5
   FIND &WNUMERO2
   IF EOF()
      STORE "ERROR, DESAPARECIO EL DOCUMENTO A IMPRIMIR" TO MES
      DO AVISO WITH MES
      RETURN
   ENDIF
   STORE REFERENCIA TO WREFERENCIA
   STORE CLIENTE   TO WCODCLI
   STORE ELABORADO TO WELABORADO
   STORE VENCE     TO WVENCE
   STORE CANCELADO TO WCANCELADO
*  STORE ESTATUS   TO WESTATUS
   IF SUBSTR(WNUMERO2,1,3) = "FAC"
      STORE WVENCE - WELABORADO TO WDIAS
      IF WELABORADO = WVENCE
         STORE "CONTADO" TO WCONDICION
      ELSE
         STORE "CREDITO A "+STR(WDIAS,3)+" DIAS" TO WCONDICION
      ENDIF
   ELSE
      STORE 0 TO WDIAS
      STORE SPACE(10) TO WCONDICION
   ENDIF
   SELECT 1
   USE COMPRO INDEX COMPRO
   FIND &WCODCLI
   IF EOF()
      STORE "NO REGISTRADO" TO WDESCLI
      STORE SPACE(20) TO WDIRCLI1
      STORE SPACE(20) TO WDIRCLI2
   ELSE
      STORE DESCLI TO WDESCLI
      STORE DIRCLI1 TO WDIRCLI1
      STORE DIRCLI2 TO WDIRCLI2
   ENDIF
   SELECT 6
   FIND &WNUMERO2
   IF EOF()
      STORE "ERROR, DOCUMENTO SIN DETALLE" TO MES
      DO AVISO WITH MES
      RETURN
   ENDIF
   STORE .T. TO ACTUALIZA
   STORE 100 TO WLINE
   STORE 0 TO PAGINA
   STORE 0 TO WMONTODOC
   SET DEVI TO PRINT
   DO WHILE .NOT. EOF() .AND. NUMERO = WNUMERO2
      STORE WLINE + 1 TO WLINE
      IF WLINE >=55
         STORE PAGINA + 1 TO PAGINA
         @ 07,00 SAY CHR(18)+" "
         @ 08,0 SAY "+---------------------------------------------+ +------------------------------+"
         @ 09,0 SAY "|SE¥OR(ES):                                   | |                              |"
         @ 09,11 SAY wdescli
         @ 09,52 SAY WDOCDES
         @ 09,52 SAY WDOCDES
         @ 10,0 SAY "|---------------------------------------------| |   No.                        |"
         @ 10,64 SAY WNUMERO
         @ 11,0 SAY "|DIRECCION:                                   | |                              |"
         @ 11,11 SAY WDIRCLI1
         @ 12,0 SAY "|                                             | |   FECHA:                     |"
         @ 12,11 SAY WDIRCLI2
         @ 12,64 SAY DTOC(WELABORADO)
         @ 13,0 SAY "|-------------------+-------------------------| |------------------------------|"
         @ 14,0 SAY "|REFERENCIA CLIENTE |  CONDICIONES DE PAGO    | |   REFERENCIA DEL DOCUMENTO   |"
         @ 15,0 SAY "|                   |                         | |                              |"
         @ 15,23 SAY WCONDICION
         IF SUBSTR(WREFERENCIA,1,3) = "ORD"
            STORE "ORDEN DE COMPRA No." TO WDESREF
         ELSE
            STORE SPACE(10) TO WDESREF
         ENDIF
         @ 15,50 SAY WDESREF+SUBSTR(WREFERENCIA,4,7)
         @ 16,0 SAY "|-------------------|                         | +------------------------------+"
         @ 17,0 SAY "|REFERENCIA NUESTRA |                         |                                 "
         @ 18,0 SAY "|                   |                         |                                 "
         @ 19,0 SAY "+-------------------+-------------------------+                                 "
         @ 20,0 SAY CHR(15)+"."
         @ 20,0 SAY "+-----+-----------+----------------------------------------+-------------------+-----------------+-------------------+---------------+"
         @ 21,0 SAY "|RENG.|CANTIDAD   | DESCRIPCION                            |  PRECIO UNITARIO  |      TOTAL      |   DESCUENTO (%)   | TOTAL RENGLON |"
         @ 22,0 SAY "+-----+-----------+----------------------------------------+-------------------+-----------------+-------------------+---------------+"
         STORE 23 TO WLINE
      ENDIF
      @ WLINE,0 SAY "|     |           |                                        |                   |                 |                   |               |"
      @ WLINE,1 SAY RENGLON
      @ WLINE,8 SAY STR(CANTIDAD,10,2)
      STORE ITEM TO WCLAVEITEM
      SELECT 1
      USE INVART INDEX INVART
      FIND &WCLAVEITEM
      IF EOF()
         STORE "NO DEFINIDO EN MAESTRO DE INV." TO WARTDES
      ELSE
         STORE DESCRI TO WARTDES
         STORE DESCRI2 TO WARTDES2
         STORE DESCRI3 TO WARTDES3
         STORE DESCRI4 TO WARTDES4
      ENDIF
      SELECT 6
      @ WLINE,19 SAY WARTDES
      IF WARTDES2 <> SPACE(25)
         STORE WLINE + 1 TO WLINE
         @ WLINE, 19 SAY WARTDES2
         @ WLINE,0 SAY "|     |           |                                        |                   |                 |                   |               |"
      ENDIF
      IF WARTDES3 <> SPACE(25)
         STORE WLINE + 1 TO WLINE
         @ WLINE, 19 SAY WARTDES3
         @ WLINE,0 SAY "|     |           |                                        |                   |                 |                   |               |"
      ENDIF
      IF WARTDES4 <> SPACE(25)
         STORE WLINE + 1 TO WLINE
         @ WLINE, 19 SAY WARTDES4
         @ WLINE,0 SAY "|     |           |                                        |                   |                 |                   |               |"
      ENDIF
      @ WLINE,67 SAY STR(PRECIO,12,2)
      @ WLINE,85 SAY STR((PRECIO*CANTIDAD),12,2)
      @ WLINE,112 SAY STR(DESCUENTO,5,2)
      STORE (CANTIDAD*PRECIO) - ((CANTIDAD*PRECIO)*(DESCUENTO/100)) TO WTOTAL
      @ WLINE,121 SAY STR(WTOTAL,12,2)
      STORE WMONTODOC + WTOTAL TO WMONTODOC
      SELECT 6
      SKIP
   ENDDO
   DO WHILE WLINE < 55
      STORE WLINE + 1 TO WLINE
      @ WLINE,0 SAY "|     |           |                                        |                   |                 |                   |               |"
   ENDDO
   @ 56,0 SAY "+-----+-----------+----------------------------------------+-------------------+-----------------+-------------------+---------------+"
   @ 57,60 SAY "T O T A L   D O C U M E N T O   Bs. ||                                  ||"
   @ 57,60 SAY "T O T A L   D O C U M E N T O   Bs. ||                                  ||"
   @ 57,120 SAY STR(WMONTODOC,12,2)
   @ 57,120 SAY STR(WMONTODOC,12,2)
   @ 58,60 SAY "                                    ++----------------------------------++"
   @ 58,60 SAY "                                    ++----------------------------------++"
   EJECT
   SET DEVI TO SCRE
   CLOSE DATA
   CLOSE INDEX
RETURN

