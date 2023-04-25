#INCLUDE 'Protheus.CH'
#INCLUDE 'TopConn.ch'
#INCLUDE 'RPTDef.ch'
#INCLUDE 'FWPrintSetup.ch'
#include "fileio.ch"

/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
---Data---|-----Autor-------|-------Descrição------------
19/02/2023| Filipe Souza    | exibir as opções de gráfico.
                                – FWChartBar    – Gráficos de Barra
                                – FWChartFunnel – Gráficos de Funil
                                – FWChartLine   – Gráficos de Linha
                                – FWChartPie    – Gráficos de Pizza   
                              Ao confirmar executa a principal GrafType(). 
20/02/2023| Filipe Souza    | Solução de erro:
Ao utilizar a classe FWMsPrinter é apresentado o erro: arquivo. rel não pode ser criado. 
Esse incidente ocorre, pois já existe o arquivo SCXXXXX dentro da pasta System,
impossibilitando a sua criação novamente. 
Para solucionar essa ocorrência, precisará limpar a pasta System todos os arquivos SCXXXXX.
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
*/
User Function Graf003()    
    Local aChart   
    Private nChart :=1
    DEFINE MSDIALOG oDlgOpt TITLE "Opções de Gráfico" FROM 0,0 TO 150,250 PIXEL        
    
    aChart := {'1-Gráfico de Barra','2-Gráfico de Funil','3-Gráfico de Linha','4-Gráfico de  Pizza'}

    oGroupChart:= tGroup():New(05,05,50,110,"Opções de Gráfico",oDlgOpt,,,.T.)
    oRadioChart:= TRadMenu():New(10,10,aChart,{|u|IIF(Pcount()>0,nChart:=u,nChart)},oDlgOpt,,,,,,,,60,80,,,,.T.)

    oBtOK := TButton():New(60,30, "OK"  ,oDlgOpt,{|| U_GrafType() } , 20,10,,,.F.,.T.,.F.,,.F.,,,.F. )     
    oBtOut:= TButton():New(60,60, "Sair",oDlgOpt,{|| oDlgOpt:end()}   , 20,10,,,.F.,.T.,.F.,,.F.,,,.F. )     
    
    ACTIVATE MSDIALOG oDlgOpt CENTER 
return 

