#INCLUDE 'Protheus.ch'
#INCLUDE 'FWMVCDEF.ch'

/*/{Protheus.doc} User Function MVCSZ7
    Função principal para a tela de Solicitação de Compras
    @type  Function
    @author Filipe Souza
    @since 04/01/2023
    /*/
User Function MVCSZ7()
    //criação do browse
    Local aArea     :=GetArea()
    Local oBrowse   := FwMBrowse():New()

    //chamará area para criar tabela se não existir.
    DbSelectArea("SZ7")
    DbSetOrder(1)
    SZ7->(DBCloseArea())

    oBrowse:SetAlias("SZ7")
    oBrowse:SetDescription("MVC-Pedido de Compras-Mod2")
    oBrowse:ACTIVATE()
    RestArea(aArea)
Return 

/*§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§*/
Static Function ModelDef()
    //formará estrutura temporária para cabeçalhos, representa a estrutura a ser criada
    Local oStHead   := FWFormModelStruct():New()
    
    //formará estrutura dos itens, chamando a tabela e dicionario de dados
    Local oStItens  := FWFormStruct(1,'SZ7')

    //b bloco de codigo, função que validará antes de INSERT dos itens
    Local bVldPos   := {|| u_VldSZ7()}

    //b bloco de codigo, função COMIT que validará INCLUSÃO/ALTERAÇÃO/EXCLUSÃO
    Local bVldCom   := {|| u_GrvSZ7()}
    
    //objeto principal do MVC model2, com caracteristicas do dicionario de dados
                                                  //*bPre*/,/*bPos*/,/*bComit*/,/*bCancel*/
    Local oModel    := MPFormModel():New('MVCSZ7m',/*bPre*/,bVldPos,bVldCom,/*bCancel*/)
    
    //variáveis que armazenarão a estrutura da trigger dos campos, para gerar TOTAL automático.
    Local aTrigQuant:={}
    Local aTrigPreco:={}

    //criação da tabela temporária Head
    oStHead:AddTable('SZ7',{'Z7_FILIAL','Z7_NUM','Z7_ITEM'},'HeadSZ7')

    //£££ criação dos campos da tabela temporaria,representa SX3
    oStHead:AddField(;//Filial
        'Filial',;               //[01] Titulo do campo
        'Filial',;               //[02] Tooltip do campo
        'Z7_FILIAL',;            //[03] Id do Field
        'C',;                    //[04] Tipo do campo
        TamSX3('Z7_FILIAL')[1],; //[05] Tamanho do campo
        0,;                      //[06] Decimal do campo
        NIL,;                    //[07] Bloco de código de validação do campo
        NIL,;                    //[08] Bloco de código de validação when do campo
        {},;                     //[09] Lista de valores permitido do campo
        .F.,;                    //[10] Indica se o campo tem preenchimento obrigatório
        FWBuildFeature(STRUCT_FEATURE_INIPAD,;//[11]Bloco de código de inicialização do campo
            "IIF(!INCLUI,SZ7->Z7_FILIAL,FwxFilial('SZ7'))"),;
        .T.,;                    //[12] Indica se trata-se de um campo chave
        .F.,;                    //[13] Indica se o campo não pode receber valor em uma operação de update
        .F.)                     //[14] Indica se o campo é virtual

    oStHead:AddField(;//Num pedido
        'Pedido',;               //[01] Titulo do campo
        'Pedido',;               //[02] Tooltip do campo
        'Z7_NUM',;            //[03] Id do Field
        'C',;                    //[04] Tipo do campo
        TamSX3('Z7_NUM')[1],; //[05] Tamanho do campo
        0,;                      //[06] Decimal do campo
        NIL,;                    //[07] Bloco de código de validação do campo
        NIL,;                    //[08] Bloco de código de validação when do campo
        {},;                     //[09] Lista de valores permitido do campo
        .F.,;                    //[10] Indica se o campo tem preenchimento obrigatório
        FWBuildFeature(STRUCT_FEATURE_INIPAD,;//[11]Bloco de código de inicialização do campo
            "IIF(!INCLUI,SZ7->Z7_NUM,GetSXEnum('SZ7','Z7_NUM'))"),;
        .T.,;                    //[12] Indica se trata-se de um campo chave
        .F.,;                    //[13] Indica se o campo não pode receber valor em uma operação de update
        .F.)                     //[14] Indica se o campo é virtual    

    oStHead:AddField(;//Emissao
        'Emissao',;               
        'Emissao',;               
        'Z7_EMISSAO',;            
        'D',;                    
        TamSX3('Z7_EMISSAO')[1],;
        0,;                      
        NIL,;                    
        NIL,;                    
        {},;                     
        .T.,;                    
        FWBuildFeature(STRUCT_FEATURE_INIPAD,;
            'IIF(!INCLUI,SZ7->Z7_EMISSAO,dDataBase)'),;
        .F.,;                   
        .F.,;                   
        .F.)                    
        
    oStHead:AddField(;//Fornecedor
        'Fornecedor',;               
        'Fornecedor',;               
        'Z7_FORNECE',;            
        'C',;                    
        TamSX3('Z7_FORNECE')[1],; 
        0,;                      
        NIL,;                    
        NIL,;                    
        {},;                     
        .T.,;                    
        FWBuildFeature(STRUCT_FEATURE_INIPAD,;
            "IIF(!INCLUI,SZ7->Z7_FORNECE,'')"),;
        .F.,;                    
        .F.,;                    
        .F.)  

    oStHead:AddField(;//Loja
        'Loja',;               
        'Loja',;               
        'Z7_LOJA',;            
        'C',;                    
        TamSX3('Z7_LOJA')[1],; 
        0,;                      
        NIL,;                    
        NIL,;                    
        {},;                     
        .T.,;                    
        FWBuildFeature(STRUCT_FEATURE_INIPAD,;
            "IIF(!INCLUI,SZ7->Z7_LOJA,'')"),;
        .F.,;                    
        .F.,;                    
        .F.)  

    oStHead:AddField(;//Usuario
        'Usuario',;               
        'Usuario',;               
        'Z7_USER',;            
        'C',;                    
        TamSX3('Z7_USER')[1],; 
        0,;                      
        NIL,;                    
        NIL,;                    
        {},;                     
        .T.,;                    
        FWBuildFeature(STRUCT_FEATURE_INIPAD,;
            "IIF(!INCLUI,SZ7->Z7_USER,__cUserId)"),;
        .F.,;                    
        .F.,;                    
        .F.)                          
    //£££

    //Gerar a estrutura dos itens, visualizados na Grid
    //modificar inicializador padrao
    oStItens:SetProperty("Z7_NUM",    MODEL_FIELD_INIT, FWBuildFeature(STRUCT_FEATURE_INIPAD,'"*"'))   //"GetSXEnum('SZ7','Z7_NUM')"  não colocar nos items pois perde a sequencia
    oStItens:SetProperty("Z7_EMISSAO",MODEL_FIELD_INIT, FWBuildFeature(STRUCT_FEATURE_INIPAD,'dDataBase'))   
    oStItens:SetProperty("Z7_FORNECE",MODEL_FIELD_INIT, FWBuildFeature(STRUCT_FEATURE_INIPAD,'"*"'))   
    oStItens:SetProperty("Z7_LOJA",   MODEL_FIELD_INIT, FWBuildFeature(STRUCT_FEATURE_INIPAD,'"*"'))   
    oStItens:SetProperty("Z7_USER",   MODEL_FIELD_INIT, FWBuildFeature(STRUCT_FEATURE_INIPAD,'__cUserId'))  

    //Trigger
    aTrigQuant  := FwStruTrigger(;
    "Z7_QUANT",;    //campo que irá disparar o gatilho/trigger
    "Z7_TOTAL",;    //campo que receberá o resultado da trigger
    "M->Z7_QUANT * M->Z7_PRECO",;//resultado da trigger
    .F.)            //não posiciona

    //Trigger
    aTrigPreco  := FwStruTrigger(;
    "Z7_PRECO",;    //campo que irá disparar o gatilho/trigger
    "Z7_TOTAL",;    //campo que receberá o resultado da trigger
    "M->Z7_QUANT * M->Z7_PRECO",;//resultado da trigger
    .F.)            //não posiciona

    //adiciono a trigger na estrutura de Itens
    oStItens:AddTrigger(;
    aTrigQuant[1],;
    aTrigQuant[2],;
    aTrigQuant[3],;
    aTrigQuant[4])
    oStItens:AddTrigger(;
    aTrigPreco[1],;
    aTrigPreco[2],;
    aTrigPreco[3],;
    aTrigPreco[4])
    
    
    //União das estruturas, cabeçalho aos itens
    oModel:AddFields("SZ7MASTER",,oStHead,,,)
    oModel:AddGrid("SZ7DETAIL","SZ7MASTER",oStItens,,,,,)

    //Modelo de Totalizadores
    oModel:AddCalc( "SZ7TOTAIS",;    //Id do Modelo    
                    "SZ7MASTER",;   //master
                    "SZ7DETAIL",;   //detail
                    "Z7_PRODUTO",;  //campo calculado
                    "QtdItens",;    //nome personalizado
                    "COUNT",,,;     //Operação ,,,
                    "ITENS")     //Nome totalizador
    oModel:AddCalc( "SZ7TOTAIS", "SZ7MASTER", "SZ7DETAIL", "Z7_QUANT", "Qtd",  "SUM",,,"QUANTIDADE")  
    oModel:AddCalc( "SZ7TOTAIS", "SZ7MASTER", "SZ7DETAIL", "Z7_TOTAL", "Total","SUM",,,"VALOR TOTAL") 


    //relacionamento através de FILIAL + NUM, que é do indice 1
    oModel:SetRelation("SZ7DETAIL",{{"Z7_FILIAL","IIF(!INCLUI,SZ7->Z7_FILIAL,FWxFilial('SZ7'))"},;
                                   {"Z7_NUM","SZ7->Z7_NUM"}},;
                                   SZ7->(INDEXKEY( 1 )))
    oModel:SetPrimarykey({})                           
    //para o item não se repetir        
    oModel:GetModel("SZ7DETAIL"):SetUniqueline({"Z7_ITEM"})  

    oModel:GetModel("SZ7MASTER"):SetDescription("Cabeçalho da Solicitação de Compras")
    oModel:Getmodel("SZ7DETAIL"):SetDescription("Itens da Solicitação de Compras")

    //Finalizar setando o modelo antigo de grid  que permite pegar aHead e aCols
    oModel:getModel("SZ7DETAIL"):SetUseOldGrid(.T.)
    

