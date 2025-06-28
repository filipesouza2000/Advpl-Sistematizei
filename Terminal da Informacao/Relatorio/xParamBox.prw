[?? Suspicious Content] //Bibliotecas
#Include "TOTVS.ch"
 
/*/{Protheus.doc} User Function zExe380
    Abre uma tela de par�metros para o usu�rio informar nos campos
    @type Function
    @author Atilio
    @since 28/03/2023
    @obs 
 
    Fun��o ParamBox
    Par�metros
        Array com as defini��es das perguntas
        T�tulo da Janela
        Array de retorno caso queira utilizar no lugar das vari�veis MV_PAR**
        Bloco de c�digo executado ao clicar em Confirmar
        Array de outros bot�es que ser�o exibidos na tela
        Define se a janela ser� aberta centralizada (.T.) ou n�o (.F.)
        Define a coordenada em x que a janela ser� aberta
        Define a coordenada em y que a janela ser� aberta
        Nome do Objeto / Wizard, em que a pergunta ser� exibida dentro
        Nome da rotina que esta carregando (que depois ser� salva no profile caso seja gravado)
        Define se os bot�es de salvar estar�o habilitados
        Define se ser� salvo por perfil de usu�rio
    Retorno
        Retorna .T. se foi clicado em Confirmar ou .F. se foi em Cancelar
 
    Obs.: Caso queiram fazer valida��es no ParamBox, recomendo a leitura desse artigo:
    <div class="video-container"><blockquote class="wp-embedded-content" data-secret="atbSg6vG1a" style="display: none;"><a href="https://terminaldeinformacao.com/2021/12/02/como-fazer-validacoes-em-um-parambox/">Como fazer valida��es em um ParamBox</a></blockquote><iframe class="wp-embedded-content" sandbox="allow-scripts" security="restricted" title="�Como fazer valida��es em um ParamBox� � Terminal de Informa��o" src="https://terminaldeinformacao.com/2021/12/02/como-fazer-validacoes-em-um-parambox/embed/#?secret=duICFmrNUu#?secret=atbSg6vG1a" data-secret="atbSg6vG1a" width="600" height="549" frameborder="0" marginwidth="0" marginheight="0" scrolling="no"></iframe></div>
 
    Obs.2: Caso desejam ver as posi��es de cada uma das op��es do Array com as defini��es
    de perguntas, recomendo a leitura do artigo disponibilizado pelo pessoal do BlackTDN:
    https://www.blacktdn.com.br/2012/05/para-quem-precisar-desenvolver-uma.html
 
    **** Apoie nosso projeto, se inscreva em https://www.youtube.com/TerminalDeInformacao ****
/*/
 
User Function zExe380()
    Local aArea      := FWGetArea()
     
    fExempSimp()
 
    fExempComp()
 
    FWRestArea(aArea)
Return
 
Static Function fExempSimp()
    Local aPergs   := {}
    Local cProdDe  := Space(TamSX3('B1_COD')[01])
    Local cProdAt  := Space(TamSX3('B1_COD')[01])
    Local dDataDe  := FirstDate(Date())
    Local dDataAt  := LastDate(dDataDe)
    Local nTipo    := 3
     
    //Adiciona as perguntas utilizadas na tela de par�metros
    aAdd(aPergs, {1, "Produto De",  cProdDe,  "", "ExistCPO('SB1')", "SB1", ".T.", 60,  .F.})
    aAdd(aPergs, {1, "Produto At�", cProdAt,  "", "ExistCPO('SB1')", "SB1", ".T.", 60,  .T.})
    aAdd(aPergs, {1, "Data De",  dDataDe,  "", ".T.", "", ".T.", 80,  .F.})
    aAdd(aPergs, {1, "Data At�", dDataAt,  "", ".T.", "", ".T.", 80,  .T.})
    aAdd(aPergs, {2, "Tipo do Filtro",      nTipo, {"1=N�o Bloqueados", "2=Somente Bloqueados", "3=Ambos"},  090, ".T.", .F.})
 
    //Se a pergunta foi confirmada    
    If ParamBox(aPergs, "Informe os par�metros")
        MV_PAR05 := Val(cValToChar(MV_PAR05))
 
        FWAlertSuccess("Pergunta confirmada", "Teste Simples de ParamBox")
    EndIf
 
Return
 
Static Function fExempComp()
    Local aPergs   := {}
    Local cProduto := Space(TamSX3('B1_COD')[01])
    Local nTipoCmb := 3
    Local nTipoRad := 3
    Local lFiltArm := .T.
    Local lFiltGrp := .T.
    Local cArquivo := "C:\spool\teste.txt"
     
    //Adiciona as perguntas utilizadas na tela de par�metros
    aAdd(aPergs, { 1, "01 (Get) - Informe o Produto",        cProduto,  "", "ExistCPO('SB1')", "SB1", ".T.", 60,  .T.})
    aAdd(aPergs, { 2, "02 (Combo) - Tipo",                   nTipoCmb, {"1=N�o Bloqueados", "2=Somente Bloqueados", "3=Ambos"},  090, ".T.", .F.})
    aAdd(aPergs, { 3, "03 (Radio) - Tipo",                   nTipoRad, {"1=N�o Bloqueados", "2=Somente Bloqueados", "3=Ambos"},  090, ".T.", .F., ".T."})
    aAdd(aPergs, { 4, "04 (CheckBox) - Filtra Armaz�m 01",   lFiltArm, "Sim, ser� filtrado",  090, ".T.", .F.})
    aAdd(aPergs, { 5, "05 (CheckBox) - Filtra Grupo G001",   lFiltGrp, 100, ".T."})
    aAdd(aPergs, { 6, "06 (File) - Caminho do arquivo",      cArquivo, "", ".T.", ".T.", 100, .F., "Arquivos txt|*.txt| Arquivos csv|*.csv", "C:\spool\", GETF_LOCALHARD  + GETF_NETWORKDRIVE, .T.})
    aAdd(aPergs, { 7, "07 (Filtro) - Filtro espec�fico",     "SB1", "", .T.})
    aAdd(aPergs, { 8, "08 (Password) - Informe a Senha",     "beluga",  "", ".T.", "", ".T.", 60,  .T.})
    aAdd(aPergs, { 9, "09 (Say) - Apenas uma frase",         100, 20, .T.})
    aAdd(aPergs, {10, "10 (Range) - Range de dados",         "", "SB1", 110, "C", 50, ".T."})
    aAdd(aPergs, {11, "11 (Memo) - Digite uma frase",        "aaaa", ".T.", ".T.", .F.})
    aAdd(aPergs, {12, "12 (Filtro) - Informe o filtro",      "SB1", "", ".T."})
 
    //Se a pergunta foi confirmada    
    If ParamBox(aPergs, "Informe os par�metros", , , , , , , , , .F., .F.)
        MV_PAR02 := Val(cValToChar(MV_PAR02))
        MV_PAR03 := Val(cValToChar(MV_PAR03))
 
        FWAlertSuccess("Pergunta confirmada", "Teste Completo de ParamBox")
    EndIf
 
Return
