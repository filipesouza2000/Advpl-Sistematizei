#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RESTFUL.CH
#INCLUDE "tbiconn.ch"

RpcSetEnv("99","01",,,"COM")
WSRESTFUL WSRESTCLI DESCRIPTION 'Servico REST para Integração de Clientes'
WSDATA CODCLIDE  As string
WSDATA CODCLIATE As string

//4 metodos, GET. POST. PUT. DELETE
WSMETHOD GET GetCli;
    DESCRIPTION 'Retorna dados do(s) Cliente(s)';
    WSSYNTAX '/getcli';
    PATH 'getcli';
    PRODUCES APPLICATION_JSON
   
WSMETHOD POST PostCli;
    DESCRIPTION 'Inserir dados de Cliente';
    WSSYNTAX '/postcli';
    PATH 'postcli';
    PRODUCES APPLICATION_JSON

WSMETHOD PUT putCli;
    DESCRIPTION 'Alterar dados do Cliente';
    WSSYNTAX '/putCli';
    PATH 'putCli';
    PRODUCES APPLICATION_JSON   

WSMETHOD DELETE delCli;
    DESCRIPTION 'Deletar registro do Cliente';
    WSSYNTAX '/delCli';
    PATH 'delCli';
    PRODUCES APPLICATION_JSON       
ENDWSRESTFUL  

WSMETHOD GET GetCli WSRECEIVE CODCLIDE,CODCLIATE WSREST WSRESTCLI
    Local lRet      := .T.
    Local nCount    :=1
    Local nReg      :=0
    Local cCodDe    := cValToChar(Self:CODCLIDE)
    Local cCodAte   := cValToChar(Self:CODCLIATE)
    Local aListCli  := {}
    Local oJson     :=JsonObject():New()
    Local cJson     :=''
    Local cAlias    :=GetNextAlias()

    IF Self:CODCLIDE > Self:CODCLIATE
        cCodDe  := cValToChar(Self:CODCLIATE)
        cCodAte := cValToChar(Self:CODCLIDE)
    ENDIF

    cWhere :=" AND SA1.A1_COD BETWEEN '"+cCodDe+"' AND '"+cCodAte+"' AND SA1.A1_FILIAL = '"+ xFilial("SA1")+"'"
    //dica para transformar cwhere em filtro, para retirar as aspas que ficam automaticamente
    cWhere := "%"+cWhere+"%"

    BEGINSQL Alias cAlias
        SELECT  SA1.A1_COD, SA1.A1_LOJA,SA1.A1_NOME,SA1.A1_NREDUZ, SA1.A1_END, SA1.A1_EST,SA1.A1_BAIRRO,SA1.A1_MUN,SA1.A1_CGC
        FROM %table:SA1% SA1
        WHERE SA1.%notDel%
        %exp:cwhere%
    ENDSQL

    Count to nReg
    (cAlias)->(DBGoTop())
    While (cAlias)->(!EOF())    
        aAdd(aListCli,JsonObject():New())
        aListCli[nCount]["clicod"]  :=(cAlias)->A1_COD 
        aListCli[nCount]["cliloja"] :=(cAlias)->A1_LOJA
        aListCli[nCount]["clinome"] :=AllTrim(EncodeUtf8((cAlias)->A1_NOME))
        aListCli[nCount]["clinred"] :=AllTrim(EncodeUtf8((cAlias)->A1_NREDUZ))
        aListCli[nCount]["cliend"]  :=AllTrim(EncodeUtf8((cAlias)->A1_END))
        aListCli[nCount]["cliuf"]   :=AllTrim(EncodeUtf8((cAlias)->A1_EST))
        aListCli[nCount]["clicid"]  :=AllTrim(EncodeUtf8((cAlias)->A1_MUN))
        aListCli[nCount]["clibai"]  :=AllTrim(EncodeUtf8((cAlias)->A1_BAIRRO))
        aListCli[nCount]["clicgc"]  :=(cAlias)->A1_CGC
        nCount++   
        (cAlias)->(DBSKIP())
    End
    (cAlias)->(DBCloseArea())

    if nReg >0
        oJson["clientes"] := aListCli
        cJson := FWJSONSerialize(oJson)
        ::SetResponse(cJson)
    Else
        SetRestFault(400,EncodeUtf8("Não existem registros com os filtros infornados!"))
        lRet :=.F.
        Return lRet    
    endif

    FreeObj(oJson)

RETURN lRet

