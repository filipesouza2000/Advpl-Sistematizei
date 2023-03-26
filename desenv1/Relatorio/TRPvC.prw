#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH'
 // Formação Desenvolvedor Protheus
 // Módulo 7- Aula 5- TReport ,pedido de venda por Cliente

User Function TRPvC()
    Private oReport := Nil
    Private oSection := Nil
    Private cperg   := "TRCli"
    ValidPerg()
    pergunte(cperg)
    ReportDef()
    oReport:PrintDialog()
Return

Static Function ReportDef()
    oReport:=TReport():New("TRPVCli","Pedidos de Venda/Cliente",cperg,{|oReport| PrintReport(oReport)})
    oReport:SetLandScape(.T.)
    oSection:=TRSection():New(oReport,"Pedidos por Cliente")
    TRCell():New(oSection,"C5_NUM"     ,"SC5")
    TRCell():New(oSection,"A1_NOME"    ,"SA1")
    TRCell():New(oSection,"C5_EMISSAO" ,"SC5")
    TRCell():New(oSection,"C6_PRODUTO" ,"SC6")
    TRCell():New(oSection,"C6_QTDVEN"  ,"SC6")
    TRCell():New(oSection,"C6_VALOR"   ,"SC6")

    oBreak:=TRBreak():New(oSection,oSection:Cell("C5_NUM","Sub Total"))
    TRFunction():New(oSection:Cell("C5_NUM")   ,Nil,"COUNT",oBreak)
    TRFunction():New(oSection:Cell("C6_QTDVEN"),Nil,"SUM"  ,oBreak)
    TRFunction():New(oSection:Cell("C6_VALOR") ,Nil,"SUM"  ,oBreak)
Return

Static Function PrintReport(oReport)
    Local cAlias   := GetNextAlias()
    oSection:beginQuery()
    BeginSql Alias cAlias
        SELECT  C5.C5_NUM, A1_NOME, C5_EMISSAO, C6_PRODUTO, C6_QTDVEN, C6_VALOR
        FROM	%table:SC5% C5
        INNER JOIN %table:SC6% C6 
        ON		C5.C5_FILIAL = C6.C6_FILIAL AND C5.C5_NUM = C6.C6_NUM AND C5.C5_SERIE = C6.C6_SERIE AND C5.D_E_L_E_T_ = C6.D_E_L_E_T_
        INNER JOIN %table:SA1% A1
        ON		C5.C5_CLIENTE = A1.A1_COD AND C5.C5_LOJACLI = A1.A1_LOJA AND C5.D_E_L_E_T_= A1.D_E_L_E_T_
        WHERE	C5.%notdel%
        AND     C5_CLIENTE BETWEEN %exp:(MV_PAR01)% AND %exp:(MV_PAR02)%
    EndSql
    oSection:EndQuery()
    oSection:Print()
    (cAlias)->(DBCloseArea())

Return

Static Function ValidPerg()
	Local aArea  := SX1->(GetArea())
	Local aRegs := {}
	Local i,j

	aadd( aRegs, { cPerg,"01","Cliente de ?","Cliente de ?","Cliente de ?","mv_ch1","C", 6,0,0,"G","","mv_par01","","","mv_par01"," ","",""," ","","","","","","","","","","","","","","","","","",   "SA1"} )
	aadd( aRegs, { cPerg,"02","Cliente ate ?","Cliente ate ?","Cliente ate ?","mv_ch2","C", 6,0,0,"G","","mv_par02","","","mv_par02"," ","",""," ","","","","","","","","","","","","","","","","","","SA1"} )

	DbselectArea('SX1')
	SX1->(DBSETORDER(1))
	For i:= 1 To Len(aRegs)
		If ! SX1->(DBSEEK( AvKey(cPerg,"X1_GRUPO") +aRegs[i,2]) )
			Reclock('SX1', .T.)
			FOR j:= 1 to SX1->( FCOUNT() )
				IF j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				ENDIF
			Next j
			SX1->(MsUnlock())
		Endif
	Next i 
	RestArea(aArea) 
Return(cPerg)




















