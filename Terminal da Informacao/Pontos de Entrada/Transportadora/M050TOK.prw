#Include "Protheus.ch"
/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
---Data---|-----Autor-------|-------Descriçãoo------------
11/04/2023| Filipe Souza    | Ponto de entrada utilizado para validar a inclusão e/ou alteração do cadastro de transportadora.
                                Programa Fonte MATA050
                                busca conteúdo do codigo atual do campo já  incrementado pelo inicializador padrão
                                para atualizar seu parâmetro.

@see https://centraldeatendimento.totvs.com/hc/pt-br/articles/13290945108503-Cross-Segmentos-TOTVS-Backoffice-Linha-Protheus-SIGAFAT-Pontos-de-Entrada-da-rotina-MATA050
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
*/
User Function M050TOK()
    Local lRet  := .F.
    Local aArea :=FwGetArea()
    Local cCod  :=""

    //busca conteúdo do codigo atual do campo já  incrementado pelo inicializador padrão
    cCod:= M->A4_COD
    If !Empty(cCod)
        PutMV('MV_CODSA4',cCod)//atualizar parâmetro
        lRet:=.T.
    EndIf

    FwAlertSuccess("Cadastrado com sucesso transportadora:"+cCod)
    FwRestArea(aArea)
Return lRet