Return oModel

/*§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§*/
Static Function ViewDef()
    Local oView 
    Local oModel    :=FwLoadModel("MVCSZ7")//carregar o modelo que foi montado na user function MVCSZ7
    Local oStHead   :=FwFormViewStruct():New()
    Local oStItens  :=FwFormStruct(2,"SZ7")// 1 para model, 2 para View
    Local oStTotais :=FWCalcStruct(oModel:GetModel("SZ7TOTAIS"))

    //addFiled em ViewStruct
    //tratando a visualização dos campos
    oStHead:AddField(;//Pedido
        "Z7_NUM",;  //1 nome do campo
        "01",;      //2 ordem
        "Pedido",;  //3 titulo do campo
        X3Descric('Z7_NUM'),;//4 desciçãod o campo
        Nil,;       //5 array help
        "C",;       //6 tipo de campo
        X3Picture("Z7_NUM"),;//7 Picture, máscara
        NIL,;       //8 bloco de picture Var
        NIL,;       //9 consulta F3
        .F.,;       //10 indica se o campo é editável na operação de INCLUI
        NIL,;       //11 pasta do campo
        NIL,;       //12 agrupamento do campo
        NIL,;       //13 lista de valores permitidos no campo
        NIL,;       //14 tamanho máximodo campo
        NIL,;       //15 inicializador do Browse
        NIL,;       //16 insica de o campo é virtual
        NIL,;       //17 picture variável
        NIL)        //18

    oStHead:AddField(;//Emissao
        "Z7_EMISSAO",;  //1 nome do campo
        "02",;      //2 ordem
        "Emissao",;  //3 titulo do campo
        X3Descric('Z7_EMISSAO'),;//4 desciçãod o campo
        Nil,;       //5 array help
        "D",;       //6 tipo de campo
        X3Picture("Z7_EMISSAO"),;//7 Picture, máscara
        NIL,;       //8 bloco de picture Var
        NIL,;       //9 consulta F3
        IIF(INCLUI, .T., .F.),;//10 indica se o campo é editável na operação de INCLUI
        NIL,;       //11 pasta do campo
        NIL,;       //12 agrupamento do campo
        NIL,;       //13 lista de valores permitidos no campo
        NIL,;       //14 tamanho máximodo campo
        NIL,;       //15 inicializador do Browse
        NIL,;       //16 insica de o campo é virtual
        NIL,;       //17 picture variável
        NIL)        //18  

    oStHead:AddField(;//Fornecedor
        "Z7_FORNECE",;  //1 nome do campo
        "03",;      //2 ordem
        "Fornecedor",;  //3 titulo do campo
        X3Descric('Z7_FORNECE'),;//4 desciçãod o campo
        Nil,;       //5 array help
        "C",;       //6 tipo de campo
        X3Picture("Z7_FORNECE"),;//7 Picture, máscara
        NIL,;       //8 bloco de picture Var
        "SA2",;     //9 consulta F3
        IIF(INCLUI, .T., .F.),;//10 indica se o campo é editável na operação de INCLUI
        NIL,;       //11 pasta do campo
        NIL,;       //12 agrupamento do campo
        NIL,;       //13 lista de valores permitidos no campo
        NIL,;       //14 tamanho máximodo campo
        NIL,;       //15 inicializador do Browse
        NIL,;       //16 insica de o campo é virtual
        NIL,;       //17 picture variável
        NIL)        //18

    oStHead:AddField(;//Loja
        "Z7_LOJA",;  //1 nome do campo
        "04",;      //2 ordem
        "Loja",;  //3 titulo do campo
        X3Descric('Z7_LOJA'),;//4 desciçãod o campo
        Nil,;       //5 array help
        "C",;       //6 tipo de campo
        X3Picture("Z7_LOJA"),;//7 Picture, máscara
        NIL,;       //8 bloco de picture Var
        NIL,;       //9 consulta F3
        IIF(INCLUI, .T., .F.),;//10 indica se o campo é editável na operação de INCLUI
        NIL,;       //11 pasta do campo
        NIL,;       //12 agrupamento do campo
        NIL,;       //13 lista de valores permitidos no campo
        NIL,;       //14 tamanho máximodo campo
        NIL,;       //15 inicializador do Browse
        NIL,;       //16 insica de o campo é virtual
        NIL,;       //17 picture variável
        NIL)        //18

    

    oStHead:AddField(;//Usuario
        "Z7_USER",;  //1 nome do campo
        "05",;      //2 ordem
        "Usuario",;  //3 titulo do campo
        X3Descric('Z7_USER'),;//4 desciçãod o campo
        Nil,;       //5 array help
        "C",;       //6 tipo de campo
        X3Picture("Z7_USER"),;//7 Picture, máscara
        NIL,;       //8 bloco de picture Var
        NIL,;       //9 consulta F3
        .F.,;       //10 indica se o campo é editável na operação de INCLUI
        NIL,;       //11 pasta do campo
        NIL,;       //12 agrupamento do campo
        NIL,;       //13 lista de valores permitidos no campo
        NIL,;       //14 tamanho máximodo campo
        NIL,;       //15 inicializador do Browse
        NIL,;       //16 insica de o campo é virtual
        NIL,;       //17 picture variável
        NIL)        //18      
      
    //remover a exibição dos itens na grid, pois estão no cabeçalho
    oStItens:RemoveField("Z7_NUM")
    oStItens:RemoveField("Z7_EMISSAO")
    oStItens:RemoveField("Z7_FORNECE")
    oStItens:RemoveField("Z7_LOJA")
    oStItens:RemoveField("Z7_USER")

    //bloqueando a edição dos campos, pois são automáticos.
    oStItens:SetProperty("Z7_ITEM" ,MVC_VIEW_CANCHANGE,.F.)
    oStItens:SetProperty("Z7_TOTAL",MVC_VIEW_CANCHANGE,.F.)

    oView:=FwFormView():New()
    //atribui na view o modelo criado
    oView:SetModel(oModel)
    //estrutura de vizualização do master , detail e totalizadores
    oView:AddField("VIEW_SZ7M",oStHead,"SZ7MASTER")
    oView:AddGrid("VIEW_SZ7D",oStItens,"SZ7DETAIL")
    oView:AddField("VIEW_TOTAL",oStTotais,"SZ7TOTAIS")
