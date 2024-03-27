#include "TOTVS.ch"
#include "Protheus.ch"

/*££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££
	Data	|	Autor		| Descricao
 25/03/2024 | Filipe Souza  | Function de teste para consultar no Sefaz dados pelo CNPJ
 @see https://terminaldeinformacao.com/2023/09/06/funcao-para-consultar-dados-de-um-cnpj-via-advpl/
 @see https://developers.receitaws.com.br/#/operations/queryCNPJFree    
 @obs aDados são:
    {
    "status": "OK",
    "ultima_atualizacao": "2019-08-24T14:15:22Z",
    "cnpj": "string",
    "tipo": "MATRIZ",
    "porte": "string",
    "nome": "string",
    "fantasia": "string",
    "abertura": "string",
    "atividade_principal": [
        {
        "code": "string",
        "text": "string"
        }
    ],
    "atividades_secundarias": [
        {
        "code": "string",
        "text": "string"
        }
    ],
    "natureza_juridica": "string",
    "logradouro": "string",
    "numero": "string",
    "complemento": "string",
    "cep": "string",
    "bairro": "string",
    "municipio": "string",
    "uf": "string",
    "email": "string",
    "telefone": "string",
    "efr": "string",
    "situacao": "string",
    "data_situacao": "string",
    "motivo_situacao": "string",
    "situacao_especial": "string",
    "data_situacao_especial": "string",
    "capital_social": "string",
    "qsa": [
        {
        "nome": "string",
        "qual": "string",
        "pais_origem": "string",
        "nome_rep_legal": "string",
        "qual_rep_legal": "string"
        }
    ],
    "billing": {
        "free": true,
        "database": true
    }
    }
£££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££*/   

User Function xReceitaWs(cCNPJ)
    Local aArea         := FWGetArea()
    Local aDados        := Array(16)
    Local aHeader       := {}    
    Local oRestClient   := FWRest():New("https://www.receitaws.com.br/v1")
    Local cResultado    := ""
    Local jResultado    := Nil
    Local cError        := ""
    Default cCNPJ       := ""
 
    //Define a primeira posição como .F. default
    aDados[01] := .F.
 
    //Retira caracteres especiais
    cCNPJ := StrTran(cCNPJ, ".", "")
    cCNPJ := StrTran(cCNPJ, "/", "")
    cCNPJ := StrTran(cCNPJ, "-", "")
 
    //Se veio CNPJ e tem 14 caracteres
    If ! Empty(cCNPJ) .And. Len(cCNPJ) == 14
 
        //Adiciona os headers que serão enviados via WS
        aAdd(aHeader,'User-Agent: Mozilla/4.0 (compatible; Protheus '+GetBuild()+')')
        aAdd(aHeader,'Content-Type: application/json; charset=utf-8')
     
        //Define a url e aciona o método GET
        oRestClient:setPath("/cnpj/" + cCNPJ)
        If oRestClient:Get(aHeader)
 
            //Pega o resultado
            cResultado := DecodeUTF8(oRestClient:cResult, "cp1252")
            jResultado := JsonObject():New()
            cError     := jResultado:FromJson(cResultado)
 
            //Se não houve erros
            If Empty(cError) .And. jResultado:GetJsonObject('status') != "ERROR"
                aDados[01] := .T.
                aDados[02] := jResultado:GetJsonObject('abertura')
                aDados[03] := jResultado:GetJsonObject('situacao')
                aDados[04] := jResultado:GetJsonObject('nome')
                aDados[05] := jResultado:GetJsonObject('fantasia')
                aDados[06] := jResultado:GetJsonObject('porte')
                aDados[07] := jResultado:GetJsonObject('natureza_juridica')
                aDados[08] := jResultado:GetJsonObject('logradouro')
                aDados[09] := jResultado:GetJsonObject('numero')
                aDados[10] := jResultado:GetJsonObject('municipio')
                aDados[11] := jResultado:GetJsonObject('uf')
                aDados[12] := jResultado:GetJsonObject('cep')
                aDados[13] := jResultado:GetJsonObject('email')
                aDados[14] := jResultado:GetJsonObject('telefone')
                aDados[15] := jResultado:GetJsonObject('cnpj')
                aDados[16] := jResultado:GetJsonObject('ultima_atualizacao')
            EndIf
        EndIf
    EndIf
 
    FWRestArea(aArea)
Return aDados


User Function xTestCNPJ()
    Local aDados    := {}
    Local cMensagem := ""
    Local cCGC      := ""
    CCGC:="28.671.016/0001-45"
    aDados := u_xReceitaWs(CCGC)
 
    If aDados[1]
        cMensagem += "Data de Abertura: "   + aDados[02] + " " + CRLF
        cMensagem += "Situação: "           + aDados[03] + " " + CRLF
        cMensagem += "Nome Fantasia: "      + aDados[05] + " " + CRLF
        cMensagem += "Porte: "              + aDados[06] + " " + CRLF
        cMensagem += "Natureza Juridica: "  + aDados[07] + " " + CRLF
        cMensagem += "Cidade: "             + aDados[10] + " " + CRLF
        cMensagem += "Estado: "             + aDados[11] + " " + CRLF
        cMensagem += "Última Atualização: " + aDados[16] + " " + CRLF
 
        FWAlertInfo(cMensagem, "Dados do CNPJ")
    EndIf
Return

