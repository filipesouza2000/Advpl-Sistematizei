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
    
    //objeto principal do MVC model2, com caracteristicas do dicionario de dados
    Local oModel    := MPFormModel():New('MVCSZ7m',/*bPre*/,/*bPos*/,/*bComit*/,/*bCancel*/)
    
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
            "IIF(!INCLUI,SZ7->Z7_NUM,'')"),;
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
    oStItens:SetProperty("Z7_NUM",    MODEL_FIELD_INIT, FWBuildFeature(STRUCT_FEATURE_INIPAD,'"*"'))   
    oStItens:SetProperty("Z7_EMISSAO",MODEL_FIELD_INIT, FWBuildFeature(STRUCT_FEATURE_INIPAD,'dDataBase'))   
    oStItens:SetProperty("Z7_FORNECE",MODEL_FIELD_INIT, FWBuildFeature(STRUCT_FEATURE_INIPAD,'"*"'))   
    oStItens:SetProperty("Z7_LOJA",   MODEL_FIELD_INIT, FWBuildFeature(STRUCT_FEATURE_INIPAD,'"*"'))   
    oStItens:SetProperty("Z7_USER",   MODEL_FIELD_INIT, FWBuildFeature(STRUCT_FEATURE_INIPAD,'__cUserId'))  

    //União das estruturas, cabeçalho aos itens
    oModel:AddFields("SZ7MASTER",,oStHead,,,)
    oModel:AddGrid("SZ7DETAIL","SZ7MASTER",oStItens,,,,,)
    //relacionamento através de FILIAL + NUM, que é do indice 1
    oModel:SetRelation("SZ7DETAIL",{{"Z7_FILIAL","'IIF(!INCLUI,SZ7->Z7_FILIAL,FWxFilial('SZ7'))'"},;
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
        IIF(INCLUI, .T., .F.),;//10 indica se o campo é editável na operação de INCLUI
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

    oView:=FwFormView():New()
    //atribui na view o modelo criado
    oView:SetModel(oModel)
    //estrutura de vizualização do master e detail
    oView:AddField("VIEW_SZ7M",oStHead,"SZ7MASTER")
    oView:AddGrid("VIEW_SZ7D",oStItens,"SZ7DETAIL")

    oView:CreateHorizontalBox("HEAD",40)
    oView:CreateHorizontalBox("GRID",60)

    //informa para onde vai cada view criada
    //associo o view a cada box criado, ID form e ID box
    oView:SetOwnerView("VIEW_SZ7M","HEAD")
    oView:SetOwnerView("VIEW_SZ7D","GRID")

    //ativar titulo de cada view box
    oView:EnableTitleView("VIEW_SZ7M","Cabeçalho de Solicitação de Compra")
    oView:EnableTitleView("VIEW_SZ7D","Itens de Solicitação de Compra")
    
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



