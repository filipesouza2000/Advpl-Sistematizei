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
