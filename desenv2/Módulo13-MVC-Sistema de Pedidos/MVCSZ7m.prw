#INCLUDE 'Protheus.ch'

/*++++DATA++++|++++AUTOR+++++|++++++++++++++++DESCRIÇÂO+++++++++++++
  10/03/2023  | Filipe Souza |  PE, validação na grid limitar para 10 qtd
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/

User Function MVCSZ7m()
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
   
    // verificar se está null, quer dizer que algumas ação está sendo feita nomodelo
    if aParam[2] <> NIL
        //se estiver na validação da linha na grid de itens
        if cIdPonto =='FORMLINEPOS'
            //Função que busca o valor do campo na linha do grid
            If FwFldGet('Z7_QUANT') > 10 
                HELP(Nil,Nil,'Validação' ,Nil,'<b>Atenção</b>!'+cL+'Quantidade não permitida',1,0,Nil,Nil,Nil,Nil,Nil,;
                {'Quantidade limitada até 10'})
            xRet    := .F.        
            EndIf
        endif            
    endif


RETURN xRet

