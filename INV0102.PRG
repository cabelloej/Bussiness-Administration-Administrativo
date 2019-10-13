
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
STORE .T. TO ACT
DO WHILE ACT
   DO INVFIC1
   @ 4,20 SAY  "A C T U A L I Z A R       A R T I C U L O S"
   DO INVFIC2
   STORE SPACE(20) TO WCODIGO
   STORE "INDIQUE EL CODIGO DESEADO, <ENTER> o <ESC> PARA SALIR" to mes
   do mensaje with mes
   @ 08,1 get wcodigo
   read
   store upper(wcodigo) to wcodigo
   if wcodigo = space(20)
      return
   endif
   IF READKEY() = 12 .OR READKEY() = 268
      RETURN
   ENDIF
   SELECT 2
   find &wcodigo
   if eof()
      store "CODIGO DE ARTICULO NO REGISTRADO, INGRESAR (S/N)" to TEX
      STORE "SN" TO WCH
      DO PREGUNTA
      STORE WCH TO CONDICION
      if condicion = "N"
         loop
      endif
      store space(40) to wdescri
      store space(40) to wdescri2
      store space(40) to wdescri3
      store space(40) to wdescri4
      store space(5) to wunimed
      store space(10) to wMARCA
      store space(10) to wMODELO
      store space(11) to wubicacion
      STORE SPACE(3) TO WLINEA
      store 0 to wminimo
      store 0 to wmaximo
      STORE 0 TO WPVP1
      STORE 0 TO WPVP2
      STORE 0 TO WPVP3
      STORE "N" TO WLOTE
      store space(10) to wPROVE1
      store space(10) to wPROVE2
      store "INGRESE LA INFORMACION SOLICITADA" TO MES
      do mensaje with mes
      save scre to wejc1
      @ 07,26 clear to 12,67
      @ 07,26 to 12,67
      @ 08,27 get wdescri
      @ 09,27 get wdescri2
      @ 10,27 get wdescri3
      @ 11,27 get wdescri4
      read
      restore scre from wejc1
      @ 08,27 SAY wdescri
      @ 08,68 get wunimed
      @ 12,1 get wMARCA
      @ 12,14 get wMODELO
      @ 12,29 get wminimo picture "#######.##"
      @ 12,42 get wmaximo picture "#######.##"
      @ 12,53 get wubicacion
      @ 12,70 get WLINEA
      @ 16,3  GET WPVP1       PICTURE "#######.##"
      @ 16,16 GET WPVP2       PICTURE "#######.##"
      @ 16,29 GET WPVP3       PICTURE "#######.##"
      @ 16,45 GET WLOTE
      @ 16,53 GET WPROVE1
      @ 16,67 GET WPROVE2
      read
      IF WLINEA <> SPACE(3)
         SELECT 1
         FIND &WLINEA
         IF EOF()
            STORE "LINEA DE VENTA NO DEFINIDA, FAVOR INGRESAR." TO MES
            DO AVISO WITH MES
            STORE SPACE(3) TO WLINEA
         ENDIF
         SELECT 2
      ENDIF
      STORE "CONFORME? (S/N)" TO TEX
      STORE "SN" TO WCH
      DO PREGUNTA
      STORE WCH TO RESP
      if resp = "S"
         append blank
         replace codigo with wcodigo
         replace descri with wdescri
         replace descri2 with wdescri2
         replace descri3 with wdescri3
         replace descri4 with wdescri4
         replace MARCA with wMARCA
         replace MODELO  with wMODELO
         replace ubicacion with wubicacion
         REPLACE LINEA WITH WLINEA
         replace unimed with wunimed
         replace minimo with wminimo
         replace maximo with wmaximo
         REPLACE PVP1 WITH WPVP1
         REPLACE PVP2 WITH WPVP2
         REPLACE PVP3 WITH WPVP3
         REPLACE LOTE WITH WLOTE
         REPLACE PROVE1 WITH WPROVE1
         REPLACE PROVE2 WITH WPROVE2
         FLUSH
      endif
   else
      @ 08,27 say descri
      @ 08,68 say unimed
      @ 12,1 say MARCA
      @ 12,14 say MODELO
      @ 12,29 say minimo picture "#######.##"
      @ 12,42 say maximo picture "#######.##"
      @ 12,53 say ubicacion
      @ 12,70 SAY LINEA
      @ 16,3  SAY PVP1       PICTURE "#######.##"
      @ 16,16 SAY PVP2       PICTURE "#######.##"
      @ 16,29 SAY PVP3       PICTURE "#######.##"
      @ 16,45 SAY LOTE
      @ 16,53 SAY PROVE1
      @ 16,67 SAY PROVE2
      store descri to wdescri
      store descri2 to wdescri2
      store descri3 to wdescri3
      store descri4 to wdescri4
      store unimed to wunimed
      store MARCA to wMARCA
      store MODELO  to wMODELO
      store minimo to wminimo
      store maximo to wmaximo
      store ubicacion to wubicacion
      STORE LINEA TO WLINEA
      STORE PVP1 TO WPVP1
      STORE PVP2 TO WPVP2
      STORE PVP3 TO WPVP3
      STORE LOTE TO WLOTE
      STORE PROVE1 TO WPROVE1
      STORE PROVE2 TO WPROVE2
      store "OPCIONES: (M)ODIFICAR, (E)LIMINAR, (S)ALIR" to TEX
         STORE "SME" TO WCH
         DO PREGUNTA
         STORE WCH TO CONDICION
      if condicion = "S"
         loop
      endif
      if condicion = "M"
         save scre to wejc1
         @ 07,26 clear to 12,67
         @ 07,26 to 12,67
         @ 08,27 get wdescri
         @ 09,27 get wdescri2
         @ 10,27 get wdescri3
         @ 11,27 get wdescri4
         read
         restore scre from wejc1
         @ 08,68 get wunimed
         @ 12,1 get wMARCA
         @ 12,14 get wMODELO
         @ 12,29 get wminimo picture "#######.##"
         @ 12,42 get wmaximo picture "#######.##"
         @ 12,53 get wubicacion
         @ 12,70 GET WLINEA
         @ 16,3  GET WPVP1       PICTURE "#######.##"
         @ 16,16 GET WPVP2       PICTURE "#######.##"
         @ 16,29 GET WPVP3       PICTURE "#######.##"
         @ 16,45 GET WLOTE
         @ 16,53 GET WPROVE1
         @ 16,67 GET WPROVE2
         read
         IF WLINEA <> SPACE(3)
            SELECT 1
            FIND &WLINEA
            IF EOF()
               STORE "LINEA DE VENTA NO DEFINIDA, FAVOR INGRESAR." TO MES
               DO AVISO WITH MES
               STORE SPACE(3) TO WLINEA
            ENDIF
            SELECT 2
         ENDIF
         STORE "CONFORME? (S/N)" TO TEX
         STORE "SN" TO WCH
         DO PREGUNTA
         STORE WCH TO RESP
         if resp = "S"
            replace codigo with wcodigo
            replace descri with wdescri
            replace descri2 with wdescri2
            replace descri3 with wdescri3
            replace descri4 with wdescri4
            replace MARCA with wMARCA
            replace MODELO  with wMODELO
            replace unimed with wunimed
            replace minimo with wminimo
            replace maximo with wmaximo
            replace ubicacion with wubicacion
            REPLACE LINEA WITH WLINEA
            REPLACE PVP1 WITH WPVP1
            REPLACE PVP2 WITH WPVP2
            REPLACE PVP3 WITH WPVP3
            REPLACE LOTE WITH WLOTE
            REPLACE PROVE1 WITH WPROVE1
            REPLACE PROVE2 WITH WPROVE2
            FLUSH
         endif
      endif
      *** OJO NO SE PUEDEN BORRAN ARTICULOS CON COSTO O EXISTE MAYOR 0
       if CONDICION = "E"
          IF UNIEXI > 0 .OR. COSEXI > 0
             STORE "ESTE ARTICULO TIENE EXISTENCIA/COSTO, OPERACION RECHAZADA (Ù)" TO MES
             DO AVISO WITH MES
             LOOP
          ELSE
            store "SOLO DEBE ELIMINAR ARTICULOS CON TRANSACCIONES EN 0. ESTA SEGURO? (S/N)" to TEX
            STORE "NS" TO WCH
            DO PREGUNTA
            STORE WCH TO RESP
             if resp = "S"
                store "ELIMINANDO,  FAVOR ESPERAR..." to mes
                do mensaje with mes
                delete
                FLUSH
                select 3
                delete all for codigo = wcodigo
                FLUSH
                select 2
             endif
         ENDIF
       endif
   endif
enddo