//£££££££££££££££££££££££££££££££££££££££££££££££££
    //Deixar o campo ITEM auto increment
    oView:AddIncrementalField("SZ7DETAIL","Z7_ITEM")

    oView:CreateHorizontalBox("HEAD",20)
    oView:CreateHorizontalBox("GRID",50)
    oView:CreateHorizontalBox("TOTAL",30)

    //informa para onde vai cada view criada
    //associo o view a cada box criado, ID form e ID box
    oView:SetOwnerView("VIEW_SZ7M","HEAD")
    oView:SetOwnerView("VIEW_SZ7D","GRID")
    oView:SetOwnerView("VIEW_TOTAL","TOTAL")

    //ativar titulo de cada view box
    oView:EnableTitleView("VIEW_SZ7M","Cabeçalho de Solicitação de Compra")
    oView:EnableTitleView("VIEW_SZ7D","Itens de Solicitação de Compra")
    oView:EnableTitleView("VIEW_TOTAL","Totalizador")
    
    //fecha a janela ao clicar em OK
    oView:SetCloseOnOK({|| .T.})
    

return oView

/*§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§*/
Static Function MenuDef()
    //1ª opção
    Local aRotina   := FwMvcmenu("MVCSZ7")

/*    //2ª opção
    Local aRotina:={}
    ADD OPTION aRotina TITLE 'Visualizar'   ACTION 'ViewDef.MVCSZ7' OPERATION 2 ACCESS 0
    ADD OPTION aRotina TITLE 'Incluir'      ACTION 'ViewDef.MVCSZ7' OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE 'Alterar'      ACTION 'ViewDef.MVCSZ7' OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE 'Excluir'      ACTION 'ViewDef.MVCSZ7' OPERATION 5 ACCESS 0

    //3ª Opção
    Local aRotina:={}
    ADD OPTION aRotina TITLE 'Visualizar'   ACTION 'ViewDef.MVCSZ7' OPERATION MODEL_OPERATION_VIEW ACCESS 0
    ADD OPTION aRotina TITLE 'Incluir'      ACTION 'ViewDef.MVCSZ7' OPERATION MODEL_OPERATION_INSERT ACCESS 0
    ADD OPTION aRotina TITLE 'Alterar'      ACTION 'ViewDef.MVCSZ7' OPERATION MODEL_OPERATION_UPDATE ACCESS 0
    ADD OPTION aRotina TITLE 'Excluir'      ACTION 'ViewDef.MVCSZ7' OPERATION MODEL_OPERATION_DELETE ACCESS 0
*/
return aRotina

