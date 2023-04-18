#INCLUDE 'Protheus.CH'

/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
---Data---|-----Autor-------|-------Descrição------------
17/02/2023| Filipe Souza    | Gráfico com a ferramenta FWChartBar
@see https://tdn.totvs.com.br/display/public/framework/FWChartBar
@see https://terminaldeinformacao.com/2016/09/06/criando-graficos-advpl-fwchartbar/
    – FWChartBar    – Gráficos de Barra
    – FWChartBarComp– Gráficos de Barra (Comparação)
    – FWChartLine   – Gráficos de Linha
    – FWChartPie    – Gráficos de Pizza
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
*/
User Function Graf001()
    Local oChart
    Local oDlg
    Local aRand :={}

    //criar janela para exiição do gráfico
    DEFINE MSDIALOG oDlg PIXEL FROM 0,0 TO 500,700
        oChart := FWChartBar():New()
                //oOwner,lSerieLabel,lShadow
        oChart:Init(oDlg,.T.,.T.)
        oChart:SetTitle("Vendas por Mês",CONTROL_ALIGN_CENTER)
        //Adiciona as séries, com as descrições e valores
        oChart:addSerie("Ano 2019", 20044453.50)
        oChart:addSerie("Ano 2020", 21044453.35)
        oChart:addSerie("Ano 2021", 22044453.15)
        oChart:addSerie("Ano 2022", 23044453.10)
        oChart:addSerie("Ano 2023", 25544453.01)
         
        //Define que a legenda será mostrada na esquerda
        oChart:setLegend( CONTROL_ALIGN_LEFT )
         
        //Seta a máscara mostrada na régua
        oChart:cPicture := "@E 999,999,999,999,999.99"
         
        //Define as cores que serão utilizadas no gráfico
        aAdd(aRand, {"084,120,164", "007,013,017"})
        aAdd(aRand, {"171,225,108", "017,019,010"})
        aAdd(aRand, {"207,136,077", "020,020,006"})
        aAdd(aRand, {"166,085,082", "017,007,007"})
        aAdd(aRand, {"130,130,130", "008,008,008"})
         
        //Seta as cores utilizadas
        oChart:oFWChartColor:aRandom := aRand
        oChart:oFWChartColor:SetColor("Random")
         
        //Constrói o gráfico
        oChart:Build()
    ACTIVATE MSDIALOG oDlg CENTERED

return
