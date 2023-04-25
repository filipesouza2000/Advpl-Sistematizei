#INCLUDE 'Protheus.CH'
#INCLUDE 'TopConn.ch'
#INCLUDE 'RPTDef.ch'
#INCLUDE 'FWPrintSetup.ch'

/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
---Data---|-----Autor-------|-------Descrição------------
25/02/2023| Filipe Souza    | Modelo de gráfico com FWChartFactory 
                              com monitor de menu miniatura
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
*/
User Function Graf004()
	Local oScroll
	Local nGrafico := BARCHART
	
	Static oMonitor

	DEFINE MSDIALOG oMonitor TITLE "Graficos-FWChartFactory" FROM 0,0  TO 600,900 COLORS 0, 16777215 PIXEL 
	oScroll := TScrollArea():New(oMonitor,01,01,300,600)
	oScroll:Align := CONTROL_ALIGN_ALLCLIENT   
	
	U_xGrafico(oScroll,nGrafico)
	
	oMenu := TBar():New( oMonitor, 48, 48, .T., , ,"CONTEUDO_BODY-FUNDO", .T. )
	DEFINE BUTTON RESOURCE "FW_PIECHART_1"		OF oMenu	ACTION U_xGrafico(oScroll,PIECHART) 	 PROMPT " "	TOOLTIP "Pizza"			
	DEFINE BUTTON RESOURCE "FW_LINECHART_1"		OF oMenu	ACTION U_xGrafico(oScroll,LINECHART) 	 PROMPT " "	TOOLTIP "Linha"			
	DEFINE BUTTON RESOURCE "FW_BARCHART_1"		OF oMenu	ACTION U_xGrafico(oScroll,BARCHART) 	 PROMPT " "	TOOLTIP "Barra"			
	DEFINE BUTTON RESOURCE "FW_BARCOMPCHART_2"	OF oMenu	ACTION U_xGrafico(oScroll,BARCOMPCHART)  PROMPT " "	TOOLTIP "Barra"			
	
	ACTIVATE MSDIALOG oMonitor CENTERED
Return

Static Function U_xGrafico(oScroll,nGrafico)
    Local aArea     := GetArea()
	Local oChart
    Local cQuery 
	
	If Valtype(oChart)=="O"
        //Usando a função FreeObj liberamos o objeto para ser recriado novamente, gerando um novo gráfico
		FreeObj(@oChart) 
	Endif
	
	oChart := FWChartFactory():New()
	oChart := oChart:getInstance( nGrafico ) 
	oChart:init( oScroll )
	oChart:SetTitle("Vendas por Cliente", CONTROL_ALIGN_CENTER)
	oChart:SetMask( "R$ *@*")
	oChart:SetPicture("@E 999,999,999.99")
	oChart:setColor("Random") //Deixamos o protheus definir as cores do gráfico
	If nGrafico == PIECHART //se o gráfico tipo pizza, deixamos a legenda no rodapé
		oChart:SetLegend( CONTROL_ALIGN_BOTTOM )
	Endif	
	oChart:nTAlign := CONTROL_ALIGN_ALLCLIENT

	//U_Query004(nGrafico)    
    if nGrafico==LINECHART .OR. nGrafico==BARCOMPCHART 
        cQuery = "SELECT	A1_COD as cod,A1.A1_NOME as Cliente,F2_EMISSAO as Emissao,F2.F2_VALBRUT as Total "
    else           
        cQuery = "SELECT	A1.A1_NOME as Cliente,SUM(F2.F2_VALBRUT) as Total "
    endif    
    cQuery += "FROM	    "+RetSqlName('SF2')+" F2 INNER JOIN "+RetSqlName('SA1')+" A1 "
    cQuery += "ON		F2_CLIENTE = A1_COD AND F2_LOJA = A1_LOJA "
    cQuery += "AND		A1.D_E_L_E_T_ = F2.D_E_L_E_T_ "
    cQuery += "WHERE	F2.D_E_L_E_T_ = '' "
    if nGrafico!=LINECHART .AND. nGrafico!=BARCOMPCHART 
        cQuery += "GROUP BY A1_NOME "     
    endif
    
    If ( SELECT("cAlias") ) > 0
		dbSelectArea("cAlias")
		cAlias->(dbCloseArea())
	EndIf
 
	TcQuery cQuery Alias "cAlias" New
	cAlias->(dbGoTop())

	//Se a série for unica o tipo de variável deve ser NUMÉRICO Ex.: (cTitle, 10)
	//Se for multi série o tipo de variável deve ser Array de numéricos Ex.: (cTitle, {10,20,30} )
	If cAlias->(!EOF())
		While cAlias->(!EOF())
			if nGrafico==LINECHART .OR. nGrafico==BARCOMPCHART 
				//Neste dois tipos de graficos temos:(Titulo, {{ Descrição, Valor }})
				oChart:addSerie( "Cliente " + cAlias->Cliente   , { { DTOC(STOD(cAlias->Emissao)), cAlias->Total   } } )
			Else
				//Aqui temos: (Titulo, Valor)
				oChart:AddSerie(cAlias->Cliente,cAlias->Total)
			Endif
			cAlias->(dbSkip())
		End
		oChart:build()
	Endif  
    RestArea(aArea)
	
Return

