#INCLUDE "TOTVS.CH"
#INCLUDE "FwMVCDef.ch"
#INCLUDE "TOPCONN.CH"

/*++++DATA++++|++++AUTOR+++++|++++++++++++++++DESCRIÇÂO+++++++++++++
  08/07/2023  | Filipe Souza |  Projeto Music, com Scrum-Kanban
                                Cadastro de Artistas x Cds x Músicas no Modelo X em MVC, tabelas, SA1 SB1
                                Onde produto tem tipo CD, MUSICA
  09/07/2023  | Filipe Souza |  MODELO1-SA1                                
  10/07/2023  | Filipe Souza |  ModeloX-SA1-SB1-ZD3
                                Criar campo B1_XART para relacionar com ZD1_COD
                                Criar campo B1_XEST para receber codigo de estudio
                                Alterar Layout de horinzontal para vertical
                                Remover campo B1_XART da estrutura a não exibir.
                                Remover campo B1_AFAMAD da estrutura a não exibir.
                                Desabiliar campo ZD1_COD, iniciar com GETXENUM
                                Desabiliar campo A2_COD, iniciar com GETXENUM
                                Desabilitar e retirar autoincrement do B1_COD, utilizar gatilho a função xCodProd 
                                    -mudar gatilho para chamar só B1_TIPO
                                    -resolvido a sequencia B1_COD que parava em único registro.
                                    -no evento cancelar, zerar a variável Private que lega o cod do registro.
                                Totalizadores para CD e Musicas
  11/07/2023  | Filipe Souza |  Reanálise dos cenários para Agendamento de ensaio e gravação.   
  17/07/2023  | Filipe Souza |  Atualizado estrutra das tabela conforme UMl_classe
  18/07/2023  | Filipe Souza |  Prototipação,novo modelo para agendamento-ZD1. renomeada função e arquivo.
                                Falta otimizar a numeração automática para ZD1_COD
  20/07/2023  | Filipe Souza |  Usar no MPFormModel bCancel FWFORMCANCEL(SELF) passando o objeto model 
                                   para cancelar numeração automática, igual RollBackSX8 
                                Retirar campos no browse e nas grids, campos do relacionamento. 
  21/07/2023  | Filipe Souza |  Análise cenário contrato de gravação
                                O layout inicial da agenda passa ser de contrato.
                                O layout da agenda atual é modelo 1, ao selecionar serviço de gravação
                                habilita ou exibe campos para buscar cd e música para a gravação.
  02/08/2023  | Filipe Souza |  criar consultas padrões para ZD0
                                formular tamanhos de campo código de 15 para 9
                                Criar campo B1_XCONTR  para relacionamento de CD - Cod Contrato
                                gerar SX5 para Instrumentos para gravação. Pois não são produtos do estudio a venda.
                                pesquisa padrão no campo ZD1_INSTR para tabela 'IM - Instrumento musical na gavação'
                                mudar campos de Status nas tabelas ZD1 ZD3 para 1-OFF 2-ON 3-OK
                                Retirar da grid Musica o campo codigo.
                                habilitar e boquear campos referente ao serviço selecionado ZD1_SERV
                                criar pesquisas padrão para auto preencher campos da ZD0-Contrato                               


    Planejamento @see https://docs.google.com/document/d/1V0EWr04f5LLvjhhBhYQbz8MrneLWxDtVqTkCJIA9kTA/edit?usp=drive_link
    UML          @see https://drive.google.com/file/d/1wFO2CKqSrvzxg5RZDYTfGayHrAUcCcfL/view?usp=drive_link 
    Scrum-kanban @see https://trello.com/w/protheusadvplmusicbusiness       
    GitHug       @see https://github.com/filipesouza2000/Advpl-Sistematizei/tree/main/desenv2/Projeto-Music                                  
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
Static cTitulo  := "Agendamento de Serviço- Ensaio e Gravação"
Static cAge     := "ZD1"
Static cCli     := "SA1"
Static cCD      := "SB1"
Static cMusica  := "ZD3"

User Function xAgenda()
    Local aArea     := GetArea()
    Local oBrowse   
    Local cArtist
    Private aRotina :={}
    Private cRegCd  :=''

    aRotina := MenuDef()
    //cArtist := U_xArtXcd()
    oBrowse:= FwMBrowse():New()
    oBrowse:SetAlias(cAge)
    oBrowse:SetDescription(cTitulo)
    oBrowse:DisableDetails()
    //recebe filtro da lista de artistas a serem listados no bowse
    //oBrowse:SetFilterDefault(cCli+"->A1_COD $"+"'"+cArtist+"'")
    oBrowse:ACTIVATE()
    RestArea(aArea)
return NIL

Static Function MenuDef()
    //Local aRotina   := FwMvcmenu("xAgenda")
    Local aRotina:={}

    ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.xAgenda" OPERATION MODEL_OPERATION_VIEW ACCESS 0
    ADD Option aRotina TITLE "Incluir"    ACTION "VIEWDEF.xAgenda" OPERATION MODEL_OPERATION_INSERT ACCESS 0
    ADD Option aRotina TITLE "Alterar"    ACTION "VIEWDEF.xAgenda" OPERATION MODEL_OPERATION_UPDATE ACCESS 0
    ADD Option aRotina TITLE "Excluir"    ACTION "VIEWDEF.xAgenda" OPERATION MODEL_OPERATION_DELETE ACCESS 0
    
return aRotina


Static Function ModelDef()
    Local oStruAge      :=FWFormStruct(1,cAge)   //remover campo , pois já exibirá na strutura Pai
    Local oStruCD       :=FWFormStruct(1,cCD)//, {|x| !AllTrim(x) $ "B1_XART"})
    Local oStruMu       :=FWFormStruct(1,cMusica)
    Local aRelCD        :={}
    Local aRelMusic     :={}    
    Local oModel
    Local bPre          :=NIL
    Local bPos          :=NIL
    Local bCommit       :=NIL
    Local bCancel       :={|| FWFORMCANCEL(SELF)}  

    oModel:=MPFormModel():New("xAgendaM",bPre,bPos,bCommit,bCancel)
    oModel:addFields("ZD1Master",/*cOwner*/,oStruAge)
    oModel:AddGrid("SB1Detail","ZD1Master",oStruCD,/*bLinePre*/,/*bLinePos*/,/*bPre-Grid Full*/,/*bLoad-Carga do modelo manual*/,)
    oModel:AddGrid("ZD3Detail","SB1Detail",oStruMu,/*bLinePre*/,/*bLinePos*/,/*bPre-Grid Full*/,/*bLoad-Carga do modelo manual*/,)
    oModel:SetPrimaryKey({"ZD1_FILIAL","ZD1_COD"})//,"A1_CGC"
   
       //CD- relacionamento B1-CD com A1-Cli 
    //propriedade do cod do artista é obrigatório na tabela, mas seta como não obrigatório para não exibir
    oStruCD:SetProperty("B1_XART", MODEL_FIELD_OBRIGAT, .F.)
    aAdd(aRelCD, {"B1_FILIAL","FwxFilial('ZD1')"})
    aAdd(aRelCD, {"B1_COD","ZD1_CODCD"})
    oModel:SetRelation("SB1Detail", aRelCD, SB1->(IndexKey(1)))
    
    //Musica- relacionamento B1-CD com ZD3-Musica
    aAdd(aRelMusic,{"ZD3_FILIAL","FwxFilial('SB1')"})
    aAdd(aRelMusic,{"ZD3_CODCD", "B1_COD"})
    oModel:SetRelation("SB1Detail", aRelMusic,SB1->(IndexKey(1)))

    oModel:GetModel("SB1Detail"):SetUniqueLine({"B1_COD"})
    oModel:GetModel("ZD3Detail"):SetUniqueLine({"ZD3_MUSICA"})
    //totalizador-  titulo,     relacionamento, camo a calcular,visrtual,operação,,,display    
    oModel:AddCalc('Totais','ZD1Master','SB1Detail','B1_COD','XX_TOTCD','COUNT',,,'Total CDs')
    oModel:AddCalc('Totais','SB1Detail','ZD3Detail','ZD3_MUSICA','XX_TOTM','COUNT',,,'Total Musicas')

