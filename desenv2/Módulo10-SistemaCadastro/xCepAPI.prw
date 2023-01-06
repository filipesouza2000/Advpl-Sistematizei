#INCLUDE "TOTVS.CH"

User Function xCEPAPI()
  Local oDlg         := Nil 
  Local oSayXX       := Nil 
  Private oGet01     := Nil 
  Private cGet01     := Space(08) 
  Private oGet11     := Nil 
  Private cGet11     := '' 
  Private oGet12     := Nil 
  Private cGet12     := '' 
  Private oGet13     := Nil 
  Private cGet13     := '' 
  Private oGet14     := Nil 
  Private cGet14     := '' 
  oDlg   := MSDialog():New( 000,000,220,430,'CEP - API',,,.F.,,,,,,.T.,,,.T. )
  oDlg:lMaximized     := .T.
  oSayXX := TSay():New( 010,010,{|| 'CEP:' },oDlg,,,.F.,.F.,.F.,.T.,,,100,008)
  oGet01 := TGet():New( 010,060,bSETGET(cGet01),oDlg,120,010,,,,/*10*/,,,,.T.,/*15*/,,,,,/*20*/,,)
  oGet01 :bValid := {|UniversoDesenvolvedor| bValid() }
  oSayXX := TSay():New( 030,010,{|| 'Estado:' },oDlg,,,.F.,.F.,.F.,.T.,,,100,008)
  oGet11 := TGet():New( 030,060,bSETGET(cGet11),oDlg,120,010,,,,/*10*/,,,,.T.,/*15*/,,,,,/*20*/,,)
  oSayXX := TSay():New( 045,010,{|| 'Cidade:' },oDlg,,,.F.,.F.,.F.,.T.,,,100,008)
  oGet12 := TGet():New( 045,060,bSETGET(cGet12),oDlg,120,010,,,,/*10*/,,,,.T.,/*15*/,,,,,/*20*/,,)
  oSayXX := TSay():New( 060,010,{|| 'Bairro:' },oDlg,,,.F.,.F.,.F.,.T.,,,100,008)
  oGet13 := TGet():New( 060,060,bSETGET(cGet13),oDlg,120,010,,,,/*10*/,,,,.T.,/*15*/,,,,,/*20*/,,)
  oSayXX := TSay():New( 075,010,{|| 'Rua:' },oDlg,,,.F.,.F.,.F.,.T.,,,100,008)
  oGet14 := TGet():New( 075,060,bSETGET(cGet14),oDlg,120,010,,,,/*10*/,,,,.T.,/*15*/,,,,,/*20*/,,)
  oDlg:Activate(,,,.T.)
Return( Nil )


Static Function bValid()
  Local lRet          := .T. 
  Local aHeader       := {}  
  Local cHeaderRet    := ''  
  Local cResult       := ''  
  Local oResult       := {}  
  Begin Sequence
    If Empty(cGet01)
      MsgInfo('Informe o CEP','Validação')
      Break
    Endif
    cResult := HTTPQuote('https://brasilapi.com.br/api/cep/v2/'+AllTrim(cGet01), "GET", "", , , aHeader, @cHeaderRet)
    If !("200 OK" $ cHeaderRet )
      MsgInfo('Erro na Consulta: ' + cResult,'Validação')
      Break
    Endif
    If !FWJsonDeserialize( cResult, @oResult )
      MsgInfo('Erro no jSon: ' + cResult,'Validação')
      Break
    Endif
    cGet11  := DecodeUTF8(oResult:state)
    cGet12  := DecodeUTF8(oResult:city)
    cGet13  := DecodeUTF8(oResult:neighborhood)
    cGet14  := DecodeUTF8(oResult:street)
    RECOVER
  End Sequence
Return( lRet )


/* 
[API.VIACEP] [GET] Conecta na Api gratuita da ViaCep para retornar dados de um Endereço a partir do CEP.
Documentação: https://viacep.com.br/
Campos Disponiveis na API: BAIRRO, CEP, COMPLEMENTO, GIA, IBGE, LOCALIDADE, LOGRADOURO, UF, UNIDADE
Chamar em gatilhos para preencher o código do municipio por exemplo
    Regra:   u_xViaCep(FwFldGet('A1_CEP'))['ibge']
*/
User Function xViaCep(cCep,nX)
 
    Local aArea         := GetArea()
    Local aHeader       := {}    
    Local oRestClient   := FWRest():New("https://viacep.com.br/ws")
    Local oJson         := JsonObject():New()
    Local cRet          := '' 
    Default cCep        := ''
    
    //fConOut("[U_xViaCep] - Entrou na função que consulta as informações do endereco pelo CEP")
 
    //Retira espaços,traços e pontos caso receba assim dos parametros
    cCep := StrTran(StrTran(StrTran(cCep," ",""),"-",""),".","")
    
    aadd(aHeader,'User-Agent: Mozilla/4.0 (compatible; Protheus '+GetBuild()+')')
    aAdd(aHeader,'Content-Type: application/json; charset=utf-8')
 
    //[GET] Consulta Dados na Api
    oRestClient:setPath("/"+cCep+"/json/")
    If oRestClient:Get(aHeader)
          
        oJson:FromJson(oRestClient:CRESULT)          
 
        //Se as keys não existirem, cria elas com conteudo vazio.
        oJson['cep']        := Iif( ValType(oJson['cep'])         != "U", oJson['cep']        , "")
        oJson['logradouro'] := Iif( ValType(oJson['logradouro'])  != "U", oJson['logradouro'] , "")
        oJson['complemento']:= Iif( ValType(oJson['complemento']) != "U", oJson['complemento'], "")
        oJson['bairro']     := Iif( ValType(oJson['bairro'])      != "U", oJson['bairro']     , "")
        oJson['localidade'] := Iif( ValType(oJson['localidade'])  != "U", oJson['localidade'] , "")
        oJson['uf']         := Iif( ValType(oJson['uf'])          != "U", oJson['uf']         , "")
        oJson['ibge']       := Iif( ValType(oJson['ibge'])        != "U", SubStr(oJson['ibge'],3,5), "")
        oJson['gia']        := Iif( ValType(oJson['gia'])         != "U", oJson['gia']        , "") 
        oJson['ddd']        := Iif( ValType(oJson['ddd'])         != "U", oJson['ddd']        , "")
        oJson['siafi']      := Iif( ValType(oJson['siafi'])       != "U", oJson['siafi']      , "")
        DO CASE 
            CASE VAL(nX) == 1
            cRet:= oJson['logradouro']
            CASE nX == 2
            cRet:= oJson['bairro']
            CASE nX == 3
            cRet:= oJson['ibge']
            CASE nX == 4
            cRet:= oJson['localidade']
            CASE nX == 5
            cRet:= oJson['uf']
        OTHERWISE 
            cRet := ''
        ENDCASE
      
    Else
        fConOut("[U_xViaCep] - ** Erro Api ViaCep: "+oRestClient:GetLastError())
    Endif  
 
   oJson['erro']:=  Iif( ValType(oJson['cep']) == "U", "Api não retornou dados do cep: "+cValTochar(cCep) ,"")      
 
    fConOut("[U_xViaCep] - Finalizou na função que consulta as informações do endereco pelo CEP") 
 
    FreeObj(oRestClient)
    RestArea(aArea)    
    //cRet:= U_xSpecialChar(cRet,nX)
Return UPPER(cRet)
 
Static Function fConOut(cLog)
     
    Default cLog := "Log empty"
         
    FwLogMsg("INFO", /*cTransactionId*/, "fConOut", FunName(), "", "01", cLog, 0, 0, {})
              
Return
