#INCLUDE "TOTVS.CH"
#INCLUDE "FwMVCDef.ch"

Static cTitulo  := "Artistas x Cds x Músicas"
Static cCli  := "SA1"
Static cCD:= "SB1"
//Static cMusica := "ZD3"

/*++++DATA++++|++++AUTOR+++++|++++++++++++++++DESCRIÇÂO+++++++++++++
  08/07/2023  | Filipe Souza |  Projeto Music, com Scrum-Kanban
                                Cadastro de Artistas x Cds x Músicas no Modelo X em MVC, tabelas, SA1 SB1
                                Onde produto tem tipo CD, MUSICA
  09/07/2023  | Filipe Souza |  Primeira etapa MODELO1-SA1
                                OBS: Cenário de gravação no estudio participará SA1 Cliente
                                     Cenário de registro para venda participará SA2 Fornecedor
                                     Condicionar o cenário para exibição do formulário certo.
    Planejamento
@see https://docs.google.com/document/d/1V0EWr04f5LLvjhhBhYQbz8MrneLWxDtVqTkCJIA9kTA/edit?usp=drive_link
    UML
@see https://drive.google.com/file/d/1wFO2CKqSrvzxg5RZDYTfGayHrAUcCcfL/view?usp=drive_link                                      
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/

User Function xCDModX()
    Local aArea     := GetArea()
    Local oBrowse   
    Private aRotina :={}

    aRotina := MenuDef()

    oBrowse:= FwMBrowse():New()
    oBrowse:SetAlias(cCli)
    oBrowse:SetDescription(cTitulo)
    oBrowse:DisableDetails()

    oBrowse:ACTIVATE()
    RestArea(aArea)
return NIL

Static Function MenuDef()
    //Local aRotina   := FwMvcmenu("xCDModX")
    Local aRotina:={}

    ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.xCDModX" OPERATION MODEL_OPERATION_VIEW ACCESS 0
    ADD Option aRotina TITLE "Incluir"    ACTION "VIEWDEF.xCDModX" OPERATION MODEL_OPERATION_INSERT ACCESS 0
    ADD Option aRotina TITLE "Alterar"    ACTION "VIEWDEF.xCDModX" OPERATION MODEL_OPERATION_UPDATE ACCESS 0
    ADD Option aRotina TITLE "Excluir"    ACTION "VIEWDEF.xCDModX" OPERATION MODEL_OPERATION_DELETE ACCESS 0
    
return aRotina


Static Function ModelDef()
    Local oStruCli      :=FWFormStruct(1,cCli)   //remover campo virtual, pois já exibirá na strutura Pai
    Local oStruCD       :=FWFormStruct(1,cCD, {|x| !AllTrim(x) $ "B1_DESC"})
    Local oStruMu       :=FWFormStruct(1,cMusica)
    Local aRelCD        :={}
    Local aRelMusic     :={}
    
    Local oModel
    Local bPre          :=NIL
    Local bPos          :=NIL
    Local bCommit       :=NIL
    Local bCancel       :=NIL

    oModel:=MPFormModel():New("xCDModXm",bPre,bPos,bCommit,bCancel)
    oModel:addFields("SA1Master",/*cOwner*/,oStruCli)
    oModel:AddGrid("SB1Detail","SA1Master",oStruCD,/*bLinePre*/,/*bLinePos*/,/*bPre-Grid Full*/,/*bLoad-Carga do modelo manual*/,)
    oModel:AddGrid("ZD3Detail","SB1Detail",oStruMu,/*bLinePre*/,/*bLinePos*/,/*bPre-Grid Full*/,/*bLoad-Carga do modelo manual*/,)
    oModel:SetPrimaryKey({"A1_FILIAL","A1_COD","A1_CGC"})
    
    //CD
    //propriedade do cod do artista é obrigatório na tabela, mas seta como não obrigatório para não exibir
    oStruCD:SetProperty("B1_XART", MODEL_FIELD_OBRIGAT, .F.)
    aAdd(aRelCD, {"B1_FILIAL","FwxFilial('SA1')"})
    aAdd(aRelCD, {"B1_XART","A1_COD"})
    oModel:SetRelation("SB1Detail", aRelCD, SB1->(IndexKey(1)))
    
    //Musica
    aAdd(aRelMusic,{"ZD3_FILIAL","FwxFilial('SB1')"})
    aAdd(aRelMusic,{"ZD3_CD", "B1_COD"})
    oModel:SetRelation("SB1Detail", aRelMusic,SB1->(IndexKey(1)))

    oModel:GetModel("SB1Detail"):SetUniqueLine({"B1_COD"})
    //oModel:GetModel("SB1Detail"):SetUniqueLine({"B1_MUSICA"})
return oModel

Static Function ViewDef()
    Local oModel    :=FwLoadModel("xCDModX")
    Local oStruCli  :=FWFormStruct(2,cCli)
    Local oStruCD:=FWFormStruct(2,cCD, {|x| !AllTrim(x) $ 'B1_DESC'})
    //Local oStruMu :=FWFormStruct(2,cMusica)
    Local oView

    oView:= FwFormView():New()
    oView:SetModel(oModel)
    oView:addField("VIEW_SA1",oStruCli  ,"SA1Master")
    oView:addGrid("VIEW_SB1",oStruCD,"SB1Detail")
   // oView:addGrid("VIEW_SB1",oStruMu ,"SB1Detail")

    oView:CreateHorizontalBox("CAB_PAI",40)
    oView:CreateHorizontalBox("GRID_CD",30)
    //oView:CreateHorizontalBox("GRID_Musica",30)
    oView:SetOwnerView("VIEW_SA1","CAB_PAI")
    oView:SetOwnerView("VIEW_SB1","GRID_CD")
    //oView:SetOwnerView("VIEW_SB1","GRID_Musica")

    oView:EnableTitleView("VIEW_SA1", "Artistas Musicais")
    oView:EnableTitleView("VIEW_SB1", "CDs")
    //oView:EnableTitleView("VIEW_SB1", "Músicas")

    //oStruCD:RemoveField("B1_ARTIST")
    //oStruCD:RemoveField("B1_NOME")
    //oStruMu:RemoveField("B1_CD")

    oView:AddIncrementField("SB1Detail","B1_COD")
    //oView:AddIncrementField("ZD3Detail","ZD3_ITEM")
    oView:SetCloseOnOk({||.T.})
return oView
