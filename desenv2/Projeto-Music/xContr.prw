#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOTVS.CH'
#INCLUDE "FwMVCDef.ch"

/*++++DATA++++|++++AUTOR+++++|++++++++++++++++DESCRI��O+++++++++++++
  21/07/2023  | Filipe Souza |  An�lise cen�rio contrato de grava��o
                                O layout inicial da agenda passa ser de contrato.
                                O layout da agenda atual � modelo 1, ao selecionar servi�o de grava��o
                                habilita ou exibe campos para buscar cd e m�sica para a grava��o.
  05/08/2023  | Filipe Souza |Gatilho via codigo para campo ZD1_SERV quando muda, para 1, apaga campos ZD1_INSTR ,ZD1_NINSTR , ZD1_CODA , ZD1_ART j� preenchidos
                              Gerar Browse de registro para tabela ZD4-ARTISTA, com rela��o com SA1-Cliente
                                    N�o foi poss�vel pelo protheus n�o ter relacionamentos integrados, formei somente ZD4
                              Na View retirar da oStrArt o campo ZD4_CLI
                              GetSxEnum no ZD4_COD
                              Criar tabela gen�rica para G�nero Musical, consulta padr�o para campo ZD4_GENERO	
                              testados registros com integridade de dados
  11/08/2023  | Filipe Souza |gerar prot�tipo do layout- xContr modelo1 ZD5
	                          criar gatilho no campo cod cliente, para filtrar somente os que existem em ZD4
  28/08/2023  | Filipe Souza |gerar campo ZD5_DATA para iniciar com data do sistema.
                            atualizar para modelo 2 e 3	
                            Gatilho B1_TIPO, campo B1_COD recebe U_xCodProd()
                            Gerar auto preenchimento de ZD5_QCD,ZD5_FAIXAS e ZD5_TEMPO relativo a totalizadores. 
                            U_xTotCd()  no campo B1_TIPO   ,valida��o do usu�rio, para chamar fun��o ao editar. Preenche ZD5_QCD
                            U_xTotMus() no campo ZD3_MUSICA,valida��o do usu�rio, para chamar fun��o ao editar. Preenche ZD5_FAIXAS
                            U_xTotDur() no campo ZD3_DURAC, valida��o do usu�rio, para chamar fun��o ao editar. Preenche ZD5_TEMPO
  12/09/2023  | Filipe Souza |Alterar tabelaSB1 como Compartilhada de filial em SX2
                            atualizar pesquisa padr�o ZD5 do campo cod artista para retornar ZD4_CLI==M->ZD5_CLI
                            gatilho para zerar campos de artista ao alterar o campo cod cliente.
                            criar campo ZD3_XCONT  para o relacionamento com m�sica.
                            atualizar relacionamento Musica com Contrato adicionando campo ZD3_XCONT
                            validar digitos do tempo , xTotDur().   
                            somar tempo formatado e atribuir ao totalizador e campo, IncTime('10:50:40',20,15,25 ) 
  13/09/2023  | Filipe Souza |otimizar soma do tempo na lista de musicas, ao alterar � atualizada.
                            ponto de entrada FORMLINEPRE em "ZD3Detail", pegar valor da linha ativa, para decrementar ao editar
                            ao invalidar valor, faz c�lculo mesmo assim, precisa impedir o c�lculo.
                            ao editar e confirmar com o mesmo n�mero, � decrementado o anterior e somado o novo no Totalizador padr�o.	
  14/09/2023  | Filipe Souza |ao editar e confirmar com o mesmo n�mero, deve decrementar para ser somado no Totalizador padr�o
                              ao deletar linha na grid deve decrementar. Depois s� precisa mudar de linha na grid que atualiza a view.
  16/09/2023  | Filipe Souza | 2� cd n�o incrementa 1� m�sica.Corrigido.
                                Recuperar linha na grid para incrementar, nao sincroniza totalizadores, s� o XX_TotDur ---fazer Refresh()				
                                Deletar musica, sincronizar ZD5_TEMPO---fazer Refresh(), decrementar musica ZD5_FAIXAS
                                Ao clicar para baixo e inserir linha e voltar para cima, s� incrementa total mas n�o decrementa automaticamente.
                                estava sendo chamado U_xTotMus(2) nos 2 eventos de 'Deletar' e 'seta apra cima' que tamb�m deleta,
  20/09/2023  | Filipe Souza | Adicionei na condi��o do ponto de entrada para verificar se campos est�o vazios, assim n�o foi confirmada linha. Solucionada quest�o acima.
                                Criar a mesma condi��o de eventos Deletar para a grid CD.   xTotCd()
  21/09/2023  | Filipe Souza | Otimizar fun��o xTotMus() para ser fun��o gen�rica com par�metros a ser reutilzada para outros totais, 
			                    xTotQtd(cModM,nOpt,nModulo) em xContr e xContrM                                
  27/09/2023  | Filipe Souza | Resolvendo o problema do evento Delete da linha de m�sicas,que totalizada duas vezes,
                                na fun��o xDelL() chama  U_xTotQtd("ZD5Master",2,2,.T.)
                                parametro .T. para informar que foi do evento da tecla Delete, IIF( lDell, , nTot++ ),
                                se for pelo ponto de entrada, identificando seta para cima ou baixo, chama U_xTotQtd("ZD5Master",2,nModel)
                                para incrementar e decrementar totalizador.         
  02/102023   | Filipe Souza | Testar eventos na grid CD,INSERT UPDATE OK
                               Ao deletar CD verificar se tem m�sica relaciona para invalidar com Help().                                                      
                               DELETE em an�lise, ao chamar xDelL() oView:ACURRENTSELECT[1]    "VIEW_SB1", 
				               erro- ao recuperar registro deletado,oView:ACURRENTSELECT[1] � "VIEW_ZD3"
  03/10/2023  | Filipe souza | xLinePre- Fun��o validadora da grid CD, 
                                para bloquear dele��o de linha quando existe m�sica com dados e n�o deletada na outra grid relacionada ao CD.
  09/10/2023  | Filipe Souza | Comentado oView:Refresh() para n�o dudar de foco o modelo em uso.
  17/10/2023  | Filipe Souza | Comentado oView:Refresh() das Grids para n�o dudar de foco o modelo em uso.
  12/12/2023  | Filipe Souza | Otimizado FWFormStruct a exibir s� os campos necess�rios de produto.
                               O totalizador de dura��o ter limite de 74min por CD
  14/12/2023  | Filipe Souza | Otimizado relacionamento  ZD3-Musica com SB1-CD 
  15/12/2023  | Filipe Souza | Melhorias para atender o fluxo dos eventos, Cadastrar, Alterar
                               Reiniciar lPre:=.T. nos eventos OK e CANCEL no View
                                para que ao FORMPRE as condi��es estejam refeitas.
                               Otimizado fluxo no evento de Decremetnar e Incremetnar tempo, 
                                para favorecer condi��es, cTemp:=cTempo e xEdit   :=.F.,
                                No compara do totalizador com o limite,cTempo retornar ao total anterior
                                Tempo correto e incrementado, seta o tempo atual cTemp:=cTempo
                                Melhoria na exibi�ao do tempo que foi digitado.

                            
    Planejamento @see https://docs.google.com/document/d/1V0EWr04f5LLvjhhBhYQbz8MrneLWxDtVqTkCJIA9kTA/edit?usp=drive_link
    UML          @see https://drive.google.com/file/d/1wFO2CKqSrvzxg5RZDYTfGayHrAUcCcfL/view?usp=drive_link 
    Scrum-kanban @see https://trello.com/w/protheusadvplmusicbusiness       
    GitHug       @see https://github.com/filipesouza2000/Advpl-Sistematizei/tree/main/desenv2/Projeto-Music                                  
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
Static cTitulo  := "Contrato de Servi�o-Grava��o"
Static cCont     := "ZD5"
//Static cCli     := "SA1"
Static cCD      := "SB1"
Static cMusica  := "ZD3"

User Function xContr()
    Local aArea     := GetArea()
    Local oBrowse   
    Private aRotina :={}
    Private cRegCd  :=''
    Private cTempo  := '00:00:00'
    Private nOldT   :=0
    Private lPre    :=.T.
    Private xEdit   :=.F.      
    Private cTemp:=''
    Private lRefresh:=.T.

    aRotina := MenuDef()
    oBrowse:= FwMBrowse():New()
    oBrowse:SetAlias(cCont)
    oBrowse:SetDescription(cTitulo)
    oBrowse:DisableDetails()
    //recebe filtro da lista de artistas a serem listados no bowse
    //oBrowse:SetFilterDefault(cCli+"->A1_COD $"+"'"+cArtist+"'")
    oBrowse:AddLegend("ZD5->ZD5_STATUS=='1'","BR_CINZA","N�o iniciado")
    oBrowse:AddLegend("ZD5->ZD5_STATUS=='2'","BR_VERDE","Em Andamentp")
    oBrowse:AddLegend("ZD5->ZD5_STATUS=='3'","BR_VERMELHO","Finalizado")
    oBrowse:ACTIVATE()
    RestArea(aArea)
return NIL

Static Function MenuDef()
    //Local aRotina   := FwMvcmenu("xContr")
    Local aRotina:={}

    ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.xContr" OPERATION 2 ACCESS 0
    ADD Option aRotina TITLE "Incluir"    ACTION "VIEWDEF.xContr" OPERATION 3 ACCESS 0
    ADD Option aRotina TITLE "Alterar"    ACTION "VIEWDEF.xContr" OPERATION 4 ACCESS 0
    ADD Option aRotina TITLE "Excluir"    ACTION "VIEWDEF.xContr" OPERATION 5 ACCESS 0
    ADD Option aRotina TITLE "Legenda"    ACTION "u_xLeg"         OPERATION 6 ACCESS 0
    
return aRotina


Static Function ModelDef()
    Local oStruCon      :=FWFormStruct(1,cCont)   //remover campo , pois j� exibir� na strutura Pai
    Local oStruCD       :=FWFormStruct(1,cCD, {|x| AllTrim(x) $ 'B1_COD;B1_DESC;B1_TIPO;B1_UM;B1_LOCPAD;B1_GRUPO;B1_FAIXAS;B1_BITMAP;B1_XSTUD;B1_XART;B1_ATIVO'})
    Local oStruMu       :=FWFormStruct(1,cMusica)
    Local aRelCD        :={}
    Local aRelMusic     :={}    
    Local oModel
    Local bPre          :=NIL
    Local bPos          :=NIL
    Local bCommit       :=NIL
    Local bCancel       :={|| FWFORMCANCEL(SELF)}
    Local bPreGrid      :={|oModel,nLine,cAction| xLinePre(oModel,nLine,cAction)}
    oModel:=MPFormModel():New("xContrM",bPre,bPos,bCommit,bCancel)
    oModel:addFields("ZD5Master",/*cOwner*/,oStruCon)
    oModel:AddGrid("SB1Detail","ZD5Master",oStruCD,/*bLinePre*/,/*bLinePos*/,bPreGrid,/*bLoad-Carga do modelo manual*/,)
    oModel:AddGrid("ZD3Detail","SB1Detail",oStruMu,/*bLinePre*/,/*bLinePos*/,/*bPre-Grid Full*/,/*bLoad-Carga do modelo manual*/,)
    oModel:SetPrimaryKey({"ZD5_FILIAL","ZD5_COD"})//,"A1_CGC"
    
    //CD- relacionamento B1-CD com ZD5-Contrato 
    //propriedade do cod do artista � obrigat�rio na tabela, mas seta como n�o obrigat�rio para n�o exibir
    oStruCD:SetProperty("B1_XART", MODEL_FIELD_OBRIGAT, .F.)
                  
    aAdd(aRelCD, {"B1_FILIAL","FWxFilial('SB1')"})
    aAdd(aRelCD, {"B1_XCONTR","ZD5_COD"})
    oModel:SetRelation("SB1Detail", aRelCD, SB1->(IndexKey(1)))
    
    //Musica- relacionamento ZD3-Musica com ZD5-Contrato
    aAdd(aRelMusic,{"ZD3_FILIAL","FWxFilial('ZD5')"})    
    AAdd(aRelMusic,{"ZD3_XCONT","ZD5_COD"})
    oModel:SetRelation("ZD3Detail", aRelMusic,ZD3->(IndexKey(3)))

    //Musica- relacionamento ZD3-Musica com SB1-CD
    aAdd(aRelMusic,{"ZD3_FILIAL","FWxFilial('ZD3')"})    
    AAdd(aRelMusic,{"ZD3_CODCD","B1_COD"})
    oModel:SetRelation("ZD3Detail", aRelMusic,ZD3->(IndexKey(2)))

    oModel:GetModel("SB1Detail"):SetUniqueLine({"B1_DESC"})
    oModel:GetModel("ZD3Detail"):SetUniqueLine({"ZD3_MUSICA"})
    //totalizador-  titulo,     relacionamento, campo a calcular,virtual,opera��o,,,display    
    oModel:AddCalc('TotaisCd','ZD5Master','SB1Detail','B1_COD'    ,'XX_TOTCD' ,'COUNT',,,'Total CDs')
    oModel:AddCalc('TotaisM','ZD5Master','ZD3Detail','ZD3_MUSICA','XX_TOTM'  ,'COUNT',,,'Total Musicas')
    oModel:AddCalc('TotaisM','ZD5Master','ZD3Detail','ZD3_DURAC' ,'XX_TOTDUR','SUM',,,'Total Dura��o')
    
