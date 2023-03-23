#INCLUDE 'Protheus.ch'
#INCLUDE 'TOPCONN.ch'
 // Formação Desenvolvedor Protheus
 // Módulo 7- Aula 4- TReport ,pedido de compra por fornecedor

User Function TRCom() 
    Private  oReport := Nil
    Private  oSecCab := Nil
    Private  cPerg   :="TRFOR"
// função que cria perguntas na SX1 se não existir
    ValidPerg()
//função para exibir pergunta e rececer parâmetros para o relatório
    pergunte(cPerg)
//funções que construirão relatorio    
ReportDef()
oReport:PrintDialog()

Return 

/*/{Protheus.doc} ReportDef
    (long_description)
    @type  Static Function
    @author user
    @since 21/01/2022
    @version 1.0    
/*/
Static Function ReportDef()
    oReport := TReport():new("TRCom","Relatorio SZ7- Pedido de Compras/Fornecedor",cPerg,{|oReport| PrintReport(oReport) })
    oReport:SetLandScape(.T.)// define relatirio no formato em paisagem

    //controle da seção do relatorio
    oSecCab := TRSection():New(oReport," Pedido de Compras/Fornecedor")

    // inserir campos/colunas no relatorio
    TRCell():New(oSecCab, "Z7_NUM"      ,"SZ7")
    TRCell():New(oSecCab, "Z7_EMISSAO"  ,"SZ7")
    TRCell():New(oSecCab, "Z7_FORNECE"  ,"SA2")
    TRCell():New(oSecCab, "A2_NOME"     ,"SA2")    
    TRCell():New(oSecCab, "Z7_PRODUTO"  ,"SZ7")
    TRCell():New(oSecCab, "B1_DESC"     ,"SB1")
    TRCell():New(oSecCab, "Z7_QUANT"    ,"SZ7")
    TRCell():New(oSecCab, "Z7_PRECO"    ,"SZ7")
    TRCell():New(oSecCab, "Z7_TOTAL"    ,"SZ7")

oBreak := TRBreak():New(oSecCab, oSecCab:Cell("Z7_FORNECE"),"Sub Total")

TRFunction():New(oSecCab:Cell("Z7_NUM"),Nil, "COUNT",oBreak)
TRFunction():New(oSecCab:Cell("Z7_QUANT"),Nil, "SUM",oBreak)
TRFunction():New(oSecCab:Cell("Z7_TOTAL"),Nil, "SUM",oBreak)

Return 

Static Function PrintReport(oReport)
    Local cAlias    := GetNextAlias()

    oSecCab:beginQuery()//relatorio começa a ser construido
    // inicio da query
    BeginSql Alias cAlias
        SELECT  Z7_NUM,Z7_FORNECE,A2_COD, A2_NOME, Z7_EMISSAO,Z7_PRODUTO,B1_DESC,Z7_QUANT,Z7_PRECO,Z7_TOTAL
        FROM		%table:SZ7% Z7 
        INNER JOIN	%table:SA2% A2
        ON	    Z7.Z7_LOJA   = A2.A2_LOJA
        AND     Z7.Z7_FORNECE= A2.A2_COD
        AND     Z7.D_E_L_E_T_ = A2.D_E_L_E_T_
        INNER JOIN %table:SB1%  B1 ON B1_COD = Z7_PRODUTO
        WHERE   A2.%NOTDEL%
        AND     Z7_FORNECE BETWEEN %exp:(MV_PAR01)% AND %exp:(MV_PAR02)%       
    EndSql        

    oSecCab:EndQuery()// fim da query
    oSecCab:Print() // impressão do relatorio

    (cAlias)->(DBCLOSEAREA())
        
Return

Static Function ValidPerg()
	Local aArea  := SX1->(GetArea())
	Local aRegs := {}
	Local i,j

	aadd( aRegs, { cPerg,"01","Fornecedor de ?","Fornecedor de ?","Fornecedor de ?","mv_ch1","C", 6,0,0,"G","","mv_par01","","","mv_par01"," ","",""," ","","","","","","","","","","","","","","","","","","SA2"          } )
	aadd( aRegs, { cPerg,"02","Fornecedor ate ?","Fornecedor ate ?","Fornecedor ate ?","mv_ch2","C", 6,0,0,"G","","mv_par02","","","mv_par02"," ","",""," ","","","","","","","","","","","","","","","","","","SA2"       } )

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
