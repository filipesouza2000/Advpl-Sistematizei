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
    Local   aArea := GetNextAlias()
    Loca    oBrowseZZ1 

oBrowseZZ1:= FwmBrowse():New()

//passo como parâmetro a tabela a mostrar no Browse    
oBrowseZZ1:SetAlias("ZZ1")
oBrowseZZ1:SetDescription('ZZ1-Protheuzeiro')
oBrowseZZ1:ACTIVATE()

RestArea(aArea)
Return 
