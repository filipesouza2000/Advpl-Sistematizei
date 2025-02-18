#INCLUDE 'Protheus.ch'
#INCLUDE "TOTVS.CH"
/*++++DATA++++|++++AUTOR+++++|++++++++++++++++DESCRI��O+++++++++++++
  13/09/2023  | Filipe Souza | PE, valida��o na grid "ZD3Detail" para vverificar se j� havia valor
  19/09/2023  | Filipe Souza | Evento aparam[5]=="DELETE" seta para cima que remove linha vazia,
                                totalizador incrementa e � preciso decrementar total de m�sicas.
  20/09/2023  | Filipe Souza | otimiza��o do ponto de entrada, estava sendo chamado U_xTotMus(2) nos 2 eventos
                                de 'Deletar' e 'seta apra cima' que tamb�m deleta. 
                                adicionei condi��o para verificar se campos est�o vazios, assim n�o foi confirmada linha.
   09/10/2023  | Filipe Souza | Alterar ZD3_DURAC da erro, foi corrigido, ap�s decrementar tempo deve zerar o nOldT, que � utilizado no PE
                                boleano para informar que editou valor    
                                No PE adicionar varipavel boleana para informar que est� sendo editado
				                Local xEdit :=.F. 
  10/10/2023  | Filipe Souza | Ao deletar cd e m�sicas, navegando na grid CD em outro foco, exibe:
                                Help: VLDDATA_FWGRIDNOLINES                                
                                Solu��o: modelo com atributo padr�o lDelAllLine:=.F.
                                mudar para oModelG:lDelAllLine:=.T. ao instanciar. 
  13/12/2023  | Filipe Souza | EDITAR: o totalizador do c�lculo n�o recupera o valor, 
			                    � preciso ao EDITAR passar valor do ZD5_TEMPO para vari�vel cTempo. 
  15/12/2023  | Filipe Souza |  Ao entrar no evento ALTERA, PE FORMPRE , boleano lPre para informar que iniciou o formulario
                                para setar em cTempo e XX_TOTDUR o valor do campo ZD5_TEMPO
                                
                                Alterada vari�vel xEdit para Private, a ser utilizada no xContr no evento Descrementar tempo
                                
                                dentro de condicional habilita refresh,muda vari�vel criada no xContr 
                                Private lRefresh .T.     para .F.  para n�o executar novamente, sen�o gera loop infinito.
                                busca view ativa e efetua refresh,
                                para atualizar totalizador de tempo que havia recebido o valor anteriormente no mesmo PE.
  15/12/2023  | Filipe Souza |  Alterada a l�gica acima para !INCLUI, pois para outros eventos sincroniza o Totalizador 
                                XX_TOTDUR o valor do campo ZD5_TEMPO
  09/04/2024  | Filipe Souza |  Otimizar totalizador de instrumentos, igual de m�sicas, mas separar total por musica relacionada, n�o o geral.                                                              
                                Evento de atualizar totalizador excluindo e recuperando pela seta.
                                Ao alterar o primeiro instrumento, incrementa qtd para mais 1
  18/02/2025  | Filipe Souza |  No ponto de entrada, add condi��o para n�o incrementar Total de instrumentos,pulando os ifs.
                                Sequencia de IF alterada, esse acima adicionado volta uma posi��o.
                                Atualizadas as condi��es, aparam[6] ==("ZD7_CHAVE") .OR. aparam[6] ==("ZD7_DESC") .AND.
                                
@see https://tdn.totvs.com/display/public/framework/Pontos+de+Entrada+para+fontes+Advpl+desenvolvidos+utilizando+o+conceito+MVC
@see https://tdn.totvs.com/display/public/PROT/DT+PE+MNTA080+Ponto+de+entrada+padrao+MVC
*/  

