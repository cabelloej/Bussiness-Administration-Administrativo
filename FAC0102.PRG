SELECT 2
USE FACCLI INDEX FACCLI
STORE .T. TO CLIEN
DO WHILE CLIEN
   STORE SPACE(3) TO WCODCLI
   @ 05,0 CLEAR
   @ 05,0 SAY  "+-------------+----------+-----------------------------------------------------+"
   @ 06,0 SAY  "|CODIGO :     |GRUPO:    |TELEFONOS:                                           |"
   @ 07,0 SAY  "+-------------+----------+----------------+------------------------------------+"
   @ 08,0 SAY  "|NOMBRE :                                 |DIRECCION :                         |"
   @ 09,0 SAY  "|                                         |                                    |"
   @ 10,0 SAY  "|                                         |                                    |"
   @ 11,0 SAY  "+-----------------------------------------+------------------------------------+"
   @ 6,9 GET WCODCLI
   READ
   IF WCODCLI = SPACE(3) .OR. READKEY() = 12 .OR. READKEY() = 268
      RETURN
   ENDIF
   FIND &WCODCLI
   IF EOF()
      STORE "CODIGO DE CLIENTE NO EXISTE. INGRESAR? (S/N)" TO TEX
      STORE "SN" TO WCH
      DO PREGUNTA
      IF WCH = "N"
         LOOP
      ENDIF
      STORE SPACE(30) TO WDESCLI
      STORE SPACE(30) TO WDESCLI2
      STORE SPACE(30) TO WDESCLI3
      STORE SPACE(2) TO WGRUCLI
      STORE SPACE(30) TO WDIRCLI1
      STORE SPACE(30) TO WDIRCLI2
      STORE SPACE(10) TO WTELCLI1
      STORE SPACE(10) TO WTELCLI2
      STORE 0 TO WCREDITCLI
      @ 8,09 GET WDESCLI
      @ 9,09 GET WDESCLI2
      @ 10,09 GET WDESCLI3
      @ 6,21 GET WGRUCLI
      @ 6,36 GET WTELCLI1
      @ 6,54 GET WTELCLI2
      @ 09,43 GET WDIRCLI1
      @ 10,43 GET WDIRCLI2
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
      REPLACE DESCLI2 WITH WDESCLI2
      REPLACE DESCLI3 WITH WDESCLI3
      REPLACE GRUCLI WITH WGRUCLI
      REPLACE DIRCLI1 WITH WDIRCLI1
      REPLACE DIRCLI2 WITH WDIRCLI2
      REPLACE TELCLI1 WITH WTELCLI1
      REPLACE TELCLI2 WITH WTELCLI2
   ELSE
      @ 8,09 SAY DESCLI
      @ 9,09 SAY DESCLI2
      @ 10,09 SAY DESCLI3
      @ 6,21 SAY GRUCLI
      @ 6,36 SAY TELCLI1
      @ 6,54 SAY TELCLI2
      @ 09,43 SAY DIRCLI1
      @ 10,43 SAY DIRCLI2

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
         STORE DESCLI2 TO WDESCLI2
         STORE DESCLI3 TO WDESCLI3
         STORE GRUCLI TO WGRUCLI
         STORE DIRCLI1 TO WDIRCLI1
         STORE DIRCLI2 TO WDIRCLI2
         STORE TELCLI1 TO WTELCLI1
         STORE TELCLI2 TO WTELCLI2
         @ 8,09 GET WDESCLI
         @ 9,09 GET WDESCLI2
         @ 10,09 GET WDESCLI3
         @ 6,21 GET WGRUCLI
         @ 6,36 GET WTELCLI1
         @ 6,54 GET WTELCLI2
         @ 09,43 GET WDIRCLI1
         @ 10,43 GET WDIRCLI2
         READ
         STORE "CONFORME? (S/N)" TO TEX
         STORE "SN" TO WCH
         DO PREGUNTA
         IF WCH = "N"
            LOOP
         ENDIF
         REPLACE CODCLI WITH WCODCLI
         REPLACE DESCLI WITH WDESCLI
         REPLACE DESCLI2 WITH WDESCLI2
         REPLACE DESCLI3 WITH WDESCLI3
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