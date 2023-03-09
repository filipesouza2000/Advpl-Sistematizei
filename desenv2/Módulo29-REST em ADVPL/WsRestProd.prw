#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RESTFUL.CH
#INCLUDE "tbiconn.ch"
//Métodos iguais para iniciar o ambiente 
//PREPARE ENVIRONMENT EMPRESA '01' FILIAL '01' USER 'Administrador' PASSWORD '' TABLES 'SE1,SA1,SE2' MODULO ‘FAT’/*******COMANDOS *********/RESET ENVIRONMENT (no final)
//RpcSetEnv("99", "01") //Abro o ambiente

WSRESTFUL WSRESTPROD DESCRIPTION 'Servico REST para manipulação de Produtos'
WSDATA CODPRODUTO As string

//4 metodos, GET. POST. PUT. DELETE
WSMETHOD GET buscaProduto;
    DESCRIPTION 'Retorna dados do Produto';
    WSSYNTAX '/buscaproduto';
    PATH 'buscaproduto';
    PRODUCES APPLICATION_JSON
ENDWSRESTFUL    


WSMETHOD GET buscaProduto WSRECEIVE CODPRODUTO WSREST WSRESTPROD
    // recuperar o prodoto informado nia url
    Local cCodProd  := Self:CODPRODUTO
    Local aArea     := GetArea()
    Local oJsonProd := JsonObject():New()
    Local cStatus   :=""
    Local cGrupo    :=""
    Local aProd     :={}
    Local cJson     :=""
    Local oReturn
    Local cReturn 
    Local lRet      :=.T.
    RpcSetEnv("99","01",,,"COM")
    //define o tipo de retorno do metodo
    ::SetContentType("application/json")
    DBSelectArea("SB1")//Abro o ambiente
    SB1->(DBSetOrder(1))
    if SB1->(DBSeek(xFilial("SB1")+cCodProd))
        cStatus := IIF(SB1->B1_MSBLQL=='1','Sim','Não')
        cGrupo  := AllTrim(Posicione('SBM',1,xFilial('SBM')+SB1->B1_GRUPO,'BM_DESC'))
        aadd(aProd,JsonObject():New())
        aProd[1]['prodcod'] :=AllTrim(SB1->B1_COD)
        aProd[1]['proddesc']:=AllTrim(EncodeUtf8(SB1->B1_DESC))
        aProd[1]['produm']  :=AllTrim(SB1->B1_UM)
        aProd[1]['prodncm'] :=AllTrim(SB1->B1_POSIPI)
        aProd[1]['prodgrup']:=cGrupo
        aProd[1]['prodbloq']:=cStatus

        cReturn := FWJSONSerialize(oReturn)//rerializa o retorno
        oReturn:= JsonObject():new()
        oReturn['cRet']:= '20-Sucesso'
        oReturn['cmessage']:='Produto entontrado com sucesso'

        //cria um objeto da classe produtos para fazer a serialização na função FWJSONSerialize
        oJsonProd['produtos']:=aProd
        cJson := FWJSONSerialize(oJsonProd)
        //envia o json gerado para a aplicação client
        ::SetResponse(cJson)   
        ::SetResponse(cReturn)  
    else
        SetRestFault(400,'Codigo do produto não contrado.')//setando o erro
        lRet := .F.
        return lRet
        //oReturn:= JsonObject():new()
        //oReturn['prodcod']:=cCodProd
        //oReturn['cRet']:= '400-Falha'
        //oReturn['cmessage']:='codigo do produto não encontrado'
    endif
    SB1->(DBCloseArea()) 
    RestArea(aArea)
    FreeObj(oJsonProd)//liberar os objetos
    FreeObj(oReturn)
return lRet