User Function GrafType()
    Local aArea     := GetArea()
    Local cNomeRel  :='rel_teste_'+dtos(Date())+StrTran(Time(),':','-')
    Local cDir      :=GetTempPath()
    Local nLCab     :=050
    Local nAlt      :=450
    Local nLarg     :=780
    Local oChart
    Local oDlg
    Local aRand :={}
    Local aNotas:={}
    Local cCli  :=""
    Local aFiles
    Local nX
    Private cHoraEx    := Time()
    Private nPagAtu    := 1
    Private oPrintPvt
    //Fontes
    Private cNomeFont  := "Arial"
    Private oFontRod   := TFont():New(cNomeFont, , -10, , .F.)
    Private oFontTit   := TFont():New(cNomeFont, , -30, , .T.)
    Private oFontSubN  := TFont():New(cNomeFont, , -17, , .T.)
    //Linhas e colunas
    Private nLinAtu     := 0
    Private nLinFin     := 600
    Private nColIni     := 010
    Private nColFin     := 750
    Private nColMeio    := 250

    //Processa({|| Query002()},"Espere","Consultando....")
    U_Query003()
    
    //verificar se existem arquivos SCXXXX para apaga-los
    aFiles := Directory('sc*')
    if len(Directory('sc*')) > 0
        For nX:= 1 to len(Directory('sc*'))
            FErase(CurDir() + aFiles[nX][1])
        Next        
    endif  

    //criando objeto de impressão
    oPrintPvt   := FWMSPrinter():New(cNomeRel,IMP_PDF,.F.,,.T.,,@oPrintPvt,,,,,.T.)
    oPrintPvt:cPathPDF:=GetTempPath()
    oPrintPvt:SetResolution(72)
    oPrintPvt:SetLandscape()
    oPrintPvt:SetPaperSize(DMPAPER_A4)
    oPrintPvt:SetMargin(60,60,60,60)
    oPrintPvt:StartPage()

    //cabeçalho
    oPrintPvt:SayAlign(nLCab,nColMeio,"Relatório Gráfico em ADVPL", oFontTit,400,50,RGB(0,0,255),0,0)
    nLCab+=30
    nLinAtu:=nLCab

    //verificar se o arquivo está aberto
    if File(cDir + 'Graf002.png')
        FErase(cDir+'Graf002.png')
    endif    

    DEFINE MSDIALOG oDlg PIXEL FROM 0,0 TO nAlt,nLarg
    //identificação da opção de gráfico escolhida 
    DO CASE
        CASE nChart == 1
            oChart := FWChartBar():New()
        CASE nChart == 2
            // NÃO EXECUTA ¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢
            oChart := FWChartFunnel():New()
        CASE nChart == 3
            U_xchartLine()//FWChartLine():New()
            return
        CASE nChart == 4
            oChart := FWChartPie():New()
    ENDCASE    

    oChart:Init(oDlg,.T.)//,.T.
    oChart:SetTitle("Vendas por Cliente",CONTROL_ALIGN_CENTER)

    While (TMP->(!EOF()))
        DO CASE         //bar ou    pizza ou        funil
            CASE nChart == 1 .OR. nChart == 3 .OR. nChart == 4 
                oChart:addSerie(TMP->Cliente,TMP->Total)
            CASE nChart == 2 //linha 
              //oChart:addSerie( "Votos PT",  {{"Jan",50}, {"Fev",55}, {"Mar",60} })
                oChart:addSerie( TMP->Cliente,{{DToC(StoD(TMP->Emissao)),TMP->Total}})            
        ENDCASE         
        TMP->(DBSKIP( ))
    End
    oChart:setLegend(CONTROL_ALIGN_LEFT)//CONTROL_ALIGN_BOTTOM

    aAdd(aRand, {"084,120,164", "007,013,017"})
    aAdd(aRand, {"171,225,108", "017,019,010"})
    aAdd(aRand, {"207,136,077", "020,020,006"})
    aAdd(aRand, {"166,085,082", "017,007,007"})
    aAdd(aRand, {"130,130,130", "008,008,008"})

    oChart:oFWChartColor:aRandom := aRand
    oChart:oFWChartColor:SetColor("Random")

    oChart:Build()    

    ACTIVATE MSDIALOG oDlg CENTERED ON INIT (oChart:SaveToPng(0,0,nLarg,nAlt,cDir +'Graf002.png'),oDlg:End())
    oPrintPvt:SayBitMap(nLinAtu,nColIni,cDir + 'Graf002.png',nLarg,nAlt)
    nLinAtu += nAlt + 5
    U_xRodape002() 
    oPrintPvt:Preview()
    oDlgOpt:End()
    RestArea(aArea)
return

User Function Query003()
    Local cQuery :=""
    if nChart == 2  //linha 
        cQuery = "SELECT	A1_COD as cod,A1.A1_NOME as Cliente,F2_EMISSAO as Emissao,F2.F2_VALBRUT as Total "
    else            //bar ou    pizza ou        funil
        cQuery = "SELECT	A1.A1_NOME as Cliente,SUM(F2.F2_VALBRUT) as Total "
    endif    
    cQuery += "FROM	    "+RetSqlName('SF2')+" F2 INNER JOIN "+RetSqlName('SA1')+" A1 "
    cQuery += "ON		F2_CLIENTE = A1_COD AND F2_LOJA = A1_LOJA "
    cQuery += "AND		A1.D_E_L_E_T_ = F2.D_E_L_E_T_ "
    cQuery += "WHERE	F2.D_E_L_E_T_ = '' "
    if nChart == 1 .OR. nChart == 3 .OR. nChart == 4
        cQuery += "GROUP BY A1_NOME "     
    endif
    
    cQuery:= ChangeQuery(cQuery)
    DBUseArea(.T.,"TOPCONN",TCGENQRY( , ,cQuery ),"TMP",.F.,.T.)
return NIL





