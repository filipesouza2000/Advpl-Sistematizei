//Bibliotecas
#Include "TOTVS.ch"
 
/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
---Data---|-----Autor-------|-------Descri��oo------------
11/04/2023| Filipe Souza    | 435-Quebrando um texto em um array com Separa, StrTokArr e StrTokArr2 

@see https://tdn.totvs.com/display/tec/StrTokArr e https://tdn.totvs.com/display/tec/StrTokArr2
@obs 
    Fun��o Separa
    Par�metros
        Recebe a string com separadores
        Recebe o token para fazer a separa��o
    Retorno
        Array com os elementos separados (considerando posi��es vazias)
 
    Fun��o StrTokArr
    Par�metros
        + cValue     , Caractere   , Recebe a string com separadores
        + cToken     , Caractere   , Recebe o token para fazer a separa��o
    Retorno
        + aRet       , Array       , Array com os elementos separados conforme par�metros informados
 
    Fun��o StrTokArr2
    Par�metros
        + cValue     , Caractere   , Recebe a string com separadores
        + cToken     , Caractere   , Recebe o token para fazer a separa��o
        + lEmptyStr  , L�gico      , Define se ir� considerar posi��es vazias
    Retorno
        + aRet       , Array       , Array com os elementos separados conforme par�metros informados
 
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
 
    //Define um texto que ter� separa��es e sua respectiva quebra
    cNomes  := "Filipe;Michelle;Henrique;;Alcione;Gabriel"
    cQuebra := ";"
 
    //Aciona os 3 tipos de separa��es
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