return oModel

Static Function ViewDef()
    Local oModel    :=FwLoadModel("xContr")
    Local oStruCon  :=FWFormStruct(2,cCont)
    Local oStruCD   :=FWFormStruct(2,cCD, {|x| AllTrim(x) $ 'B1_COD;B1_DESC;B1_TIPO;B1_UM;B1_LOCPAD;B1_GRUPO;B1_FAIXAS;B1_BITMAP;B1_XSTUD;B1_XART;B1_ATIVO'})
    Local oStruMu   :=FWFormStruct(2,cMusica)
    Local oStruTotCd:=FWCalcStruct(oModel:GetModel('TotaisCd'))
    Local oStruTotM :=FWCalcStruct(oModel:GetModel('TotaisM'))
    Local oView
    
    oView:= FwFormView():New()
    oView:SetModel(oModel)
    
    oView:addField("VIEW_ZD5",oStruCon  ,"ZD5Master")
    oView:addGrid("VIEW_SB1",oStruCD,"SB1Detail")
    oView:addGrid("VIEW_ZD3",oStruMu ,"ZD3Detail")
    oView:addField("VIEW_TOTCD",oStruTotCd,"TotaisCd")
    oView:addField("VIEW_TOTM",oStruTotM,"TotaisM")

    oView:CreateHorizontalBox("CONT_BOX",50)
    
    oView:CreateHorizontalBox("MEIO_BOX",40)
    oView:CreateVerticalBox("MEIOLEFT",70,"MEIO_BOX")// Vertical BOX
    oView:CreateVerticalBox("MEIORIGHT",30,"MEIO_BOX")// Vertical BOX    
    
    oView:CreateHorizontalBox("BARTOT",10)   
    oView:CreateVerticalBox("TOTLEFT",70,"BARTOT")// Vertical BOX
    oView:CreateVerticalBox("TOTRIGHT",30,"BARTOT")// Vertical BOX
    
    oView:SetOwnerView("VIEW_SB1","MEIOLEFT")
    oView:SetOwnerView("VIEW_ZD3","MEIORIGHT")
    oView:SetOwnerView("VIEW_TOTCD","TOTLEFT")
    oView:SetOwnerView("VIEW_TOTM","TOTRIGHT")

    oView:EnableTitleView("VIEW_SB1", "CDs")
    oView:EnableTitleView("VIEW_ZD3", "M�sicas")

    oView:SetOwnerView("VIEW_ZD5","CONT_BOX")
    oView:EnableTitleView("VIEW_ZD5", "Contrato")
    

    //oStruCD:RemoveField("B1_NOME")
    oStruMu:RemoveField("ZD3_CODCD")
    oStruMu:RemoveField("ZD3_COD")
    oStruMu:RemoveField("ZD3_XCONT")
    oStruCD:RemoveField("B1_XART")
   
    //refresh para tentar atualziar Totalizadores
    /*    oView:AddUserButton('Refresh','MAGIC.BMP',{|| oView:Refresh()},,,,.T.)
        oView:SetViewAction('REFRESH',      {|| oView:Refresh()})
        oView:SetViewAction('DELETELINE',   {|| oView:Refresh()})
        oView:SetViewAction('UNDELETELINE', {|| oView:Refresh()})
    */
    //para zerar o tempo ao sair da view
    oView:SetViewAction('BUTTONOK',    {|| cTempo  := '00:00:00', lPre:=.T.})
    oView:SetViewAction('BUTTONCANCEL',{|| cTempo  := '00:00:00', lPre:=.T.})
    //para decrementar o tempo ao deletar a linha
    oView:SetViewAction('DELETELINE',   {|| U_xDelL()})
    //para incrementar o tempo ao desdeletar a linha
    oView:SetViewAction('UNDELETELINE', {|| U_xDelL()})

    //oView:AddIncrementField("SB1Detail","B1_COD")// gatilho xCodProd()
    oView:AddIncrementField("ZD3Detail","ZD3_COD")
    oView:AddIncrementField("ZD3Detail","ZD3_ITEM")
    oView:SetCloseOnOk({||.T.})
