
SELECT 2
USE COMPRO INDEX COMPRO
STORE .T. TO CLIEN
DO WHILE CLIEN
   STORE SPACE(3) TO WCODCLI
   @ 5,0 CLEAR
   @ 5,0 SAY  "+-------------+---------------------------------------+------------------------+"
   @ 6,0 SAY  "|CODIGO :     |NOMBRE :                               |GRUPO :                 |"
   @ 7,0 SAY  "+-------------+---------------------------+-----------+------------------------+"
   @ 8,0 SAY  "|DIRECCION :                              |TELEFONOS :                         |"
   @ 9,0 SAY  "|                                         |                                    |"
   @ 10,0 SAY "+-----------------------------------------+------------------------------------+"
   @ 6,9 GET WCODCLI
   READ
   IF WCODCLI = SPACE(3) .OR. READKEY() = 12 .OR. READKEY() = 268
      RETURN
   ENDIF
   FIND &WCODCLI
   IF EOF()
      STORE "CODIGO DE PROVEEDOR NO EXISTE. INGRESAR? (S/N)" TO TEX
      STORE "SN" TO WCH
      DO PREGUNTA
      IF WCH = "N"
         LOOP
      ENDIF
      STORE SPACE(30) TO WDESCLI
      STORE SPACE(2) TO WGRUCLI
      STORE SPACE(30) TO WDIRCLI1
      STORE SPACE(30) TO WDIRCLI2
      STORE SPACE(10) TO WTELCLI1
      STORE SPACE(10) TO WTELCLI2
      @ 6,23 GET WDESCLI
      @ 6,70 GET WGRUCLI
      @ 8,12 GET WDIRCLI1
      @ 9,12 GET WDIRCLI2
      @ 8,54 GET WTELCLI1
      @ 8,68 GET WTELCLI2
      READ
      STORE "CONFORME? (S/N)" TO TEX
      STORE "SN" TO WCH
      DO PREGUNTA
      IF WCH = "N"
         LOOP
      ENDIF
      APPEND BLANK
      REPLACE CODCLI WITH WCODCLI
      REPLACE DESCLI WITH WDESCLI
      REPLACE GRUCLI WITH WGRUCLI
      REPLACE DIRCLI1 WITH WDIRCLI1
      REPLACE DIRCLI2 WITH WDIRCLI2
      REPLACE TELCLI1 WITH WTELCLI1
      REPLACE TELCLI2 WITH WTELCLI2
   ELSE
      @ 6,23 SAY DESCLI
      @ 6,70 SAY GRUCLI
      @ 8,12 SAY DIRCLI1
      @ 9,12 SAY DIRCLI2
      @ 8,54 SAY TELCLI1
      @ 8,68 SAY TELCLI2
      STORE "OPCIONES: (M)ODIFICAR, (E)LIMINAR, (S)ALIR" TO TEX
      STORE "SME" TO WCH
      DO PREGUNTA
      STORE WCH TO WRES
      IF WRES = "S"
         LOOP
      ENDIF
      IF WRES = "E"
         STORE "ESTA USTED SEGURO ? (N/S)" TO TEX
         STORE "NS" TO WCH
         DO PREGUNTA
         IF WCH = "N"
            LOOP
         ELSE
            DELETE
            LOOP
         ENDIF
      ENDIF
      IF WRES = "M"
         STORE CODCLI TO WCODCLI
         STORE DESCLI TO WDESCLI
         STORE GRUCLI TO WGRUCLI
         STORE DIRCLI1 TO WDIRCLI1
         STORE DIRCLI2 TO WDIRCLI2
         STORE TELCLI1 TO WTELCLI1
         STORE TELCLI2 TO WTELCLI2
         @ 6,23 GET WDESCLI
         @ 6,70 GET WGRUCLI
         @ 8,12 GET WDIRCLI1
         @ 9,12 GET WDIRCLI2
         @ 8,54 GET WTELCLI1
         @ 8,68 GET WTELCLI2
         READ
         STORE "CONFORME? (S/N)" TO TEX
         STORE "SN" TO WCH
         DO PREGUNTA
         IF WCH = "N"
            LOOP
         ENDIF
         REPLACE CODCLI WITH WCODCLI
         REPLACE DESCLI WITH WDESCLI
         REPLACE GRUCLI WITH WGRUCLI
         REPLACE DIRCLI1 WITH WDIRCLI1
         REPLACE DIRCLI2 WITH WDIRCLI2
         REPLACE TELCLI1 WITH WTELCLI1
         REPLACE TELCLI2 WITH WTELCLI2
      ENDIF
   ENDIF
ENDDO
RETURN

