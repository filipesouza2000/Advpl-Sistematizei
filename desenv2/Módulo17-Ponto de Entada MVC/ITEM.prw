#INCLUDE 'Protheus.ch'

/*++++DATA++++|++++AUTOR+++++|++++++++++++++++DESCRIÇÂO+++++++++++++
  27/03/2023  | Filipe Souza |  Escopo: codigo do produto deve conter nomínimo 10 caracteres
                                descrição deve conter 15 caracteres obrigatórios.
  30/03/2023  | Filipe Souza |  Bloquear a operação de excluir. 
                                Confirmação para cancelamento.                               
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
User Function ITEM()
    //parametro PE em MVC contendo informações sobre o estado e ponto de execução da rotina
    Local aParam        := PARAMIXB
    
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
        //verifica se o cod do produto a partir de 10 caracteres
            If Len(Alltrim(M->B1_COD)) < 10
                HELP(Nil,Nil,'COD PRODUTO' ,Nil,'Código não permitido',1,0,Nil,Nil,Nil,Nil,Nil,;
                {'O Código <b>'+Alltrim(M->B1_COD)+'</b> deve ter a partir de 10 caracteres.'})
                xRet:=.F.
            elseif Len(Alltrim(M->B1_DESC)) < 15
                HELP(Nil,Nil,'DESC PRODUTO' ,Nil,'Descrição não permitida',1,0,Nil,Nil,Nil,Nil,Nil,;
                {'A descrição <b>'+Alltrim(M->B1_DESC)+'</b> deve ter a partir de 15 caracteres.'})                
                xRet:=.F.
            EndIf  
        elseif cIdPonto == 'MODELCANCEL'
                xRet:= FwAlertNoYes('Certeza de cancelar operação?','Confirmação')                      
        elseif nOperation == 5 //exclusão    
            HELP(Nil,Nil,'Exclusão de Produto' ,Nil,'Exclusão não permitida',1,0,Nil,Nil,Nil,Nil,Nil,;
                {'Produtos não podem ser excluídos!<br>Consulte departamento de TI'})                
                xRet:=.F.
        endif
    endif


RETURN xRet
