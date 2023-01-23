#INCLUDE 'protheus.ch'
#INCLUDE 'FWMVCDEF.ch'

//-------------------------------------------------------------------
/*/{Protheus.doc} Browse
Definição do modelo de Browse(janela com dados)
@author  author
@since   date
@version version
/*/
//-------------------------------------------------------------------

User Function BRWZZ1()
    Local   aArea := GetArea()
    Local   oBrowseZZ1 

oBrowseZZ1:= FwmBrowse():New()

//passo como parâmetro a tabela a mostrar no Browse    
oBrowseZZ1:SetAlias("ZZ1")
oBrowseZZ1:SetDescription('ZZ1-Protheuzeiro')

oBrowseZZ1:AddLegend("ZZ1->ZZ1_STATUS=='2'","RED","Desativado(a)")
oBrowseZZ1:AddLegend("ZZ1->ZZ1_STATUS=='1'","GREEN","Ativo(a)")

//retira a barra de detalhes na base do browse
//oBrowseZZ1:DisableDetails()

//Filtrando os dados
//oBrowseZZ1:SetFilterDefault("ZZ1->ZZ1_STATUS == '1'")

//Exibir determinados campos na tabela, SetOnlyFields
oBrowseZZ1:SetOnlyFields({"ZZ1_COD","ZZ1_NOME","ZZ1_NOMERE","ZZ1_CPF","ZZ1_BAIRRO","ZZ1_CIDADE"})
oBrowseZZ1:ACTIVATE()
RestArea(aArea)
Return 
