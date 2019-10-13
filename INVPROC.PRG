PROCEDURE INDICES
store "DESEA REORGANIZAR LOS INDICES (S/N)" TO TEX
STORE "SN" TO WCH
DO PREGUNTA
IF WCH = "N"
   RETURN
ENDIF
@ 0,0 CLEAR
@ 08,5 SAY "REORGANIZANDO INDICES DEBIDO A INTERRUPCION DEL SISTEMA, FAVOR ESPERAR"
SELECT 1
USE INVLIN
INDEX ON CODIGO TO INVLIN
SELECT 2
USE INVART
INDEX ON CODIGO TO INVART
SELECT 3
USE INVTRA
INDEX ON CODIGO+SUBS(DTOC(FECHA),7,2)+SUBS(DTOC(FECHA),4,2)+SUBS(DTOC(FECHA),1,2);
        +STR(SERIAL,10) TO INVTRA1
INDEX ON SUBS(DTOC(FECHA),7,2)+SUBS(DTOC(FECHA),4,2)+SUBS(DTOC(FECHA),1,2);
        +STR(SERIAL,10) TO INVTRA2
INDEX ON REFERENCIA TO INVTRA3
SELECT 4
USE INVLOT
INDEX ON CODART+CODLOT TO INVLOT
SELECT 8
USE INVLOTTR
INDEX ON CODART+CODLOT TO INVLOTTR
SELECT 9
USE SYSDATE
REPLACE FALLAINV WITH 0
CLOSE DATA
CLOSE INDEX
RETURN TO MASTER
****************************************
PROCEDURE RECLOC
SAVE SCRE TO SCRE1
STORE .T. TO WRECLOC
DO WHILE WRECLOC
   IF RLOCK()
      EXIT
   ELSE
      @ 12,20 CLEAR TO 18,60
      @ 12,20 TO 18,60
      @ 14,30 SAY "REGISTRO OCUPADO POR OTRO USUARIO, REINTENTANDO ..."
      @ 16,30 SAY "          OPRIMA [ESC] PARA ABANDONAR              "
      WVALUE = INKEY()
      IF WVALUE = 27
         RETURN TO MASTER
      ENDIF
   ENDIF
ENDDO
RESTORE SCRE FROM SCRE1
RETURN
****************************************
PROCEDURE FILLOC
SAVE SCRE TO SCRE1
STORE .T. TO WFILLOC
DO WHILE WFILLOC
   IF FLOCK()
      EXIT
   ELSE
      @ 12,20 CLEAR TO 18,60
      @ 12,20 TO 18,60
      @ 14,30 SAY "ARCHIVO OCUPADO POR OTRO USUARIO, REINTENTANDO ..."
      @ 16,30 SAY "          OPRIMA [ESC] PARA ABANDONAR             "
      WVALUE = INKEY()
      IF WVALUE = 27
         RETURN TO MASTER
      ENDIF
   ENDIF
ENDDO
RESTORE SCRE FROM SCRE1
RETURN
***********************
PROCEDURE PREGUNTA
STORE .T. TO WPREG
DO WHILE WPREG
   @ 23,0
   STORE SUBSTR(WCH,1,1) TO WCHOICE
   @ 23,40- (LEN(TEX)/2) SAY TEX GET WCHOICE
   READ
   IF AT(WCHOICE,WCH) > 0
      STORE .F. TO WPREG
      EXIT
   ENDIF
