#INCLUDE 'Protheus.ch'
#INCLUDE 'TOTVS.ch'

/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
---Data---|-----Autor-------|-------Descrição------------
10/03/2023| Filipe Souza    | 09 - PE ao clicar no confirmar
                                Este ponto de entrada é executado ao clicar no botão SALVAR da rotina de Manutenção do Pedido de Venda

@see Terminal da Informação
Pontos de Entrada na rotina "Pedidos de Venda (MATA410)"
@see https://centraldeatendimento.totvs.com/hc/pt-br/articles/7381576110871-Cross-Segmentos-Backoffice-Protheus-SIGAFAT-Pontos-de-Entrada-na-rotina-Pedidos-de-Venda-MATA410
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
*/
User Function MT410TOK()
    Local aArea     := FwGetArea()
    Local lContinua :=.T.
    Local cVended   :=""
    Local cTipoPed  :=""
    Local cTitle    :='Help_MT410TOK'
    Local cProblema := 'Para pedido do tipo Normal(N), é obrigatorio preencher o campo de código do vendedor!'
    Local cSoluction:= 'Preencha a informação no campo C5_VEND1'

    //pega o campo de vendedor e tipo de pedido
    cVended:=M->C5_VEND1
    cTipoPed:=M->C5_TIPO

    //se a data de entrega estiver atrasada ou a diferença for maior que 30 dias, nao prossegue.
    if cTipoPed =="N" .AND. Empty(cVended)
        ExibeHelp(cTitle,cProblema,cSoluction)                                                            
        lContinua:=.F.
    EndIf
    FwRestArea(aArea)    
return lContinua