WSMETHOD POST PostCli WSRECEIVE WSREST WSRESTCLI   
    Local aArea     := GetArea()
    Local oJsonCli  := JsonObject():New()
    Local oReturn   := JsonObject():new()
    Local lRet      :=.T.
    Local cCod,cLoja,cNome,cNRed,cEnd,cCid, cUf,cBai,cCgc  := ""
    //FROMJSON Carrega os dados vindos do conteúdo da requisição em json
    oJsonCli:FromJson(Self:GetContent())//getContent traz o conteúdo
    //busca o codigo do cliente no objeto Json na estrutura criada.
    cCod  := AllTrim(oJsonCli['clientes']:GetJsonObject('clicod'))
    cLoja := AllTrim(oJsonCli['clientes']:GetJsonObject('cliloja'))
    cNome := AllTrim(oJsonCli['clientes']:GetJsonObject('clinome'))
    cNRed := AllTrim(oJsonCli['clientes']:GetJsonObject('clinred'))
    cEnd  := AllTrim(oJsonCli['clientes']:GetJsonObject('cliend'))
    cCid  := AllTrim(oJsonCli['clientes']:GetJsonObject('clicid'))
    cUf   := AllTrim(oJsonCli['clientes']:GetJsonObject('cliuf'))
    cBai  := AllTrim(oJsonCli['clientes']:GetJsonObject('clibai'))
    cCgc  := AllTrim(oJsonCli['clientes']:GetJsonObject('clicgc'))
    
    DBSelectArea("SA1")//Abro o ambiente
    SA1->(DBSetOrder(1))
    //verificar se o código já existe
    if SA1->(DBSeek(xFilial("SA1")+cCod+cLoja))
        SetRestFault(400,'Codigo do Cliente ja existe na base.')
        lRet := .F.
        return lRet
        //verificar campo em branco    
        elseif Empty(cCod)
            SetRestFault(401,'Codigo do cliente esta em branco.')
            lRet := .F.
            return lRet
        //verificar 6 digitos do codigo
        elseif Len(cCod)<6 .OR. Len(cCod)>6
            SetRestFault(402,'Somente é permitido 6 digitos para o código.')
            lRet := .F.
            return lRet
        elseif Empty(cNome)
            SetRestFault(403,'Nome do cliente esta em branco.')
            lRet := .F.
            return lRet
        elseif Empty(cLoja)
            SetRestFault(404,'Loja do cliente esta em branco.')
            lRet := .F.
            return lRet
        elseif Empty(cNRed)
            SetRestFault(405,'Nome reduzido do cliente esta em branco.')
            lRet := .F.
            return lRet             
        elseif Empty(cEnd)
            SetRestFault(406,'Endereço do cliente esta em branco.')
            lRet := .F.
            return lRet  
        elseif Empty(cCid)
            SetRestFault(407,'Cidade do cliente esta em branco.')
            lRet := .F.
            return lRet 
        elseif Empty(cBai)
            SetRestFault(408,'bairro do cliente esta em branco.')
            lRet := .F.
            return lRet             
         elseif Empty(cUf)
            SetRestFault(409,'Estado Federativo do cliente esta em branco.')
            lRet := .F.
            return lRet   
        elseif Empty(cCgc)
            SetRestFault(410,'Documento CGC do cliente esta em branco.')
            lRet := .F.
            return lRet 
        elseif !CGC(cCgc)
            SetRestFault(411,'Verifique numero do CGC, inválido.')
            lRet := .F.
            return lRet 
    //incluir
    else   
        RECLOCK( "SA1", .T.)
            SA1->A1_COD     := cCod
            SA1->A1_LOJA    := cLoja
            SA1->A1_NOME    := cNome
            SA1->A1_NREDUZ  := cNRed
            SA1->A1_END     := cEnd
            SA1->A1_BAIRRO  := cBai
            SA1->A1_MUN     := cCid
            SA1->A1_EST     := cUf
            SA1->A1_CGC     := cCgc           
        SA1->(MSUNLOCK())
        //exibir retorno do processo        
        oReturn['clicod']  := cCod
        oReturn['clinome'] := cNome
        oReturn['cRet']     := '201-Sucesso'
        oReturn['cMsg']     := 'Registro efetuado com sucesso, complete o registro no Protheus.'
        
        Self:SetStatus(201)
        //tipo de conteúdo retornado
        Self:SetContentType(APPLICATION_JSON)
        //serializa o Json para exibição ao usuário
        Self:SetResponse(FWJSONSerialize(oReturn))
    endif
    DBSelectArea("SA1")
    RestArea(aArea)
    FreeObj(oJsonCli)//liberar os objetos
    FreeObj(oReturn)
return lRet

/* Modelo Json
{
    "clientes": [
        {
        "clicod":"000088",
        "cliloja":"01",
        "clinome":"Antonio ResFul",
        "clinred":"ARestFul",
        "cliend":"Avenida 7 de setembro",
        "cliuf":"RJ",
        "clicid":"Volta Redonda",
        "clibai":"Aterrado",
        "clicgc":"95175668455"
        }
    ]
}           
*/
