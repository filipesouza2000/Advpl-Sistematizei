#include 'protheus.ch'
#include 'parmtype.ch'

/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
---Data---|-----Autor-------|-------Descri��oo------------
18/03/2023| Filipe Souza    | Fun��o parambox com todos os tipos e bot�es  extras.

@see Terminal da Informa��o
@see https://terminaldeinformacao.com/knowledgebase/parambox/
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
*/
user function xParamBox()
local aPergs   := {}
local aRet     := {}
local aButtons := {}
local aCombo   := {"","SP","RJ","MG","ES","MA","BA"}
local cArquivo := ""
 
    // Array com bot�es extras do parambox - Bot�es Tipo 1= OK e 2= Cancelar j� vem nos bot�es padr�es
    AAdd(aButtons, {03, {|| u_xAtuParBox()   }, 'Esse � o bot�o 03 - Excluir'   }) // bot�o Excluir
    AAdd(aButtons, {04, {|| u_xAtuParBox()   }, 'Esse � o bot�o 04 - Incluir'   }) // bot�o Incluir
    AAdd(aButtons, {05, {|| u_xAtuParBox()   }, 'Esse � o bot�o 05 - Parametros'}) // bot�o Parametros
    AAdd(aButtons, {06, {|| u_xAtuParBox()   }, 'Esse � o bot�o 06 - Imprimir'  }) // bot�o Imprimir
     
     
    //S� cabem 4 bot�es extras na janela padr�o da parabox, se colocar mais, fica estourado na janela
    /*
    AAdd(aButtons, {03, {|| Alert('Bot�o 03 - Excluir'   )}, 'Esse � o bot�o 03 - Excluir'   }) // bot�o Excluir
    AAdd(aButtons, {04, {|| Alert('Bot�o 04 - Incluir'   )}, 'Esse � o bot�o 04 - Incluir'   }) // bot�o Incluir
        AAdd(aButtons, {05, {|| Alert('Bot�o 05 - Parametros')}, 'Esse � o bot�o 05 - Parametros'}) // bot�o Parametros
        AAdd(aButtons, {06, {|| Alert('Bot�o 06 - Imprimir'  )}, 'Esse � o bot�o 06 - Imprimir'  }) // bot�o Imprimir
        AAdd(aButtons, {07, {|| Alert('Bot�o 07 - Susp.Impr.'        )}, 'Esse � o bot�o 07 - Susp.Impr.'        }) // bot�o Susp.Impr.
        AAdd(aButtons, {08, {|| Alert('Bot�o 08 - Cancelar Impress�o')}, 'Esse � o bot�o 08 - Cancelar Impress�o'}) // bot�o Cancela Impress�o 
        AAdd(aButtons, {09, {|| Alert('Bot�o 09 - Ordem'             )}, 'Esse � o bot�o 09 - Ordem'             }) // bot�o Ordem
        AAdd(aButtons, {10, {|| Alert('Bot�o 10 - Prioridade'        )}, 'Esse � o bot�o 10 - Prioridade'        }) // bot�o Prioridade
        AAdd(aButtons, {11, {|| Alert('Bot�o 11 - Editar'            )}, 'Esse � o bot�o 11 - Editar'            }) // bot�o Editar
        AAdd(aButtons, {12, {|| Alert('Bot�o 12 - Ouvir'             )}, 'Esse � o bot�o 12 - Ouvir'             }) // bot�o Ouvir
        AAdd(aButtons, {13, {|| Alert('Bot�o 13 - Salvar'            )}, 'Esse � o bot�o 13 - Salvar'            }) // bot�o Salvar
        AAdd(aButtons, {14, {|| Alert('Bot�o 14 - Abrir'             )}, 'Esse � o bot�o 14 - Abrir'             }) // bot�o Abrir
        AAdd(aButtons, {15, {|| Alert('Bot�o 15 - Visualizar'        )}, 'Esse � o bot�o 15 - Visualizar'        }) // bot�o Visualizar
        AAdd(aButtons, {16, {|| Alert('Bot�o 16 - Cond.Neg.'         )}, 'Esse � o bot�o 16 - Cond.Neg.'         }) // bot�o Cond.Neg.
        AAdd(aButtons, {17, {|| Alert('Bot�o 17 - Filtrar'           )}, 'Esse � o bot�o 17 - Filtrar'           }) // bot�o Filtrar
        AAdd(aButtons, {18, {|| Alert('Bot�o 18 - Financ.'           )}, 'Esse � o bot�o 18 - Financ.'           }) // bot�o Financ.
        AAdd(aButtons, {19, {|| Alert('Bot�o 19 - Avan�ar'           )}, 'Esse � o bot�o 19 - Avan�ar'           }) // bot�o Avan�ar (em pt-br)
        AAdd(aButtons, {20, {|| Alert('Bot�o 20 - Voltar'            )}, 'Esse � o bot�o 20 - Voltar'            }) // bot�o Voltar (em pt-br)
        AAdd(aButtons, {21, {|| Alert('Bot�o 21 - Forward'           )}, 'Esse � o bot�o 21 - Forward'           }) // bot�o Forward (Avan�ar)
        AAdd(aButtons, {22, {|| Alert('Bot�o 22 - Backward'          )}, 'Esse � o bot�o 22 - Backward'          }) // bot�o Backward (Voltar)
    */
 
    //Perguntas que ser�o apresentadas
     
    //Tipo 9 - Apresenta um texto fixo, que ser� transportado para o aRet no momento da execu��o. 
    aAdd( aPergs ,{9,"Tipo 9 - Apenas texto demonstrativo.",200, 40,.T.})    
 
    //Tipo 2 - Apresenta um seletor que ser� alimentado com o array aCombo.
    aAdd( aPergs ,{9,"Abaixo escolha uma op��o",200, 40,.T.})                 
     aAdd( aPergs ,{2,"Tipo 2 - Escolha:",01,aCombo,50,"",.T.})
 
     //Tipo 1 - Cria um MSGet para digita��o livre
     aAdd( aPergs ,{9,"Tipo 1 - Digite Livre",200, 40,.T.})                    
     aAdd( aPergs ,{1,"Digite Algo: "    , Upper(Space(100))    ,"","","","",110,.T.})
      
     //Tipo 4 - Cria Op��es de CheckBox com Texto SAY antes da op��o - Pode se passar .T. ou .F. para trazer o check j� marcado/desmarcado na primeira execu��o
     aAdd( aPergs ,{9,"Tipo 4 - Say + CheckBox com Texto",200, 40,.T.})        
     aAdd( aPergs ,{4,"Cod-1"        ,.T.,"Cod-1 - Com Check Marcado"       ,90,"",.F.})
     aAdd( aPergs ,{4,"Cod2-"        ,.F.,"Cod-2 - Com Check Desmarcado"    ,90,"",.F.})
      
     //Tipo 5 - Cria Op��es de CheckBox. 
     aAdd( aPergs ,{9,"Tipo 5 - CheckBox com Texto",200, 40,.T.})
     aAdd( aPergs ,{5,"001 - Alimenta��o"                ,.F.,90,"",.F.})
     aAdd( aPergs ,{5,"002 - Associa��es Diversas"        ,.F.,90,"",.F.})
     aAdd( aPergs ,{5,"003 - Companhias de Petr�leo/�leo",.F.,100,"",.F.})
      
     //Tipo 6 - Cria um bot�o tipo File para buscar arquivos e retorna o caminho apontado.
     aAdd( aPergs ,{9,"Tipo 6 - Busca de Arquivo via FILE",200, 40,.T.})      
     aAdd( aPergs ,{6,"Aponte o arquivo:",Space(100),"","","",70,.F.,"Todos os arquivos (*.*) |*.*"})     
      
     aAdd( aPergs ,{9,"Os textos livres retornam como parametros preenchidos no aRet[n] com seu conte�do padr�o",200, 40,.T.})
      
     /*
     //Chamada padr�o 
     ParamBox( < aParametros >  , < cTitle > , < aRet > , < bOk >, < aButtons > ,< lCentered >, < nPosX >,< nPosY > , < oDlgWizard >, < cLoad > ,< lCanSave >,< lUserSave >  )
    Onde: 
    // 1 - < aParametros > - Vetor com as configura��es
    // 2 - < cTitle >      - T�tulo da janela
    // 3 - < aRet >        - Vetor passador por referencia que cont�m o retorno dos par�metros
    // 4 - < bOk >         - Code block para validar o bot�o Ok
    // 5 - < aButtons >    - Vetor com mais bot�es al�m dos bot�es de Ok e Cancel
    // 6 - < lCentered >   - Centralizar a janela
    // 7 - < nPosX >       - Se n�o centralizar janela coordenada X para in�cio
    // 8 - < nPosY >       - Se n�o centralizar janela coordenada Y para in�cio
    // 9 - < oDlgWizard >  - Utiliza o objeto da janela ativa
    //10 - < cLoad >       - Nome do perfil se caso for carregar
    //11 - < lCanSave >    - Salvar os dados informados nos par�metros por perfil
    //12 - < lUserSave >   - Configura��o por usu�rio
     
    Obs: As respostas carregadas no aRet, array de retorno do parambox tamb�m assumem os parametros MV_PAR automaticamente. 
 
    Logo: aRet[1] == MV_PAR01, aRet[5] == MV_PAR05 e nessa segue nessa l�gica. 
 
    */
     
    //Chamada com bloco de bOK
    If ParamBox(aPergs ,"ZPARBOX",aRet,{|| bOKaRet(aRet)},aButtons,,,,,,,)
        If ! Empty(aRet[14])     
             
            cArquivo := alltrim( aRet[14])
            MsgInfo("Arquivo apontado:" + left(alltrim(cArquivo),20),"ZPARBOX")
            Return
              
        EndIf            
    Else
        MsgAlert("Processo Cancelado pelo usu�rio","ZPARBOX")
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
       
    oPanel1 := TPanel():New(01,01,"Rotina em Manuten��o!!! TI vai arrumar!!!!",oPanel1,oTFont,.T.,,CLR_RED,/*CLR_BLUE*/,600,230,.T.,.T.)
    oPanel1 := TWebEngine():New(oPanel1, 01, 01, 600, 230, cGetPatch,  )    
     
  oDlg:lEscClose := .F.
  Activate MSDialog oDlg Centered On Init EnchoiceBar(oDlg, {||OK()}, { ||oDlg:End()},,,,,.F.,.F., .F., .T.,.F.,)
 
return
//-------------------------------------------------
Static Function OK()
    oDlg:End()
Return
