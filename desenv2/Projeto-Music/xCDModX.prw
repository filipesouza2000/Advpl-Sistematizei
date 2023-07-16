#INCLUDE "TOTVS.CH"
#INCLUDE "FwMVCDef.ch"
#INCLUDE "TOPCONN.CH"

Static cTitulo  := "Artistas x Cds x Músicas"
Static cCli  := "SA1"
Static cCD:= "SB1"
Static cMusica := "ZD3"

/*++++DATA++++|++++AUTOR+++++|++++++++++++++++DESCRIÇÂO+++++++++++++
  08/07/2023  | Filipe Souza |  Projeto Music, com Scrum-Kanban
                                Cadastro de Artistas x Cds x Músicas no Modelo X em MVC, tabelas, SA1 SB1
                                Onde produto tem tipo CD, MUSICA
  09/07/2023  | Filipe Souza |  MODELO1-SA1                                
  10/07/2023  | Filipe Souza |  ModeloX-SA1-SB1-ZD3
                                Criar campo B1_XART para relacionar com A1_COD
                                Criar campo B1_XEST para receber codigo de estudio
                                Alterar Layout de horinzontal para vertical
                                Remover campo B1_XART da estrutura a não exibir.
                                Remover campo B1_AFAMAD da estrutura a não exibir.
                                Desabiliar campo A1_COD, iniciar com GETXENUM
                                Desabiliar campo A2_COD, iniciar com GETXENUM
                                Desabilitar e retirar autoincrement do B1_COD, utilizar gatilho a função xCodProd 
                                    -mudar gatilho para chamar só B1_TIPO
                                    -resolvido a sequencia B1_COD que parava em único registro.
                                    -no evento cancelar, zerar a variável Private que lega o cod do registro.
                                Totalizadores para CD e Musicas
  11/07/2023  | Filipe Souza |  Reanálise dos cenários para Agendamento de ensaio e gravação.   
                               

    Planejamento
@see https://docs.google.com/document/d/1V0EWr04f5LLvjhhBhYQbz8MrneLWxDtVqTkCJIA9kTA/edit?usp=drive_link
    UML
@see https://drive.google.com/file/d/1wFO2CKqSrvzxg5RZDYTfGayHrAUcCcfL/view?usp=drive_link 
    Scrum e kanban
@see https://trello.com/w/protheusadvplmusicbusiness       
    GitHug
@see https://github.com/filipesouza2000/Advpl-Sistematizei/tree/main/desenv2/Projeto-Music                                  
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/

User Function xCDModX()
    Local aArea     := GetArea()
    Local oBrowse   
    Local cArtist
    Private aRotina :={}
    Private cRegCd  :=''

    aRotina := MenuDef()
    cArtist := U_xArtXcd()
    oBrowse:= FwMBrowse():New()
    oBrowse:SetAlias(cCli)
    oBrowse:SetDescription(cTitulo)
    oBrowse:DisableDetails()
    //recebe filtro da lista de artistas a serem listados no bowse
    oBrowse:SetFilterDefault(cCli+"->A1_COD $"+"'"+cArtist+"'")
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
    Local oStruCli      :=FWFormStruct(1,cCli)   //remover campo , pois já exibirá na strutura Pai
    Local oStruCD       :=FWFormStruct(1,cCD)//, {|x| !AllTrim(x) $ "B1_XART"})
    Local oStruMu       :=FWFormStruct(1,cMusica)
    Local aRelCD        :={}
    Local aRelMusic     :={}    
    Local oModel
    Local bPre          :=NIL
    Local bPos          :=NIL
    Local bCommit       :=NIL
    Local bCancel       :={|| U_xCDMcan(@cRegCd)} 

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
    oModel:GetModel("ZD3Detail"):SetUniqueLine({"ZD3_MUSICA"})
    //totalizador-  titulo,     relacionamento, camo a calcular,visrtual,operação,,,display    
    oModel:AddCalc('Totais','SA1Master','SB1Detail','B1_COD','XX_TOTCD','COUNT',,,'Total CDs')
    oModel:AddCalc('Totais','SB1Detail','ZD3Detail','ZD3_MUSICA','XX_TOTM','COUNT',,,'Total Musicas')

return oModel

Static Function ViewDef()
    Local oModel    :=FwLoadModel("xCDModX")
    Local oStruCli  :=FWFormStruct(2,cCli)
    Local oStruCD:=FWFormStruct(2,cCD, {|x| !AllTrim(x) $ 'B1_AFAMAD'})
    Local oStruMu :=FWFormStruct(2,cMusica)
    Local oStruTot  :=FWCalcStruct(oModel:GetModel('Totais'))
    Local oView

    oView:= FwFormView():New()
    oView:SetModel(oModel)
    oView:addField("VIEW_SA1",oStruCli  ,"SA1Master")
    oView:addGrid("VIEW_SB1",oStruCD,"SB1Detail")
    oView:addGrid("VIEW_ZD3",oStruMu ,"ZD3Detail")
    oView:addField("VIEW_TOT",oStruTot,"Totais")

    oView:CreateHorizontalBox("CLI_BOX",30)
    oView:CreateHorizontalBox("MEIO_BOX",60)
        oView:CreateVerticalBox("MEIOLEFT",50,"MEIO_BOX")// Vertical BOX
        oView:CreateVerticalBox("MEIORIGHT",50,"MEIO_BOX")// Vertical BOX
    oView:CreateHorizontalBox("ENCH_TOT",10)

    /* Horizontal BOX
        oView:CreateHorizontalBox("CLI_BOX",40)
        oView:CreateHorizontalBox("GRID_CD",30)
        oView:CreateHorizontalBox("GRID_Musica",30)    
        oView:SetOwnerView("VIEW_SA1","CLI_BOX")
        oView:SetOwnerView("VIEW_SB1","GRID_CD")
        oView:SetOwnerView("VIEW_ZD3","GRID_Musica")
    */ 
     oView:SetOwnerView("VIEW_SA1","CLI_BOX")
        oView:SetOwnerView("VIEW_SB1","MEIOLEFT")
        oView:SetOwnerView("VIEW_ZD3","MEIORIGHT")
    //oView:SetOwnerView("VIEW_ZD2","GRID_FILHO")
    //oView:SetOwnerView("VIEW_ZD3","GRID_NETO")
    oView:SetOwnerView("VIEW_TOT","ENCH_TOT")

    oView:EnableTitleView("VIEW_SA1", "Artistas Musicais")
    oView:EnableTitleView("VIEW_SB1", "CDs")
    oView:EnableTitleView("VIEW_ZD3", "Músicas")

    //oStruCD:RemoveField("B1_NOME")
    oStruMu:RemoveField("ZD3_CD")
    oStruCD:RemoveField("B1_XART")

    //oView:AddIncrementField("SB1Detail","B1_COD")// gatilho xCodProd()
    oView:AddIncrementField("ZD3Detail","ZD3_COD")
    oView:AddIncrementField("ZD3Detail","ZD3_ITEM")
    oView:SetCloseOnOk({||.T.})
return oView

//função chamada no evento CENCELAR, para zerar a variável Private cRegCd que guarda o código que ainda não foi gravado.
User Function xCDMcan(cRegCd)
    cRegCd :=NIL
    //FwFreeVar(cRegCd)
return .T.

User Function xArtXcd()
        Local cQuery
        Local cRet :=''
        
        cQuery := " SELECT DISTINCT(B1_XART) as art"
        cQuery += " FROM "+RetSqlName("SB1")
        cQuery += " WHERE D_E_L_E_T_ = '' AND B1_FILIAl ='"+ FwXFilial('SB1')+"'
        
        cQuery:= ChangeQuery(cQuery)   
        DBUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),'xArt',.F.,.T.)
        While xArt->(!EOF())
            cRet+= "|"+xArt->art
            xArt->(DBSKIP())
        EndDo
        IIF(Alltrim(cRet)=='|',cRet:='',cRet)
        xArt->(DBCloseArea())
    
Return cRet