return oView

//enviar total de CD para o campo ZD5_QCD na view
User Function xTotCd()
    Local oModel
    Local oModelTot := FwModelActive()
    Local oModelCd       

    If oModelTot:Adependency[1][1] == "ZD5Master"
        oModelCd  := oModelTot:GetModel("TotaisCd")        
        nCd       := oModelCd:GetValue("XX_TOTCD")        
        oModel:= oModelTot:GetModel("ZD5Master")
        oModel:SetValue("ZD5_QCD",nCd)         
    EndIf
    
return .T.

//chamdo no validador do usuario no campo B1_TIPO, ZD3_MUSICA      U_xTotQtd('ZD5Master',0,2)
//enviar total de CD, Musica para o campo do Form na view
//no 2� CD n�o incrementa a 1� m�sica, chamar U_xTotQtd() para incrementar.
//Deletar ou recuperando m�sica deletada.
User Function xTotQtd(cModM,nOpt,nModulo,lDell)//xTotMus(nOpt)
    DEFAULT cModM   :=''
    DEFAULT nOpt    :=0
    DEFAULT nModulo :=0
    DEFAULT lDell   :=.F.   //para tratar do evento DELETE, diferenciar ao de seta para cima
    Local oModel
    Local oModelTot := FwModelActive()
    Local oModelG 
    Local nTot      :=0 
    Local aTot      :={}   

    If nModulo==1//'SB1Detail'             
            aAdd(aTot,'TotaisCd')//modulo
            aAdd(aTot,'XX_TOTCD')//totalizador qtd
            aAdd(aTot,'ZD5_QCD') //campo do form
    elseif nModulo==2//'ZD3Detail'            
            aAdd(aTot,'TotaisM')            
            aAdd(aTot,'XX_TOTM')
            aAdd(aTot,'ZD5_FAIXAS')
    EndIf

    If oModelTot:Adependency[1][1] == cModM
        oModelG  := oModelTot:GetModel(aTot[1])//TotaisM
        nTot     := oModelG:GetValue(aTot[2])//XX_TOTM
        //no 2� CD n�o incrementa a 1� m�sica, chamar XX_TOTM para incrementar. Ou recuperando m�sica deletada.
        If nOpt==1 
            IIF( lDell, , nTot++ )
            oModelG:SetValue(aTot[2],nTot)  //"XX_TOTM",nMus          
        elseIf nOpt==2 // DELETE, seta para cima, decrementar m�sica 
                IIF( lDell, , nTot-- )//se DELETE n�o decremetna pois totalizador ao ser chamado ln 237 o executa, sen�o � seta para cima � preciso decremetnar. 
                oModelG:SetValue(aTot[2],nTot)         
        EndIf
        oModel:= oModelTot:GetModel(cModM)//ZD5Master
        oModel:SetValue(aTot[3],nTot)    //"ZD5_FAIXAS",nMus
    EndIf
    cModM   :=''
    nOpt    :=0   
    nModulo :=0
