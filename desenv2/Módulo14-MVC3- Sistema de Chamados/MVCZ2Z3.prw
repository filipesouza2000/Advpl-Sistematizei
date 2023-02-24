#INCLUDE 'protheus.ch'
#INCLUDE 'FwMvcDef.ch'

/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+++DATA++++|++++AUTOR+++++|++++++++++++++++DESCRIÇÂO++++++++++++++++++++++++++++++
10/02/2023 | Filipe Souza | sistema de chamados, modelo3 com as tabelas SZ2 SZ3
11/02/2023 | Filipe Souza | Implementação VIEWDEF , Legenda
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
@see https://centraldeatendimento.totvs.com/hc/pt-br/articles/360016740431-MP-ADVPL-ESTRUTURA-MVC-PAI-FILHO-NETO

*/

User Function MVCZ2Z3()
    //importação do browse static
    Local oBrowse:= FwLoadBrw("MVCZ2Z3")

     //chamará area para criar tabela se não existir.
    DbSelectArea("SZ2")
    DbSetOrder(1)
    SZ2->(DBCloseArea())

    oBrowse:ACTIVATE()


return

//££££££££££££££££££££££££££££££££££££££££££££££££££££££££££
// Static function browse serve para ser importada por outros fontes, FwLoadBr
Static Function BrowseDef()
    Local aArea     := GetArea()
    Local oBrowse   := FwMBrowse():New()    

    oBrowse:SetAlias("SZ2")
    oBrowse:SetDescription("Cadastro de Chamados")
    
    oBrowse:Addlegend("SZ2->Z2_STATUS=='1'","Green","Aberto")
    oBrowse:Addlegend("SZ2->Z2_STATUS=='2'","Red","Finalizado")
    oBrowse:Addlegend("SZ2->Z2_STATUS=='3'","Yellow","Em Andamento")

    //definir de onde virá o Menufef
    oBrowse:Setmenudef("MVCZ2Z3")

    
    RestArea(aArea)

return oBrowse

Static Function ModelDef()
    Local oModel    := MPFormModel():New('MVCSZ23m',,,,)

    //estruturas das SZ2 e SZ3
    Local oStZ2 := FWFormStruct(1,'SZ2')
    Local oStZ3 := FWFormStruct(1,'SZ3')

    //após declarar estrutura de dados, posso modificar com Setproperty
    //na lista de comentarios, o campos chamado será auto preenchido com o campo Z2_COD
    //oStZ3:SetProperty("Z3_CHAMADO",MODEL_FIELD_INIT,FWBuildFeature(STRUCT_FEATURE_INIPAD,"SZ2->Z2_COD"))

    oModel:AddFields("SZ2MASTER",,oStZ2)
    oModel:AddGrid("SZ3DETAIL","SZ2MASTER",oStZ3,,,,,)
    //relaciona o detail com o master pela FILIAL e pelo numero do chamado, com a ordenação indice 1
    oModel:SetRelation("SZ3DETAIL",{{"Z3_FILIAL","xFilial('SZ2')"},{"Z3_CHAMADO","Z2_COD"}},SZ3->(Indexkey(1)))
    //define a chave primária, se nãoter X2_UNICO
    oModel:SetPrimaryKey({"Z3_FILIAL","Z3_CHAMADO","Z3_CODIGO"})
    //cominação de campos que não podem se repetir
    oModel:GetModel("SZ3DETAIL"):SetUniqueline({"Z3_CHAMADO","Z3_CODIGO"})
    oModel:SetDescription("Modelo3-Sistema de Chamados")
    oModel:GetModel("SZ2MASTER"):SetDescription("Cabeçalho do Chamado")
    oModel:GetModel("SZ3DETAIL"):SetDescription("Comentários do Chamado")

    //não utilizaremos GetOldGrid pois nao precisaremos manipular aCols e aHeader com bloco de codigo



return oModel

Static Function ViewDef()
    Local oView     := Nil
    Local oModel    := FwLoadModel("MVCZ2Z3")// importa o model da função
    Local oStZ2     := FwFormStruct(2,"SZ2")    
    Local oStZ3     := FwFormStruct(2,"SZ3")
    
    //remove o campo pois ele é auto preenchido com o codigo no cabeçalho
    //oStZ3:RemoveField("Z3_CHAMADO")

    //bloquear a edição do codigo pois é auto incrementado
    oStZ2:SetProperty("Z2_COD",     MVC_VIEW_CANCHANGE,.F.)
    oStZ2:SetProperty("Z2_USUARIO", MVC_VIEW_CANCHANGE,.F.)
    oStZ2:SetProperty("Z2_USERNAM", MVC_VIEW_CANCHANGE,.F.)
    oStZ2:SetProperty("Z2_MODULO",  MVC_VIEW_CANCHANGE,.F.)
    oStZ3:SetProperty("Z3_CODIGO",  MVC_VIEW_CANCHANGE,.F.)
    
    oView   := FwFormView():New()
    //carego o model importado
    oView:SetModel(oModel)
    
    oView:AddField("VIEWSZ2",oStZ2,"SZ2MASTER")
    oView:AddGrid("VIEWSZ3",oStZ3,"SZ3DETAIL")

    //campo do item auto incremental
    oView:AddIncrementalField("SZ3DETAIL","Z3_CODIGO")

    //criar box horizontais da view
    oView:CreateHorizontalBox("Head",60)
    oView:CreateHorizontalBox("Grid",40)

    //ammaro as views criadas aos BOX criados
    oView:SetOwnerView("VIEWSZ2","Head")
    oView:SetOwnerView("VIEWSZ3","Grid")

    //titulos personalizados ao cabeçalho e comentarios
    oView:EnableTitleView("VIEWSZ2","Titulo do Chamado")
    oView:EnableTitleView("VIEWSZ3","Comentários do Chamado")

return oView

User Function SZ2LEG()
    Local aLegenda

    Add(aLegenda,{"BR_VERDE","Aberto"})
    Add(aLegenda,{"BR_VERMELHO","Finalizado"})
    Add(aLegenda,{"BR_AMARELO","Em Andamento"})
    BrwLegenda("Status dos chamados",,aLegenda)

return aLegenda

Static Function MenuDef()
    Local aMenu     :={}
    //trago o menu padrão para o menuAut
    Local aMenuAut  := FwMvcMenu("MVCZ2Z3")
    Local n
    
    //Adiciono dentro de aMenu o titulo legenda, ação chamando a função de Legenda, operações de codigo 6
    ADD OPTION aMenu TITLE "Legenda" ACTION 'U_SZ2LEG' OPERATION 6 ACCESS 0

    //para adicionar item ao menu padrão, utilizo um laço para incrementar ao aMenu
    // cada item do amenuAut que é padrão
    For n:= 1 to Len(amenuAut)
        AAdd(aMenu,amenuAut[n])        
    Next n
    
return aMenu

//testes
// verificar o campo Z3_CHAMADO não recebe auto increment do Z2_COD
