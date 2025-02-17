SELECT 2
USE INVART INDEX INVART
SELECT 3
USE INVTRA INDEX INVTRA3,INVTRA2,INVTRA1
SELECT 4
USE INVLOT INDEX INVLOT
SELECT 5
USE COMDCGE INDEX COMDCGE
SELECT 6
USE COMDCDE INDEX COMDCDE
SELECT 9
USE SYSDATE

STORE .T. TO REVERSA
DO WHILE REVERSA
   SELECT 3
   FIND &WNUMERO2
   IF EOF()
      STORE .F. TO REVERSA
      LOOP
   ENDIF
   IF ORIGEN <> "COM"
      LOOP
   ENDIF
   STORE CODIGO TO WCODIGO
   STORE UNIDADES TO WUNIDADES
   STORE COSTO TO WCOSTO
   DELETE
   IF WCODIGO = SPACE(20)
      STORE "ERROR, CODIGO DE ARTICULO EN BLANCO. OPRIMA ENTER" TO MES
      DO AVISO WITH MES
      LOOP
   ENDIF
   SELECT 2
   FIND &WCODIGO
   IF EOF()
      STORE "ERROR, CODIGO DE ARTICULO NO EXISTE EN MAESTRO. OPRIMA ENTER" TO MES
      DO AVISO WITH MES
      LOOP
   ENDIF
   IF UNIEXI - WUNIDADES <> 0
      REPLACE COSEXI WITH ((COSEXI*UNIEXI)-(WCOSTO)) / (UNIEXI-WUNIDADES)
   ELSE
      REPLACE COSEXI WITH 0
   ENDIF
   REPLACE UNIEXI WITH UNIEXI - WUNIDADES
ENDDO

SELECT 6
FIND &WNUMERO2
IF EOF()
   CLOSE DATA
   CLOSE INDEX
   RETURN
ENDIF
DO WHILE .NOT. EOF() .AND. NUMERO = WNUMERO2
   IF SUBSTR(ITEM,1,1) = "\"
      SKIP
      LOOP
   ENDIF
   STORE ITEM TO WITEM, WCODIGO
   STORE CANTIDAD TO WCANTIDAD
   STORE PRECIO TO WPRECIO
   STORE DESCUENTO TO WDESCUENTO
   IF WITEM = SPACE(20)
      STORE "ERROR, CODIGO DE ARTICULO EN BLANCO (2). OPRIMA ENTER" TO MES
      DO AVISO WITH MES
      SKIP
      LOOP
   ENDIF
   SELECT 2
   FIND &WITEM
   IF EOF()
      STORE "ERROR, ARTICULO "+RTRIM(WITEM)+" DE FACTURA NO EXISTE EN MAESTRO.<ENTER>" TO MES
      DO AVISO WITH MES
      SELECT 6
      SKIP
      LOOP
   ENDIF
   STORE (COSEXI*UNIEXI) TO WCOSTACT
   STORE (WPRECIO*WCANTIDAD) - ((WPRECIO*WCANTIDAD*WDESCUENTO)/100) TO WCOSTFAC
   IF UNIEXI - WCANTIDAD > 0
      REPLACE COSEXI WITH (WCOSTACT+WCOSTFAC)/(UNIEXI+WCANTIDAD)
   ELSE
      REPLACE COSEXI WITH 0
   ENDIF
   REPLACE UNIEXI WITH UNIEXI + WCANTIDAD
   SELECT 3
   append blank
   REPLACE SERIAL WITH SYSDATE->SERIAL+1
   replace codigo with witem
   replace fecha with WFECACT
   replace operacion with "EN"
   replace referencia with wnumero2
   replace origen with "COM"
   REPLACE PROCLI WITH COMDCGE->CLIENTE
   REPLACE UNIDADES WITH WCANTIDAD
   REPLACE COSTO WITH (WCANTIDAD*WPRECIO) - ((WCANTIDAD*WPRECIO*WDESCUENTO)/100)
   FLUSH
   IF INVART->LOTE = "S"
      DO COMACTLO
   ENDIF
   SELECT 9
   USE SYSDATE
   REPLACE SERIAL WITH SERIAL+1
   FLUSH
   SELECT 6
   SKIP
ENDDO
CLOSE DATA
CLOSE INDEX
RETURN

