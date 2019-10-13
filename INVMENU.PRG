SET TALK OFF
SET ECHO OFF
SET PROC TO INVPROC
SELECT 9
USE SYSDATE
IF FALLAINV = 1
   DO INDICES
   SELECT 9
   REPLACE FALLAINV WITH 0
   CLOSE DATA
   CLOSE INDEX
   RETURN TO MASTER
ELSE
   REPLACE FALLAINV WITH 1
ENDIF
SELECT 1
USE INVLIN INDEX INVLIN
SELECT 2
USE INVART INDEX INVART
SELECT 3
USE INVTRA INDEX INVTRA1,INVTRA2,INVTRA3
SELECT 4
USE INVLOT INDEX INVLOT
SELECT 8
USE INVLOTTR INDEX INVLOTTR
store .t. to subve
do while subve
   set color to g/n
   STORE T7 TO MES
   DO MENSAJE WITH MES
   @ 08,27  prompt "FICHEROS                 "
   @ 09,27  prompt "INFORMES                 "
   @ 10,27  prompt "PROCESOS                 "
   @ 11,27  prompt "MANTENIMIENTO MODULO     "
   save scre to s2
   menu to wsubopcion
   do case
      case wsubopcion = 1
           do INV0100
      case wsubopcion = 2
           do INV0200
      case wsubopcion = 3
           do INV0300
      case wsubopcion = 4
           do INV0400
      case wsubopcion = 0
           SELECT 9
           REPLACE FALLAINV WITH 0
           CLOSE DATA
           CLOSE INDEX
           store .f. to subve
   endcase
   restore scre from s2
enddo

