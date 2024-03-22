#include 'totvs.ch'
#include 'parmtype.ch'
/*££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££
	Data	|	Autor		| Descricao
 20/03/2024 | Filipe Souza  | Modelo da Classe FwAdapterBaseV2

 @see https://tdn.totvs.com/display/public/framework/09.+FWAdapterBaseV2
 @see https://medium.com/totvsdevelopers/criando-servi%C3%A7os-rest-avan%C3%A7ados-no-protheus-parte-2-trabalhando-com-filtros-3973b95e416f
 @see https://medium.com/@toledo.anderson/rela%C3%A7%C3%A3o-de-filtros-odata4-53d089a02faf

£££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££*/

CLASS PrdAdapter FROM FWAdapterBaseV2
	METHOD New()
	METHOD GetListProd()

EndClass

Method New( cVerb ) CLASS PrdAdapter
	_Super:New( cVerb, .T. )
return

Method GetListProd( ) CLASS PrdAdapter
	Local aArea 	AS ARRAY
	Local cWhere	AS CHAR

	aArea   := FwGetArea()

	//Adiciona o mapa de campos Json/ResultSet
	AddMapFields( self )

	//Informa a Query a ser utilizada pela API
	::SetQuery( GetQuery() )

	//Informa a clausula Where da Query
	cWhere := " B1_FILIAL = '"+ FWxFilial('SB1') +"' AND SB1.D_E_L_E_T_ = ' '"
	::SetWhere( cWhere )

	//Informa a ordenação a ser Utilizada pela Query
	::SetOrder( "B1_COD" )

	//Executa a consulta, se retornar .T. tudo ocorreu conforme esperado
	If ::Execute() 
		// Gera o arquivo Json com o retorno da Query
		// Pode ser reescrita, iremos ver em outro artigo de como fazer
		::FillGetResponse()
	EndIf

	FwrestArea(aArea)

RETURN



Static Function AddMapFields( oSelf )
	
	oSelf:AddMapFields( 'CODE'              , 'B1_COD'  , .T., .T., { 'B1_COD', 'C', TamSX3( 'B1_COD' )[1], 0 } )
	oSelf:AddMapFields( 'DESCRIPTION'	    , 'B1_DESC' , .T., .F., { 'B1_DESC', 'C', TamSX3( 'B1_DESC' )[1], 0 } )	
	oSelf:AddMapFields( 'GROUP'		        , 'B1_GRUPO', .T., .F., { 'B1_GRUPO', 'C', TamSX3( 'B1_GRUPO' )[1], 0 } )
	oSelf:AddMapFields( 'GROUPDESCRIPTION'	, 'BM_DESC' , .T., .F., { 'BM_DESC', 'C', TamSX3( 'BM_DESC' )[1], 0 } )

Return 


Static Function GetQuery()
	Local cQuery AS CHARACTER
	
	//Obtem a ordem informada na requisição, a query exterior SEMPRE deve ter o id #QueryFields# ao invés dos campos fixos
	//necessáriamente não precisa ser uma subquery, desde que não contenha agregadores no retorno ( SUM, MAX... )
	//o id #QueryWhere# é onde será inserido o clausula Where informado no método SetWhere()
	cQuery := " SELECT #QueryFields#"
    cQuery +=   " FROM " + RetSqlName( 'SB1' ) + " SB1 "
    cQuery +=   " LEFT JOIN " + RetSqlName( 'SBM' ) + " SBM"
	cQuery +=       " ON B1_GRUPO = BM_GRUPO"
	cQuery +=           " AND BM_FILIAL = '"+ FWxFilial( 'SBM' ) +"'"
	cQuery +=           " AND SBM.D_E_L_E_T_ = ' '"
    cQuery += " WHERE #QueryWhere#"
	
Return cQuery
