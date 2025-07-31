#Include "Protheus.ch"
/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
---Data---|-----Autor-------|-------Descri��oo------------
11/04/2023| Filipe Souza    | Ponto de entrada utilizado para validar a inclus�o e/ou altera��o do cadastro de transportadora.
                                Programa Fonte MATA050
                                busca conte�do do codigo atual do campo j�  incrementado pelo inicializador padr�o
                                para atualizar seu par�metro.

@see https://centraldeatendimento.totvs.com/hc/pt-br/articles/13290945108503-Cross-Segmentos-TOTVS-Backoffice-Linha-Protheus-SIGAFAT-Pontos-de-Entrada-da-rotina-MATA050
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
*/
User Function M050TOK()
    Local lRet  := .F.
    Local aArea :=FwGetArea()
    Local cCod  :=""

    //busca conte�do do codigo atual do campo j�  incrementado pelo inicializador padr�o
    cCod:= M->A4_COD
    If !Empty(cCod)
        PutMV('MV_CODSA4',cCod)//atualizar par�metro
        lRet:=.T.
    EndIf

    FwAlertSuccess("Cadastrado com sucesso transportadora:"+cCod)
    FwRestArea(aArea)
Return lRet
