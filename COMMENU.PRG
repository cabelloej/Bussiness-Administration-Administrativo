
SET TALK OFF
SET ECHO OFF
SET PROC TO COMPROC
SELECT 9
USE SYSDATE
IF FALLACOM = 1
   DO INDICES
   SELECT 9
   REPLACE FALLACOM WITH 0
   CLOSE DATA
   CLOSE INDEX
   RETURN
ELSE
   REPLACE FALLACOM WITH 1
ENDIF
store .t. to subve
do while subve
   CLOSE DATA
   CLOSE INDEX
   set color to g/n
   STORE T7 TO MES
   DO MENSAJE WITH MES
   @ 08,27  prompt "FICHEROS                 "
   @ 09,27  prompt "ORDEN DE COMPRA (PEDIDO) "
   @ 10,27  prompt "RECEPCION DE MERCANCIA   "
   @ 11,27  prompt "CUENTAS POR PAGAR        "
   @ 12,27  prompt "INFORMES                 "
   @ 13,27  prompt "PROCESOS                 "
   @ 14,27  prompt "MANTENIMIENTO MODULO     "
   save scre to s2
   menu to wsubopcion
   do case
      case wsubopcion = 1
           do COM0100
      case wsubopcion = 2
           select 9
           USE SYSDATE
           store LTRIM(str(comseriord+1,7)) to wnumero
           STORE REPLICATE("0",7-LEN(WNUMERO))+WNUMERO TO WNUMERO
           STORE "ORD" TO WTIPODOC
           STORE "ORDEN DE COMPRA" TO WDOCDES
           STORE .F. TO WFLAGELA
           do COMELADC
           select 9
           USE SYSDATE
           if comseriord+1 = val(wnumero) .AND. WFLAGELA
              replace comseriord with val(wnumero)
           endif
           use
      case wsubopcion= 3
           DO COM0300
      case wsubopcion= 4
           DO COM0400
      case wsubopcion= 5
           DO COM0500
      case wsubopcion= 6
           do COM0600
      case wsubopcion = 7
           do COM0700
      case wsubopcion = 0
           SELECT 9
           USE SYSDATE
           REPLACE FALLACOM WITH 0
           CLOSE DATA
           CLOSE INDEX
           store .f. to subve
   endcase
   restore scre from s2
enddo

