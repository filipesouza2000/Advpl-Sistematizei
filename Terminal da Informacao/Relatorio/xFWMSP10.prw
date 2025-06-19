#Include "TOTVS.ch"
#Include "TopConn.ch"
#Include "RPTDef.ch"
#Include "FwPrintSetup.ch"

/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
---Data---|-----Autor-------|-------Descrição------------
21/03/2025| Filipe Souza    | Modelo de gráfico com FWMsPrinter 

@see Terminal da Informação
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
*/

User Function xFWMSP10()
    Local   aArea   :=FWGetArea()
    Private lJob    := IsBlind()

    //Se for execução automática via JOB, executa sem pergunta
    If lJob
        Processa({|| fMontaRel()}, "Processando...")
    else//senão exibe pergunta
        If MsgYesNo("Deseja gerar relatório?","Atenção")
            Processa({|| fMontaRel()}, "Processando...")
        EndIf            
    EndIf
    
    FwRestArea(aArea)
return 

Static Function fMontaRel()
    Local       cCaminho,cArquivo :=""
    Private     nLinAtu:=000
    Private     nTamLin:=010
    Private     nLinFin:=820
    Private     nColIni:=010
    Private     nColFin:=550
    Private     nColMeio:= (nColFin-nColIni)/2
    Private     dDataGer:=Date()
    Private     cHoraGer:=Time()
    Private     oPrintPvt

    If lJob
        cCaminho:="/report/"
        cArquivo:="FWMSP_job_"+ dToS(dDataGer) + "_" + StrTran(cHoraGer,':','')+".pdf"
        If !ExistDir(cCaminho)
            MakeDir(cCaminho)
        EndIf

        //cria objeto FwMsprinter
        oPrintPvt:=FwMsprinter():New(;
            cArquivo,;//cFilePrinter
            IMP_PDF,; //nDevice
            .F.,;     //lAdjustToLegacy
            '',;      //cPathInServer
            .T.,;     //lDisableSeturo
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
            IMP_PDF,; //nDevice
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
        
    EndIf
    //Setando atributos do relatório
    oPrintPvt:SetResolution(72)
    oPrintPvt:SetPortrait()
    oPrintPvt:SetPaperSize(DMPAPER_A4)
    oPrintPvt:SetMargin(60,60,60,60)

    //inicializa pagina
    oPrintPvt:StartPage()
    //finaliza página
    oPrintPvt:EndPage()

    //se for via job, imprime o arquivo apra gerar corretamente o pdf
    If lJob
        oPrintPvt:Print()        
    else
        oPrintPvt:Preview()    
    EndIf
return
