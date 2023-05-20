#INCLUDE 'Protheus.ch'

/*++++DATA++++|++++AUTOR+++++|++++++++++++++++DESCRIÇÂO+++++++++++++
  01/04/2023  | Filipe Souza |  Escopo: Ponto de entrada 'Fornecedor' Na confirmação do cadastro, 
                                validar campo Razão Social para conter mínimo de 20 caracteres,
                                e Validar campo nome de fantasia conter mínimo de 10 caracteres.
                                Adicionar botão para acessar módulo ProdutoXFornecedor
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
User Function CUSTOMERVENDOR()
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
            //verifica se razão social contem a partir de 20 caracteres
            If Len(Alltrim(M->A2_NOME)) < 20
                HELP(Nil,Nil,'RAZÃO SOCIAL' ,Nil,'Conteúdo não permitido',1,0,Nil,Nil,Nil,Nil,Nil,;
                {'A Razão Social <b>'+Alltrim(M->A2_NOME)+'</b><br> deve conter a partir de 20 caracteres.'})
                xRet:=.F.
            //verifica se nome de fantasia contem a partir de 10 caracteres
            elseif Len(Alltrim(M->A2_NREDUZ)) < 10//
                HELP(Nil,Nil,'NOME DE FANTASIA' ,Nil,'Conteúdo não permitido',1,0,Nil,Nil,Nil,Nil,Nil,;
                {'Nome de Fantasia <b>'+Alltrim(M->A2_NREDUZ)+'</b><br> deve conter a partir de 10 caracteres.'})                
                xRet:=.F.
            EndIf
        //adicionar botão para acessar módulo ProdutoXFornecedor    
        elseif cIdPonto =='BUTTONBAR'
                xRet:= {{"ProdXForn","ProdXForn",{|| MATA061()},"Abre o módulo de amarração Produto X Fornecedor"}}
        endif
    endif


RETURN xRet
