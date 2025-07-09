#Include "TOTVS.ch"
#Include "TopConn.ch"
#Include "RPTDef.ch"
#Include "FwPrintSetup.ch"

Static oSetupRel    :=NIL
#Define PAD_LEFT    0
#Define PAD_RIGHT   1
#Define PAD_CENTER  2
#Define PAD_JUSTIFY  3

/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
---Data---|-----Autor-------|-------Descrição------------
15/07/2023| Filipe Souza    | Aula 23 - FWMSPrinter - email com um pdf FWMSPrinter em anexo
                                função para exibir pergunta e rececer parâmetros para o relatório
                                aciona setup do relatorio
                                Gmail Filipe-senha de app 'bkeg gdrz uoki jrqk'
                                smtp.gmail.com:587      TLS:587  SSL:465
                              Em versões muito antigas (antes da 22.10), o GPEMail pode não existir.
                                
@see Terminal da Informação
@see https://tdn.totvs.com/display/public/framework/FWMsPrinter
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
*/

User Function xFWMSP23()
    Local     aArea   :=FWGetArea()  
    Local    cProdDe  := Space(TamSX3('B1_COD')[01])
    Local    cProdAt  := Space(TamSX3('B1_COD')[01])
    Local    cTipoDe  := Space(TamSX3('B1_TIPO')[01])
    Local    cTipoAt  := Space(TamSX3('B1_TIPO')[01])
    Local     nOrden  :=1
    Private   lJob    := .T.//IsBlind()
    Private   cPerg   :="PERPROD"
    Private   aPergs  :={}  

    //Se for execução automática via JOB, executa sem pergunta
    If lJob
        fMontaRel()
    else
        //    xValidPerg()
        //função para exibir pergunta e rececer parâmetros para o relatório
        //    pergunte(cPerg)
        //Parambox
        aAdd(aPergs,{1,"Produto de:", cProdDe,"",".T.","SB1",".T.",80,.F.})//MV_PAR01
        aAdd(aPergs,{1,"Produto até:",cProdAt,"",".T.","SB1",".T.",80,.F.})//MV_PAR02
        aAdd(aPergs,{1,"Tipo de:",    cTipoDe,"",".T.","02",".T.", 40,.F.})//MV_PAR03
        aAdd(aPergs,{1,"Tipo ate:",   cTipoAt,"",".T.","02",".T.", 40,.F.})//MV_PAR04        
        aAdd(aPergs,{2,"Ordenar por:",nOrden,  {"1-Cod Prod","2-Desc Prod","3-Tipo","4-Uni Med"},100,".T.",.T.})//MV_PAR05
        //se a pergunta for confirmada, cria as definições do relatorio
        if Parambox(aPergs,"Informe os parÂmetros",,,,,,,,,.F.,.F.)
            MV_PAR05:=Val(cValToChar(MV_PAR05))
            //aciona setup do relatorio
            xSetupPrint()
            If ValType( oSetupRel)!="U"
                Processa({|| fMontaRel()}, "Processando...")                    
            EndIf            
        Endif            
    EndIf
    
    FwRestArea(aArea)
return 

