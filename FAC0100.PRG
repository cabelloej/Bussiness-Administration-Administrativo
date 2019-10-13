
SET TALK OFF
SET ECHO OFF
***
** ON ERROR DO ERRCON
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
   @ 08,54   prompt "GRUPOS DE CLIENTES      "
   @ 09,54   prompt "CLIENTES                "
   @ 10,54   prompt "VENDEDORES              "
   @ 11,54   prompt "SERVICIOS / OTROS       "
   save scre to s3
   menu to wsubopcion3
   do case
      case wsubopcion3= 1
           do FAC0101
      case wsubopcion3= 2
           do FAC0102
      case wsubopcion3= 3
           do FAC0103
      case wsubopcion3= 4
           do FAC0104
      case wsubopcion3= 0
           store .f. to subve3
   endcase
   restore scre from s3
enddo

