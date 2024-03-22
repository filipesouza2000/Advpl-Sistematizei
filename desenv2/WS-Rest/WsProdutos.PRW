#Include "TOTVS.ch"
#Include "RESTFul.ch"
#Include "TopConn.ch"
/*££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££
	Data	|	Autor		| Descricao
 20/03/2024 | Filipe Souza  | Exemplo de um fonte para ser usado com REST com paginação customizada. 
                              Classe simples que lista produtos da SB1
 @see https://terminaldeinformacao.com/2021/10/05/como-usar-a-autenticacao-com-oauth2-em-rest/

£££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££*/   

   
WSRESTFUL WsProdutos DESCRIPTION "Api de Produtos com paginação"
    //Atributos usados
    WSDATA pageSize AS INTEGER
    WSDATA page     AS INTEGER
    
    //Métodos usados
    WSMETHOD GET Prods DESCRIPTION "Retorna produtos" WSSYNTAX '/prods' PATH "Prods"       PRODUCES APPLICATION_JSON
END WSRESTFUL
   
//Poderia ser usado o FWAdapterBaseV2(), porém a paginação foi feita manualmente
WSMETHOD GET Prods WSRECEIVE pageSize, page WSSERVICE WsProdutos
    Local lRet       := .T.
    Local oResponse  := JsonObject():New()
    Local cQuery  := ""
    Local nTamanho   := 10
    Local nTotal     := 0
    Local nPags      := 0
    Local nPagina    := 0
    Local nAtual     := 0
   
    //Efetua a busca dos Produtos
    cQuery := " SELECT B1_COD CODE,B1_DESC DESCRICAO,B1_GRUPO COD_GRUPO,BM_DESC GRUPO" + CRLF    
    cQuery +=   " FROM " + RetSqlName( 'SB1' ) + " SB1 "
    cQuery +=   " LEFT JOIN " + RetSqlName( 'SBM' ) + " SBM"
	cQuery +=       " ON B1_GRUPO = BM_GRUPO"
	cQuery +=           " AND BM_FILIAL = '"+ FWxFilial( 'SBM' ) +"'"
	cQuery +=           " AND SBM.D_E_L_E_T_ = ' '"
    cQuery += " WHERE  B1_FILIAL = '"+ FWxFilial('SB1') +"' AND SB1.D_E_L_E_T_ = ' '"
    TCQuery cQuery New Alias "B1BM"
   
    //Se não encontrar produto
    If B1BM->(EoF())
        SetRestFault(500, "Falha ao consultar Produtos - A consulta de Produtos nao retornou nenhuma informacao, revise os filtros")
    Else
   
        oResponse["objects"] := {}
   
        //Conta o total de registros
        Count To nTotal
        B1BM->(DbGoTop())
   
        //O tamanho do retorno, será o pageSize, se ele estiver definido
        If ! Empty(::pageSize)
            nTamanho := ::pageSize
        EndIf
   
        //Pegando total de páginas
        nPags := NoRound(nTotal / nTamanho, 0)
        nPags += Iif(nTotal % nTamanho != 0, 1, 0)
           
        //Se vier página
        If ! Empty(::page)
            nPagina := ::page
        EndIf
   
        //Se a página vier zerada ou negativa ou for maior que o máximo, será 1 
        If nPagina <= 0 .Or. nPagina > nPags
            nPagina := 1
        EndIf
   
        //Se a página for diferente de 1, pula os registros
        If nPagina != 1
            B1BM->(DbSkip((nPagina-1) * nTamanho))
        EndIf
   
        //Adiciona os dados para a meta
        oJsonMeta := JsonObject():New()
        oJsonMeta["total"]         := nTotal
        oJsonMeta["atual_page"]  := nPagina
        oJsonMeta["total_page"]    := nPags
        oJsonMeta["total_items"]   := nTamanho
        oResponse["meta"] := oJsonMeta
   
        //Percorre os Produtos
        While ! B1BM->(EoF())
            nAtual++
               
            //Se ultrapassar o pageSizee, encerra o laço
            If nAtual > nTamanho
                Exit
            EndIf
   
            //Posiciona a produto e adiciona no retorno
            DbSelectArea("B1BM")
            B1BM->(DBGoTop())
            oJsonObj := JsonObject():New()
            //B1_CODas CODE,B1_DESC DESCRICAO,B1_GRUPO COD_GRUPO,BM_DESC GRUPO
            oJsonObj["CODE"]      := B1BM->CODE
            oJsonObj["DESCRICAO"] := B1BM->DESCRICAO
            oJsonObj["COD_GRUPO"] := B1BM->COD_GRUPO
            oJsonObj["GRUPO"]     := B1BM->GRUPO
            aAdd(oResponse["objects"], oJsonObj)
   
            B1BM->(DbSkip())
        EndDo
    EndIf
    B1BM->(DbCloseArea())
   
    //Define o retorno
    Self:SetContentType("application/json")
    Self:SetResponse(oResponse:toJSON())
Return lRet
