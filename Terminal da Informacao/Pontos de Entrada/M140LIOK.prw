#INCLUDE 'Protheus.ch'
#INCLUDE 'TOTVS.ch'

/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
---Data---|-----Autor-------|-------Descrição------------
10/03/2023| Filipe Souza    | 08 - PE ao alternar uma linha
                                Ponto de entrada disparado ao confirmar linha de itens do pedido de vendas,
                                se a data de entrega estiver atrasada ou a diferença for maior que 30 dias, nao prossegue.
Função ExibeHelp
    Parâmetros
        Título que será exibido do Help
        Mensagem do Problema
        Mensagem da Solução
    Retorno
        Não tem retorno
 
    Função ShowHelpDlg
    Parâmetros
        + cCabec     , Caractere     , Título que será exibido do Help
        + aProbl     , Array         , Array com a mensagem de problema
        + nLinProbl  , Numérico      , Número máximo de linhas que serão exibidas do problema
        + aSolucao   , Array         , Array com a mensagem de solução
        + nLinSoluc  , Numérico      , Número máximo de linhas que serão exibidas da solução
    Retorno
        Não tem retorno                                
                                

@see Terminal da Informação
Pontos de Entrada na rotina "Pedidos de Venda (MATA410)"
@see https://centraldeatendimento.totvs.com/hc/pt-br/articles/7381576110871-Cross-Segmentos-Backoffice-Protheus-SIGAFAT-Pontos-de-Entrada-na-rotina-Pedidos-de-Venda-MATA410
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
*/
User Function M410LIOK()
    Local aArea     := FwGetArea()
    Local lContinua :=.T.
    Local nLinha    := n    // em modelos antigos de aCols e aHeader, n é linha atual
    Local dDtEnt    :=StoD("")
    Local dDtHj     :=Date()
    Local nDif      :=0

    //pega data de entrega da linha atual e a diferenã dos dias com data de hoje
    dDtEnt  := aCols[nLinha,GDFieldPos("C6_ENTREG")]
    nDif    :=DateDiffDay(dDtEnt,dDtHj)

    //se a data de entrega estiver atrasada ou a diferença for maior que 30 dias, nao prossegue.
    if dDtHj > dDtEnt .OR. nDif >30
        ExibeHelp('Help_M410LIOK','A data de entrega ['+ DtoC(dDtEnt)+'] esta atrasada ou esta mais que 30 dias da data de hoje.'+dToc(dDtHj);
        ,'Corrija a informacao no campo C6_ENTREG na linha ['+Alltrim(str(nLinha))+"]")                                                            
        lContinua:=.F.
    EndIf
    FwRestArea(aArea)    
return lContinua
