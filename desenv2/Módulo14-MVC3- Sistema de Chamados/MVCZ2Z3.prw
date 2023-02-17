#INCLUDE 'protheus.ch'
#INCLUDE 'FwMvcDef.ch'

/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+++DATA++++|++++AUTOR+++++|++++++++++++++++DESCRIÇÂO++++++++++++++++++++++++++++++
10/02/2023 | Filipe Souza | sistema de chamados, modelo3 com as tabelas SZ2 SZ3

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
@see https://centraldeatendimento.totvs.com/hc/pt-br/articles/360016740431-MP-ADVPL-ESTRUTURA-MVC-PAI-FILHO-NETO

*/

User Function MVCZ2Z3()
    //importação do browse static
    Local oBrowse:= FwLoadBr("MVCZ2Z3")

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
    Local oStZ3 := FWFormStruct(2,'SZ3')

    oModel:AddFields("SZ2MASTER",,oStZ2)
    oModel:AddGrid("SZ3DETAIL","SZ2MASTER",oStZ3,,,,,)
    //relaciona o detail com o master pela FILIAL e pelo numero do chamado, com a ordenação indice 1
    oModel:SetRelation("SZ3DETAIL",{{"Z3_FILIAL","xFilial('SZ2)"},{"Z3_CHAMADO","Z2_COD"}},SZ3->(Indicekey(1)))
    //define a chave primária, se nãoter X2_UNICO
    oModel:SetPrimaryKey({"Z3_FILIAL","Z3_CHAMADO","Z3_CODIGO"})
    //cominação de campos que não podem se repetir
    oModel:GetModel("SZ3DETAIL"):SetUniqueline("Z3_CHAMADO","Z3_CODIGO")
    oModel:SetDescription("Modelo3-Sistema de Chamados")
    oModel:GetModel("SZ2MASTER"):SetDescription("Cabeçalho do Chamado")
    oModel:GetModel("SZ3DETAIL"):SetDescription("Comentários do Chamado")

    //não utilizaremos GetOldGrid pois nao precisaremos manipular aCols e aHeader com bloco de codigo



return oModel

Static ViewDef()
    Local oView     := Nil
    Local oModel    := FwLoadModel("MVCZ2Z3")// importa o model da função
    Local oStPaiZ2  := FwFormStruct(2,"SZ2")    
    Local oStFilhoZ3:= FwFormStruct(2,"SZ3")

    oView   := FwFormView():New()
    //carego o model importado
    oView:SetModel(oModel)
    oView:AddField("VIEWSZ2",oStPaiZ2,"SZ2MASTER")
    oView:AddGrid("VIEWSZ3",oStFilhoZ3,"SZ3DETAIL")

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