return .T.


/* enviar total de Dura��o para o campo ZD5_TEMPO na view
    -participa do evento editar Dura��o, para decrementar valor antigo e incrementar valor novo.
    -participa do evento DeleteLine e UndeleteLine,para decrementar valor ou incrementar valor. 
    atribuindo valores para o Totalizador e campos na view, sincronizando-os.
*/
User Function xTotDur(nOld)
    DEFAULT nOld :=0
    Local oModel,oModelB1,oModelM
    Local oModelTot := FwModelActive()
    //Local oModelDur 
    //Local nDur
    Local xRet := .T. //se nOld>0 � que ser� digitado outro valor, sen�o, � o 1� d�gito e traz este   
    Local cDur := IIF( nOld>0,alltrim(str(nOld)) ,alltrim(str(M->ZD3_DURAC))  )
    Local cS   := ''
    Local cM   := ''    
    Local cH   := ''
    Local cTemp2:=''
    Local nNewT   
    
    // se ZD3_DURAC==Nil n�o digitou valor ainda e pega nOld do par�metro para decrementar
    //      ou est� sendo deletada linha e passou nOld para decrementar
    // sen�o, foi digitado novo valor para incrementar. 
    if U_xValTime(IIF(M->ZD3_DURAC==Nil,nOld,M->ZD3_DURAC) )    
        //atribuir Seg Min Hora
        if Len(cDur)==2
            cS := right( cDur ,2)
            elseIf Len(cDur)==3 
                cS := right( cDur ,2)
                cM := Left(cDur, 1)  // 1 30
                elseif Len(cDur)==4
                    cS := right( cDur ,2)
                    cM :=  Left(cDur, 2)  //11 30
                    elseif Len(cDur)==5
                        cS := right( cDur ,2)                
                        cM := SubStr(cDur,2,2)//1 11 30
                        cH := Left(cDur,1)
                        elseif Len(cDur)==6
                            cS := right( cDur ,2)                
                            cM := SubStr(cDur,3,2) //10 11 30            
                            cH := Left(cDur,2)                      
        EndIf 
        

        oModelDur := oModelTot:GetModel("TotaisM")
        oModel:= oModelTot:GetModel("ZD5Master")
            //somahoras(28.55,5.10)          
            //IncTime('10:50:40',20,15,25 ) 
            //DecTime('10:50:40',20,15,25 )  
        If nOld>0 //se houver tempo anterior e diferente, decrementa no totalizador
            //recebe valor atual para depois ser retornado.
            cTemp:=cTempo
            xEdit   :=.F.
            cTempo  :=DecTime(cTempo,val(cH),+val(cM),+val(cS))
            nNewT   := strtran(cTempo,':','')    
            nOldT   :=0 
        else
            cTempo  :=IncTime(cTempo,val(cH),+val(cM),+val(cS))
            nNewT      := strtran(cTempo,':','') 
            //O totalizador de dura��o tem limite de 74min por CD
            //compara o totalizador com o limite
            If val(nNewT) > 11400 //"000352"
                //usa o total anterior para decrement�-lo do limite, para informar o tempo que falta at� o limite
                cTemp2:=strtran(cTemp,':','')// '001122'
                cS := right( cTemp2 ,2)
                cM := SubStr(cTemp2,3,2)
                cH := Left(cTemp2,2)
                cTemp2 := DecTime("01:14:00",val(cH),+val(cM),+val(cS))

                cDur:=IIF(len(cdur)==5, ;
                    left(cdur,1)+':'+substr(cdur,2,2)+':'+right(cdur,2),;// 5 digitos
                    left(cdur,2)+':'+substr(cdur,3,2)+':'+right(cdur,2))//6 digitos

                Help(NIL, NIL, "Valida��o!", NIL, ;
                "N�o � poss�vel inserir a dura��o:"+cDur+Chr(10)+Chr(13)+;
                'O limite para o CD � de 74min(01:14:00)'+Chr(10)+Chr(13)+;
                'Total dura��o gerada: '+cTempo, 1, 0, NIL, NIL, NIL, NIL, NIL, ;
                {"Digite n�meros para preencher at� o limite, tempo que falta: "+cTemp2})                   
                //cTempo retornar ao total anterior
                cTempo:=cTemp
                Return .F. 
            else
                 cTemp:=cTempo   
            EndIf  
            oModelDur:SetValue("XX_TOTDUR",val(nNewT))            
            oModel:SetValue("ZD5_TEMPO",Val( nNewT))                          
        EndIf    

    else
    xRet := .F.    
    EndIf      
    
    
    oModelB1:=oModel:GetModel("SB1Detail")
    oModelB1:=oModelB1:GetModel("SB1Detail")
    oModelM:=oModel:GetModel("ZD3Detail")
    oModelM:=oModelM:GetModel("ZD3Detail")
    //no 2� CD n�o incrementa a 1� m�sica, chamar U_aTot() para incrementar.
    If oModelB1:Length() >=2 .and. oModelM:Length()==1
        U_xTotQtd("ZD5Master",1,2)//cModM,nOpt,nModulo    
    EndIf
    
    