ENDDO
@ 23,0
STORE WCHOICE TO WCH
RETURN
*************************
 PROCEDURE MENSAJE
 PARAMETERS MES
 SET COLOR TO g/n
 @ 23,1
 @ 23,40-(LEN(MES)/2) SAY MES
 RETURN
 **************************************************
 PROCEDURE AVISO
 PARAMETERS MES
 STORE " " TO X
 SET COLOR TO g/n
 ?? CHR(7)
 @ 23,1 SAY SPACE(78)
 @ 23,40-(LEN(MES)/2) SAY MES GET X
 READ
 @ 23,1
 RETURN
 *****************
 PROCEDURE CHKPRINT
 PARAMETERS SALTAR
 store .t. to wprinting
 do while wprinting
    store "Prepare la impresora y oprima (Ù) para continuar o (R)echazar" to Qmes
    @ 23,1 
    @ 23,40-(len(Qmes)/2) say Qmes
    store " " to wstat
    @ 23,78 get wstat
    read
    if upper(wstat) = "R"
       store 1 to saltar
       store .f. to wprinting
    else
       store 0 to saltar
       if sys(13) = "READY"
          store .f. to wprinting
       endif
    endif
    @ 23,1
 enddo
 RETURN
 ******************************************************************
 procedure informa
 store " " to qw1
 store " " to qw2
 store " " to qw3
 store "." to qw4
 store "A" to qw5
 store "." to qw6
 store "C" to qw7
 store " " to qw8
 store "," to qw9
 store "A" to qw10
 store "D" to qw11
 store "A" to qw12
 store "R" to qw13
 store "O" to qw14
 store "D" to qw15
 store " " to qw16
 store "A" to qw17
 store "I" to qw18
 store "C" to qw19
 store "N" to qw20
 store "A" to qw21
 store "T" to qw22
 store "S" to qw23
 store "E" to qw24
 store " " to qw25
 store "A" to qw26
 store "L" to qw27
 store " " to qw28
 store "A" to qw29
 store "R" to qw30
 store "O" to qw31
 store "T" to qw32
 store "C" to qw33
 store "U" to qw34
 store "R" to qw35
 store "T" to qw36
 store "S" to qw37
 store "N" to qw38
 store "O" to qw39
 store "C" to qw40
 STORE QW40+QW39+QW38+QW37+QW36+QW35+QW34+QW33+QW32+QW31+QW30+QW29+QW28 TO QQWW
 STORE QQWW+QW27+QW26+QW25+QW24+QW23+QW22+QW21+QW20+QW19+QW18+QW17+QW16 TO QQWW
 STORE QQWW+QW15+QW14+QW13+QW12+QW11+QW10+QW9+QW8+QW7+QW6+QW5+QW4+QW3+QW2+QW1 TO QQWW
 RETURN
 ***********************
 PROCEDURE INVFIC1
   set color to G+/N
   @ 4,0 clear
   @ 5,0 say  "+-------------------------+----------------------------------------+-----------+"
   @ 6,0 SAY  "|CODIGO DEL ARTICULO      |DESCRIPCION                             |UNIDAD     |"
   @ 7,0 say  "|-------------------------|----------------------------------------|-----------|"
   @ 08,0 SAY "|                         |                                        |           |"
   @ 09,0 say "|-------------------------|----------------------------------------|-----------|"
RETURN
************************
PROCEDURE INVFIC2
   SET COLOR TO G+/N
   @ 10,0 SAY "|   MARCA    |  MODELO    |   MINIMO   |   MAXIMO   |  UBICACION  |   LINEA    |"
   @ 11,0 SAY "|------------|------------|------------|------------|-------------|------------|"
   @ 12,0 SAY "|            |            |            |            |             |            |"
   @ 13,0 SAY "|------------+------------|------------|------------|-------------+------------+"
   @ 14,0 SAY "|  LISTA 1   |  LISTA 2   |   LISTA 3  |REG.DE LOTE?| PROVEEDOR 1 | PROVEEDOR 2|"
   @ 15,0 SAY "|------------|------------|------------|------------|-------------+------------+"
   @ 16,0 SAY "|            |            |            |            |             |            |"
   @ 17,0 SAY "+------------+------------+------------+------------+-------------+------------+"
RETURN
************************
PROCEDURE DADI0301
@ WSCRELIN,1  SAY FECHA
@ WSCRELIN,10 SAY CODIGO
@ WSCRELIN,31 SAY OPERACION
@ WSCRELIN,34 SAY REFERENCIA
@ WSCRELIN,47 SAY UNIDADES PICTURE "#######.##"
@ WSCRELIN,58 SAY COSTO PICTURE "########.##"
@ WSCRELIN,70 SAY PROCLI
@ WSCRELIN,76 SAY ORIGEN
RETURN
******************
PROCEDURE DAGE0301
@ WSCRELIN,1  GET WFECHA
@ WSCRELIN,10 GET WCODIGO
@ WSCRELIN,31 GET WOPERA
@ WSCRELIN,34 GET WREFEREN
@ WSCRELIN,47 GET WUNIDADES PICTURE "#######.##"
@ WSCRELIN,58 GET WCOSTO PICTURE "########.##"
READ
RETURN
********************
PROCEDURE DARE0301
REPLACE FECHA WITH WFECHA
REPLACE CODIGO WITH WCODIGO
REPLACE OPERACION WITH WOPERA
REPLACE REFERENCIA WITH WREFEREN
REPLACE UNIDADES WITH WUNIDADES
REPLACE COSTO WITH WCOSTO
REPLACE ORIGEN WITH WORIGEN
FLUSH
RETURN
**********************
PROCEDURE ERRCON
STORE "ERROR IRRECUPERABLE, EL SISTEMA FINALIZARA. <ENTER>" TO MES
DO AVISO WITH MES
SELECT 10
USE SYSERR
APPEND BLANK
REPLACE NUMERO WITH ERROR()
REPLACE MENSAJE WITH MESSAGE()
REPLACE PROGRAMA WITH SYS(16,4)
REPLACE FECHA WITH WFECACT
REPLACE HORA WITH TIME()
CLOSE ALL
QUIT
RETURN
