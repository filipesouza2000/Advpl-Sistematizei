#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RESTFUL.CH
#INCLUDE "tbiconn.ch"
//https://github.com/filipesouza2000/Advpl-Sistematizei/tree/main/desenv2/M%C3%B3dulo29-REST%20em%20ADVPL
//Métodos iguais para iniciar o ambiente 
//PREPARE ENVIRONMENT EMPRESA '01' FILIAL '01' USER 'Administrador' PASSWORD '' TABLES 'SE1,SA1,SE2' MODULO ‘FAT’/*******COMANDOS *********/RESET ENVIRONMENT (no final)
//RpcSetEnv("99", "01") //Abro o ambiente
RpcSetEnv("99","01",,,"COM")
WSRESTFUL WSRESTPROD DESCRIPTION 'Servico REST para manipulação de Produtos'
WSDATA CODPRODUTO As string

//4 metodos, GET. POST. PUT. DELETE
WSMETHOD GET buscaProduto;
    DESCRIPTION 'Retorna dados do Produto';
    WSSYNTAX '/buscaproduto';
    PATH 'buscaproduto';
    PRODUCES APPLICATION_JSON
   
WSMETHOD POST inserirProduto;
    DESCRIPTION 'Inserir dados do Produto';
    WSSYNTAX '/inserirproduto';
    PATH 'inserirproduto';
    PRODUCES APPLICATION_JSON

WSMETHOD PUT alterarProduto;
    DESCRIPTION 'Alterar dados do Produto';
    WSSYNTAX '/alterarproduto';
    PATH 'alterarproduto';
    PRODUCES APPLICATION_JSON   

WSMETHOD DELETE deletarProduto;
    DESCRIPTION 'Deletar registro do Produto';
    WSSYNTAX '/deletarproduto';
    PATH 'deletarproduto';
    PRODUCES APPLICATION_JSON       
ENDWSRESTFUL  

WSMETHOD GET buscaProduto WSRECEIVE CODPRODUTO WSREST WSRESTPROD
    // recuperar o produto informado via url
    Local cCodProd  := Self:CODPRODUTO
    Local aArea     := GetArea()
    Local oJsonProd := JsonObject():New()
    Local oReturn   := JsonObject():new()
    Local cStatus   :=""
    Local cGrupo    :=""
    Local aProd     :={}
    Local cJson     :=""
    Local cReturn 
    Local lRet      :=.T.
   
    //define o tipo de retorno do metodo
    ::SetContentType("application/json")
    DBSelectArea("SB1")//Abro o ambiente
    SB1->(DBSetOrder(1))
    if SB1->(DBSeek(xFilial("SB1")+cCodProd))
        cStatus := IIF(SB1->B1_MSBLQL=='1','Sim','Não')
        cGrupo  := AllTrim(Posicione('SBM',1,xFilial('SBM')+SB1->B1_GRUPO,'BM_DESC'))
        aadd(aProd,JsonObject():New())
        aProd[1]['prodcod']   :=AllTrim(SB1->B1_COD)
        aProd[1]['proddesc']  :=AllTrim(EncodeUtf8(SB1->B1_DESC))
        aProd[1]['produm']    :=AllTrim(SB1->B1_UM)
        aProd[1]['prodncm']   :=AllTrim(SB1->B1_POSIPI)
        aProd[1]['prodgrup']  :=cGrupo
        aProd[1]['prodstatus']:=cStatus

        cReturn := FWJSONSerialize(oReturn)//rerializa o retorno
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

