#include "totvs.ch"
#include "restful.ch"
/*££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££
	Data	|	Autor		| Descricao
 20/03/2024 | Filipe Souza  | Modelo de API Utilizando Classe FwAdapterBaseV2

 @see https://tdn.totvs.com/display/public/framework/09.+FWAdapterBaseV2
 @see https://medium.com/totvsdevelopers/criando-servi%C3%A7os-rest-avan%C3%A7ados-no-protheus-parte-2-trabalhando-com-filtros-3973b95e416f
 @see https://medium.com/@toledo.anderson/rela%C3%A7%C3%A3o-de-filtros-odata4-53d089a02faf

£££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££*/
WSRESTFUL products DESCRIPTION 'endpoint products API' FORMAT "application/json,text/html"
    WSDATA Page     AS INTEGER OPTIONAL
    WSDATA PageSize AS INTEGER OPTIONAL
    WSDATA aQueryString AS ARRAY OPTIONAL
// http://localhost:8089/rest/PRODUCTS?page=1&PageSize=1    
 	WSMETHOD GET ProdList;
	    DESCRIPTION "Retorna uma lista de produtos";
	    WSSYNTAX "/products" ;
        PATH "/products" ;
	    PRODUCES APPLICATION_JSON
 	
END WSRESTFUL

WSMETHOD GET ProdList QUERYPARAM Page,PageSize WSREST products
Return getPrdList(self)

Static Function getPrdList( oWS )
   Local lRet  as logical
   Local oProd as object

   DEFAULT oWS:Page      := 1  
   DEFAULT oWS:PageSize  := 10  

   lRet        := .T.

   //PrdAdapter será nossa classe que implementa fornecer os dados para o WS
   // O primeiro parametro indica que iremos tratar o método GET
   oProd := PrdAdapter():new( 'GET' )
  
   //o método setPage indica qual página deveremos retornar
   //ex.: nossa consulta tem como resultado 100 produtos, e retornamos sempre uma listagem de 10 itens por página.
   // a página 1 retorna os itens de 1 a 10
   // a página 2 retorna os itens de 11 a 20
   // e assim até chegar ao final de nossa listagem de 100 produtos 
   oProd:setPage(oWS:Page)
   // setPageSize indica que nossa página terá no máximo 10 itens
   oProd:setPageSize(oWS:PageSize)
   // Esse método irá processar as informações

   //Irá transferir as informações de filtros da url para o objeto
   oProd:SetUrlFilter( oWS:aQueryString )


   oProd:GetListProd()
   ConOut( JsonObject():new( oProd:getJSONResponse()))
   //Se tudo ocorreu bem, retorna os dados via Json
   If oProd:lOk
       oWS:SetResponse(oProd:getJSONResponse())
   Else
   //Ou retorna o erro encontrado durante o processamento
       SetRestFault(oProd:GetCode(),oProd:GetMessage())
       lRet := .F.
   EndIf

   //faz a desalocação de objetos e arrays utilizados
   oProd:DeActivate()
   oProd := nil
   
Return lRet

