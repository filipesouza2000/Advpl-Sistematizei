#include "protheus.ch"
#include "TOTVS.ch"

/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
---Data---|-----Autor-------|-------Descriçãoo------------
11/04/2023| Filipe Souza    | 040-Função ArrToJson para transformar um Array numa String JSON

@see Terminal da Informação
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
*/


user function xArToJson()
    Local aArea     := FwGetArea()
    Local aDados    :={}
    Local cJson     :=""

    aAdd(aDados,{"Site",    "Terminal de Informacao"})
    aAdd(aDados,{"URL",     "http://terminaldeinformacao.com"})
    aAdd(aDados,{"Autor",   "Daniel Atilio"})

    cJson:=ArrToJson(aDados)

    FwAlertInfo("Json: "+cJson,"Resultado JSON")

    FwRestArea(aArea)
return