return xRet

//validar se n�mero est� dentro do escopo de hor�rio, 23:59:59
User Function xValTime(nDur)
    Local xRet := .T.    
    Local cDur := alltrim(str(nDur))
    Local cS   := ''
    Local cM   := ''    
    Local cH   := ''
    
    //atribuir Min Hora
    if Len(cDur)==2 //11
        cS := right( cDur ,2)
        elseIf Len(cDur)==3 
            cS := right( cDur ,2)
            cM := Left(cDur, 1)  // 1 30
            elseif Len(cDur)==4
                cS := right( cDur ,2)
                cM :=  Left(cDur, 2)  //11 30
                elseif Len(cDur)==5
                    cS := right( cDur ,2)                
                    cM := SubStr(cDur,2,2)//1 11 30
                    cH := Left(cDur,1)
                    elseif Len(cDur)==6
                        cS := right( cDur ,2)                
                        cM := SubStr(cDur,3,2) //10 11 30            
                        cH := Left(cDur,2)
    EndIf
                                                 
    If  cS=='' .OR. val(cS)>59 //validar segundos       
        xRet  :=.F.
        elseif val(cM)>59 //validar minutos
            xRet  :=.F.
            elseIf val(cH)>23 //validar hora
                xRet  :=.F.            
    EndIf
