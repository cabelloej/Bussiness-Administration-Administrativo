
STORE .F. TO FLAGDEL                                                                                                                                  
SELECT 2
SET COLOR TO G/N                                                                                                                                      
@ 4,0 CLEAR                                                                                                                                           
SET COLOR TO W+/B                                                                                                                                     
STORE "SELECCION DE ARTICULOS" TO WHEADER
@ 4,40 - (LEN(WHEADER)/2) SAY WHEADER                                                                                                                 
SET COLOR TO W+/B                                                                                                                                     
@ 5,0                                                                                                                                                 
@ 5,01 SAY "CODIGO"
@ 5,22 SAY "DESCRI"

SET COLOR TO B+/N                                                                                                                                     
@ 6,0 TO 19,79                                                                                                                                        
SET COLOR TO G/N                                                                                                                                      
STORE  "INCLUIR    " TO XMENU1                                                                                                                        
STORE  "MODIFICAR  " TO XMENU2                                                                                                                        
STORE  "ELIMINAR   " TO XMENU3                                                                                                                        
STORE  "SELECCIONAR" TO XMENU4                                                                                                                        
STORE  "BUSCAR     " TO XMENU5                                                                                                                        
STORE 4 TO WMENU                                                                                                                                      
STORE .T. TO XFLAG                                                                                                                                    
STORE .F. TO WREGS                                                                                                                                    
GO TOP                                                                                                                                                
DO WHILE .NOT. EOF()                                                                                                                                  
   STORE .T. TO WREGS                                                                                                                                 
   EXIT                                                                                                                                               
ENDDO                                                                                                                                                 
IF .NOT. WREGS                                                                                                                                        
  RETURN
