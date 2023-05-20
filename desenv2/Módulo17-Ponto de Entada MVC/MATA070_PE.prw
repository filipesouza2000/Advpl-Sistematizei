#INCLUDE 'Protheus.ch'

/*++++DATA++++|++++AUTOR+++++|++++++++++++++++DESCRIÇÂO+++++++++++++
  01/04/2023  | Filipe Souza |  Ponto de entrada 'Bancos' 
                                Neste caso o IdModel tem o mesmo nome da Function, por isso tem o nome MATA070_PE
                                Escopo:Campos de dígito da agencia e do banco não podem estar vazios.
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
User Function MATA070()
    //parametro PE em MVC contendo informações sobre o estado e ponto de execução da rotina
    Local aParam        := PARAMIXB
    Local cL        :=CHR( 19 )+Chr(13)
/* Retorno do array
1   O  Objeto do formulário ou do modelo, conforme o caso
2   C  ID do local de execução do ponto de entrada
3   C  ID do formulário */
    //variável poderá retornar Lógico ou Array, por isso usa notação Húngaradefinida com X
    Local xRet      := .T.
    Local oObject   := aParam[1]
    Local cIdPonto  := aParam[2]
    Local cIdModel  := aParam[3]
    // captura a operação da aplicação
    Local nOperation    := oObject:GetOperation()
   
    // verificar se está null, quer dizer que algumas ação está sendo feita nomodelo
    if aParam[2] <> NIL
        //se estiver na pós validação
        if cIdPonto =='MODELPOS'
            //verifica se campo Dígito da agencia e dígito da conta estão vazios
            If Empty(M->A6_DVAGE)
                HELP(Nil,Nil,'MATA070' ,Nil,'Conteúdo não permitido',1,0,Nil,Nil,Nil,Nil,Nil,;
                {'Campo Dígito da Agencia pode estar vazio, ou somente com espaço!'+cL+;
                 'Insira conteúdos válidos.'})
                xRet:=.F.            
            elseif Empty(M->A6_DVCTA)
                HELP(Nil,Nil,'MATA070' ,Nil,'Conteúdo não permitido',1,0,Nil,Nil,Nil,Nil,Nil,;
                {'Campo Dígito da Conta pode estar vazio, ou somente com espaço!'+cL+;
                 'Insira conteúdos válidos.'})
                xRet:=.F.            
            EndIf
        endif            
    endif


RETURN xRet
