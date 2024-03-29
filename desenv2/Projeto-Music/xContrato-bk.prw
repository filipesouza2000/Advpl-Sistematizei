#INCLUDE "TOTVS.CH"
#INCLUDE "FwMVCDef.ch"
#INCLUDE "TOPCONN.CH"

/*++++DATA++++|++++AUTOR+++++|++++++++++++++++DESCRI��O+++++++++++++
  21/07/2023  | Filipe Souza |  An�lise cen�rio contrato de grava��o
                                O layout inicial da agenda passa ser de contrato.
                                O layout da agenda atual � modelo 1, ao selecionar servi�o de grava��o
                                habilita ou exibe campos para buscar cd e m�sica para a grava��o.
    Planejamento @see https://docs.google.com/document/d/1V0EWr04f5LLvjhhBhYQbz8MrneLWxDtVqTkCJIA9kTA/edit?usp=drive_link
    UML          @see https://drive.google.com/file/d/1wFO2CKqSrvzxg5RZDYTfGayHrAUcCcfL/view?usp=drive_link 
    Scrum-kanban @see https://trello.com/w/protheusadvplmusicbusiness       
    GitHug       @see https://github.com/filipesouza2000/Advpl-Sistematizei/tree/main/desenv2/Projeto-Music                                  
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
Static cTitulo  := "Contrato de Servi�o-Grava��o"
Static cCont     := "ZD0"
//Static cCli     := "SA1"
//Static cCD      := "SB1"
//Static cMusica  := "ZD3"

User Function xContrato()
    Local aArea     := GetArea()
    Local oBrowse   
//    Local cArtist
    Private aRotina :={}
    Private cRegCd  :=''

    aRotina := MenuDef()
    //cArtist := U_xArtXcd()
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
    //Local aRotina   := FwMvcmenu("xContrato")
    Local aRotina:={}

    ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.xContrato" OPERATION MODEL_OPERATION_VIEW ACCESS 0
    ADD Option aRotina TITLE "Incluir"    ACTION "VIEWDEF.xContrato" OPERATION MODEL_OPERATION_INSERT ACCESS 0
    ADD Option aRotina TITLE "Alterar"    ACTION "VIEWDEF.xContrato" OPERATION MODEL_OPERATION_UPDATE ACCESS 0
    ADD Option aRotina TITLE "Excluir"    ACTION "VIEWDEF.xContrato" OPERATION MODEL_OPERATION_DELETE ACCESS 0
    
return aRotina


Static Function ModelDef()
    Local oStruCon      :=FWFormStruct(1,cCont)   //remover campo , pois j� exibir� na strutura Pai
    //Local oStruCD       :=FWFormStruct(1,cCD)//, {|x| !AllTrim(x) $ "B1_XART"})
    //Local oStruMu       :=FWFormStruct(1,cMusica)
    //Local aRelCD        :={}
    //Local aRelMusic     :={}    
    Local oModel
    Local bPre          :=NIL
    Local bPos          :=NIL
    Local bCommit       :=NIL
    Local bCancel       :={|| FWFORMCANCEL(SELF)}

    oModel:=MPFormModel():New("xContratoM",bPre,bPos,bCommit,bCancel)
    oModel:addFields("ZD0Master",/*cOwner*/,oStruCon)
    //oModel:AddGrid("SB1Detail","ZD0Master",oStruCD,/*bLinePre*/,/*bLinePos*/,/*bPre-Grid Full*/,/*bLoad-Carga do modelo manual*/,)
    //oModel:AddGrid("ZD3Detail","SB1Detail",oStruMu,/*bLinePre*/,/*bLinePos*/,/*bPre-Grid Full*/,/*bLoad-Carga do modelo manual*/,)
    oModel:SetPrimaryKey({"ZD0_FILIAL","ZD0_COD"})//,"A1_CGC"
    
    //CD- relacionamento B1-CD com A1-Cli 
    //propriedade do cod do artista � obrigat�rio na tabela, mas seta como n�o obrigat�rio para n�o exibir
    //oStruCD:SetProperty("B1_XART", MODEL_FIELD_OBRIGAT, .F.)
    //aAdd(aRelCD, {"B1_FILIAL","FwxFilial('ZD0')"})
    //aAdd(aRelCD, {"B1_COD","ZD0_CODCD"})
    //oModel:SetRelation("SB1Detail", aRelCD, SB1->(IndexKey(1)))
    
    //Musica- relacionamento B1-CD com ZD3-Musica
    //aAdd(aRelMusic,{"ZD3_FILIAL","FwxFilial('SB1')"})
    //aAdd(aRelMusic,{"ZD3_CODCD", "B1_COD"})
    //oModel:SetRelation("SB1Detail", aRelMusic,SB1->(IndexKey(1)))

    //oModel:GetModel("SB1Detail"):SetUniqueLine({"B1_COD"})
    //oModel:GetModel("ZD3Detail"):SetUniqueLine({"ZD3_MUSICA"})
    //totalizador-  titulo,     relacionamento, camo a calcular,visrtual,opera��o,,,display    
    //oModel:AddCalc('Totais','ZD0Master','SB1Detail','B1_COD','XX_TOTCD','COUNT',,,'Total CDs')
    //oModel:AddCalc('Totais','SB1Detail','ZD3Detail','ZD3_MUSICA','XX_TOTM','COUNT',,,'Total Musicas')