//função COMIT que validará INCLUSÃO/ALTERAÇÃO/EXCLUSÃO
User Function GrvSZ7()
    Local aArea     := GetArea()
                    //retorna a referência do ultimo MODEL utilizado, o ativo
    Local oModel    := FwModelActive()
    //criar modelo de dados MASTER/HEAD com dados do model geral que foi capturado acima
    //carrega o demolo do Head
    Local oModelHead  := oModel:GetModel("SZ7MASTER")    
    //carrega o modelo do DETAIL(detalhes-itens)
    Local oModelDetail:= oModel:GetModel("SZ7DETAIL")    

    //capturo os valores que estão no cabeçalho, métido GETVALUE
    Local cFilSZ7   := oModelHead:Getvalue("Z7_FILIAL")
    Local cNum      := oModelHead:Getvalue("Z7_NUM")
    Local dEmissao  := oModelHead:Getvalue("Z7_EMISSAO")
    Local cForn     := oModelHead:Getvalue("Z7_FORNECE")
    Local cLoja     := oModelHead:Getvalue("Z7_LOJA")
    Local cUser     := oModelHead:Getvalue("Z7_USER")

    //variáveis que farão a captura dos dados com base no head e detail
    Local aHeadAux  :=oModelDetail:aHeader  //captura head do grid
    Local aColsAux  :=oModelDetail:aCols    //captura aCols do grid

    //pegar posição de cada campo dentro do grid
    Local nPosItem  := aScan(aHeadAux,{|x| AllTrim(Upper(x[2])) == AllTrim("Z7_ITEM")})
    Local nPosProd  := aScan(aHeadAux,{|x| AllTrim(Upper(x[2])) == AllTrim("Z7_PRODUTO")})
    Local nPosQtd   := aScan(aHeadAux,{|x| AllTrim(Upper(x[2])) == AllTrim("Z7_QUANT")})
    Local nPosPrec  := aScan(aHeadAux,{|x| AllTrim(Upper(x[2])) == AllTrim("Z7_PRECO")})
    Local nPosTotal := aScan(aHeadAux,{|x| AllTrim(Upper(x[2])) == AllTrim("Z7_TOTAL")})

    //pegar a linha atual que o usuario estpa posicionado
    Local nLinAtu   :=0

    //Identificar quel operação está sendo feita(INCLUSÃO/ALTERAÇÃO/EXCLUSÃO)
    Local cOption   := oModelHead:GetOperation()
    Local lRet := .T.
    //selecionar area SZ7
    DBSelectArea("SZ7")
    SZ7->(DbSetOrder(1))
    IF cOption == MODEL_OPERATION_INSERT
        //primeiro verificar se a linha está deletada
        For nLinAtu:= 1 to Len(aColsAux)
            If !aColsAux[nLinAtu][len(aHeadAux)+1] // expressão que verifica se a linha NÃO está deletada no aColsAux
                RECLOCK( "SZ7", .T.)
                    //header
                    Z7_FILIAL   := cFilSZ7
                    Z7_NUM      := cNum
                    Z7_EMISSAO  := dEmissao
                    Z7_FORNECE  := cForn
                    Z7_LOJA     := cLoja
                    Z7_USER     := cUser
                    //grid
                    Z7_ITEM     := aColsAux[nLinAtu][nPosItem]
                    Z7_PRODUTO  := aColsAux[nLinAtu][nPosProd]
                    Z7_QUANT    := aColsAux[nLinAtu][nPosQtd]
                    Z7_PRECO    := aColsAux[nLinAtu][nPosPrec]
                    Z7_TOTAL    := aColsAux[nLinAtu][nPosTotal]                
                MSUNLOCK()                
            EndIf  
        Next nLinAtu 
    ELSEIF cOption == MODEL_OPERATION_UPDATE
        For nLinAtu:= 1 to Len(aColsAux)
            If aColsAux[nLinAtu][len(aHeadAux)+1] // expressão que verifica se a linha está deletada no aColsAux
                //se a linha está deletada
                SZ7->(DbSetOrder(3))// FILIAL+NUM+ITEM
                If SZ7->(DBSeek(cFilSZ7 + cNum + aColsAux[nLinAtu,nPosItem]))//deletar do banco
                    RecLock("SZ7",.F.)
                        DBDelete()
                    SZ7->(MSUNLOCK())
                EndIf
            ELSE //A linha não está excluída, fazer atualização
                //é possível ter novos itens no pedido
                //validar se existem no BD, senão faz inclusão  
                SZ7->(DbSetOrder(3))// FILIAL+NUM+ITEM
                If SZ7->(DBSeek(cFilSZ7 + cNum + aColsAux[nLinAtu,nPosItem]))//se existe faz atualização
                    RecLock("SZ7",.F.)                
                    Z7_FILIAL   := cFilSZ7
                    Z7_NUM      := cNum
                    Z7_EMISSAO  := dEmissao
                    Z7_FORNECE  := cForn
                    Z7_LOJA     := cLoja
                    Z7_USER     := cUser
                    Z7_ITEM     := aColsAux[nLinAtu][nPosItem]
                    Z7_PRODUTO  := aColsAux[nLinAtu][nPosProd]
                    Z7_QUANT    := aColsAux[nLinAtu][nPosQtd]
                    Z7_PRECO    := aColsAux[nLinAtu][nPosPrec]
                    Z7_TOTAL    := aColsAux[nLinAtu][nPosTotal]
                    SZ7->(MSUNLOCK())
                else// se não achar, o item existe na base, ocorrerá a inclusão
                    RECLOCK( "SZ7", .T.)//
                    Z7_FILIAL   := cFilSZ7
                    Z7_NUM      := cNum
                    Z7_EMISSAO  := dEmissao
                    Z7_FORNECE  := cForn
                    Z7_LOJA     := cLoja
                    Z7_USER     := cUser
                    Z7_ITEM     := aColsAux[nLinAtu][nPosItem]
                    Z7_PRODUTO  := aColsAux[nLinAtu][nPosProd]
                    Z7_QUANT    := aColsAux[nLinAtu][nPosQtd]
                    Z7_PRECO    := aColsAux[nLinAtu][nPosPrec]
                    Z7_TOTAL    := aColsAux[nLinAtu][nPosTotal]                
                    SZ7->(MSUNLOCK())  
                   
                EndIf 
            EndIf  
        Next nLinAtu 
    
    ELSEIF cOption == MODEL_OPERATION_DELETE
        SZ7->(DbSetOrder(1))
        While !SZ7->(EOF()) .AND. SZ7->Z7_NUM = cNum .AND. SZ7->Z7_FILIAL = cFilSZ7
            RecLock("SZ7",.F.)
            DBDelete()
            SZ7->(MSUNLOCK())
            SZ7->(DBSKIP())//pula ao próximo registro
        ENDDO        
    ENDIF
    SZ7->(DBCloseArea())
    RestArea(aArea)

