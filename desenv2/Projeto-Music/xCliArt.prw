#INCLUDE "TOTVS.CH"
#INCLUDE "FwMVCDef.ch"
#INCLUDE "TOPCONN.CH"

/*++++DATA++++|++++AUTOR+++++|++++++++++++++++DESCRIÇÂO+++++++++++++
  07/08/2023  | Filipe Souza | Gerar Browse de registro para tabela ZD4-ARTISTA, com relação com SA1-Cliente
                               Na View retirar da oStrArt o campo ZD4_CLI
                               GetSxEnum no ZD4_COD
                               Criar tabela genérica para Gênero Musical, para campo ZD4_GENERO	
                               Testados registros com integridade de dados
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/  
Static cTitulo  := "Registros de Clientes x Artistas"
Static cArt     := "ZD4"
Static cCli     := "SA1"

User Function xCliArt()
    //criação do browse
    Local aArea     :=GetArea()
    Local oBrowse   := FwMBrowse():New()
    Private aRotina :={}
    aRotina := MenuDef()

    oBrowse:SetAlias(cCli)
    oBrowse:SetDescription(cTitulo)
    oBrowse:ACTIVATE()
    RestArea(aArea)
Return 

Static Function MenuDef()
    ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.xCliArt" OPERATION MODEL_OPERATION_VIEW ACCESS 0
    ADD Option aRotina TITLE "Incluir"    ACTION "VIEWDEF.xCliArt" OPERATION MODEL_OPERATION_INSERT ACCESS 0
    ADD Option aRotina TITLE "Alterar"    ACTION "VIEWDEF.xCliArt" OPERATION MODEL_OPERATION_UPDATE ACCESS 0
    ADD Option aRotina TITLE "Excluir"    ACTION "VIEWDEF.xCliArt" OPERATION MODEL_OPERATION_DELETE ACCESS 0
    
return aRotina

Static Function ModelDef()
    Local oStrArt   := FwFormStruct(1,cArt)
    Local oStrCli   := FwFormStruct(1,cCli)
    Local oModel
    Local aRelArt   := {}
    //Local bLinePre := {|oMod|, U_xLPreGrid(oModel)}

    oModel:=MPFormModel():New("xCliArtM",Nil,Nil,Nil,Nil)
    oModel:addFields("SA1Master",/*cOwner*/,oStrCli)
    oModel:AddGrid("ZD4Detail","SA1Master",oStrArt,/*bLinePre*/,/*bLinePos*/,/*bPre-Grid Full*/,/*bLoad-Carga do modelo manual*/,)
    oModel:SetPrimaryKey({"A1_FILIAL","A1_COD"})//,"A1_CGC"
    
    //relacionar SA1 - ZD4
    aAdd(aRelArt, {"ZD4_FILIAL","FWxFilial('ZD4')"})
    aAdd(aRelArt, {"ZD4_CLI","A1_COD"})
    oModel:SetRelation("ZD4Detail", aRelArt, ZD4->(IndexKey(4)))
    
    oModel:GetModel("ZD4Detail"):SetUniqueLine({"ZD4_COD"})
    //totalizador-  titulo,     relacionamento, camo a calcular,visrtual,operação,,,display    
    oModel:AddCalc('Artistas','SA1Master','ZD4Detail','ZD4_COD','XX_TART','COUNT',,,'Artistas')

return oModel

Static Function ViewDef()
    Local oModel    :=FwLoadModel("xCliArt")
    Local oStrCli   :=FWFormStruct(2,cCli)
    Local oStrArt   :=FWFormStruct(2,cArt , {|x| !AllTrim(x) $ 'ZD4_CLI'})
    Local oStrTot   :=FWCalcStruct(oModel:GetModel('Artistas'))
    Local oView

    oView:= FwFormView():New()
    oView:SetModel(oModel)
    oView:addField("VIEW_SA1",oStrCli,"SA1Master")
    oView:addGrid("VIEW_ZD4",oStrArt,"ZD4Detail")    
    oView:addField("VIEW_TOT",oStrTot,"Artistas")

    oView:CreateHorizontalBox("CLI_BOX",50)
    oView:CreateHorizontalBox("ART_BOX",40)        
    oView:CreateHorizontalBox("ENCH_TOT",10)

    oView:SetOwnerView("VIEW_SA1","CLI_BOX")        
    oView:SetOwnerView("VIEW_ZD4","ART_BOX")        
    oView:SetOwnerView("VIEW_TOT","ENCH_TOT")

    oView:EnableTitleView("VIEW_SA1", "Cliente")
    oView:EnableTitleView("VIEW_ZD4", "Artistas")

    //oView:AddIncrementField("ZD4Detail","ZD4_COD")
    oView:SetCloseOnOk({||.T.})
return oView  

//evento pré validação da linha da grid
User Function xlPreGrid(oModel)
    Local oGrid :=  oModel:GetModel('ZD4Detail')
    Local nOp   :=  oModel:GetOperation()
    Local lRet  := .T.   
    //Local nGrid :=  oGrid:Length()
    Local cArt  :=  oGrid:GetValue('ZD4_NOME')
    Local cCod1 :=  oGrid:GetValue('ZD4_COD')
    Local cCod  := GetSxEnum('ZD4','ZD4_COD')

   If Empty(AllTrim(cCod1)) .AND. Empty(AllTrim(cArt)) // .AND. nGrid ==0
      If nOP ==MODEL_OPERATION_UPDATE        
         oGrid:SetValue('ZD4_COD',cCod)        
      EndIf
   EndIf
Return lRet




