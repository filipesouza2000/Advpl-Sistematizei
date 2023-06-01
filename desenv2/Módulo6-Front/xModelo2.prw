#include "protheus.ch"

/*++++LOJA++++|++++AUTOR+++++|++++++++++++++++DESCRIÇÂO+++++++++++++
  11/10/2022  | Filipe Souza | Modelo 2 convencional
                                Exibe formulário para cadastro contendo: uma enchoice, 
                                uma getdados e uma área que pode ser utilizada para apresentar 
                                totalizadores ou outros dados mais relevantes.
@see https://tdn.totvs.com/pages/releaseview.action?pageId=6814982
@see https://centraldeatendimento.totvs.com/hc/pt-br/articles/360021384491-Cross-Segmento-TOTVS-Backoffice-Linha-Protheus-ADVPL-Modelo2-com-mais-de-99-Registros
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/

User Function xModelo2()
    Local nOpcx:=3
    Local nInd
    
    dbSelectArea("Sx3")
    dbSetOrder(1)
    dbSeek("SZ7")
    nUsado:=0
    aHeader:={}
    While !Eof() .And. (x3_arquivo == "SZ7")
        IF X3USO(x3_usado) .AND. cNivel >= x3_nivel
            nUsado:=nUsado+1    
            AADD(aHeader,{ TRIM(x3_titulo),x3_campo,;
            x3_picture,x3_tamanho,x3_decimal,,x3_usado,;
            x3_tipo, x3_arquivo, x3_context } )    
        Endif
    dbSkip()    
    End    

    aCols:= Array(1,nUsado+1)
    dbSelectArea("Sx3")
    dbSeek("SZ7")
    nUsado:=0
    While !Eof() .And. (x3_arquivo == "SZ7")
        IF X3USO(x3_usado) .AND. cNivel >= x3_nivel
            nUsado:=nUsado+1     
            IF nOpcx == 3     
                IF x3_tipo == "C"    
                    aCOLS[1][nUsado] := SPACE(x3_tamanho)     
                Elseif x3_tipo == "N"     
                    aCOLS[1][nUsado] := 0     
                Elseif x3_tipo == "D"     
                 aCOLS[1][nUsado] := dLOJABase     
                Elseif x3_tipo == "M" 
                    aCOLS[1][nUsado] := ""    
                Else 
                    aCOLS[1][nUsado] := .F.     
                Endif     
            Endif     
        Endif     
        dbSkip()
    End
    
    aCOLS[1][nUsado+1] := .F.

    cFil     :=Space(2)    
    cNum     :=Space(6)    
    dEmissao :=Space(10)  
    cForn    :=Space(6)
    cLoja    :=Space(2)
    cUser    :=Space(6)
    nLinGetD:=0       
    cTitulo:="Solicitação de Compras-Modelo2"       
    //+----------------------------------------------+
    //¦ Array com descricao dos campos do Cabecalho ¦
    //+----------------------------------------------+
    aC:={}       
        AADD(aC,{"cFil" ,   {20,10} ,"Filial ","@!",,,.F.})     
        AADD(aC,{"cNum" ,   {20,45},"Numero","@!",,,})             
        AADD(aC,{"dEmissao",{20,110} ,"Data de Emissao ",,,,})          
        AADD(aC,{"cUser" ,  {20,205},"Usuario ","@!",,,.F.})
        AADD(aC,{"cForn" ,  {20,280},"Fornecedor ","@!",,"SA2",})           
        AADD(aC,{"cLoja" ,  {20,360},"Loja ","@!",,,})              
    
    dEmissao := Date()
    cUser    := RETCODUSR()
    cFil     := FWxFilial()         
    //+-------------------------------------------------+
    //¦ Array com descricao dos campos do Rodape ¦
    //+-------------------------------------------------+    
    aR:={}    
    AADD(aR,{"nLinGetD" ,{10,10},"Linha na GetDados", "@E 999",,,.F.})    
    //+------------------------------------------------+
    //¦ Array com coordenadas da GetDados no modelo2 ¦
    //+------------------------------------------------+      
    aCGD:={100,5,100,200}           
    //+----------------------------------------------+
    //¦ Validacoes na GetDados da Modelo 2 ¦
    //+----------------------------------------------+    
    cLinhaOk := "ExecBlock('Md2LinOk',.f.,.f.)"
    cTudoOk := "ExecBlock('Md2TudOk',.f.,.f.)"    
    //+----------------------------------------------+
    //¦ Chamada da Modelo2 ¦
    //+----------------------------------------------+
    lRet:= Modelo2(CTITULO,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk, , , ,999,,,.T.,)    
    If lRet
        //Inclui os Registros na tabela SZ7
        For nInd := 1 to len( aCols )
        If !(aCols[nInd][len(aHeader)+1]) //não foi deletado
            // tratamento do motivo para apontamentos de horas não vinculados à OP 
            // retirada a validação de apontamentos existentes desta área e a movemos para função que valida todo o vetor acols - MG 
            RecLock("SZ7",.t.)            
            Replace SZ7->Z7_FILIAL with FWxFilial('SZ7') , ; 
            SZ7->Z7_NUM        with aCols[nInd][aScan( aHeader, { |x| x[2]="Z7_NUM" } )] , ;
            SZ7->Z7_EMISSAO    with aCols[nInd][aScan( aHeader, { |x| x[2]="Z7_EMISSAO" } )] , ;
            SZ7->Z7_LOJA       with aCols[nInd][aScan( aHeader, { |x| x[2]="Z7_LOJA" } )] , ; 
            SZ7->Z7_FORNECE    with aCols[nInd][aScan( aHeader, { |x| x[2]="Z7_FORNECE" } )], ;    
            SZ7->Z7_USER       with aCols[nInd][aScan( aHeader, { |x| x[2]="Z7_USER" } )]     
            SZ7->(MsUnlock())     
        EndIf
        Next
    EndIf
Return lRet
    
    User function Md2LinOk()    
    //Msginfo("Validando a linha")    
    Return .t.
    
    User function Md2TudOk()    
    //Msginfo("Validando o Formulário")    
    Return .t.
    
    User function Md2valid()    
    //Msginfo("Validando")    
    Return .t.    
    
    User function MD2VLPED()    
    //Msginfo("Validando")    
    Return .t.
/*    nOpcx:=3        
//+-----------------------------------------------+
//¦ Montando aHeader para a Getdados ¦
//+-----------------------------------------------+
    dbSelectArea("Sx3")
    dbSetOrder(1)
    dbSeek("SX5")
    nUsado:=0
    aHeader:={}
    
    While !Eof() .And. (x3_arquivo == "SX5")    
        IF X3USO(x3_usado) .AND. cNivel >= x3_nivel        
            nUsado:=nUsado+1        
            AADD(aHeader,{ TRIM(x3_titulo),x3_campo,;           
            x3_picture,x3_tamanho,x3_decimal,;           
            ".T.",x3_usado,;           
            x3_tipo, x3_arquivo, x3_context } )    
        Endif   
    dbSkip()
    End    
//+-----------------------------------------------+
//¦ Montando aCols para a GetDados ¦
//+-----------------------------------------------+
    aCols:=Array(1,nUsado+1)
    dbSelectArea("Sx3")
    dbSeek("SX5")
    nUsado:=0
    
    While !Eof() .And. (x3_arquivo == "SX5")    
        IF X3USO(x3_usado) .AND. cNivel >= x3_nivel        
            nUsado:=nUsado+1        
            IF nOpcx == 3           
                IF x3_tipo == "C"             
                    aCOLS[1][nUsado] := SPACE(x3_tamanho)                
                    Elseif x3_tipo == "N"                    
                         aCOLS[1][nUsado] := 0                
                    Elseif x3_tipo == "D"                    
                         aCOLS[1][nUsado] := dLOJABase                
                    Elseif x3_tipo == "M"                    
                        aCOLS[1][nUsado] := ""                
                    Else                    
                    aCOLS[1][nUsado] := .F.                
                Endif            
            Endif        
        Endif   
        dbSkip()
    End
    
   aCOLS[1][nUsado+1] := .F.
 //+----------------------------------------------+
 //¦ Variaveis do Cabecalho do Modelo 2 ¦
 //+----------------------------------------------+
   cCliente:=Space(6)
   cLoja   :=Space(2)
   dLOJA   :=Date()
 //+----------------------------------------------+
 //¦ Variaveis do Rodape do Modelo 2
 //+----------------------------------------------+
   nLinGetD:=0
   cTitulo:="TESTE DE MODELO2"
 //+----------------------------------------------+
 //¦ Array com descricao dos campos do Cabecalho ¦
 //+----------------------------------------------+   
   aC:={}
   
   #IFDEF WINDOWS 
// AADD(aCab,{"Variável",{L,C}  ,"Título","Picture","Valid","F3",lEnable})
   AADD(aC,{"cCliente" ,{15,10} ,"Cod. do Cliente","@!",,"SA1",}) 
   AADD(aC,{"cLoja"    ,{15,200},"Loja","@!",,,}) 
   AADD(aC,{"dData"    ,{27,10} ,"Data de Emissao",,,,})
   #ELSE 
   AADD(aC,{"cCliente" ,{6,5} ,"Cod. do Cliente","@!",,"SA1",})
   AADD(aC,{"cLoja"    ,{6,40},"Loja","@!",,,}) 
   AADD(aC,{"dData"    ,{7,5} ,"Data de Emissao",,,,})
   #ENDIF
 //+-------------------------------------------------+
 //¦ Array com descricao dos campos do Rodape ¦
 //+-------------------------------------------------+  
   aR:={}
   
   #IFDEF WINDOWS 
   AADD(aR,{"nLinGetD" ,{120,10},"Linha na GetDados", "@E 999",,,.F.})
   #ELSE 
   AADD(aR,{"nLinGetD" ,{19,05},"Linha na GetDados","@E 999",,,.F.})
   #ENDIF
 //+------------------------------------------------+
 //¦ Array com coordenadas da GetDados no modelo2 ¦
 //+------------------------------------------------+   
   #IFDEF WINDOWS    
   aCGD:={44,5,118,315}
   #ELSE    
   aCGD:={10,04,15,73}
   #ENDIF
 //+----------------------------------------------+
 //¦ Validacoes na GetDados da Modelo 2 ¦
 //+----------------------------------------------+
   //cLinhaOk := "ExecBlock('Md2LinOk',.f.,.f.)"
   //cTudoOk  := "ExecBlock('Md2TudOk',.f.,.f.)"
   lRet:=Modelo2(cTitulo,aC,aR,aCGD,nOpcx,.T.,.T.)
   
Return lRet
*/
