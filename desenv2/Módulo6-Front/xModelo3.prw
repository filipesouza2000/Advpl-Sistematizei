#include "protheus.ch"
#include "rwmake.ch"    

/*++++DATA++++|++++AUTOR+++++|++++++++++++++++DESCRIÇÂO+++++++++++++
  11/10/2022  | Filipe Souza | Modelo 3 convencional
                               Exibe formulário para cadastro contendo uma enchoice e uma getdados.
@see https://tdn.totvs.com/display/public/framework/Modelo3

erro no inicializador padrão 
C5_MONMOT nome do motorista
C6_INFAD  
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 
User Function xModelo3()
    Local cOpcao        as character
    Local nOpcE         as numeric
    Local nOpcG         as numeric
    Local nUsado        as numeric
    Local _ni           as numeric
    
    Private aHeader     as array
    Private aRotina     as array
    Private aCols       as array
    
    aRotina := {{ "Pesquisa","AxPesqui", 0 , 1}, { "Visual","AxVisual", 0 , 2}, { "Inclui","AxInclui", 0 , 3}, { "Altera","AxAltera", 0 , 4, 20 }, { "Exclui","AxDeleta", 0 , 5, 21 }}
    
    //+--------------------------------------------------------------+
    //| Opcoes de acesso para a Modelo 3                             |
    //+--------------------------------------------------------------+
    cOpcao:= "INCLUIR"
    
    Do Case
        Case cOpcao=="INCLUIR"; nOpcE:=3 ; nOpcG:=3
        Case cOpcao=="ALTERAR"; nOpcE:=3 ; nOpcG:=3
        Case cOpcao=="VISUALIZAR"; nOpcE:=2 ; nOpcG:=2
    EndCase
    
    DbSelectArea("SC5")
    DbSetOrder(1)
    DbGotop()
    
    //+--------------------------------------------------------------+
    //| Cria variaveis M->????? da Enchoice                          |
    //+--------------------------------------------------------------+
    RegToMemory("SC5", (cOpcao=="INCLUIR"))
    //+--------------------------------------------------------------+
    //| Cria aHeader e aCols da GetDados                             |
    //+--------------------------------------------------------------+
    nUsado := 0
    
    dbSelectArea("SX3")
    DbSetOrder(1)
    DbSeek("SC6")
    aHeader := {}
    While !Eof() .And. (X3_ARQUIVO == "SC6")   
        If Alltrim(X3_CAMPO) == "C6_ITEM"      
            dbSkip()       
            Loop   
        Endif  
        If X3USO(X3_USADO) .And. cNivel >= X3_NIVEL     
            nUsado := nUsado+1       
            Aadd(aHeader,{ TRIM(X3_TITULO),;
                            AllTrim(X3_CAMPO),;
                            X3_PICTURE,;
                            X3_TAMANHO,;
                            X3_DECIMAL,;
                            "AllwaysTrue()",;
                            X3_USADO,;
                            X3_TIPO,;
                            X3_ARQUIVO,;
                            X3_CONTEXT } ) 
        Endif
        dbSkip()
    EndDo
    
    If cOpcao == "INCLUIR" 
        aCols:={Array(nUsado+1)}   
        aCols[1, nUsado+1] := .F.  
    
        For _ni := 1 to nUsado     
            aCols[1, _ni] := CriaVar(aHeader[_ni, 2])  
        Next
    Else   
        aCols := {}
        dbSelectArea("SC6")
        dbSetOrder(1)  
        dbSeek(xFilial()+M->C5_NUM) 
        While !eof() .and. SC6->C6_NUM == M->C5_NUM      
            AADD(aCols, Array(nUsado+1))       
    
            For _ni := 1 to nUsado         
                aCols[Len(aCols), _ni] := FieldGet(FieldPos(aHeader[_ni, 2]))      
            Next       
    
            aCols[Len(aCols), nUsado+1] := .F.     
            dbSkip()   
        EndDo
    Endif
        
    If Len(aCols) > 0   
    //+--------------------------------------------------------------+ 
    //| Executa a Modelo 3                                           | 
    //+--------------------------------------------------------------+ 
        cTitulo := "Teste de Modelo3"  
        cAliasEnchoice := "SC5"
        cAliasGetD := "SC6"
        cLinOk := "AllwaysTrue()"  
        cTudOk := "AllwaysTrue()"  
        cFieldOk := "AllwaysTrue()"
        _lRet:= Modelo3(cTitulo, cAliasEnchoice, cAliasGetD,, cLinOk, cTudOk, nOpcE, nOpcG, cFieldOk)  
        //+--------------------------------------------------------------+ 
        //| Executar processamento                                       | 
        //+--------------------------------------------------------------+ 
        If _lRet       
            Aviso("Modelo3()", "Confirmada operacao!", {"Ok"}) 
        Endif
    Endif                
Return
