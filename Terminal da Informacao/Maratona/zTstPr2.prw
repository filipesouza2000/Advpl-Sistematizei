//Bibliotecas
#Include "Totvs.ch"
#Include "FWMVCDef.ch"
  
//Variveis Estaticas
Static cTitulo := "Grupo x Produtos"
Static cTabPai := "SBM"
Static cTabFilho := "SB1"
/*
 o cabeçalho é o grupo de produtos (SBM) e a grid são os produtos (SB1), 
 ao alternar entre as linhas da grid, é exibido o saldo do produto (SB2)
 Utilizado AddOtherObject, assim que clicamos na linha do Produto o TGet exibe o saldo que é atualizado
*/    
User Function zTstPr2()
    Local aArea   := FWGetArea()
    Local oBrowse
    Private aRotina := {}
    Private bBlocoAtu := {|| fAtualiza()}
    Private oGetObj, nSaldo := 0
  
    //Definicao do menu
    aRotina := MenuDef()
  
    //Instanciando o browse
    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias(cTabPai)
    oBrowse:SetDescription(cTitulo)
    oBrowse:DisableDetails()
  
    //Ativa a Browse
    oBrowse:Activate()
  
    FWRestArea(aArea)
Return Nil

Static Function MenuDef()
    Local aRotina := {}
  
    //Adicionando opcoes do menu
    ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.zTstPr2" OPERATION 1 ACCESS 0
  
Return aRotina

Static Function ModelDef()
    Local oStruPai := FWFormStruct(1, cTabPai)
    Local oStruFilho := FWFormStruct(1, cTabFilho)
    Local aRelation := {}
    Local oModel
    Local bPre := bBlocoAtu
    Local bPos := Nil
    Local bCommit := Nil
    Local bCancel := Nil
  
  
    //Cria o modelo de dados para cadastro
    oModel := MPFormModel():New("zTstPr2M", bPre, bPos, bCommit, bCancel)
    oModel:AddFields("SBMMASTER", /*cOwner*/, oStruPai)
    oModel:AddGrid("SB1DETAIL","SBMMASTER",oStruFilho,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)
    oModel:SetDescription("Modelo de dados - " + cTitulo)
    oModel:GetModel("SBMMASTER"):SetDescription( "Dados de - " + cTitulo)
    oModel:GetModel("SB1DETAIL"):SetDescription( "Grid de - " + cTitulo)
    oModel:SetPrimaryKey({})
  
    //Fazendo o relacionamento
    aAdd(aRelation, {"B1_FILIAL", "FWxFilial('SB1')"} )
    aAdd(aRelation, {"B1_GRUPO", "BM_GRUPO"})
    oModel:SetRelation("SB1DETAIL", aRelation, SB1->(IndexKey(1)))
  
Return oModel

Static Function ViewDef()
    Local oModel := FWLoadModel("zTstPr2")
    Local oStruPai := FWFormStruct(2, cTabPai)
    Local oStruFilho := FWFormStruct(2, cTabFilho)
    Local oView
    Local aChangeLine := {}
  
    aAdd(aChangeLine, bBlocoAtu)
  
    //Cria a visualizacao do cadastro
    oView := FWFormView():New()
    oView:SetModel(oModel)
    oView:AddField("VIEW_SBM", oStruPai, "SBMMASTER")
    oView:AddGrid("VIEW_SB1",  oStruFilho,  "SB1DETAIL")
    oView:AddOtherObject("VIEW_OTHER", {|oPanel| fCustom(oPanel)})
  
    //Definindo que irá mudar a cor da linha, e irá acionar para atualizar o totalizador ao alternar de linhas
    oView:SetViewProperty("VIEW_SB1", "SETCSS", {"QTableView { selection-background-color: #1C9DBD; selection-color: #FFFFFF; }"} )
    oView:SetViewProperty("VIEW_SB1", "CHANGELINE", aChangeLine)
  
    //Partes da tela
    oView:CreateHorizontalBox("CABEC", 30)
    oView:CreateHorizontalBox("GRID", 55)
    oView:CreateHorizontalBox("ENCH_TOT", 15)
    oView:SetOwnerView("VIEW_SBM", "CABEC")
    oView:SetOwnerView("VIEW_SB1", "GRID")
    oView:SetOwnerView("VIEW_OTHER", "ENCH_TOT")
  
    //Titulos
    oView:EnableTitleView("VIEW_SBM", "Cabecalho - SBM")
    oView:EnableTitleView("VIEW_SB1", "Grid - SB1")
    oView:EnableTitleView("VIEW_OTHER", "Totalizadores")
  
    //Removendo campos
    oStruFilho:RemoveField("B1_GRUPO")
  
Return oView
  
Static Function fCustom(oPanel)
    Local aArea       := FWGetArea()
    Local cFontNome   := "Tahoma"
    Local oFontPadrao := TFont():New(cFontNome, , -12)
    Local lDimPixels  := .T.
  
    //objeto2 - usando a classe TSay
    nObjLinha := 18
    nObjColun := 4
    nObjLargu := 45
    nObjAltur := 6
    oSayObj   := TSay():New(nObjLinha, nObjColun, {|| "Saldo Produto:"}, oPanel, /*cPicture*/, oFontPadrao, , , , lDimPixels, /*nClrText*/, /*nClrBack*/, nObjLargu, nObjAltur, , , , , , /*lHTML*/)
  
    //objeto3 - usando a classe TGet
    nObjLinha := 16
    nObjColun := 49
    nObjLargu := 100
    nObjAltur := 10
    oGetObj   := TGet():New(nObjLinha, nObjColun, {|| nSaldo}, oPanel, nObjLargu, nObjAltur, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels)
    oGetObj:lReadOnly  := .T.
  
    FWRestArea(aArea)
Return
  
Static Function fAtualiza()
    Local aArea    := FWGetArea()
    Local cProduto := ""
    Local cArmazem := ""
    Local dDataFim := sToD("")
    Local oGrid    := Nil
    Default oModel := FWModelActive()
  
    //Pega a grid e os totalizadores
    oGrid := oModel:GetModel("SB1DETAIL")
  
    //Define os parâmetros que serão usados no CalcEst
    cProduto := oGrid:GetValue("B1_COD")
    cArmazem := "01"
    dDataFim := DaySum(Date(), 1)
  
    //Busca os saldos
    aSaldos := CalcEst(cProduto, cArmazem, dDataFim)
  
    //Define o retorno
    nSaldo := aSaldos[1]
    If Type("oGetObj") != "U"
        oGetObj:Refresh()
    EndIf
  
    FWRestArea(aArea)
Return