return oModel

Static Function ViewDef()
    Local oModel    :=FwLoadModel("xContrato")
    Local oStruCon  :=FWFormStruct(2,cCont)
    //Local oStruCD   :=FWFormStruct(2,cCD, {|x| !AllTrim(x) $ 'B1_AFAMAD'})
    //Local oStruMu   :=FWFormStruct(2,cMusica)
    //Local oStruTot  :=FWCalcStruct(oModel:GetModel('Totais'))
    Local oView
    
    oView:= FwFormView():New()
    oView:SetModel(oModel)
    
    oView:addField("VIEW_ZD0",oStruCon  ,"ZD0Master")
    //oView:addGrid("VIEW_SB1",oStruCD,"SB1Detail")
    //oView:addGrid("VIEW_ZD3",oStruMu ,"ZD3Detail")
    //oView:addField("VIEW_TOT",oStruTot,"Totais")

    oView:CreateHorizontalBox("CONT_BOX",100)
    /*
        oView:CreateHorizontalBox("MEIO_BOX",40)
        oView:CreateVerticalBox("MEIOLEFT",50,"MEIO_BOX")// Vertical BOX
        oView:CreateVerticalBox("MEIORIGHT",50,"MEIO_BOX")// Vertical BOX
        oView:CreateHorizontalBox("ENCH_TOT",10)        
        
        oView:SetOwnerView("VIEW_SB1","MEIOLEFT")
        oView:SetOwnerView("VIEW_ZD3","MEIORIGHT")
        oView:SetOwnerView("VIEW_TOT","ENCH_TOT")

        oView:EnableTitleView("VIEW_SB1", "CDs")
        oView:EnableTitleView("VIEW_ZD3", "M�sicas")
    */
    oView:SetOwnerView("VIEW_ZD0","CONT_BOX")
    oView:EnableTitleView("VIEW_ZD0", "Contrato")
    

    //oStruCD:RemoveField("B1_NOME")
    //oStruMu:RemoveField("ZD3_CD")
    //oStruCD:RemoveField("B1_XART")

    //oView:AddIncrementField("SB1Detail","B1_COD")// gatilho xCodProd()
    //oView:AddIncrementField("ZD3Detail","ZD3_COD")
    //oView:AddIncrementField("ZD3Detail","ZD3_ITEM")
    oView:SetCloseOnOk({||.T.})
return oView

