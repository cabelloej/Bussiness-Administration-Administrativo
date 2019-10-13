SET TALK OFF
SET ECHO OFF
***
* ON ERROR DO ERRCON
*STORE SPACE(40) TO QQWW
*STORE "CONSTRUCTORA LA ESTANCIA DORADA, C.A.   " TO T3
*STORE 0 TO PPP
*DO INFORMA
*if qqww<>t3
*    store 1 to ppp
*endif
*if ppp = 1
*   store "ERROR DE INSTALACION" to mes
*   do aviso with mes
*   close all
*   quit
*endif
***
store .t. to subve3
do while subve3
   set color to g/n
   STORE T7 TO MES
   DO MENSAJE WITH MES
   @ 8,54   prompt "LINEAS DE ARTICULOS     "
   @ 9,54   prompt "ARTICULOS               "
   @ 10,54  prompt "PRECIOS DE VENTA        "
   @ 11,54  prompt "COSTOS UNITARIOS        "
   @ 12,54  prompt "MOVIMIENTOS DE ARTICULOS"
   @ 13,54  prompt "RESUMEN DE EXISTENCIAS  "
   @ 14,54  prompt "LOTES DE ARTICULOS      "
*  @ 15,54  prompt "DETALLE DE INVENTARIO   "

   save scre to s3
   menu to wsubopcion3
   do case
      case wsubopcion3= 1
           do INV0201
      case wsubopcion3= 2
           do INV0202
      case wsubopcion3= 3
           do INV0203
      case wsubopcion3= 4
           do INV0204
      case wsubopcion3= 5
           do INV0205
      case wsubopcion3= 6
           do INV0206
      case wsubopcion3= 7
           do INV0207
*     case wsubopcion3= 8
*          do INV0208
      case wsubopcion3= 0
           store .f. to subve3
   endcase
   restore scre from s3
enddo

