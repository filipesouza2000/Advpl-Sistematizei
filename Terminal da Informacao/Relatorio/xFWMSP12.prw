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
                              Aula 14 - FWMSPrinter - Imprimindo imagens com SayBitmap 
                              Aula 15 - FWMSPrinter - Imprimindo QRCode
                              Aula 16 - FWMSPrinter - Imprimindo linhas e quadros com os métodos Line e Box
                              Aula 17 - FWMSPrinter - Utilizando cores nos textos
                              Aula 18 - FWMSPrinter - Pintando uma cor de fundo com FillRect
@see Terminal da Informação
@see https://tdn.totvs.com/display/public/framework/FWMsPrinter
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
    Local       cLogo       :="\x_imagens\ti_logo.png"
    Local       cUrl        :="http://terminaldeinformacao.com"
    Local       cMail       :="suporte@terminaldeinformacao.com "
    Local       cTel        :="(14)997385495 "
    Local       cAdm        :="Atílio Sistemas"
    Local       nLarg       :=90
    Local       nAlt        :=90
    Private     nLinAtu     :=000
    Private     nTamLin     :=010
    Private     nLinFin     :=820
    Private     nColIni     :=010
    Private     nColFin     :=550
    Private     nColMeio    := (nColFin-nColIni)/2
    Private     nEspLin     :=015
    Private     nFimQdr     :=0
    Private     dDataGer    :=Date()
    Private     cHoraGer    :=Time()
    Private     nCorFraca   :=RGB(198,239,206)
    Private     nCorForte   :=RGB(003,101,002)
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
