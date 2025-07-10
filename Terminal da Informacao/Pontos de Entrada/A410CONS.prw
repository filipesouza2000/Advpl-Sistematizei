#INCLUDE 'Protheus.ch'
#INCLUDE 'TOTVS.ch'

/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
---Data---|-----Autor-------|-------Descri��o------------
10/03/2023| Filipe Souza    | 07 -PE Adicionar bot�es na EnchoiceBar, ao abrir Pedido de Venda
                                Ponto de entrada disparado no momento de montar a enchoicebar do pedido de vendas
                                Apresenta dados do cliente e dos porodutos em janela de log

@see Terminal da Informa��o
Pontos de Entrada na rotina "Pedidos de Venda (MATA410)"
@see https://centraldeatendimento.totvs.com/hc/pt-br/articles/7381576110871-Cross-Segmentos-Backoffice-Protheus-SIGAFAT-Pontos-de-Entrada-na-rotina-Pedidos-de-Venda-MATA410
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
*/
User Function A410CONS()
    Local aArea     := FwGetArea()
    Local aButtons  :={}
  
    aadd(aButtons,{'DBG07',{|| U_xPeEnch()},"*A410CONS","*Atualizar Entrega"})
    FwRestArea(aArea)
return aButtons

//Fun��o altera��o da Data de Entrega para hoje
User Function xPeEnch()
    Local aArea     := FwGetArea()//SC5
    Local nLinha    :=0
    Local nPosDTEnt :=GDFieldPos("C6_ENTREG")
    Local nPosItem  :=GDFieldPos("C6_ITEM")
    Local nPosValor :=GDFieldPos("C6_VALOR")
    Local nPosProd  :=GDFieldPos("C6_PRODUTO")
    Local cItem     :=""
    Local nValor    :=0
    Local cProd     :=""
    Local cDtEntr   :=""
    Local cMsg      :=""
    Local nTotal    :=0

    If FwAlertYesNo("Confirma altera��o da Data de Entrega para hoje? Coluna:"+cValToChar(nPosDTEnt),"Continua")        
        cDtEntr:=aCols[1][nPosDTEnt]
        cMsg+="PEDIDO - "+ SC5->C5_NUM + CRLF
        cMsg+="CLIENTE: "+ SC5->C5_CLIENTE + " - "+ Posicione('SA1',1,"  "+SC5->C5_CLIENTE+SC5->C5_LOJACLI,'A1_NOME') +CRLF        
        cMsg+="--------------------------------------" + CRLF
        for nLinha := 1 to Len(aCols)
            If !GDDeleted(nLinha)                                
                cItem     :=aCols[nLinha][nPosItem]
                nValor    :=aCols[nLinha][nPosValor]
                cProd     :=Alltrim(aCols[nLinha][nPosProd])
                GDFieldPut("C6_ENTREG",Date(),nLinha)
                cMsg+= cItem +" - "+ cProd+" - "
                cMsg+= Alltrim( SC6->C6_DESCRI)
                cMsg+= "  R$ "+Alltrim(Transform(nValor,"@E 99,999,999,999.99"))+CRLF
                nTotal+= nValor                                            
            EndIf 
        next         
        cMsg+="--------------------------------------" + CRLF 
        cMsg+="Total: R$"+Alltrim(Transform(nTotal,"@E 99,999,999,999.99"))+ CRLF 
        cMsg+="Entrega de "+ DtoC(cDtEntr)  +" para "+ DtoC(Date()) + CRLF
        cMsg+="______________________________________" + CRLF
        cMsg+="**** CONFIRA PARA SALVAR NO BROWSE ****"
        //fun��es que exibem uma tela de visualiza��o de Logs
        //Exemplo usando a ShowLog (s� manda texto, sem op��o de alterar t�tulo)
        //ShowLog(cMsg)
        //Exemplo usando a AtShowLog (al�m do texto, � poss�vel enviar o t�tulo, se vai ter rolagem vertical, rolagem horizontal, se vai quebrar palavras ao trocar de linha e por �ltimo se ter� bot�o de cancelar)
        //Nesse caso, tamb�m � poss�vel capturar o retorno da AtShowLog, se o usu�rio clicar no Ok retorna .T. ou se clicar no Cancelar retorna .F.
        AtShowLog(cMsg, "AtShowLog", /*lVScroll*/, /*lHScroll*/, /*lWrdWrap*/, .T./*lCancel*/)            
        //Exemplo usando a AutoGrLog junto com a MostraErro, sendo que al�m de exibir o log, tamb�m � poss�vel salvar ele em um arquivo direto clicando em bot�o
        //AutoGrLog(cMsg)
        //MostraErro()                
        
    EndIf
  
    FwRestArea(aArea)

return