Static Function fMontaRel()   
    Private     cCaminho,cArquivo :=""
        Private     cQuery      :=""
        Private     cLogo       :="\x_imagens\ti_logo.png"
        Private     cUrl        :="http://terminaldeinformacao.com"
        Private     cMail       :="suporte@terminaldeinformacao.com "
        Private     cTel        :="(14)997385495 "
        Private     cAdm        :="Atílio Sistemas"
        Private     nLarg       :=90
        Private     nAlt        :=90     
        Private     nLinAtu     :=000        
        Private     nTamLin     :=010
        Private     nLinFin     :=820
        Private     nColIni     :=010
        Private     nColFin     :=550
        Private     nPageAtu    :=1
        Private     nColProd    :=nColIni
        Private     nColDesc    :=nColIni+090
        Private     nColTipo    :=nColFin-270
        Private     nColTDes    :=nColFin-230
        Private     nColUMed    :=nColFin-130
        Private     nColDUMed   :=nColFin-090
        Private     nColMeio    := (nColFin-nColIni)/2
        Private     nEspLin     :=015
        Private     nFimQdr     :=0
        Private     dDataGer    :=Date()
        Private     cHoraGer    :=Time()
        Private     nCorFraca   :=RGB(198,239,206)
        Private     nCorForte   :=RGB(003,101,002)
        Private     nCorCinza   :=RGB(150,150,150)
        Private     oBrush      :=TBrush():New(,nCorFraca)
        Private     oPrintPvt   
        Private     cNomeFont   :="Arial"
                                            //font     ,,tam,negr,,,,subl,ital        
        Private     oFontDet    :=TFont():New(cNomeFont,,-11,,.F.,,,,,.F.,.F.)       
        Private     oFontCabN   :=TFont():New(cNomeFont,,-15,,.T.,,,,,.F.,.F.)   
        Private     oFontDetN   :=TFont():New(cNomeFont,,-13,,.T.,,,,,.F.,.F.) 
        Private     oFontDetI   :=TFont():New(cNomeFont,,-11,,.F.,,,,,.F.,.T.)  
        Private     oFontMin    :=TFont():New(cNomeFont,,-09,,.F.,,,,,.F.,.F.) 
        Private     cTextV      :="Assinatura Premium do Terminal de Informação, veja https://terminaldeinformacao.com/hotmart"
        //Private     cProd1      :=IIF(Alltrim(MV_PAR01)=='' .OR. Alltrim(MV_PAR01)=='0','',Alltrim(MV_PAR01))
        //Private     cProd2      :=IIF(Alltrim(MV_PAR02)=='' .OR. Alltrim(MV_PAR02)=='0','ZZZZZZ',Alltrim(MV_PAR02))
        Private     nReg        :=0
        //para envio de e-amil
        Private     lSend       :=.F.
        Private     aAnexos     :={}
        Private     cAssunto    :="Lista de Produtos "+dToS(dDataGer) + "_" + StrTran(cHoraGer,':','')
        Private     cPara       :="filipesouza2000@gmail.com"
        Private     cBody       :="<p>Olá</p>"
                    cBody       +="<p>Segue em anexo o relatório com listagem de produtos na data informada</p>Obrigado"

    If lJob
        cCaminho:=GetTempPath()
        cArquivo:="FWMSP_job_"+ dToS(dDataGer) + "_" + StrTran(cHoraGer,':','')+".pdf"       

        //cria objeto FwMsprinter
        oPrintPvt:=FwMsprinter():New(;
            cArquivo,;//cFilePrinter
            IMP_PDF,; //nDevice
            .F.,;     //lAdjustToLegacy
            '',;      //cPathInServer
            .T.,;     //lDisableSetup
            .F.,;     //lTreport
            ,;        //oPrintSetup
            ,;        //cPrinter
            .T.,;     //lServer
            .T.,;     //lParam10
            ,;        //lraw
            .F.)      //lViewPdf
        oPrintPvt:cPathPDF:=cCaminho  

    else
        cCaminho:=GetTempPath()
        cArquivo:="FWMSP_"+ dToS(dDataGer) + "_" + StrTran(cHoraGer,':','')+".pdf"
    
        //cria objeto FwMsprinter
    /*Params:
        CFILEPRINT:FWMSP_20250321_125824.pdf,
        NDEVICE:6,
        LADJUSTTOLEGACY:.F.,
        CPATHINSERVER:,
        LDISABLESETUP:.T.,
        LTREPORT:.F.,
        OPRINTSETUP:NIL,
        CPRINTER:,
        LSERVER:.F.,
        LPDFASPNG:.T.,
        LRAW:.F.,
        LVIEWPDF:.T.,
        NQTDCOPY:1,
        LCONVERTFONT:.T. )
    */
        oPrintPvt:=FwMsprinter():New(;
            cArquivo,;//cFilePrinter
            ,; //nDevice  IMP_PDF
            .F.,;     //lAdjustToLegacy
            '',;      //cPathInServer
            .T.,;     //lDisableSetup
            ,;        //lTreport
            ,;        //oPrintSetup
            ,;      //cPrinter
            ,;        //lServer
            ,;        //LPDFASPNG
            ,;        //lraw
            .T.)      //lViewPdf
        //FWMSPrinter():New(cNomeRel,IMP_PDF,.F.,'',.T.,,@oPrintPvt,,,,,.T.)
        oPrintPvt:cPathPDF:=cCaminho    
        oPrintPvt:nDevice:=IMP_PDF
        oPrintPvt:cPrinter:= oSetupRel:aOptions[PD_VALUETYPE]
        
    EndIf
    //Setando atributos do relatório
    oPrintPvt:SetResolution(72)
    oPrintPvt:SetPortrait()
    oPrintPvt:SetPaperSize(DMPAPER_A4)
    oPrintPvt:SetMargin(60,60,60,60)

    xImpCab()
    //imprimir consulta
        cQuery := "SELECT  B1.B1_COD as Cod,"
        cQuery += "	B1.B1_DESC as Descr,    "
        cQuery += "	B1.B1_TIPO as Tipo,     "
        cQuery += "	(	SELECT X5.X5_DESCRI "
        cQuery += "		FROM "+RetSqlName("SX5")+" X5"
        cQuery += "		WHERE X5.D_E_L_E_T_ ='' AND  X5.X5_TABELA='02' AND X5.X5_CHAVE=B1.B1_TIPO) as TpDesc,"
        cQuery += "	B1.B1_UM as UMED,       "
        cQuery += "	AH.AH_DESCPO as UmDesc  "
        cQuery += " FROM "+RetSqlName("SB1")+" B1  INNER JOIN "+RetSqlName("SAH")+" AH "
        cQuery += " ON	B1.B1_UM = AH.AH_UNIMED AND B1.D_E_L_E_T_ = AH.D_E_L_E_T_"
        cQuery += " Where B1.B1_COD  BETWEEN '"+IIF(lJob,"",MV_PAR01)+"' and '"+IIF(lJob,"ZZZZZZ",MV_PAR02)+"'"
        cQuery += " AND   B1.B1_TIPO BETWEEN '"+IIF(lJob,"",MV_PAR03)+"' and '"+IIF(lJob,"ZZ",MV_PAR04)+"'"
        cQuery += " AND   B1.B1_MSBLQL != '1'"
        cQuery += " AND   B1.D_E_L_E_T_ =''"
        cQuery += " ORDER BY  "
        If lJob
            cQuery+= " B1.B1_COD "
        elseif MV_PAR05 == 1
            cQuery+= " B1.B1_COD "
        elseIf MV_PAR05 == 2
            cQuery+= " B1.B1_DESC "    
        elseIf MV_PAR05 == 3
            cQuery+= " B1.B1_TIPO " 
        elseIf MV_PAR05 == 4
            cQuery+= " B1.B1_UM "        
        EndIf
        
        
        cQuery:= ChangeQuery(cQuery)    
                          //https://tdn.totvs.com/display/tec/TCGenQry
    DBUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),'B1',.F.,.T.)
    
    // Garante que a área será fechada mesmo com erro
    BEGIN SEQUENCE
        B1->(DBGoTop())
        IF B1->(!EOF())
        // Imprime os dados encontrados
        While B1->(!EOF())
            nReg++            
            xBreackPage()//verifica quebra de página
            If nReg %2==0
                oPrintPvt:FillRect({nLinAtu-2,nColIni+1,nLinAtu+nEspLin-3 ,nColFin-1},oBrush)
            EndIf
                            //( < nRow>, < nCol>, < cText>,  [ oFont], [ nWidth], [ nHeigth], [ nClrText], [ nAlignHorz], [ nAlignVert ] )
            oPrintPvt:SayAlign(nLinAtu, nColProd, " "+Alltrim(B1->cod),oFontDet, 100 , 10 , RGB(0,0,0), PAD_LEFT,)
            oPrintPvt:SayAlign(nLinAtu, nColDesc,Alltrim( B1->Descr),  oFontDet, 200 , 10 , RGB(0,0,0), PAD_LEFT,)
            oPrintPvt:SayAlign(nLinAtu, nColTipo, Alltrim(B1->Tipo),   oFontDet, 040 , 10 , RGB(0,0,0), PAD_CENTER,)
            oPrintPvt:SayAlign(nLinAtu, nColTDes, Alltrim(B1->TpDesc), oFontDet, 120 , 10 , RGB(0,0,0), PAD_LEFT,)
            oPrintPvt:SayAlign(nLinAtu, nColUMed, Alltrim(B1->UMED),   oFontDet, 040 , 10 , RGB(0,0,0), PAD_CENTER,)
            oPrintPvt:SayAlign(nLinAtu, nColDUMed,Alltrim(B1->UmDesc), oFontDet, 080 , 10 , RGB(0,0,0), PAD_LEFT,)
            nLinAtu+=nEspLin
            //limha de separação
            oPrintPvt:Line(nLinAtu-3,nColIni,nLinAtu-3,nColFin,nCorCinza)
            //linha vertical na lista
            oPrintPvt:Line(nLinAtu-18,nColIni,   nLinAtu-3,nColIni,   nCorCinza)//produto
            oPrintPvt:Line(nLinAtu-18,nColDesc-2,nLinAtu-3,nColDesc-2,nCorCinza)//desc
            oPrintPvt:Line(nLinAtu-18,nColTipo+5,nLinAtu-3,nColTipo+5,  nCorCinza)//TP
            oPrintPvt:Line(nLinAtu-18,nColTDes-2,nLinAtu-3,nColTDes-2,nCorCinza)//tp desc
            oPrintPvt:Line(nLinAtu-18,nColUMed+5,nLinAtu-3,nColUMed+5,  nCorCinza)//um
            oPrintPvt:Line(nLinAtu-18,nColDUMed-2,nLinAtu-3,nColDUMed-2,nCorCinza)//um des
            oPrintPvt:Line(nLinAtu-18,nColFin,    nLinAtu-3,nColFin,   nCorCinza)//final
            B1->(DbSkip())
        EndDo
        else
            FwAlertError("Dados não encontrados com os filtros informados","Falha")
        Endif    

        B1->(dbCloseArea())
    RECOVER
        Alert("Ocorreu um erro durante a execução da consulta.")
    END SEQUENCE

    //impressão vertical                                   ângulo a girar
    oPrintPvt:Say(40,nColIni-15, "Esq:"+ cTextV,oFontMin,,nCorFraca,90)
    oPrintPvt:Say(40,nColFin+15, "Dir:"+ cTextV,oFontMin,,nCorFraca,90)
    //se não houver quebra de pagina, imprimir rodapé
    If nLinAtu < nLinFin
        xImpRod()
    EndIf
    If File(cCaminho+cArquivo)
        aadd(aAnexos,cCaminho+cArquivo)
    EndIf
    
    
    //se for via job, imprime o arquivo apra gerar corretamente o pdf
    If lJob
        oPrintPvt:Print()  
        U_EnviaEmailGmail(cAssunto,cPara,cBody,aAnexos)
        
    else
        oPrintPvt:Preview()    
    EndIf
    