return xRet

/*Fun��o executa no evento view-Delete, para controlar totalizador de dura��o
         e sincronizar totalizadores com formulario*/
User Function xDelL()
    Local oModel    := FwModelActive()      //pegar modelo ativo
    Local oModelM//,oModelZD3       //pegar submodelo, a grid cd ou musica 
    Local oView     :=FwViewActive()
    Local nGrid     :=0    // 1 = SB1Detail   2=ZD3Detail
    //Local aSaveLines:= {}
            //verifica se est� posicionado na grid CD
    IF  oView:ACURRENTSELECT[1]=="VIEW_SB1" .or. oView:ACURRENTSELECT[1]=="SB1Detail"
        nGrid:=1
        oModelM:=oModel:GetModel("SB1Detail")
            //verifica se est� posicionado na grid Musica
    elseif  oView:ACURRENTSELECT[1]=="VIEW_ZD3" .or. oView:ACURRENTSELECT[1]=="ZD3Detail"
        nGrid:=2
        oModelM:=oModel:GetModel("ZD3Detail")
    EndIf    
    //aSaveLines := FWSaveRows()
    //se linha j� est� deletada, recupera e adiciona valor no totalizador
    //exec fun��o xTotDur() com valor do campo da linha posicionada na grid
    If oModelM:IsDeleted()//deletando
        // no par�metro � para decrementar
        IF nGrid==2  //executa se for grid m�sica                      
            U_xTotDur(oModelM:GetValue('ZD3_DURAC'))                        
        EndIf
            //xTotQtd(modulo master,2=decrementar qtd,1=cd 2=musica,)
            U_xTotQtd("ZD5Master",2,nGrid,.T.)   //decrementar cd ou m�sica     
    else //recuperando
        //sen�o deletar�, decrementa valor no totalizador
        IF nGrid==2
            M->ZD3_DURAC:=oModelM:GetValue('ZD3_DURAC')//atribui na vari�vel de mem�ria para incrementar
            U_xTotDur()     
        EndIf            
        //xTotQtd(modulo master,1=incrementar qtd,1=cd 2=musica,)
            U_xTotQtd("ZD5Master",1,nGrid,.T.)  
    EndIf      
    //oView:Refresh()
    //IIF( nGrid==1, oView:Refresh('VIEW_SB1'), oView:Refresh('VIEW_ZD3') )
    //FWRestRows(aSaveLines)
