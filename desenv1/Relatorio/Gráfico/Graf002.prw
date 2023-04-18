#INCLUDE 'Protheus.CH'
#INCLUDE 'TopConn.ch'
#INCLUDE 'RPTDef.ch'
#INCLUDE 'FWPrintSetup.ch'

/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
---Data---|-----Autor-------|-------Descrição------------
17/02/2023| Filipe Souza    | Relatório Gráfico com a ferramenta FWPrintSetup

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
*/
User Function Graf002()
    Local aArea     := GetArea()
    Local cNomeRel  :='rel_teste_'+dtos(Date())+StrTran(Time(),':','-')
    Local cDir      :=GetTempPath()
    Local nLCab     :=025
    Local nAlt      :=250
    Local nLarg     :=1050
    Local oChart
    Local oDlg
    Local aRand :={}
    Private cHoraEx    := Time()
    Private nPagAtu    := 1
    Private oPrintPvt
    //Fontes
    Private cNomeFont  := "Arial"
    Private oFontRod   := TFont():New(cNomeFont, , -06, , .F.)
    Private oFontTit   := TFont():New(cNomeFont, , -20, , .T.)
    Private oFontSubN  := TFont():New(cNomeFont, , -17, , .T.)
    //Linhas e colunas
    Private nLinAtu     := 0
    Private nLinFin     := 820
    Private nColIni     := 010
    Private nColFin     := 550
    Private nColMeio    := (nColFin-nColIni)/2
    
    //Processa({|| Query002()},"Espere","Consultando....")
    U_Query002()
    //criando objeto de impressão
    oPrintPvt   := FWMSPrinter():New(cNomeRel,IMP_PDF,.F.,,.T.,,@oPrintPvt,,,,,.T.)
    oPrintPvt:cPathPDF:=GetTempPath()
    oPrintPvt:SetResolution(72)
    oPrintPvt:SetPortrait()
    oPrintPvt:SetPaperSize(DMPAPER_A4)
    oPrintPvt:SetMargin(60,60,60,60)
    oPrintPvt:StartPage()

    //cabeçalho
    oPrintPvt:SayAlign(nLCab,nColMeio-150,"Relatório Gráfico em ADVPL", oFontTit,300,20,RGB(0,0,255),2,0)
    nLCab+=35
    nLinAtu:=nLCab

    //verificar se o arquivo está aberto
    if File(cDir + 'Graf002.png')
        FErase(cDir+'Graf002.png')
    endif

    DEFINE MSDIALOG oDlg PIXEL FROM 0,0 TO nAlt,nLarg
    oChart := FWChartBar():New()
    oChart:Init(oDlg,.T.,.T.)
    oChart:SetTitle("Vendas por Cliente",CONTROL_ALIGN_CENTER)

    While (TMP->(!EOF()))
        oChart:addSerie(TMP->Cliente,TMP->Total)
        TMP->(DBSKIP( ))
    End
    oChart:setLegend(CONTROL_ALIGN_LEFT)

    aAdd(aRand, {"084,120,164", "007,013,017"})
    aAdd(aRand, {"171,225,108", "017,019,010"})
    aAdd(aRand, {"207,136,077", "020,020,006"})
    aAdd(aRand, {"166,085,082", "017,007,007"})
    aAdd(aRand, {"130,130,130", "008,008,008"})

    oChart:oFWChartColor:aRandom := aRand
    oChart:oFWChartColor:SetColor("Random")

    oChart:Build()    

    ACTIVATE MSDIALOG oDlg CENTERED ON INIT (oChart:SaveToPng(0,0,nLarg,nAlt,cDir +'Graf002.png'),oDlg:End())
    oPrintPvt:SayBitMap(nLinAtu,nColIni,cDir + 'Graf002.png',nLarg/2,nAlt/1.6)
    nLinAtu += nAlt + 5
    oPrintPvt:EndPage()
    oPrintPvt:Preview()

    RestArea(aArea)
return

User Function Query002()
    Local cQuery :=""

    cQuery = "SELECT	A1.A1_NOME as Cliente,SUM(F2.F2_VALBRUT) as Total "
    cQuery += "FROM	    "+RetSqlName('SF2')+" F2 INNER JOIN "+RetSqlName('SA1')+" A1 "
    cQuery += "ON		F2_CLIENTE = A1_COD AND F2_LOJA = A1_LOJA "
    cQuery += "AND		A1.D_E_L_E_T_ = F2.D_E_L_E_T_ "
    cQuery += "WHERE	F2.D_E_L_E_T_ = '' "
    cQuery += "GROUP BY A1_NOME "
    cQuery:= ChangeQuery(cQuery)
    DBUseArea(.T.,"TOPCONN",TCGENQRY( , ,cQuery ),"TMP",.F.,.T.)
return NIL
