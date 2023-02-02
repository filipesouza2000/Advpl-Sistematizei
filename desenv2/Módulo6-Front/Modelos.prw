#INCLUDE 'Protheus.ch'

/*££££££££££££££££££££££££££££££££££££££££££££££££££
-----------------Modelos 1 2 3----------------------
*/

User Function xMod1SA1()  
    //AxCadastro(cAlias, cTitulo, cVldExc, cVldAlt)
    DBSelectArea('SA1')
    DBSetOrder(1)
    axcadastro("SA1",'Modelo1 Cliente') 
return

user Function xMvcMod1SA1()  
    Local oBrowse := FwMBrowse():New()

    oBrowse:SetAlias("SA1")
    oBrowse:SetDescription("MVC-Modelo1 Cliente")
    oBrowse:Activate()
Return

User Function xMod2()
    
Return

User Function Modelo3()
 
   
Return