return Nil

/*
Fun��o validadora da grid CD, 
para bloquear dele��o de linha quando existe m�sica com dados e n�o deletada na outra grid relacionada ao CD.
*/
Static Function xLinePre(oModel,nLine,cAction)
    Local oModelM    
    Local lRet    :=.T.
    Local nL 

    oModel:GoLine(nLine)//linha do CD com foco
    If cAction=='DELETE' .and. !oModel:IsDeleted()//verifica se est� no comando Delete e a  linha n�o est� deletada        
        //Inicia com modelo B1, mas chama o modelo ativo, do Ponto de entrada
        oModelM:=oModel:GetModel("ZD3Detail")//CID:xContrM
        oModelM:=oModel:GetModel("ZD3Detail"):AALLSUBMODELS[3]//recebe modelo grid M�sica
        
        //navega na grid de musica
        for nL :=1  to oModelM:length()
            oModelM:GoLine(nL)
            if !oModelM:IsDeleted()
                If (!Empty(AllTrim(FWFldGet("ZD3_MUSICA"))) .and. FWFldGet("ZD3_DURAC")>0)                        
                        lRet :=.F.                 
                EndIf               
            EndIf
        next
        If !lRet
            Help(NIL, NIL, "N�o � poss�vel excluir", NIL, "Cont�m registro de m�sica relacionado a este CD.", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Delete os registros de m�sica deste CD."})                            
        EndIf                
    EndIf
return lRet

/*
Fun��o para determinar Legenda
    ZD5_STATUS    Status do servi�o
    1=N�o iniciado
    2=Em andamento
    3=Finalizado
*/
User Function xLeg()
    Local aLeg      :={}

    aadd(aLeg,{"BR_CINZA"   ,"OFF-N�o Iniciado"})
    aadd(aLeg,{"BR_VERDE"   ,"ON-Em Andamento"})
    aadd(aLeg,{"BR_VERMELHO","OK-Finalizado"})    

    BrwLegenda("Status do Contrato da Grava��o","N�o Iniciado/Em Andamento/Finalizado",aLeg)

return aLeg