return oModel

Static Function ViewDef()
    Local oModel    :=FwLoadModel("xAgenda")
    Local oStruAge  :=FWFormStruct(2,cAge)
    Local oStruCD:=FWFormStruct(2,cCD,      {|x| !AllTrim(x) $ 'B1_AFAMAD'})
    Local oStruMu :=FWFormStruct(2,cMusica, {|x| !AllTrim(x) $ 'ZD3_COD'})
    Local oStruTot  :=FWCalcStruct(oModel:GetModel('Totais'))
    Local oView

    oView:= FwFormView():New()
    oView:SetModel(oModel)
    
    oView:addField("VIEW_ZD1",oStruAge  ,"ZD1Master")
    oView:addGrid("VIEW_SB1",oStruCD,"SB1Detail")
    oView:addGrid("VIEW_ZD3",oStruMu ,"ZD3Detail")
    oView:addField("VIEW_TOT",oStruTot,"Totais")

    oView:CreateHorizontalBox("AGE_BOX",50)
    oView:CreateHorizontalBox("MEIO_BOX",40)
        oView:CreateVerticalBox("MEIOLEFT",50,"MEIO_BOX")// Vertical BOX
        oView:CreateVerticalBox("MEIORIGHT",50,"MEIO_BOX")// Vertical BOX
    oView:CreateHorizontalBox("ENCH_TOT",10)
    
     oView:SetOwnerView("VIEW_ZD1","AGE_BOX")
        oView:SetOwnerView("VIEW_SB1","MEIOLEFT")
        oView:SetOwnerView("VIEW_ZD3","MEIORIGHT")
    oView:SetOwnerView("VIEW_TOT","ENCH_TOT")

    oView:EnableTitleView("VIEW_ZD1", "Agendamento")
    oView:EnableTitleView("VIEW_SB1", "CDs")
    oView:EnableTitleView("VIEW_ZD3", "Músicas")

    //oStruCD:RemoveField("B1_NOME")
    oStruAge:RemoveField("ZD1_CODCD")
    oStruMu:RemoveField("ZD3_CODCD")
    oStruCD:RemoveField("B1_XART")
    
    //oView:AddIncrementField("SB1Detail","B1_COD")// gatilho xCodProd()
    oView:AddIncrementField("ZD3Detail","ZD3_COD")
    oView:AddIncrementField("ZD3Detail","ZD3_ITEM")
    oView:SetCloseOnOk({||.T.})
return oView

// Função para verificar o serviço selecionado para exibir ou ocultar campos necessários 
User Function xServ()
    Local lRet :=.F.
        
    lRet := FwAlertYesNo('Selecionou serviço'+M->ZD1_SERV,'Warning')
    
    //oModel:GetStruct():SetProperty("ZD1_INSTR",MVC_VIEW_CANCHANGE, lRet)
    //oModel:GetStruct():SetProperty("ZD1_CODCA",MVC_VIEW_CANCHANGE, lRet)
    //oModel:GetStruct():SetProperty("ZD1_CONTR",MVC_VIEW_CANCHANGE, lRet)
    

return lRet


/* função chamada no evento CENCELAR, para zerar a variável Private cRegCd que guarda o código que ainda não foi gravado.
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
*/
