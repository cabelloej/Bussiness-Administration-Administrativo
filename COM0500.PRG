SET TALK OFF
SET ECHO OFF
store .t. to subve3
do while subve3
   set color to g/n
   STORE T7 TO MES
   DO MENSAJE WITH MES
   @ 08,54   prompt "FICHEROS                "
   @ 09,54   prompt "DOCUMENTOS              "
   @ 10,54   prompt "PEDIDOS y EXISTENCIAS   "
   @ 11,54   prompt "RESUMEN DE COMPRAS      "
   @ 12,54   prompt "RESUMEN DE CTAS.x PAGAR "
   save scre to s3
   menu to wsubopcion3
   do case
      case wsubopcion3= 1
           do COM0501
      case wsubopcion3= 2
           do COM0502
      case wsubopcion3= 3
           do COM0503
      case wsubopcion3= 4
           do COM0504
      case wsubopcion3= 5
           do COM0505
      case wsubopcion3= 0
           store .f. to subve3
   endcase
   restore scre from s3
enddo

