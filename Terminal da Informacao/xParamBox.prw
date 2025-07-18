#include 'protheus.ch'
#include 'parmtype.ch'

/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
---Data---|-----Autor-------|-------Descriçãoo------------
18/03/2023| Filipe Souza    | Função parambox com todos os tipos e botões  extras.

@see Terminal da Informação
@see https://terminaldeinformacao.com/knowledgebase/parambox/
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
*/
user function xParamBox()
local aPergs   := {}
local aRet     := {}
local aButtons := {}
local aCombo   := {"","SP","RJ","MG","ES","MA","BA"}
local cArquivo := ""
 
    // Array com botões extras do parambox - Botões Tipo 1= OK e 2= Cancelar já vem nos botões padrões
    AAdd(aButtons, {03, {|| u_xAtuParBox()   }, 'Esse é o botão 03 - Excluir'   }) // botão Excluir
    AAdd(aButtons, {04, {|| u_xAtuParBox()   }, 'Esse é o botão 04 - Incluir'   }) // botão Incluir
    AAdd(aButtons, {05, {|| u_xAtuParBox()   }, 'Esse é o botão 05 - Parametros'}) // botão Parametros
    AAdd(aButtons, {06, {|| u_xAtuParBox()   }, 'Esse é o botão 06 - Imprimir'  }) // botão Imprimir
     
     
    //Só cabem 4 botões extras na janela padrão da parabox, se colocar mais, fica estourado na janela
    /*
    AAdd(aButtons, {03, {|| Alert('Botão 03 - Excluir'   )}, 'Esse é o botão 03 - Excluir'   }) // botão Excluir
    AAdd(aButtons, {04, {|| Alert('Botão 04 - Incluir'   )}, 'Esse é o botão 04 - Incluir'   }) // botão Incluir
        AAdd(aButtons, {05, {|| Alert('Botão 05 - Parametros')}, 'Esse é o botão 05 - Parametros'}) // botão Parametros
        AAdd(aButtons, {06, {|| Alert('Botão 06 - Imprimir'  )}, 'Esse é o botão 06 - Imprimir'  }) // botão Imprimir
        AAdd(aButtons, {07, {|| Alert('Botão 07 - Susp.Impr.'        )}, 'Esse é o botão 07 - Susp.Impr.'        }) // botão Susp.Impr.
        AAdd(aButtons, {08, {|| Alert('Botão 08 - Cancelar Impressão')}, 'Esse é o botão 08 - Cancelar Impressão'}) // botão Cancela Impressão 
        AAdd(aButtons, {09, {|| Alert('Botão 09 - Ordem'             )}, 'Esse é o botão 09 - Ordem'             }) // botão Ordem
        AAdd(aButtons, {10, {|| Alert('Botão 10 - Prioridade'        )}, 'Esse é o botão 10 - Prioridade'        }) // botão Prioridade
        AAdd(aButtons, {11, {|| Alert('Botão 11 - Editar'            )}, 'Esse é o botão 11 - Editar'            }) // botão Editar
        AAdd(aButtons, {12, {|| Alert('Botão 12 - Ouvir'             )}, 'Esse é o botão 12 - Ouvir'             }) // botão Ouvir
        AAdd(aButtons, {13, {|| Alert('Botão 13 - Salvar'            )}, 'Esse é o botão 13 - Salvar'            }) // botão Salvar
        AAdd(aButtons, {14, {|| Alert('Botão 14 - Abrir'             )}, 'Esse é o botão 14 - Abrir'             }) // botão Abrir
        AAdd(aButtons, {15, {|| Alert('Botão 15 - Visualizar'        )}, 'Esse é o botão 15 - Visualizar'        }) // botão Visualizar
        AAdd(aButtons, {16, {|| Alert('Botão 16 - Cond.Neg.'         )}, 'Esse é o botão 16 - Cond.Neg.'         }) // botão Cond.Neg.
        AAdd(aButtons, {17, {|| Alert('Botão 17 - Filtrar'           )}, 'Esse é o botão 17 - Filtrar'           }) // botão Filtrar
        AAdd(aButtons, {18, {|| Alert('Botão 18 - Financ.'           )}, 'Esse é o botão 18 - Financ.'           }) // botão Financ.
        AAdd(aButtons, {19, {|| Alert('Botão 19 - Avançar'           )}, 'Esse é o botão 19 - Avançar'           }) // botão Avançar (em pt-br)
        AAdd(aButtons, {20, {|| Alert('Botão 20 - Voltar'            )}, 'Esse é o botão 20 - Voltar'            }) // botão Voltar (em pt-br)
        AAdd(aButtons, {21, {|| Alert('Botão 21 - Forward'           )}, 'Esse é o botão 21 - Forward'           }) // botão Forward (Avançar)
        AAdd(aButtons, {22, {|| Alert('Botão 22 - Backward'          )}, 'Esse é o botão 22 - Backward'          }) // botão Backward (Voltar)
    */
 
    //Perguntas que serão apresentadas
     
    //Tipo 9 - Apresenta um texto fixo, que será transportado para o aRet no momento da execução. 
    aAdd( aPergs ,{9,"Tipo 9 - Apenas texto demonstrativo.",200, 40,.T.})    
 
    //Tipo 2 - Apresenta um seletor que será alimentado com o array aCombo.
    aAdd( aPergs ,{9,"Abaixo escolha uma opção",200, 40,.T.})                 
     aAdd( aPergs ,{2,"Tipo 2 - Escolha:",01,aCombo,50,"",.T.})
 
     //Tipo 1 - Cria um MSGet para digitação livre
     aAdd( aPergs ,{9,"Tipo 1 - Digite Livre",200, 40,.T.})                    
     aAdd( aPergs ,{1,"Digite Algo: "    , Upper(Space(100))    ,"","","","",110,.T.})
      
     //Tipo 4 - Cria Opções de CheckBox com Texto SAY antes da opção - Pode se passar .T. ou .F. para trazer o check já marcado/desmarcado na primeira execução
     aAdd( aPergs ,{9,"Tipo 4 - Say + CheckBox com Texto",200, 40,.T.})        
     aAdd( aPergs ,{4,"Cod-1"        ,.T.,"Cod-1 - Com Check Marcado"       ,90,"",.F.})
     aAdd( aPergs ,{4,"Cod2-"        ,.F.,"Cod-2 - Com Check Desmarcado"    ,90,"",.F.})
      
     //Tipo 5 - Cria Opções de CheckBox. 
     aAdd( aPergs ,{9,"Tipo 5 - CheckBox com Texto",200, 40,.T.})
     aAdd( aPergs ,{5,"001 - Alimentação"                ,.F.,90,"",.F.})
     aAdd( aPergs ,{5,"002 - Associações Diversas"        ,.F.,90,"",.F.})
     aAdd( aPergs ,{5,"003 - Companhias de Petróleo/Óleo",.F.,100,"",.F.})
      
     //Tipo 6 - Cria um botão tipo File para buscar arquivos e retorna o caminho apontado.
     aAdd( aPergs ,{9,"Tipo 6 - Busca de Arquivo via FILE",200, 40,.T.})      
     aAdd( aPergs ,{6,"Aponte o arquivo:",Space(100),"","","",70,.F.,"Todos os arquivos (*.*) |*.*"})     
      
     aAdd( aPergs ,{9,"Os textos livres retornam como parametros preenchidos no aRet[n] com seu conteúdo padrão",200, 40,.T.})
      
     /*
     //Chamada padrão 
     ParamBox( < aParametros >  , < cTitle > , < aRet > , < bOk >, < aButtons > ,< lCentered >, < nPosX >,< nPosY > , < oDlgWizard >, < cLoad > ,< lCanSave >,< lUserSave >  )
    Onde: 
    // 1 - < aParametros > - Vetor com as configurações
    // 2 - < cTitle >      - Título da janela
    // 3 - < aRet >        - Vetor passador por referencia que contém o retorno dos parâmetros
    // 4 - < bOk >         - Code block para validar o botão Ok
    // 5 - < aButtons >    - Vetor com mais botões além dos botões de Ok e Cancel
    // 6 - < lCentered >   - Centralizar a janela
    // 7 - < nPosX >       - Se não centralizar janela coordenada X para início
    // 8 - < nPosY >       - Se não centralizar janela coordenada Y para início
    // 9 - < oDlgWizard >  - Utiliza o objeto da janela ativa
    //10 - < cLoad >       - Nome do perfil se caso for carregar
    //11 - < lCanSave >    - Salvar os dados informados nos parâmetros por perfil
    //12 - < lUserSave >   - Configuração por usuário
     
    Obs: As respostas carregadas no aRet, array de retorno do parambox também assumem os parametros MV_PAR automaticamente. 
 
    Logo: aRet[1] == MV_PAR01, aRet[5] == MV_PAR05 e nessa segue nessa lógica. 
 
    */
     
    //Chamada com bloco de bOK
    If ParamBox(aPergs ,"ZPARBOX",aRet,{|| bOKaRet(aRet)},aButtons,,,,,,,)
        If ! Empty(aRet[14])     
             
            cArquivo := alltrim( aRet[14])
            MsgInfo("Arquivo apontado:" + left(alltrim(cArquivo),20),"ZPARBOX")
            Return
              
        EndIf            
    Else
        MsgAlert("Processo Cancelado pelo usuário","ZPARBOX")
        return
    EndIf
     
