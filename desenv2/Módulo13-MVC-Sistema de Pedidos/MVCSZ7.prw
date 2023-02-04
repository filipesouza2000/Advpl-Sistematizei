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
    Local oModel    := MDFormModel('MVCSZ7m',/*bPre*/,/*bPos*/,/*bComit*/,/*bCancel*/)
    
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
            'IIF(!INCLUI,SZ7->Z7_EMISAO,dDataBase'),;
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
    oStItens:SetProperty("Z7_NUM",    MODEL_FILED_INIT, FWBuildFeature(STRUCT_FEATURE_INIPAD,'"*"'))   
    oStItens:SetProperty("Z7_EMISSAO",MODEL_FILED_INIT, FWBuildFeature(STRUCT_FEATURE_INIPAD,'dDataBase'))   
    oStItens:SetProperty("Z7_FORNECE",MODEL_FILED_INIT, FWBuildFeature(STRUCT_FEATURE_INIPAD,'"*"'))   
    oStItens:SetProperty("Z7_LOJA",   MODEL_FILED_INIT, FWBuildFeature(STRUCT_FEATURE_INIPAD,'"*"'))   
    oStItens:SetProperty("Z7_USER",   MODEL_FILED_INIT, FWBuildFeature(STRUCT_FEATURE_INIPAD,'__cUserId'))  

    //União das estruturas, cabeçalho aos itens
    oModel:AddFields("SZ7MASTER",,oStHead)
    oModel:AddGrid("SZ7DETAIL","SZ7MASTER",oStItens,,,,,)
    //relacionamento através de FILIAL + NUM, que é do indice 1
    oModel:SetRelation("SZ7DETAIL",{{"Z7_FILIAL","'IIF(!INCLUI,SZ7->Z7_FILIAL,FWxFilial('SZ7'))'"},;
                                   {"Z7_NUM","SZ7->Z7_NUM"}},;
                                   SZ7->(INDEXKEY( 1 )))
    oModel:SetPrimarikey({})                           
    //para o item não se repetir        
    oModel:GetModel("SZ7DETAIL"):SetUniqueline("Z7_ITEM")  
     
    oModel:GetModel("SZ7MASTER"):SetDescription("Cabeçalho da Solicitação de Compras")
    oModel:Getmodel("SZ7DETAIL"):SetDescription("Itens da Solicitação de Compras")

    //Finalizar setando o modelo antigo de grid  que permite pegar aHead e aCols
    oModel:getModel("SZ7DETAIL"):SetUseOldGrid(.T.)
    

Return oModel

/*§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§*/
Static Function MenuDef()

return

/*§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§*/
Static Function ViewDef()

return oView

