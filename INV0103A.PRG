STORE 100 TO WLINE
STORE .T. TO ACT
STORE "INV" TO WORIGEN
DO WHILE ACT
   STORE WLINE + 1 TO WLINE
   IF WLINE >19
      @ 4,0 CLEAR
      @ 04,20 SAY "R E G I S T R A R      M O V I M I E N T O S"
      @ 05,0 say "+--------+--------------------+--+------------+----------+-----------+-----+---+"
      @ 06,0 SAY "| FECHA  |NUMERO DEL ARTICULO |TP|DOCUMENTO No| CANTIDAD |COSTO TOTAL|PR/CL|ORG|"
      @ 07,0 SAY "|--------|--------------------|--|------------|----------|-----------|-----|---|"
      @ 08,0 SAY "|        |                    |  |            |          |           |     |   |"
      @ 09,0 SAY "|        |                    |  |            |          |           |     |   |"
      @ 10,0 SAY "|        |                    |  |            |          |           |     |   |"
      @ 11,0 SAY "|        |                    |  |            |          |           |     |   |"
      @ 12,0 SAY "|        |                    |  |            |          |           |     |   |"
      @ 13,0 SAY "|        |                    |  |            |          |           |     |   |"
      @ 14,0 SAY "|        |                    |  |            |          |           |     |   |"
      @ 15,0 SAY "|        |                    |  |            |          |           |     |   |"
      @ 16,0 SAY "|        |                    |  |            |          |           |     |   |"
      @ 17,0 SAY "|        |                    |  |            |          |           |     |   |"
      @ 18,0 SAY "|        |                    |  |            |          |           |     |   |"
      @ 19,0 SAY "|        |                    |  |            |          |           |     |   |"
      @ 20,0 SAY "|--------|--------------------|--|------------|----------|-----------|-----|---|"
      STORE 8 TO WLINE
   ENDIF
   STORE WFECACT TO WFECHAOP
   SET COLOR TO G/N
   @ WLINE,1 SAY wfechaop
   @ WLINE,76 SAY WORIGEN

   STORE SPACE(20) TO WCODIGO
   @ WLINE,10 get wcodigo
   STORE "INDIQUE EL CODIGO DESEADO, <ENTER> o <ESC> PARA SALIR" to mes
   do mensaje with mes
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
      store "CODIGO NO REGISTRADO, (Ù)" to mes
      do AVISO WITH MES
      store wline - 1 to wline
      LOOP
   endif
   @ 21,1  say "DESCRIPCION:"+descri
   @ 21,50 say "UNIDAD/MEDIDA:"+unimed

   STORE .T. TO VERTIP
   DO WHILE VERTIP
      STORE SPACE(2) TO WOPE
      STORE "(EN)=Entrada, (SA)=Salida, (AE)=Aj.Entrada, (AS)=Aj.Salida, (AC)=Aj.Costo" to mes
      do mensaje with mes
      @ WLINE,31 get wope
      read
      if wope = space(2)
         LOOP
      endif
      IF WOPE="EN" .OR. WOPE="SA" .OR. WOPE="AE" .OR. WOPE="AS" .OR. WOPE="AC"
         STORE .F. TO VERTIP
      ENDIF
   ENDDO

   STORE SPACE(10) TO WNUMERO
   do while wnumero = space(10)
      store "NUMERO DEL DOCUMENTO QUE RESPALDA LA OPERACION" to mes
      do mensaje with mes
      @ WLINE,34 GET Wnumero
      READ
   enddo

   STORE 0.00 TO WUNIDADES
   STORE .T. TO VERUN
   DO WHILE VERUN
      IF WOPE = "AC"
         STORE .F. TO VERUN
         LOOP
      ENDIF
      STORE 0.00 TO WUNIDADES
      STORE "NUMERO DE UNIDADES DE LA OPERACION" to mes
      do mensaje with mes
      @ WLINE,47 GET WUNIDADES PICTURE "#######.##"
      READ
      IF WUNIDADES=0
         STORE "DEBEN EXISTIR UNIDADES EN ESTA OPERACION (Ù)" TO MES
         DO AVISO WITH MES
         LOOP
      ELSE
         STORE .F. TO VERUN
      ENDIF
   ENDDO

   STORE 0.00 TO WCOSTO
   IF WOPE="EN".OR. WOPE="AC"
      STORE "Costo TOTAL de la operacion" to mes
      do mensaje with mes
      @ WLINE,58 GET WCOSTO PICTURE "########.##"
      READ
      IF WCOSTO = 0
         STORE "DEBE EXISTIR COSTO EN LA OPERACION (Ù)" TO MES
         DO AVISO WITH MES
         LOOP
      ENDIF
   ELSE
      STORE COSEXI*WUNIDADES TO WCOSTO
      @ WLINE,58 SAY WCOSTO PICTURE "########.##"
   ENDIF
   STORE "CONFORME? (S/N)" TO TEX
   STORE "SN" TO WCH
   DO PREGUNTA
   STORE WCH TO RESP
   if resp = "N"
      STORE WLINE - 1 TO WLINE
      loop
   endif
   select 3
   append blank
   REPLACE SERIAL WITH SYSDATE->SERIAL+1
   replace codigo with wcodigo
   replace fecha with wfechaop
   replace operacion with wope
   replace referencia with wnumero
   replace origen with WORIGEN
   REPLACE UNIDADES WITH WUNIDADES
   REPLACE COSTO WITH WCOSTO
   FLUSH
   IF INVART->LOTE = "S"
      SAVE SCRE TO S9
      DO INV0103L
      RESTORE SCRE FROM S9
   ENDIF
   SELECT 9
   REPLACE SERIAL WITH SERIAL+1
   FLUSH
   DO CASE
      CASE WOPE = "EN"
           SELECT 2
           REPLACE COSEXI WITH ((COSEXI*UNIEXI)+(WCOSTO)) / (UNIEXI+WUNIDADES)
           REPLACE UNIEXI WITH UNIEXI + WUNIDADES

   *       REPLACE COSENT WITH ((COSENT*UNIENT)+(WCOSTO)) / (UNIENT+WUNIDADES)
   *       REPLACE UNIENT WITH UNIENT+WUNIDADES

           REPLACE ULTCOMPRA WITH WFECHAOP
           REPLACE ULTCANTI WITH WUNIDADES
           REPLACE ULTCOSTO WITH WCOSTO
           FLUSH
      CASE WOPE = "SA"
           SELECT 2
           REPLACE UNIEXI WITH UNIEXI - WUNIDADES

    *      REPLACE COSSAL WITH ((COSSAL*UNISAL)+(COSEXI*WUNIDADES)) / (UNISAL+WUNIDADES)
    *      REPLACE UNISAL WITH UNISAL+WUNIDADES
           FLUSH
      CASE WOPE = "AE"
           SELECT 2
           REPLACE UNIEXI WITH UNIEXI + WUNIDADES

     *     REPLACE COSAE  WITH ((COSAE*UNIAE )+(COSEXI*WUNIDADES)) / (UNIAE+WUNIDADES)
     *     REPLACE UNIAE  WITH UNIAE+WUNIDADES
           FLUSH
      CASE WOPE = "AS"
           SELECT 2
           REPLACE UNIEXI WITH UNIEXI - WUNIDADES

      *    REPLACE COSAS  WITH ((COSAS*UNIAS )+(COSEXI*WUNIDADES)) / (UNIAS+WUNIDADES)
      *    REPLACE UNIAS  WITH UNIAS+WUNIDADES
           FLUSH
      CASE WOPE = "AC"
           SELECT 2
           REPLACE COSEXI WITH ((COSEXI*UNIEXI)+(WCOSTO)) / (UNIEXI)

       *   REPLACE COSAC  WITH COSAC+WCOSTO
           FLUSH
   ENDCASE
enddo