return
//------------------------
Static Function bOKaRet(aRet)
local w
local lRet := .T. 
 
For w := 1  To Len(aRet)
 
    If Empty(aRet[14])
        MsgInfo("Nenhum arquivo foi apontado na busca","bOKaRet")
        lRet := .F.
        Exit
    EndIf
     
Next w 
 
Return lRet
//-------------------------
user function xAtuParBox()
Local oTFont     := TFont():New("Arial",,40,,.F.,,,,.T.,.F.)
Private oPatch, cGetPatch := "https://terminaldeinformacao.com/knowledgebase/parambox/"
Private oDlg, oPanel1
   
  DEFINE FONT oBold NAME "Arial" SIZE 0, -12 BOLD
  DEFINE MSDIALOG oDlg TITLE "Teste PARBOX" STYLE DS_MODALFRAME FROM 000, 000  TO 460, 800 COLORS 0, 16777215 PIXEL
       
    oPanel1 := TPanel():New(01,01,"Rotina em Manutenção!!! TI vai arrumar!!!!",oPanel1,oTFont,.T.,,CLR_RED,/*CLR_BLUE*/,600,230,.T.,.T.)
    oPanel1 := TWebEngine():New(oPanel1, 01, 01, 600, 230, cGetPatch,  )    
     
  oDlg:lEscClose := .F.
  Activate MSDialog oDlg Centered On Init EnchoiceBar(oDlg, {||OK()}, { ||oDlg:End()},,,,,.F.,.F., .F., .T.,.F.,)
 
return
//-------------------------------------------------
Static Function OK()
    oDlg:End()
Return
