#Include "TOTVS.ch"
#Include "TopConn.ch"
#Include "RPTDef.ch"
#Include "FwPrintSetup.ch"

#Define PAD_LEFT    0
#Define PAD_RIGHT   1
#Define PAD_CENTER  2
#Define PAD_JUSTIFY  3

/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
---Data---|-----Autor-------|-------Descrição------------
10/06/2023| Filipe Souza    | Aula 12 - FWMSPrinter - Imprimindo texto com SayAlign
                              Aula 13 - FWMSPrinter - Imprimindo texto na vertical com Say

@see Terminal da Informação
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
*/

User Function xFWMSP12()
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
    Local       cTexto      :=xMkText()
    Private     nLinAtu     :=000
    Private     nTamLin     :=010
    Private     nLinFin     :=820
    Private     nColIni     :=010
    Private     nColFin     :=550
    Private     nColMeio    := (nColFin-nColIni)/2
    Private     nEspLin     :=015
    Private     dDataGer    :=Date()
    Private     cHoraGer    :=Time()
    Private     oPrintPvt   
    Private     cNomeFont   :="Arial"
                                        //font     ,,tam,negr,,,,subl,ital        
    Private     oFontDet    :=TFont():New(cNomeFont,,-11,,.F.,,,,.F.,.F.)       
    Private     oFontCabN   :=TFont():New(cNomeFont,,-15,,.T.,,,,.F.,.F.)   
    Private     oFontDetN   :=TFont():New(cNomeFont,,-13,,.T.,,,,.F.,.F.) 
    Private     oFontDetI   :=TFont():New(cNomeFont,,-11,,.F.,,,,.F.,.T.)  
    Private     oFontMin    :=TFont():New(cNomeFont,,-09,,.F.,,,,.F.,.F.) 
    Private     cTextV      :="Assinatura Premium do Terminal de Informação, veja https://terminaldeinformacao.com/hotmart"

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
    
    nLinAtu:=40
    oPrintPvt:SayAlign(nLinAtu,nColIni +200,"Dados: ",                          oFontDetN,200,    015,,PAD_LEFT, )
    nLinAtu+=nEspLin
    oPrintPvt:SayAlign(nLinAtu,nColIni +200,"Terminal de Informação:",          oFontCabN,200,    015,,PAD_LEFT, )
    nLinAtu+=nEspLin+5
    oPrintPvt:SayAlign(nLinAtu,nColIni +200,"Site: ",                           oFontDetN,200,    015,,PAD_LEFT, )
    oPrintPvt:SayAlign(nLinAtu,nColIni +270,"https://terminaldeinformacao ",    oFontDet ,200,    015,,PAD_LEFT, )
    nLinAtu+=nEspLin
    oPrintPvt:SayAlign(nLinAtu,nColIni +200,"E-mail: ",                         oFontDetN,200,    015,,PAD_LEFT, )
    oPrintPvt:SayAlign(nLinAtu,nColIni +270,"suporte@terminaldeinformacao.com ",oFontDet ,200,    015,,PAD_LEFT, )
    nLinAtu+=nEspLin
    oPrintPvt:SayAlign(nLinAtu,nColIni +200,"Whats App: ",                       oFontDetN,200,    015,,PAD_LEFT, )
    oPrintPvt:SayAlign(nLinAtu,nColIni +270,"(14)997385495 ",                    oFontDet ,200,    015,,PAD_LEFT, )
    nLinAtu+=nEspLin
    oPrintPvt:SayAlign(nLinAtu,nColIni +200,"Atílio Sistemas",                   oFontDetI,200,    015,,PAD_LEFT, )
    nLinAtu+=nEspLin
    nLinAtu+=30
    oPrintPvt:SayAlign(nLinAtu,nColIni,cTexto,               oFontDet,(nColFin-nColIni),    300,,PAD_JUSTIFY, )
    
    //impressão vertical                                   ângulo a girar
    oPrintPvt:Say(40,nColIni-15, "Esq:"+ cTextV,oFontMin,,,90)
    oPrintPvt:Say(40,nColFin+15, "Dir:"+ cTextV,oFontMin,,,90)
    //finaliza página
    oPrintPvt:EndPage()

    //se for via job, imprime o arquivo apra gerar corretamente o pdf
    If lJob
        oPrintPvt:Print()        
    else
        oPrintPvt:Preview()    
    EndIf
return

Static Function xMkText()
Local cText:="O Terminal de Informação (Projeto ‘Ti’), foi criado para compartilhar ideias e informações com outros usuários, tratando de diversos assuntos,"+;
            " como sistemas operacionais (OpenSUSE, Windows e outras distros Linux), projetos da Mozilla, Desenvolvimento (Java, C / C++ e AdvPL),"+;
            " tutoriais, análises e dicas de aplicativos e produtos, dentre outros assuntos."+CHR(10)+CHR(13)+;
            "Tudo começou em 2012 (dia 08/08/2012 para ser mais preciso), e desde então o projeto não parou mais de crescer, recebendo sempre feedbacks positivos de toda a comunidade."+CHR(10)+CHR(13)+;
            "Em 2016 foi feita uma grande mudança para hospedagem própria, muita coisa no Terminal mudou, e cada vez mais focando em artigos de qualidade para os usuários."+CHR(10)+CHR(13)+;
            "Só tenho a agradecer aos amigos e aos internautas que sempre apoiam o projeto Ti."+CHR(10)+CHR(13)+;
            "Espero que gostem."+CHR(10)+CHR(13)+;
            "Sugestões, Críticas ou outras ideias, podem entrar em contato."
return cText
