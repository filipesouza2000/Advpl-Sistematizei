#include "TOTVS.ch"
#include "Protheus.ch"

/*££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££
	Data	|	Autor		| Descricao
 26/03/2024 | Filipe Souza  | Function para buscar dados da Sefaz pelo CNPJ e 
                              automatizar dados no cadastro de Clientes
 
 @see https://developers.receitaws.com.br/#/operations/queryCNPJFree                               
  */

User Function xReceitaCli(cCNPJ)
    Local aArea         := FWGetArea()
    Local aDados        := Array(16)
    Local aHeader       := {}    
    Local oRestClient   := FWRest():New("https://www.receitaws.com.br/v1")
    Local cResultado    := ""
    Local jResultado    := Nil
    Local cError        := ""
    Local cTel          := ""
    Local cCep          := ""
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
          if Empty(cError) .And. jResultado:GetJsonObject('status') != "ERROR"    
            If jResultado:GetJsonObject('situacao')=='ATIVA'
                A1_NOME     :=jResultado:GetJsonObject('nome')
                A1_PESSOA   :='J'
                A1_NREDUZ   := jResultado:GetJsonObject('fantasia')
                A1_BAIRRO   := jResultado:GetJsonObject('bairro')
                A1_END      := jResultado:GetJsonObject('logradouro')+","+jResultado:GetJsonObject('numero')
                A1_EST      := jResultado:GetJsonObject('uf')
                cCep        := jResultado:GetJsonObject('cep') 
                    cCep    := StrTran(cCep, "-", "")
                    cCep    := StrTran(cCep, ".", "") 
                A1_CEP      := cCep              
                A1_MUN      := jResultado:GetJsonObject('municipio')
                A1_DTNASC   := jResultado:GetJsonObject('abertura')
                A1_EMAIL    := jResultado:GetJsonObject('email')               
                cTel        := jResultado:GetJsonObject('telefone')
                    cTel    := StrTran(cTel, "(", "")
                    cTel    := StrTran(cTel, "-", "")
                    cTel    := StrTran(cTel, ")", "")
                    cTel    := StrTran(cTel, " ", "")
                A1_DDD      :=SubStr(cTel,1,2)
                A1_TEL      :=SubStr(cTel,3,Len(cTel))                              
            else
                FwAlertError('Situação do cadastro no SERFAZ pelo CNPJ '+cCNPJ+ 'NÃO ATIVA','Situação no SEFAZ')    
            EndIf
          EndIf    
        EndIf
    EndIf
 
    FWRestArea(aArea)

return cCNPJ     