User Function xContrM()
/* PARAMIXB FORMLINEPRE
    1     O        Objeto do formul�rio ou do modelo, conforme o caso
    2     C        ID do local de execu��o do ponto de entrada
    3     C        ID do formul�rio
    4     N        N�mero da Linha da FWFORMGRID
    5     C        A��o da FWFORMGRID
    6     C        Id do campo
*/
    Local aparam    := PARAMIXB
    Local xRet      :=.T.
    //Local oObject   := aparam[1] //objeto do formul�rio ou do modelo
    Local cIdPonto  := aparam[2] // id do local de execu��o do ponto de entrada
    Local cIdModel  := aparam[3] //id do formulario
    Local oModel, oModelGM, oModelG,oView//,oViewM
    Local nModel    :=0
    Local aCampos   :={}    
    
    IF FwModelActive()<>NIL
        oModel  :=FwModelActive()
        nOp     :=oModel:GetOperation()
    Endif
    //(nOp==1 .or. ALTERA) .and. */
    if !INCLUI .and. cIdPonto=='FORMPRE' .and. cIdModel=='ZD5Master' .and. lPre  
        oModel  :=FwModelActive()  
        oModelG :=oModel:GetModel("ZD5Master")
        cTempo  :=Transform( oModelG:GetValue("ZD5_TEMPO") ,"@R 99:99:99")
        oModel:GetModel("TotaisM"):Setvalue('XX_TOTDUR',oModelG:GetValue("ZD5_TEMPO"))  
        oModelGM:=oModel:GetModel("ZD3Detail")
        oModelGM:GoLine(1)
        oView:=FwViewActive()
        oView:GetViewObject('VIEW_ZD3')
        
            If  lRefresh            
                lRefresh:=.F.               
            //    oView:=FwViewActive()
            //    oView:Refresh() 
            EndIf        
        lPre :=.F.
        oView:Refresh()
    EndIf
    
    If aparam[2] <> Nil
        //nOpt, cTotalM, cXX_TOT
        //verifica qual m�dulo foi chamado, qual Grid        
        If cIdModel=='SB1Detail'
            nModel:=1
            aAdd(aCampos,'B1_COD')
            aAdd(aCampos,'B1_DESC')
        elseif cIdModel=='ZD3Detail'
            nModel:=2            
            aAdd(aCampos,'ZD3_MUSICA')            
            aAdd(aCampos,'ZD3_DURAC')
        elseif cIdModel=='ZD7Detail'
            nModel:=3            
            aAdd(aCampos,'ZD7_CHAVE')            
            aAdd(aCampos,'ZD7_DESC')    
        EndIf
        
        If (nModel<=3) .and. cIdPonto == "FORMLINEPRE"
            oModel  :=FwModelActive()
            oModelG :=oModel:GetModel(cIdModel)
            oModelG:lDelAllLine:=.T.   //habilita deletar todas linhas da Grid
            
            //evento de seta para cima                          campos vazios
            If  Len(aparam) >4 .and. aparam[5]=="DELETE" .and. Empty(AllTrim(oModelG:GetValue(aCampos[1]))) .and. Empty(AllTrim(oModelG:GetValue(aCampos[2])))
                //xTotQtd(modulo master,2=decrementar qtd,1=cd 2=musica,3=instrumentos)
                U_xTotQtd("ZD5Master",2,nModel)                
            EndIf
            
            //tratar dura��o da m�sica e totalizador
            If nModel==2  .and. !Empty(M->ZD3_DURAC) .and. M->ZD3_DURAC > 0
                xRet := U_xValTime(M->ZD3_DURAC)//valida tempo digitado                 
                xEdit :=.T.//boleano para informar que editou valor
            elseif nModel==2 .and.  M->ZD3_DURAC <= 0
               xRet:=.F.   
               xEdit   :=.F.
            elseif nModel==2  // recebe valor dura��o anterior da edi��o
                nOldT:= omodelg:GetValue(aCampos[2])   
                xEdit   :=.F.
                 // Valida��o: se CD est� deletado, grid de musica for editada  
                 If oModelG:OFORMMODELOWNER:isDeleted() .and. aparam[5]=="CANSETVALUE"
                    //se tem 1 m�sica, a inicial e sem valor
                    If oModelG:length()==1 .AND. (Empty(AllTrim(FWFldGet("ZD3_MUSICA"))) .and. FWFldGet("ZD3_DURAC")==0)
                        oModelG:OFORMMODELOWNER:GoLine(oModelG:OFORMMODELOWNER:nLine)
                        FwAlerthelp('Valida��o','N�o � poss�vel inserir M�sica'+Chr(10)+Chr(13)+' com CD deletado'+Chr(10)+Chr(13)+'Recupere o CD '+Alltrim(FWFldGet("B1_DESC")))
                        xRet :=.F.
                    //se tem mais de 1 m�sica preenchida, posiciona na ultima linha a saber se n�o est� deletada.    
                    elseIf oModelG:length()>1           
                        oModelG:GoLine(oModelG:length())
                        IF !oModelG:IsDeleted()
                             oModelG:OFORMMODELOWNER:GoLine(oModelG:OFORMMODELOWNER:nLine)
                            FwAlerthelp('Valida��o','N�o � poss�vel inserir M�sica'+Chr(10)+Chr(13)+' com CD deletado'+Chr(10)+Chr(13)+'Recupere o CD '+Alltrim(FWFldGet("B1_DESC")))                                
                            xRet:=.F.                            
                        EndIf                     
                    EndIf
                EndIf               
            
            //condi��o para n�o incrementar Total de instrumentos ao editar
            elseif (nModel==3 .AND. ;                   //grid ZD7 instrumento
                    aparam[5]=="SETVALUE" .AND. ;       //evento set valor    
                    aparam[6] ==("ZD7_CHAVE") .OR. aparam[6] ==("ZD7_DESC") .AND. ; //posicionado no campo chave ou desc chamado pelo gatilho                    
                    !Empty(Alltrim(M->ZD7_CHAVE)) .and. ;       // n�o est� vazio campo, pois est� em edi��o
                    oModel:AALLSUBMODELS[3]:CID=="ZD3Detail" )  //submodelo � M�sica                    
                    //-----------//
            //condi��o para incrementar Total de instrumentos ap�s a 1� linha    
            elseif (nModel==3 .AND. ;                   //grid ZD7 instrumento
                    aparam[5]=="SETVALUE" .AND. ;       //evento set valor
                    aparam[6] ==("ZD7_CHAVE") .OR. aparam[6] ==("ZD7_DESC") .AND. ; //posicionado no campo chave ou desc chamado pelo gatilho                    
                    oModel:AALLSUBMODELS[3]:CID=="ZD3Detail" .and. ; //submodelo � M�sica
                    oModel:AALLSUBMODELS[3]:NLINE > 1 .and.;         //submodelo m�sica posicionado na linha >1
                    oModel:AALLSUBMODELS[4]:NLINE == 1)              //submodelo instrumento posicionado na linha 1
                        U_xTotQtd("ZD5Master",1,nModel)              //incrementar qtd                      
            elseif nModel==3 
                   U_xTotQtd("ZD5Master",3,nModel)     //setar qtd para ZD3_INSTR
                                    
            EndIf
    
            If xRet   //entrar somente para edi��o do campo
                If M->ZD3_DURAC <> nOldT .and. nOldT >0 .and. xEdit//valor editado
                    xRet := U_xTotDur(nOldT)//decrementa antes de adicionar
                    elseif M->ZD3_DURAC == nOldT    
                        nOldT  := M->ZD3_DURAC 
                        xRet := U_xTotDur(nOldT)//mesmo igual, deve decrementar para adicionar automaticamente pelo totalizador.
                EndIf
            else
                Help(NIL, NIL, "Valida��o!", NIL, "N�mero incoreto para o campo de dura��o", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Digite n�meros dentro do formato da hora."})
                
            EndIf  
        EndIf             

        
    EndIf    
    aCampos   :={}
    //xEdit     :=.F.
return xRet
