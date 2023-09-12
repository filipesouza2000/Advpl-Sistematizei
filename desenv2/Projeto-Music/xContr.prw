#INCLUDE "TOTVS.CH"
#INCLUDE "FwMVCDef.ch"

/*++++DATA++++|++++AUTOR+++++|++++++++++++++++DESCRIÇÂO+++++++++++++
  21/07/2023  | Filipe Souza |  Análise cenário contrato de gravação
                                O layout inicial da agenda passa ser de contrato.
                                O layout da agenda atual é modelo 1, ao selecionar serviço de gravação
                                habilita ou exibe campos para buscar cd e música para a gravação.
    Planejamento @see https://docs.google.com/document/d/1V0EWr04f5LLvjhhBhYQbz8MrneLWxDtVqTkCJIA9kTA/edit?usp=drive_link
    UML          @see https://drive.google.com/file/d/1wFO2CKqSrvzxg5RZDYTfGayHrAUcCcfL/view?usp=drive_link 
    Scrum-kanban @see https://trello.com/w/protheusadvplmusicbusiness       
    GitHug       @see https://github.com/filipesouza2000/Advpl-Sistematizei/tree/main/desenv2/Projeto-Music                                  
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
Static cTitulo  := "Contrato de Serviço-Gravação"
Static cCont     := "ZD5"
//Static cCli     := "SA1"
Static cCD      := "SB1"
Static cMusica  := "ZD3"

User Function xContr()
    Local aArea     := GetArea()
    Local oBrowse   
//    Local cArtist
    Private aRotina :={}
    Private cRegCd  :=''

    aRotina := MenuDef()
    oBrowse:= FwMBrowse():New()
    oBrowse:SetAlias(cCont)
    oBrowse:SetDescription(cTitulo)
    oBrowse:DisableDetails()
    //recebe filtro da lista de artistas a serem listados no bowse
    //oBrowse:SetFilterDefault(cCli+"->A1_COD $"+"'"+cArtist+"'")
    oBrowse:ACTIVATE()
    RestArea(aArea)
return NIL

Static Function MenuDef()
    //Local aRotina   := FwMvcmenu("xContr")
    Local aRotina:={}

    ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.xContr" OPERATION MODEL_OPERATION_VIEW ACCESS 0
    ADD Option aRotina TITLE "Incluir"    ACTION "VIEWDEF.xContr" OPERATION MODEL_OPERATION_INSERT ACCESS 0
    ADD Option aRotina TITLE "Alterar"    ACTION "VIEWDEF.xContr" OPERATION MODEL_OPERATION_UPDATE ACCESS 0
    ADD Option aRotina TITLE "Excluir"    ACTION "VIEWDEF.xContr" OPERATION MODEL_OPERATION_DELETE ACCESS 0
    
return aRotina


Static Function ModelDef()
    Local oStruCon      :=FWFormStruct(1,cCont)   //remover campo , pois já exibirá na strutura Pai
    Local oStruCD       :=FWFormStruct(1,cCD)//, {|x| !AllTrim(x) $ "B1_XART"})
    Local oStruMu       :=FWFormStruct(1,cMusica)
    Local aRelCD        :={}
    Local aRelMusic     :={}    
    Local oModel
    Local bPre          :=NIL
    Local bPos          :=NIL
    Local bCommit       :=NIL
    Local bCancel       :={|| FWFORMCANCEL(SELF)}

    oModel:=MPFormModel():New("xContrM",bPre,bPos,bCommit,bCancel)
    oModel:addFields("ZD5Master",/*cOwner*/,oStruCon)
    oModel:AddGrid("SB1Detail","ZD5Master",oStruCD,/*bLinePre*/,/*bPos*/,/*bPre-Grid Full*/,/*bLoad-Carga do modelo manual*/,)
    oModel:AddGrid("ZD3Detail","SB1Detail",oStruMu,/*bLinePre*/,/*bLinePos*/,/*bPre-Grid Full*/,/*bLoad-Carga do modelo manual*/,)
    oModel:SetPrimaryKey({"ZD5_FILIAL","ZD5_COD"})//,"A1_CGC"
    
    //CD- relacionamento B1-CD com ZD5-Contrato 
    //propriedade do cod do artista é obrigatório na tabela, mas seta como não obrigatório para não exibir
    oStruCD:SetProperty("B1_XART", MODEL_FIELD_OBRIGAT, .F.)
                  
    aAdd(aRelCD, {"B1_FILIAL","FwxFilial('SB1')"})
    aAdd(aRelCD, {"B1_XCONTR","ZD5_COD"})
    oModel:SetRelation("SB1Detail", aRelCD, SB1->(IndexKey(1)))
    
    //Musica- relacionamento B1-CD com ZD3-Musica
    aAdd(aRelMusic,{"ZD3_FILIAL","FwxFilial('ZD3')"})
    aAdd(aRelMusic,{"ZD3_CODCD", "B1_COD"})
    oModel:SetRelation("ZD3Detail", aRelMusic,ZD3->(IndexKey(2)))

    oModel:GetModel("SB1Detail"):SetUniqueLine({"B1_DESC"})
    oModel:GetModel("ZD3Detail"):SetUniqueLine({"ZD3_MUSICA"})
    //totalizador-  titulo,     relacionamento, campo a calcular,virtual,operação,,,display    
    oModel:AddCalc('Totais','ZD5Master','SB1Detail','B1_COD','XX_TOTCD','COUNT',,,'Total CDs')
    oModel:AddCalc('Totais','SB1Detail','ZD3Detail','ZD3_MUSICA','XX_TOTM','COUNT',,,'Total Musicas')
    oModel:AddCalc('Totais','SB1Detail','ZD3Detail','ZD3_DURAC' ,'XX_TOTDUR','SUM',,,'Total Duração')

