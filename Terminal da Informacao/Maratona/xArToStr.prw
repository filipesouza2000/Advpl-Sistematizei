#include "protheus.ch"
#include "TOTVS.ch"

/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
---Data---|-----Autor-------|-------Descriçãoo------------
11/04/2023| Filipe Souza    | 041-Transformar Array em String com ArrTokStr e CenArr2Str

@see Terminal da Informação
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
*/


user function xArToStr()
    Local aArea     := FwGetArea()
    Local aDados    :={}
    Local aNomes    :={}
    Local cRes1     :=""
    Local cRes2     :=""

    aAdd(aDados,{"Site",    "Terminal de Informacao"})
    aAdd(aDados,{"URL",     "http://terminaldeinformacao.com"})
    aAdd(aDados,{"Autor",   "Daniel Atilio"})
    //Transformar Array em String
    cRes1:=ArrTokStr(aDados,";")

    aAdd(aNomes,"Filipe")
    aAdd(aNomes,"Michelle")
    aAdd(aNomes,"Alcione")
    //Transformar Array em String JSON
    cRes2:=CenArr2Str(aNomes,";")

    FwAlertInfo("RES1: "+cRes1+ CRLF +"RES2: "+cRes2,"Resultado ARRAY->TEXT")

    FwRestArea(aArea)
return
