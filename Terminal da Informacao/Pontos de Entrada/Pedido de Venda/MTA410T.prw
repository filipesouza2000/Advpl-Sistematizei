#INCLUDE 'Protheus.ch'
#INCLUDE 'TOTVS.ch'

/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
---Data---|-----Autor-------|-------Descrição------------
12/03/2023| Filipe Souza    | 12 - PE após a gravação
                                Envio de e-mail em html com informação do registro novo ou copiado de pedido de vendas.
                                

@see Terminal da Informação
Pontos de Entrada na rotina "Pedidos de Venda (MATA410)"
@see https://centraldeatendimento.totvs.com/hc/pt-br/articles/7381576110871-Cross-Segmentos-Backoffice-Protheus-SIGAFAT-Pontos-de-Entrada-na-rotina-Pedidos-de-Venda-MATA410
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
*/
User Function MTA410T()
    Local aArea   := FwGetArea()
    Local cBody   :=""
    Local cAssunto:=""
    Local cPara   :=""
    Local nPosProd:=GDFieldPos("C6_PRODUTO")
    Local nPosDesc:=GDFieldPos("C6_DESCRI")
    Local nPosQtd :=GDFieldPos("C6_QTDVEN")
    Local nPosVlUn:=GDFieldPos("C6_PRCVEN")
    Local nPosVTot:=GDFieldPos("C6_VALOR")
    Local nAtual  :=0
   
    //se for Inclusão u cópia e o tipo de pedido for Normal
    If (INCLUI .OR. FwIsInCallStack("a410Copia")) .AND. SC5->C5_TIPO =="N"
        cBody:="<p><h1><b>PEDIDO DE VENDA</b></h1></p>"
        cBody+="<p>Foi incluído novo Pedido de Venda no Sistema, abaixo as informações:</p>"
        cBody+="<p><b>Pedido:</b>"          +SC5->C5_NUM +"<p>"
        cBody+="<p><b>Cliente:</b>"         +SC5->C5_CLIENTE +" ( " + Alltrim(Posicione('SA1',1,FwxFilial('SA1')+SC5->C5_CLIENTE+SC5->C5_LOJACLI,'A1_NREDUZ')) +  " )</p>"
        cBody+="<p><b>Vendedor:</b>"        +SC5->C5_VEND1   +" ( " + Alltrim(Posicione('SA3',1,FwxFilial('SA3')+SC5->C5_VEND1,'A3_NOME')) +  " )</p>"
        cBody+="<p><b>Cond. Pagamento:</b>" +SC5->C5_CONDPAG +" ( " + Alltrim(Posicione('SE4',1,FwxFilial('SE4')+SC5->C5_CONDPAG,'E4_DESCRI')) +  " )</p>"
        cBody+="<p><b>Itens:</b></p>"
        cBody+="<center><table border='1'><tr>"
        cBody+="<td><b>Produto</b></td>"
        cBody+="<td><b>Descrição</b></td>"
        cBody+="<td><b>Qtd</b></td>"
        cBody+="<td><b>Val. Unit.</b></td>"
        cBody+="<td><b>Val. Total</b></td>"
        cBody+="</tr>"
        for nAtual := 1 to Len(aCols)
            cBody+="<tr>"
            cBody+="<td>"+ Alltrim(aCols[nAtual][nPosProd])+" </td>"
            cBody+="<td>"+ Alltrim(aCols[nAtual][nPosDesc])+" </td>"
            cBody+="<td>"+ Alltrim(Str(aCols[nAtual][nPosQtd]))+" </td>"
            cBody+="<td>"+ Transform(aCols[nAtual][nPosVlUn], "@E 999,999.99")+" </td>"
            cBody+="<td>"+ Transform(aCols[nAtual][nPosVTot], "@E 999,999.99")+" </td>"
            cBody+="</tr>"               
        next
        cBody+="</table></center>" 
        cBody+="<p>Mensagem disparada em <em>"+ DToC(Date()) + "</em> às <em>"+Time()+"</em></p>"
        cAssunto:= "Pedido de Venda - "+ SC5->C5_NUM        
        cPara   := "filipesouza2000@gmail.com"
        
        GPEmail(cAssunto,cBody,cPara,/*aAnexo*/,/*lhelp*/)
    EndIf
    

   
    FwRestArea(aArea)    
return 