WSMETHOD POST inserirProduto WSRECEIVE WSREST WSRESTPROD   
    Local aArea     := GetArea()
    Local oJsonProd := JsonObject():New()
    Local oReturn   := JsonObject():new()
    Local lRet      :=.T.
    Local cCod,cDesc,cUm,cTipo,cGrupo  := ""
    //FROMJSON Carrega os dados vindos do conteúdo da requisição em json
    oJsonProd:FromJson(Self:GetContent())//getContent traz o conteúdo
    //busca o codigo do produto no objeto Json na estrutura criada.
    cCod  := AllTrim(oJsonProd['produtos']:GetJsonObject('prodcod'))
    cDesc := AllTrim(oJsonProd['produtos']:GetJsonObject('proddesc'))
    cUm   := AllTrim(oJsonProd['produtos']:GetJsonObject('produm'))
    cTipo := AllTrim(oJsonProd['produtos']:GetJsonObject('prodtipo'))
    cGrupo:= AllTrim(oJsonProd['produtos']:GetJsonObject('prodgrup'))



    //RpcSetEnv("99","01",,,"COM")    
    DBSelectArea("SB1")//Abro o ambiente
    SB1->(DBSetOrder(1))
    //verificar se o código já existe
    if SB1->(DBSeek(xFilial("SB1")+cCod))
        SetRestFault(400,'Codigo do produto ja existe na base.')
        lRet := .F.
        return lRet
        //verificar campo em branco    
        elseif Empty(cCod)
            SetRestFault(401,'Codigo do produto esta em branco.')
            lRet := .F.
            return lRet
        elseif Empty(cDesc)
            SetRestFault(402,'Descricao produto esta em branco.')
            lRet := .F.
            return lRet
        elseif Empty(cUm)
            SetRestFault(403,'Unidade de Medida do produto esta em branco.')
            lRet := .F.
            return lRet
        elseif Empty(cTipo)
            SetRestFault(404,'Tipo do produto esta em branco.')
            lRet := .F.
            return lRet             
        elseif Empty(cGrupo)
            SetRestFault(405,'Grupo do produto esta em branco.')
            lRet := .F.
            return lRet  
            //verificar se algum campo de consulta padrão existe
            elseif !SBM->(DbSeek(xFilial("SBM")+cGrupo))               
                SetRestFault(406,'Grupo do produto não existe na base. Verifique ou informe para cadastrar.')
                lRet := .F.
                return lRet 
            elseif !SX5->(DbSeek(xFilial("SX5")+"02"+cTipo))               
                SetRestFault(407,'Tipo de produto não existe na base. Verifique ou informe para cadastrar.')
                lRet := .F.
                return lRet 
            elseif !SAH->(DbSeek(XFILIAL('SAH')+cUm))                
                SetRestFault(408,'Unidade de Medida do produto não existe na base. Verifique ou informe para cadastrar.')
                lRet := .F.
                return lRet          
        
    //incluir
    else   
        RECLOCK( "SB1", .T.)
            SB1->B1_COD     := cCod
            SB1->B1_DESC    := cDesc
            SB1->B1_TIPO    := cTipo
            SB1->B1_UM      := cUm
            SB1->B1_GRUPO   := cGrupo
            SB1->B1_MSBLQL  :='2'//ja inicia com status Ativo, nao bloqueado
        SB1->(MSUNLOCK())
        //exibir retorno do processo        
        oReturn['prodcod']  := cCod
        oReturn['proddesc'] := cDesc
        oReturn['cRet']     := '201-Sucesso'
        oReturn['cMsg']     := 'Registro efetuado com sucesso, complete o registro no Protheus.'
        
        Self:SetStatus(201)
        //tipo de conteúdo retornado
        Self:SetContentType(APPLICATION_JSON)
        //serializa o Json para exibição ao usuário
        Self:SetResponse(FWJSONSerialize(oReturn))
    endif
    
    RestArea(aArea)
    FreeObj(oJsonProd)//liberar os objetos
    FreeObj(oReturn)
return lRet