return lRet

/*£££££££££££££££££££££££££££££££££££££££££££££££££££££££*/
User Function VldSZ7()
    Local lRet        := .T.
    Local aArea       := GetArea()
    //¢¢¢¢¢¢¢¢ estrutura igual ao GrvSZ7()
    //instancio os models para pegar os valores digitados
    Local oModel      := FwModelActive()
    Local oModelHead  := oModel:GetModel("SZ7MASTER")    
    Local cFilSZ7     := oModelHead:GetValue("Z7_FILIAL")
    Local cNum        := oModelHead:GetValue("Z7_NUM")
    Local cOption     := oModelHead:GetOperation()
    //¢¢¢¢¢¢¢
    If cOption == MODEL_OPERATION_INSERT
        DbSelectArea("SZ7")
        SZ7->(DbSetOrder(1))
        //se encontrar o numero do Pedido no banco
        if SZ7->(DBSeek(cFilSZ7+cNum))
            lRet :=.F.
            //Use Help,aparece mensagem de erro, pois Alert e MsInfo não.
            Help(NIL, NIL, "Escolha outro numero de pedido.", NIL, "Este numero já existe.", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Atenção! verifique nos registros."})            
        endif
        SZ7->(DBCloseArea())
    EndIf
    RestArea(aArea)
Return lRet
/*
Melhorias a serem feitas, scopo:
1- Não deixar incluir pedido com mesmo número
2- Número do pedido auto incremental
3- Item do grid auto incremental
4- gatilhos nos campos calculados, total dos itens.
5-Travar campos de Item e Total para não serem editados.
6-Gerar rodapé com totalizadores do grid.
*/