ENDIF                                                                                                                                                 
GO TOP                                                                                                                                                
STORE 12 TO WRANGO                                                                                                                                    
STORE RECNO() TO WINICIO                                                                                                                              
STORE 0 TO WREVERSE                                                                                                                                   
STORE 0 TO WEDILIN                                                                                                                                    
STORE .T. TO FLAGJUMP                                                                                                                                 
STORE .T. TO WEDITAR                                                                                                                                  
DO WHILE WEDITAR                                                                                                                                      
   IF FLAGJUMP                                                                                                                                        
      STORE 0       TO WCONT                                                                                                                          
      STORE 07      TO WLINE                                                                                                                          
      GO WINICIO                                                                                                                                      
      SET COLOR TO G/N                                                                                                                                
   *  @ 7,1 CLEAR TO 18,78                                                                                                                            
      DO WHILE .NOT. EOF() .AND. WCONT < WRANGO                                                                                                       
         STORE WLINE+WCONT TO WSCRELIN                                                                                                                
         STORE WLINE+WCONT TO WLASTLIN                                                                                                                
         STORE RECNO() TO WLASTREC                                                                                                                    
         @ WSCRELIN ,01  SAY CODIGO
         @ WSCRELIN ,22  SAY DESCRI
         STORE WCONT + 1 TO WCONT                                                                                                                     
         SKIP                                                                                                                                         
      ENDDO                                                                                                                                           
      STORE .F. TO FLAGJUMP                                                                                                                           
   ENDIF                                                                                                                                              
   *** RELLENO DE ESP. VACION (SI NO HAY SUF. REGISTROS)                                                                                              
   STORE WCONT TO WFILCON                                                                                                                             
   STORE WLASTLIN TO WFILLIN                                                                                                                          
   DO WHILE WFILCON < WRANGO                                                                                                                          
      STORE WFILLIN + 1 TO WFILLIN                                                                                                                    
      @ WFILLIN, 1 SAY SPACE(77)                                                                                                                      
      STORE WFILCON + 1 TO WFILCON                                                                                                                    
   ENDDO                                                                                                                                              
   ***                                                                                                                                                
   IF WREVERSE = 0                                                                                                                                    
      STORE WLASTREC TO WREVERSE                                                                                                                      
      STORE WLASTLIN TO WEDILIN                                                                                                                       
      STORE WINICIO  TO WCLEARREC                                                                                                                     
      STORE WLINE    TO WCLEARLIN                                                                                                                     
   ENDIF                                                                                                                                              
   ** PARA BORRAR EL REGISTRO ANTERIOR                                                                                                                
   SET COLOR TO w/N                                                                                                                                   
   GO WCLEARREC                                                                                                                                       
   STORE WCLEARLIN TO WSCRELIN                                                                                                                        
   @ WSCRELIN ,01  SAY CODIGO
   @ WSCRELIN ,22  SAY DESCRI
   @ 21,0 SAY "DESCRIPCION DETALLADA ======>"
   @ 21,39 SAY DESCRI
   @ 22,39 SAY DESCRI2
   @ 23,39 SAY DESCRI3
   @ 24,39 SAY DESCRI4
   ** PARA MARCAR EL REGISTRO ACTUAL                                                                                                                  
   SET COLOR TO N/w                                                                                                                                   
   GO WREVERSE                                                                                                                                        
   STORE WEDILIN TO WSCRELIN                                                                                                                          
   @ WSCRELIN ,01  SAY CODIGO
   @ WSCRELIN ,22  SAY DESCRI
   @ 21,0 SAY "DESCRIPCION DETALLADA ======>"
   @ 21,39 SAY DESCRI
   @ 22,39 SAY DESCRI2
   @ 23,39 SAY DESCRI3
   @ 24,39 SAY DESCRI4
   STORE WREVERSE TO WCLEARREC                                                                                                                        
   STORE WSCRELIN TO WCLEARLIN                                                                                                                        
   SET COLOR TO G/N                                                                                                                                   
   *** PARA INDICAR LA ROTACION DEL MENU (SI LA HUBO)                                                                                                 
   IF XFLAG                                                                                                                                           
      SET COLOR TO G/N                                                                                                                                
      @ 20,05 SAY  XMENU1                                                                                                                             
      @ 20,20 SAY  XMENU2                                                                                                                             
      @ 20,35 SAY  XMENU3                                                                                                                             
      @ 20,50 SAY  XMENU4                                                                                                                             
      @ 20,65 SAY  XMENU5                                                                                                                             
      SET COLOR TO N/G                                                                                                                                
      STORE "XMENU"+STR(WMENU,1) TO WMACRO                                                                                                            
      @ 20,5+((WMENU-1)*15)  SAY &WMACRO                                                                                                              
      STORE .F. TO XFLAG                                                                                                                              
      SET COLOR TO G/N                                                                                                                                
   ENDIF                                                                                                                                              
   *** CAPTURA DE INTERACTIVIDAD                                                                                                                      
   CLEAR TYPEAHEAD                                                                                                                                    
   STORE INKEY(0) TO WMUEVE                                                                                                                           
   *** PAGE DOWN                                                                                                                                      
   IF WMUEVE = 3                                                                                                                                      
      GO WINICIO                                                                                                                                      
      SKIP +12                                                                                                                                        
      IF .NOT. EOF()                                                                                                                                  
         STORE RECNO() TO WINICIO                                                                                                                     
         STORE .T.     TO FLAGJUMP                                                                                                                    
         STORE WINICIO TO WREVERSE                                                                                                                    
         STORE WLINE   TO WEDILIN                                                                                                                     
         STORE WINICIO TO WCLEARREC                                                                                                                   
         STORE WLINE   TO WCLEARLIN                                                                                                                   
      ENDIF                                                                                                                                           
   ENDIF                                                                                                                                              
   *** PAGE UP                                                                                                                                        
   IF WMUEVE =  18                                                                                                                                    
      GO WINICIO                                                                                                                                      
      SKIP -12                                                                                                                                        
      STORE RECNO() TO WINICIO                                                                                                                        
      STORE .T. TO FLAGJUMP                                                                                                                           
      STORE 0 TO WREVERSE                                                                                                                             
   ENDIF                                                                                                                                              
   *** HOME                                                                                                                                           
   IF WMUEVE = 1                                                                                                                                      
      GO TOP                                                                                                                                          
      IF .NOT. EOF()                                                                                                                                  
         STORE RECNO() TO WINICIO                                                                                                                     
         STORE .T. TO FLAGJUMP                                                                                                                        
         STORE WINICIO TO WREVERSE                                                                                                                    
         STORE WLINE   TO WEDILIN                                                                                                                     
         STORE WINICIO TO WCLEARREC                                                                                                                   
         STORE WLINE   TO WCLEARLIN                                                                                                                   
      ENDIF                                                                                                                                           
   ENDIF                                                                                                                                              
   *** END                                                                                                                                            
   IF WMUEVE = 6                                                                                                                                      
      GO BOTT                                                                                                                                         
      SKIP -11                                                                                                                                        
      STORE RECNO() TO WINICIO                                                                                                                        
      STORE 0 TO WREVERSE                                                                                                                             
      STORE .T. TO FLAGJUMP                                                                                                                           
   ENDIF                                                                                                                                              
   *** DOWN ARROW                                                                                                                                     
   IF WMUEVE = 24                                                                                                                                     
      SKIP + 1                                                                                                                                        
      IF WEDILIN < (WLINE+(WCONT-1))                                                                                                                  
         STORE WREVERSE    TO WCLEARREC                                                                                                               
         STORE RECNO()     TO WREVERSE                                                                                                                
         STORE WEDILIN     TO WCLEARLIN                                                                                                               
         STORE WEDILIN + 1 TO WEDILIN                                                                                                                 
      ELSE                                                                                                                                            
         IF .NOT. EOF()                                                                                                                               
            GO WINICIO                                                                                                                                
            SKIP +1                                                                                                                                   
            STORE RECNO() TO WINICIO                                                                                                                  
            STORE .T.     TO FLAGJUMP                                                                                                                 
            STORE 0       TO WREVERSE                                                                                                                 
         *  STORE WINICIO TO WREVERSE                                                                                                                 
         *  STORE WLINE   TO WEDILIN                                                                                                                  
         *  STORE WINICIO TO WCLEARREC                                                                                                                
         *  STORE WLINE   TO WCLEARLIN                                                                                                                
         ELSE                                                                                                                                         
            GO WINICIO                                                                                                                                
            STORE RECNO() TO WINICIO                                                                                                                  
            STORE .T.     TO FLAGJUMP                                                                                                                 
            STORE 0       TO WREVERSE                                                                                                                 
         *  STORE WINICIO TO WREVERSE                                                                                                                 
         *  STORE WLINE   TO WEDILIN                                                                                                                  
         *  STORE WINICIO TO WCLEARREC                                                                                                                
         *  STORE WLINE   TO WCLEARLIN                                                                                                                
         ENDIF                                                                                                                                        
      ENDIF                                                                                                                                           
   ENDIF                                                                                                                                              
   *** UP ARROW                                                                                                                                       
   IF WMUEVE = 5                                                                                                                                      
      SKIP -1                                                                                                                                         
      IF WEDILIN > WLINE                                                                                                                              
         STORE WREVERSE    TO WCLEARREC                                                                                                               
         STORE RECNO()     TO WREVERSE                                                                                                                
         STORE WEDILIN     TO WCLEARLIN                                                                                                               
         STORE WEDILIN - 1 TO WEDILIN                                                                                                                 
      ELSE                                                                                                                                            
         GO WINICIO                                                                                                                                   
         SKIP -1                                                                                                                                      
         STORE RECNO() TO WINICIO                                                                                                                     
         STORE .T.     TO FLAGJUMP                                                                                                                    
         STORE WINICIO TO WREVERSE                                                                                                                    
         STORE WLINE   TO WEDILIN                                                                                                                     
         STORE WINICIO TO WCLEARREC                                                                                                                   
         STORE WLINE   TO WCLEARLIN                                                                                                                   
      ENDIF                                                                                                                                           
   ENDIF                                                                                                                                              
   *** RIGHT ARROW                                                                                                                                    
   IF WMUEVE = 4                                                                                                                                      
      STORE .T. TO XFLAG                                                                                                                              
      STORE WMENU+1 TO WMENU                                                                                                                          
      IF WMENU > 5                                                                                                                                    
         STORE 1 TO WMENU                                                                                                                             
      ENDIF                                                                                                                                           
   ENDIF                                                                                                                                              
   *** LEFT ARROW                                                                                                                                     
   IF WMUEVE = 19                                                                                                                                     
      STORE .T. TO XFLAG                                                                                                                              
      STORE WMENU-1 TO WMENU                                                                                                                          
      IF WMENU < 1                                                                                                                                    
         STORE 5 TO WMENU                                                                                                                             
      ENDIF                                                                                                                                           
   ENDIF                                                                                                                                              
   *** ESCAPE                                                                                                                                         
   IF WMUEVE = 27                                                                                                                                     
      STORE CODIGO TO WITEM
   *   IF FLAGDEL                                                                                                                                     
   *      STORE "COMPACTANDO FICHERO DEBIDO A ELIMINACION DE CONTENIDO" TO MES                                                                        
   *      DO MENSAJE WITH MES                                                                                                                         
   *      do filloc                                                                                                                                   
   *      PACK                                                                                                                                        
   *      REINDEX                                                                                                                                     
   *      unlock all                                                                                                                                  
   *   ENDIF                                                                                                                                          
      RETURN                                                                                                                                          
   ENDIF                                                                                                                                              
   *** ENTER (INICIO DE OPERACIONES DE ACTUALIZACION DE DATOS                                                                                         
   IF WMUEVE = 13                                                                                                                                     
      DO CASE                                                                                                                                         
         CASE WMENU = 1                                                                                                                               
           *   DO EX0101I
         CASE WMENU = 2                                                                                                                               
           *   DO EX0101M
         CASE WMENU = 3                                                                                                                               
           *   DO EX0101E
         CASE WMENU = 4                                                                                                                               
               STORE CODIGO TO WITEM
            *  IF FLAGDEL                                                                                                                             
            *     STORE "COMPACTANDO FICHERO DEBIDO A ELIMINACION DE CONTENIDO" TO MES                                                                
            *     DO MENSAJE WITH MES                                                                                                                 
            *     do filloc                                                                                                                           
            *     PACK                                                                                                                                
            *     REINDEX                                                                                                                             
            *     unlock all                                                                                                                          
            *  ENDIF                                                                                                                                  
               RETURN
         CASE WMENU = 5                                                                                                                               
              SAVE SCRE TO S9                                                                                                                         
              STORE SPACE(LEN(CODIGO)) TO WCODCOB
              @ WSCRELIN ,01  GET WCODCOB
              READ                                                                                                                                    
              IF WCODCOB <> SPACE(LEN(CODIGO))
                 FIND &WCODCOB
                 IF .NOT. EOF()                                                                                                                       
                    STORE RECNO() TO WINICIO                                                                                                          
                    STORE .T. TO FLAGJUMP                                                                                                             
                    STORE RECNO() TO WREVERSE                                                                                                         
                    STORE RECNO() TO WCLEARREC                                                                                                        
                    STORE WLINE   TO WEDILIN                                                                                                          
                    STORE WLINE   TO WCLEARLIN                                                                                                        
                 ELSE                                                                                                                                 
                    RESTORE SCRE FROM S9                                                                                                              
                 ENDIF                                                                                                                                
              ELSE                                                                                                                                    
                 RESTORE SCRE FROM S9                                                                                                                 
              ENDIF                                                                                                                                   
      ENDCASE                                                                                                                                         
   ENDIF                                                                                                                                              
ENDDO                                                                                                                                                 
RETURN                                                                                                                                                
                                                                                                                                                      
