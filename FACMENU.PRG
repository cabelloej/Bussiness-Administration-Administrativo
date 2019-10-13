
SET TALK OFF
SET ECHO OFF
SET PROC TO FACPROC
SELECT 9
USE SYSDATE
IF FALLAFAC = 1
   DO INDICES
   SELECT 9
   REPLACE FALLAFAC WITH 0
   CLOSE DATA
   CLOSE INDEX
   RETURN TO MASTER
ELSE
   REPLACE FALLAFAC WITH 1
ENDIF
CLOSE DATA
CLOSE INDEX
store .t. to subve
do while subve
   CLOSE DATA
   CLOSE INDEX
   set color to g/n
   STORE T7 TO MES
   DO MENSAJE WITH MES
   @ 08,27  prompt "FICHEROS                 "
   @ 09,27  prompt "PRESUPUESTAR             "
   @ 10,27  prompt "CARGAR ORDENES DE COMPRA "
   @ 11,27  prompt "NOTAS DE ENTREGA         "
   @ 12,27  prompt "FACTURAS                 "
   @ 13,27  prompt "CUENTAS POR COBRAR       "
   @ 14,27  prompt "INFORMES                 "
   @ 15,27  prompt "PROCESOS                 "
   @ 16,27  prompt "MANTENIMIENTO MODULO     "
   save scre to s2
   menu to wsubopcion
   do case
      case wsubopcion = 1
           do FAC0100
      case wsubopcion = 2
           DO FAC0200
      case wsubopcion= 3
           select 9
           USE SYSDATE
           store LTRIM(str(facseriord+1,20)) to wnumero
           STORE REPLICATE("0",20-LEN(WNUMERO))+WNUMERO TO WNUMERO
           STORE "ORD" TO WTIPODOC
           STORE "ORDEN DE COMPRA" TO WDOCDES
           STORE .F. TO WFLAGELA
           do FACELADC
           select 9
           USE SYSDATE
           if WFLAGELA
              replace facseriord with val(wnumero)
           endif
           use
      case wsubopcion= 4
           DO FAC0400
      case wsubopcion= 5
           DO FAC0500
      case wsubopcion= 6
           do FAC0600
      case wsubopcion = 7
           do FAC0700
      case wsubopcion = 8
           do FAC0800
      case wsubopcion = 9
           do FAC0900
      case wsubopcion = 0
           SELECT 9
           USE SYSDATE
           REPLACE FALLAFAC WITH 0
           CLOSE DATA
           CLOSE INDEX
           store .f. to subve
   endcase
   restore scre from s2
enddo

