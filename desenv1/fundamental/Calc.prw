#INCLUDE 'Protheus.ch'

    /*/{Protheus.doc} fCalc
	Funùùo para resolver as 4 operaùùes atitmùticas,
	recebendo dois nùmeros como parùmetro
	@type  Function
	@author Filipe Souza
	@since 10/10/2021
    /*/
User Function fCalc()	
	
	Local nOp := Val(FWInputBox("Qual operaùùo?"+Chr(13)+" 1-Soma"+Chr(13)+"2-Subtraùùo"+Chr(13)+"3-Multiplicaùùo"+Chr(13)+"4-Divizùo",""))

	Local n1 := Val(FWInputBox("Nùmero1: ",""))
	Local n2 := Val(FWInputBox("Nùmero2: ",""))
	//MsgInfo('Funùùes:' + Chr(13)+'Soma'+ Chr(13)+'Sub'+ Chr(13)+'Mult'+ Chr(13)+'Div','Operaùùes')
	if nOp = 1 
	fSoma(n1,n2)
		elseif nOp = 2
		fSubt(n1,n2)
			elseif nOp = 3
			fMult(n1,n2)
				elseif nOp = 4
				fDiviz(n1,n2)
				else
					MsgAlert("Opùùo invùlida", "Alerta!")
	endif

Return


Static Function fSoma(n1,n2)
	Local nResultado
	nResultado := n1 + n2
	MsgAlert('Soma: '+cValTochar(nResultado), 'Soma')
return

Static Function fSubt(n1,n2)
	Local nResultado
	nResultado := n1 - n2
	MsgAlert('subtraùùo: '+cValTochar(nResultado), 'Subtraùùo')
Return

Static Function fMult(n1,n2)
	Local nResultado
	nResultado := n1 * n2
	MsgAlert('Multiplicaùùo: '+cValTochar(nResultado), 'Multiplicaùùo')
Return

Static Function fDiviz(n1,n2)
	Local nResultado
	nResultado := n1 / n2
	MsgAlert('Divizùo: '+cValTochar(nResultado), 'Divizùo')
Return