return

Static Function  xImpCab()
    //inicializa pagina
    oPrintPvt:StartPage()
     
    nLinAtu:=40
    if nPageAtu ==1
        nFimQdr:=nLinAtu + ((nEspLin*6)+5)
        oPrintPvt:Box( nLinAtu,          nColIni,    nFimQdr,nColFin, )
        oPrintPvt:FillRect({nLinAtu+1,   nColIni+95, nLinAtu+nEspLin,nColFin-105},oBrush)
        oPrintPvt:Line(nLinAtu+nEspLin,  nColIni+95, nLinAtu+nEspLin,nColFin-105, )
        oPrintPvt:Line(nLinAtu,          nColIni+95, nFimQdr,        nColIni+95, )
        oPrintPvt:Line(nLinAtu,          nColFin-105,nFimQdr,        nColFin-105, )
        oPrintPvt:Line(nLinAtu+33,       nColIni +100,nLinAtu+33,  nColIni +250, nCorFraca)
        
        nLinAtu+=nEspLin
        //imprimir logo
        oPrintPvt:SayBitMap(nLinAtu-12,nColIni+2,cLogo, nLarg,nAlt)

        //Imprimindo QRCode                       //proporcional de lagura e altura
        oPrintPvt:QRCode(nLinAtu+75,nColFin-100,cUrl,90)

        oPrintPvt:SayAlign(nLinAtu-15,nColIni +100,"Dados",                         oFontCabN,200,    015,nCorForte,PAD_LEFT, )
        oPrintPvt:SayAlign(nLinAtu,nColIni +100,"Terminal de Informação:",          oFontCabN,200,    015,nCorForte,PAD_LEFT, )
        nLinAtu+=nEspLin+5
        oPrintPvt:SayAlign(nLinAtu,nColIni +100,"Site: ",                           oFontDetN,200,    015,,PAD_LEFT, )
        oPrintPvt:SayAlign(nLinAtu,nColIni +170,cUrl,                               oFontDet ,200,    015,,PAD_LEFT, )
        nLinAtu+=nEspLin
        oPrintPvt:SayAlign(nLinAtu,nColIni +100,"E-mail: ",                         oFontDetN,200,    015,,PAD_LEFT, )
        oPrintPvt:SayAlign(nLinAtu,nColIni +170,cMail,oFontDet ,200,    015,,PAD_LEFT, )
        nLinAtu+=nEspLin
        oPrintPvt:SayAlign(nLinAtu,nColIni +100,"Whats App: ",                       oFontDetN,200,    015,,PAD_LEFT, )
        oPrintPvt:SayAlign(nLinAtu,nColIni +170,cTel,                               oFontDet ,200,    015,,PAD_LEFT, )
        nLinAtu+=nEspLin
        oPrintPvt:SayAlign(nLinAtu,nColIni +100,cAdm,                              oFontDetI,200,    015,,PAD_LEFT, )
        nLinAtu+=nEspLin
    EndIf //fim do cabeçalho na primeira página
    //impressão vertical                                   ângulo a girar
    oPrintPvt:Say(40,nColIni-15, "Esq:"+ cTextV,oFontMin,,nCorFraca,90)
    oPrintPvt:Say(40,nColFin+15, "Dir:"+ cTextV,oFontMin,,nCorFraca,90)

    //nLinAtu+=10
    //imprimir titulos do resultado
    oPrintPvt:SayAlign(nLinAtu+05, nColProd, "Produto",     oFontMin, 070 , 10 , nCorCinza, PAD_LEFT,)
    oPrintPvt:SayAlign(nLinAtu+05, nColDesc, "Descrição",   oFontMin, 80 , 10 , nCorCinza, PAD_LEFT,)
    oPrintPvt:SayAlign(nLinAtu+05, nColTipo, "TP",          oFontMin, 040 , 10 , nCorCinza, PAD_CENTER,)
    oPrintPvt:SayAlign(nLinAtu+00, nColTDes, "Tipo",        oFontMin, 120 , 10 , nCorCinza, PAD_LEFT,)
    oPrintPvt:SayAlign(nLinAtu+10, nColTDes, "Descrição",   oFontMin, 120 , 10 , nCorCinza, PAD_LEFT,)
    oPrintPvt:SayAlign(nLinAtu+05, nColUMed, "U.M.",        oFontMin, 040 , 10 , nCorCinza, PAD_CENTER,)
    oPrintPvt:SayAlign(nLinAtu+00, nColDUMed, "U.Medida",    oFontMin, 100 , 10 , nCorCinza, PAD_LEFT,)
    oPrintPvt:SayAlign(nLinAtu+10, nColDUMed, "Descrição",   oFontMin, 100 , 10 , nCorCinza, PAD_LEFT,)
    //separatória
    nLinAtu+=020
    oPrintPvt:Line(nLinAtu,nColIni,nLinAtu,nColFin,)
    //linha vertical complementar, primeira linha maior
    oPrintPvt:Line(nLinAtu,nColIni,   nLinAtu+18, nColIni,   nCorCinza)//produto
    oPrintPvt:Line(nLinAtu,nColDesc-2,nLinAtu+18, nColDesc-2,nCorCinza)//desc
    oPrintPvt:Line(nLinAtu,nColTipo+5,nLinAtu+18, nColTipo+5,nCorCinza)//TP
    oPrintPvt:Line(nLinAtu,nColTDes-2,nLinAtu+18, nColTDes-2,nCorCinza)//tp desc
    oPrintPvt:Line(nLinAtu,nColUMed+5,nLinAtu+18, nColUMed+5,nCorCinza)//um
    oPrintPvt:Line(nLinAtu,nColDUMed-2,nLinAtu+18,nColDUMed-2,nCorCinza)//um des
    oPrintPvt:Line(nLinAtu,nColFin,   nLinAtu+18,nColFin,nCorCinza)//final
    nLinAtu+=005