WSMETHOD PUT alterarProduto WSRECEIVE WSREST WSRESTPROD   
    Local aArea     := GetArea()
    Local oJsonProd := JsonObject():New()
    Local oReturn   := JsonObject():new()
    Local lRet      :=.T.
    Local cCod,cDesc,cUm,cTipo,cGrupo  := ""
    //FROMJSON Carrega os dados vindos do conteúdo da requisição em json
    oJsonProd:FromJson(Self:GetContent())//getContent traz o conteúdo
    //busca o codigo do produto no objeto Json na estrutura criada.
    cCod  := AllTrim(oJsonProd['produtos']:GetJsonObject('prodcod'))
    cDesc := AllTrim(oJsonProd['produtos']:GetJsonObject('proddesc'))
    cUm   := AllTrim(oJsonProd['produtos']:GetJsonObject('produm'))
    cTipo := AllTrim(oJsonProd['produtos']:GetJsonObject('prodtipo'))
    cGrupo:= AllTrim(oJsonProd['produtos']:GetJsonObject('prodgrup'))



    //RpcSetEnv("99","01",,,"COM")    
    DBSelectArea("SB1")//Abro o ambiente
    SB1->(DBSetOrder(1))
    //verificar se o código já existe, senão existir não pode ser atualziado
    if !SB1->(DBSeek(xFilial("SB1")+cCod))
        SetRestFault(400,'Codigo do produto nao existe na base.')
        lRet := .F.
        return lRet
        //verificar campo em branco    
        elseif Empty(cCod)
            SetRestFault(401,'Codigo do produto esta em branco.')
            lRet := .F.
            return lRet
        elseif Empty(cDesc)
            SetRestFault(402,'Descricao produto esta em branco.')
            lRet := .F.
            return lRet
        elseif Empty(cUm)
            SetRestFault(403,'Unidade de Medida do produto esta em branco.')
            lRet := .F.
            return lRet
        elseif Empty(cTipo)
            SetRestFault(404,'Tipo do produto esta em branco.')
            lRet := .F.
            return lRet             
        elseif Empty(cGrupo)
            SetRestFault(405,'Grupo do produto esta em branco.')
            lRet := .F.
            return lRet  
            //verificar se algum campo de consulta padrão existe
            elseif !SBM->(DbSeek(xFilial("SBM")+cGrupo))               
                SetRestFault(406,'Grupo do produto não existe na base. Verifique ou informe para cadastrar.')
                lRet := .F.
                return lRet 
            elseif !SX5->(DbSeek(xFilial("SX5")+"02"+cTipo))               
                SetRestFault(407,'Tipo de produto não existe na base. Verifique ou informe para cadastrar.')
                lRet := .F.
                return lRet 
            elseif !SAH->(DbSeek(XFILIAL('SAH')+cUm)) 
                SetRestFault(408,'Unidade de Medida do produto não existe na base. Verifique ou informe para cadastrar.')
                lRet := .F.
                return lRet          
        
    //aupdate
    else   
        RECLOCK( "SB1", .F.)            
            SB1->B1_DESC    := cDesc
            SB1->B1_TIPO    := cTipo
            SB1->B1_UM      := cUm
            SB1->B1_GRUPO   := cGrupo           
        SB1->(MSUNLOCK())
        //exibir retorno do processo        
        oReturn['prodcod']  := cCod
        oReturn['proddesc'] := cDesc
        oReturn['cRet']     := '201-Sucesso'
        oReturn['cMsg']     := 'Registro atualizado com sucesso, complete a atualizacao no Protheus.'
        
        Self:SetStatus(201)
        //tipo de conteúdo retornado
        Self:SetContentType(APPLICATION_JSON)
        //serializa o Json para exibição ao usuário
        Self:SetResponse(FWJSONSerialize(oReturn))
    endif
    
    RestArea(aArea)
    FreeObj(oJsonProd)//liberar os objetos
    FreeObj(oReturn)
return lRet

WSMETHOD DELETE deletarProduto WSRECEIVE CODPRODUTO WSREST WSRESTPROD
    // recuperar o produto informado via url
    Local cCodProd  := Self:CODPRODUTO
    Local aArea     := GetArea()
    Local oJsonProd := JsonObject():New() 
    Local oReturn   := JsonObject():New()
    Local lRet      :=.T.   
    Local cDesc
    
    DBSelectArea("SB1")//Abro o ambiente
    SB1->(DBSetOrder(1))
    if SB1->(DBSeek(xFilial("SB1")+cCodProd))
        cDesc   := AllTrim(SB1->B1_DESC)
        RECLOCK( "SB1", .F. )
            DBDelete()
        SB1->(MSUNLOCK())
        
        oReturn['prodcod']  := cCodProd
        oReturn['proddesc'] := cDesc
        oReturn['cRet']     := '201-Sucesso'
        oReturn['cMsg']     := 'Registro exckído com sucesso.'
        Self:SetStatus(201)
        Self:SetContentType(APPLICATION_JSON)
        Self:SetResponse(FWJSONSerialize(oReturn))
    else
        SetRestFault(401,'Codigo do produto não contrado.')//setando o erro
        lRet := .F.
        return lRet        
    endif
    SB1->(DBCloseArea()) 
    RestArea(aArea)
    FreeObj(oJsonProd)//liberar os objetos
    FreeObj(oReturn)
return lRet
