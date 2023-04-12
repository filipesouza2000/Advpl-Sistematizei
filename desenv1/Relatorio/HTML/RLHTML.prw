#Include 'Protheus.ch'
#Include 'Parmtype.ch'

/*/{Protheus.doc} 
Relatório em formato HTM utilizando advpl
@type function
@author Curso Desenvolvendo relatórios com ADVPL - RCTI Treinamentos
@see www.rctitreinamentos.com.br
/*/

User Function RLHTML()

	If MsgYesNo("Deseja imprimir o relatório HTML?")
		
	Processa({||MntQry() 	},,"Processando...")
	MsAguarde( { || GeraHTML() },,"O arquivo HTML está sendo Gerado... ")
	
	Else
		Alert("<b>Cancelado pero usuário.</b>")
		Return Nil
	EndIf
	
Return

/** Função estática que monta a pesquisa em SQL  **/
Static Function MntQry()
    Local cQuery := " "
 	cQuery += " SELECT B1.B1_COD AS CODIGO, B1.B1_DESC AS DESCRICAO, B1.B1_TIPO AS TIPO,"
	cQuery += " B1.B1_UM AS UM,B2.B2_QATU AS QTD,B2.B2_CM1 AS PRECO, B2.B2_VATU1 AS VALOR"
 	cQuery += " FROM SB1990 B1 INNER JOIN SB2990 B2" 
 	cQuery += " ON B1.B1_COD = B2.B2_COD AND B1.D_E_L_E_T_ = B2.D_E_L_E_T_"
	cQuery += " WHERE B1.D_E_L_E_T_ = ''"
	cQuery := ChangeQuery(cQuery)
	DbUseArea(.T., "TOPCONN", TCGENQRY(,,cQuery), 'HT1', .F., .T.)
Return Nil

/** Função para gerar o HTML **/

Static Function GeraHTML()
	Local dData := Date() //armazenando a data atual
	Local cHtml := "" 
	Local cFile := "Index-"+FWTimeStamp()+".htm"
	Local cFold := "C:\TOTVS12133\Protheus\protheus_data\rel_html\"	
	
	nH := fCreate(cFold + cFile)
		If nH == -1
			MsgStop("Falha ao criar o arquivo HTML "+ Str(Ferror()))
				Return
		EndIf
		
		// Montagem do HTML.
	cHtml += '<html xmlns="http://www.w3.org/1999/xhtml">' 
	cHtml += '<head>' 
	cHtml += '<meta charset="iso-8859-1">'       
	cHtml += '<title>Relatório de produtos</title>' 
	cHtml += "<link rel='stylesheet' href='estilo.css' />"
	cHtml += "</head>"    
	cHtml += "<body>" 
	cHtml += "<div id='cabec'>" 
	cHtml += "   <center>"
	cHtml += "<table width='331' id='table-b' summary='Produtos'>"    
	cHtml += "<tr>" 
	cHtml += " <td width='252' scope='row'><font face='arial'><b>Parametros:</b></font><br />" 
	cHtml += " <font face='arial'>Data de atualização: "+ DToC(dData) +" "+Time()+" </font><br /> <font face='arial'></font></td>" 
	cHtml += " </tr>" 
	cHtml += "</table></center>"    
	cHtml += "<p align=center><font face='Lucida Sans Unicode' size='6'><u>Relatório Produtos</u></font></p>" 
	cHtml += "  <center>" 
	cHtml += "<table width='1000' id='table-b' summary='Produtos'>" 
	cHtml += "<tr>" 
	//cHtml += "<th width='72' scope='row'>Filial</th>" 
	cHtml += "<th width='100' scope='row'>Codigo</th>" 
	cHtml += "<th width='200'>Descrição</th>" 
	cHtml += "<th width='72'>Tipo</th>" 
	cHtml += "<th width='72'>UM</th>" 
	cHtml += "<th width='100'>Saldo</th>" 
	cHtml += "<th width='100'>Preço</th>" 
	cHtml += "<th width='100'>Total</th>" 
	cHtml += "</tr>" 
   
   	FWrite(nH,cHtml)
   		cHtml := ""
   
   	While HT1->(!EOF())
   		
   		cHtml += "<tr>"
   		cHtml += "<td>"		+HT1->(CODIGO)+"</td>"
   		cHtml += "<td>"		+HT1->(DESCRICAO)+"</td>"
   		cHtml += "<td>"		+HT1->(TIPO)+"</td>"
   		cHtml += "<td>"		+HT1->(UM)+"</td>"
		cHtml += "<td>"		+Str(HT1->(QTD))+"</td>"
		cHtml += "<td>"		+Transform(HT1->(PRECO),Alltrim(PesqPict("SB2","B2_CM1")))+"</td>"
   		cHtml += "<td>"		+Transform(HT1->(VALOR),Alltrim(PesqPict("SB2","B2_VATU1")))+"</td></tr>"   		
		
		FWrite(nH,cHtml)
			cHtml := ""
			HT1->(dbSkip())
   	
   	EndDO
   	
   		FClose(nH)
   		
   	MsgInfo("Arquivo gerado com sucesso!!")
   	
   	//Abrindo o arquivo 
		  //ShellExecute([Ação], [Arquivo / Programa],  [], [Diretório], [Opção (1 = Normal)])
   	nRet := ShellExecute("open",  cFile				 ,""	,cFold		,1)
   
Return nRet

