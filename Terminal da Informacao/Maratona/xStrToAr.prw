//Bibliotecas
#Include "TOTVS.ch"
 
/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
---Data---|-----Autor-------|-------Descriçãoo------------
11/04/2023| Filipe Souza    | 435-Quebrando um texto em um array com Separa, StrTokArr e StrTokArr2 

@see https://tdn.totvs.com/display/tec/StrTokArr e https://tdn.totvs.com/display/tec/StrTokArr2
@obs 
    Função Separa
    Parâmetros
        Recebe a string com separadores
        Recebe o token para fazer a separação
    Retorno
        Array com os elementos separados (considerando posições vazias)
 
    Função StrTokArr
    Parâmetros
        + cValue     , Caractere   , Recebe a string com separadores
        + cToken     , Caractere   , Recebe o token para fazer a separação
    Retorno
        + aRet       , Array       , Array com os elementos separados conforme parâmetros informados
 
    Função StrTokArr2
    Parâmetros
        + cValue     , Caractere   , Recebe a string com separadores
        + cToken     , Caractere   , Recebe o token para fazer a separação
        + lEmptyStr  , Lógico      , Define se irá considerar posições vazias
    Retorno
        + aRet       , Array       , Array com os elementos separados conforme parâmetros informados
 
    **** Apoie nosso projeto, se inscreva em https://www.youtube.com/TerminalDeInformacao ****
/*/
 
User Function xStrToAr()
    Local aArea     := FWGetArea()
    Local cNomes    := ""
    Local cQuebra   := ""
    Local aSepara := {}
    Local aStrAr := {}
    Local aStrAr2 := {}
    Local cMensagem := ""
    Local nL        :=0
 
    //Define um texto que terá separações e sua respectiva quebra
    cNomes  := "Filipe;Michelle;Henrique;;Alcione;Gabriel"
    cQuebra := ";"
 
    //Aciona os 3 tipos de separações
    aSepara := Separa(cNomes, cQuebra)
    aStrAr  := StrTokArr(cNomes, cQuebra)
    aStrAr2 := StrTokArr2(cNomes, cQuebra, .T.)
 
    //Monta a mensagem e exibe
    cMensagem += "Separa:"+CRLF
    for nL := 1 to Len(aSepara)
        cMensagem += "aSepara["+cValToChar(nL)+"]: "+aSepara[nl] +CRLF   
    next
    cMensagem += CRLF+"StrTokArr:"+CRLF
    for nL := 1 to Len(aStrAr)
        cMensagem += "aSepara["+cValToChar(nL)+"]: "+aStrAr[nl] +CRLF   
    next
    cMensagem += CRLF+"StrTokArr2:"+CRLF
    for nL := 1 to Len(aStrAr2)
        cMensagem += "aSepara["+cValToChar(nL)+"]: "+aStrAr2[nl] +CRLF   
    next
    
    FwAlertInfo(cMensagem,"Alert")
    
    FWRestArea(aArea)
Return
