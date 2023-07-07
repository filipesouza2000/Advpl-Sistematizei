#INCLUDE "TOTVS.CH"
#INCLUDE "FwMVCDef.ch"

Static cTitulo  := "Artistas x Cds x Músicas"
Static cTabPai  := "ZD1"
Static cTabFilho:= "ZD2"
Static cTabNeto := "ZD3"

/*++++DATA++++|++++AUTOR+++++|++++++++++++++++DESCRIÇÂO+++++++++++++
  05/01/2023  | Filipe Souza |  Modelo X em MVC, tabelas Artistas x Cds x Músicas
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/

User Function xModeloX()
    Local aArea     := GetArea()
    Local oBrowse   
    Private aRotina :={}

    aRotina := MenuDef()

    oBrowse:= FwMBrowse():New()
    oBrowse:SetAlias(cTabPai)
    oBrowse:SetDescription(cTitulo)
    oBrowse:DisableDetails()

    oBrowse:ACTIVATE()
    RestArea(aArea)
return NIL

Static Function MenuDef()
    Local aRotina   := FwMvcmenu("xModeloX")
    /*Local aRotina:={}

    ADD Option aRotina TITLE "Visualizar" ACTION "VIEWDEF.xModeloX" OPERATION MODEL_OPERATION_VIEW ACCESS 0
    ADD Option aRotina TITLE "Incluir"    ACTION "VIEWDEF.xModeloX" OPERATION MODEL_OPERATION_INSERT ACCESS 0
    ADD Option aRotina TITLE "Alterar"    ACTION "VIEWDEF.xModeloX" OPERATION MODEL_OPERATION_UPDATE ACCESS 0
    ADD Option aRotina TITLE "Excluir"    ACTION "VIEWDEF.xModeloX" OPERATION MODEL_OPERATION_DELETE ACCESS 0
    */
return aRotina


Static Function ModelDef()
    Local oStruPai      :=FWFormStruct(1,cTabPai)   //remover campo virtual, pois já exibirá na strutura Pai
    Local oStruFilho    :=FWFormStruct(1,cTabFilho, {|x| !AllTrim(x) $ "ZD2_NOME"})
    Local oStruNeto     :=FWFormStruct(1,cTabNeto)
    Local aRelFilho     :={}
    Local aRelNeto      :={}
    Local oModel
    Local bPre          :=NIL
    Local bPos          :=NIL
    Local bCommit       :=NIL
    Local bCancel       :=NIL

    oModel:=MPFormModel():New("xModeloXm",bPre,bPos,bCommit,bCancel)
    oModel:addFields("ZD1Master",/*cOwner*/,oStruPai)
    oModel:AddGrid("ZD2Detail","ZD1Master",oStruFilho,/*bLinePre*/,/*bLinePos*/,/*bPre-Grid Full*/,/*bLoad-Carga do modelo manual*/,)
    oModel:AddGrid("ZD3Detail","ZD2Detail",oStruNeto,/*bLinePre*/,/*bLinePos*/,/*bPre-Grid Full*/,/*bLoad-Carga do modelo manual*/,)
    oModel:SetPrimaryKey({})

    //propriedade do cod do artista é obrigatório na tabela, mas seta como não obrigatório para não exibir
    oStruFilho:SetProperty("ZD2_ARTIST", MODEL_FIELD_OBRIGAT, .F.)
    aAdd(aRelFilho, {"ZD2_FILIAL","FwxFilial('ZD2')"})
    aAdd(aRelFilho, {"ZD2_ARTIST","ZD1_CODIGO"})
    oModel:SetRelation("ZD2Detail", aRelFilho, ZD2->(IndexKey(1)))

    aAdd(aRelNeto,{"ZD3_FILIAL","FwxFilial('ZD3')"})
    aAdd(aRelNeto,{"ZD3_CD", "ZD2_CD"})
    oModel:SetRelation("ZD3Detail", aRelNeto,ZD3->(IndexKey(1)))

    oModel:GetModel("ZD2Detail"):SetUniqueLine({"ZD2_CD"})
    oModel:GetModel("ZD3Detail"):SetUniqueLine({"ZD3_MUSICA"})
    
return oModel

Static Function ViewDef()
    Local oModel    :=FwLoadModel("xModeloX")
    Local oStruPai  :=FWFormStruct(2,cTabPai)
    Local oStruFilho:=FWFormStruct(2,cTabFilho, {|x| !AllTrim(x) $ 'ZD2_NOME'})
    Local oStruNeto :=FWFormStruct(2,cTabNeto)
    Local oView

    oView:= FwFormView():New()
    oView:SetModel(oModel)
    oView:addField("VIEW_ZD1",oStruPai  ,"ZD1Master")
    oView:addField("VIEW_ZD2",oStruFilho,"ZD2Detail")
    oView:addField("VIEW_ZD3",oStruNeto ,"ZD3Detail")

    oView:CreateHorizontalBox("CAB_PAI",30)
    oView:CreateHorizontalBox("GRID_FILHO",40)
    oView:CreateHorizontalBox("GRID_NETO",30)
    oView:SetOwnerView("VIEW_ZD1","CAB_PAI")
    oView:SetOwnerView("VIEW_ZD2","GRID_FILHO")
    oView:SetOwnerView("VIEW_ZD3","GRID_NETO")

    oView:EnableTitleView("VIEW_ZD1", "Pai-ZD1(Artistas)")
    oView:EnableTitleView("VIEW_ZD2", "Filho-ZD2(CDs)")
    oView:EnableTitleView("VIEW_ZD3", "Neto-ZD3(Músicas)")

    oStruFilho:RemoveField("ZD2_ARTIST")
    oStruFilho:RemoveField("ZD2_NOME")
    oStruNeto:RemoveField("ZD3_CD")

    oView:AddIncrementField("ZD3Detail","ZD3_ITEM")

return oView
