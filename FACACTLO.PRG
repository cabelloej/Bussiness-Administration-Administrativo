*:*****************************************************************************
*:
*:        Program: C:\SOFT\SYSADM\FACACTLO.PRG
*:
*:         System: SISTEMA DE INVENTARIO Y FACTURACION
*:         Author: EDUARDO CABELLO
*:      Copyright (c) 1993, (c) MERCASISTEMAS, C.A.
*:  Last modified: 01/27/93     16:56
*:
*:      Called by: FACACTIN.PRG                      
*:
*:          Calls: INV0103L.PRG
*:
*:           Uses: INVLOTTR.DBF       
*:
*:        Indexes: INVLOTTR.IDX       
*:
*:      Documented 09/02/93 at 18:19               FoxDoc  version 2.10e
*:*****************************************************************************

SAVE SCRE TO s9
STORE wfecact TO wfechaop
STORE wcantidad TO wunidades
STORE "SA" TO wope
STORE wnumero2 TO wrespaldo
SELECT 8
USE invlottr INDEX invlottr
**** REVERSANDO LOS MOVIMIENTOS DE LOTES AFECTADOS
LOCATE FOR referencia = wnumero2
DO WHILE .NOT. EOF()
   STORE codart TO wcodart
   STORE codlot TO wcodlot
   STORE operacion TO woperacion
   STORE unidades TO wunix
   DELETE
   SELECT 4
   STORE wcodart+wcodlot TO wcla
   FIND &wcla
   IF .NOT. EOF()
      IF woperacion = "EN"
         REPLACE unidades WITH unidades - wunix
      ELSE
         IF woperacion = "SA"
            REPLACE unidades WITH unidades + wunix
         ENDIF
      ENDIF
   ENDIF
   SELECT 8
   CONTINUE
ENDDO
DO inv0103l
RESTORE SCRE FROM s9
*: EOF: FACACTLO.PRG