return oModel

Static Function ViewDef()
    Local oModel    :=FwLoadModel("xContr")
    Local oStruCon  :=FWFormStruct(2,cCont)
    Local oStruCD   :=FWFormStruct(2,cCD, {|x| !AllTrim(x) $ 'B1_AFAMAD'})
    Local oStruMu   :=FWFormStruct(2,cMusica)
    Local oStruTot  :=FWCalcStruct(oModel:GetModel('Totais'))
    Local oView
    
    oView:= FwFormView():New()
    oView:SetModel(oModel)
    
    oView:addField("VIEW_ZD5",oStruCon  ,"ZD5Master")
    oView:addGrid("VIEW_SB1",oStruCD,"SB1Detail")
    oView:addGrid("VIEW_ZD3",oStruMu ,"ZD3Detail")
    oView:addField("VIEW_TOT",oStruTot,"Totais")

    oView:CreateHorizontalBox("CONT_BOX",50)
    
    oView:CreateHorizontalBox("MEIO_BOX",40)
    oView:CreateVerticalBox("MEIOLEFT",50,"MEIO_BOX")// Vertical BOX
    oView:CreateVerticalBox("MEIORIGHT",50,"MEIO_BOX")// Vertical BOX    
    oView:CreateHorizontalBox("ENCH_TOT",10)   
    
    oView:SetOwnerView("VIEW_SB1","MEIOLEFT")
    oView:SetOwnerView("VIEW_ZD3","MEIORIGHT")
    oView:SetOwnerView("VIEW_TOT","ENCH_TOT")

    oView:EnableTitleView("VIEW_SB1", "CDs")
    oView:EnableTitleView("VIEW_ZD3", "Músicas")

    oView:SetOwnerView("VIEW_ZD5","CONT_BOX")
    oView:EnableTitleView("VIEW_ZD5", "Contrato")
    

    //oStruCD:RemoveField("B1_NOME")
    oStruMu:RemoveField("ZD3_CODCD")
    oStruMu:RemoveField("ZD3_COD")
    oStruCD:RemoveField("B1_XART")

    //oView:AddIncrementField("SB1Detail","B1_COD")// gatilho xCodProd()
    oView:AddIncrementField("ZD3Detail","ZD3_COD")
    oView:AddIncrementField("ZD3Detail","ZD3_ITEM")
    oView:SetCloseOnOk({||.T.})
return oView

User Function xTotCd()
    Local oModel
    Local oModelTot := FwModelActive()
    Local oModelCd       

    If oModelTot:Adependency[1][1] == "ZD5Master"
        oModelCd  := oModelTot:GetModel("Totais")        
        nCd       := oModelCd:GetValue("XX_TOTCD")        
        oModel:= oModelTot:GetModel("ZD5Master")
        oModel:SetValue("ZD5_QCD",nCd)         
    EndIf
    
return .T.

User Function xTotMus()
    Local oModel
    Local oModelTot := FwModelActive()
    Local oModelMu 
    Local nMus       

    If oModelTot:Adependency[1][1] == "ZD5Master"
        oModelMu  := oModelTot:GetModel("Totais")
        nMus      := oModelMu:GetValue("XX_TOTM")
        oModel:= oModelTot:GetModel("ZD5Master")
        oModel:SetValue("ZD5_FAIXAS",nMus) 
    EndIf
    
return .T.

User Function xTotDur()
    Local oModel
    Local oModelTot := FwModelActive()
    Local oModelDur 
    Local nDur       

    If oModelTot:Adependency[1][1] == "ZD5Master"
        oModelDur := oModelTot:GetModel("Totais")
        nDur      := oModelDur:GetValue("XX_TOTDUR")
        oModel:= oModelTot:GetModel("ZD5Master")
        oModel:SetValue("ZD5_TEMPO",nDur) 
    EndIf
    
return .T.