return

Static Function xImpRod()
    Local nLinRod:= nLinFin +10
    Local cText:=""

    //separatória
    oPrintPvt:Line(nLinRod,nColIni,nLinRod,nColFin,nCorFraca)
    nLinRod+=10
    
    cText:=DToC(dDataGer)+"  "+cHoraGer+"  "+FunName()+"(xFWMSP12)  "+cUserName
    
    oPrintPvt:Say(nLinRod,nColIni, cText,oFontMin,400,10,nCorForte,PAD_LEFT)
    cText:="Página "+cValToChar(nPageAtu)
    oPrintPvt:Say(nLinRod,nColFin-40, cText,oFontMin,040,10,nCorForte,PAD_LEFT)

    //finaliza página
    oPrintPvt:EndPage()
    nPageAtu++
return

Static Function xBreackPage()
    //se atingiu o limite, quebra página
    If nLinAtu >= nLinFin-5
        xImpRod()
        xImpCab()
    EndIf
return

Static Function xValidPerg()
	Local aArea  := SX1->(GetArea())
	Local aRegs := {}
	Local i,j

	aadd( aRegs, { cPerg,"01","Produto de ?","Produto de ?","Produto de ?","mv_ch1","C", 15,0,0,"G","","mv_par01","","","mv_par01"," ","",""," ","","","","","","","","","","","","","","","","","","SB1"          } )
	aadd( aRegs, { cPerg,"02","Produto ate ?","Produto ate ?","Produto ate ?","mv_ch2","C", 15,0,0,"G","","mv_par02","","","mv_par02"," ","",""," ","","","","","","","","","","","","","","","","","","SB1"       } )

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



User Function EnviaEmailGmail(cAssunto,cPara,cBody,aAnexos)
    DEFAULT cAssunto:= "Relatório do sistema"
    DEFAULT cBody   := "Segue em anexo o relatório solicitado."
    DEFAULT cPara   := "filipesouza2000@gmail.com"
    DEFAULT aAnexos :={"C:\relato\aula20-fwmsp_20250627_232819.pdf"}
   
    
    GPEmail(cAssunto,cBody,cPara,aAnexos)

Return

