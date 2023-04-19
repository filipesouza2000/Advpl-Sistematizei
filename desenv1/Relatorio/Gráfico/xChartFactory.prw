#include 'protheus.ch'

User Function xChartFactory()
    Local oDlg
    Local oChart
    Local oPanel
    Local oPanel2
    DEFINE DIALOG oDlg TITLE "Graficos-FWChartFactory" SIZE 800,800 PIXEL
     
    oPanel:= TPanel():New( , ,,oDlg,,,,,, 0,  50)
    oPanel:Align := CONTROL_ALIGN_TOP
     
    oPanel2:= TPanel():New( , ,,oDlg,,,,,, 0,  0)
    oPanel2:Align := CONTROL_ALIGN_ALLCLIENT
    TButton():New( 10, 10, "Refresh",oPanel,{||BtnClick(oChart)},45,15,,,.F.,.T.,.F.,,.F.,,,.F. )
    oChart := FWChartFactory():New()
    oChart:SetOwner(oPanel2)
     
     
    //Para graficos multi serie, definir a descricao pelo SetxAxis e passar array no addSerie
    /*oChart:SetXAxis( {"periodo um", "periodo dois", "periodo tres"} )
     
    oChart:addSerie('Apresentação teste', {  96, 33, 10 } )
    oChart:addSerie('Qualificação teste', {  100, 33, 10 } )
    oChart:addSerie('Fechamento teste', {  99, 36, 10 } )
    oChart:addSerie('Pós Venda', { 80, 100, 10 } )
    */
     
    //Para graficos de serie unica utilizar conforme abaixo
    oChart:addSerie('Apresentação teste',   96 )
    oChart:addSerie('Qualificação teste',   100  )
    oChart:addSerie('Fechamento teste',   99 )
    oChart:addSerie('Pós Venda',  80 )
     
    //Picture   
    oChart:setPicture("@E 999,999,999.99")
     
    //Mascara
    oChart:setMask("R$ *@*")
     
    //Adiciona Legenda
    //opções de alinhamento da legenda:
    //CONTROL_ALIGN_RIGHT | CONTROL_ALIGN_LEFT | CONTROL_ALIGN_TOP | CONTROL_ALIGN_BOTTOM
    oChart:SetLegend(CONTROL_ALIGN_LEFT)

    //Titulo
    //opções de alinhamento do titulo:
    //CONTROL_ALIGN_RIGHT | CONTROL_ALIGN_LEFT | CONTROL_ALIGN_CENTER
    oChart:setTitle("Titulo do Grafico", CONTROL_ALIGN_CENTER) //"Oportunidades por fase"
     
    //Opções de alinhamento dos labels(disponível somente no gráfico de funil):
    //CONTROL_ALIGN_RIGHT | CONTROL_ALIGN_LEFT | CONTROL_ALIGN_CENTER
    oChart:SetAlignSerieLabel(CONTROL_ALIGN_RIGHT)
     
    //Desativa menu que permite troca do tipo de gráfico pelo usuário
    oChart:EnableMenu(.F.)
             
    //Define o tipo do gráfico
    oChart:SetChartDefault(FUNNELCHART)
    // Opções disponiveis
    // RADARCHART  
    // FUNNELCHART 
    // COLUMNCHART 
    // NEWPIECHART 
    // NEWLINECHART
    //-----------------------------------------
 
    oChart:Activate()
     
    ACTIVATE DIALOG oDlg CENTERED
Return
  
 
Static function BtnClick(oChart)
     
        oChart:DeActivate()
         
        //Para graficos multi serie, definir a descricao pelo SetxAxis e passar array no addSerie
        /*oChart:SetXAxis( {"periodo um", "periodo dois", "periodo tres"} )
             
        oChart:addSerie('WApresentação teste', {  Randomize(1,20), Randomize(1,20), Randomize(1,20) } )
        oChart:addSerie('AQualificação teste', {  Randomize(1,20), Randomize(1,20), Randomize(1,20) } )
        oChart:addSerie('EFechamento teste', {  Randomize(1,20), Randomize(1,20), Randomize(1,20) } )
        oChart:addSerie('BPós Venda', { Randomize(1,20), Randomize(1,20), Randomize(1,20) } )
    */
     
    //Para graficos de serie unica utilizar conforme abaixo
      
        oChart:addSerie('Apresentação teste',   Randomize(1,20) )
        oChart:addSerie('Qualificação teste',   Randomize(1,20)  )
        oChart:addSerie('Fechamento teste',   Randomize(1,20)  )
        oChart:addSerie('Pós Venda',  Randomize(1,20)  )
     
         
        oChart:Activate()
         
     
Return
