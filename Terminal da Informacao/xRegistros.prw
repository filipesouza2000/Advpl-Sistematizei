#include "Protheus.ch"
#include "TOTVS.ch"
/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
---Data---|-----Autor-------|-------Descriçãoo------------
15/03/2023| Filipe Souza    | Aula 13 - Manipulação de registros - 
                                ExecAuto_RecLock (Curso Boas Práticas de Programação em AdvPL) 

@see Terminal da Informação
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
*/

user function xRegistros()
    U_xEAutoMVC()
    U_xEAuto()
    U_xRecLock()
return

User Function xEAutoMVC()
    Local aArea  :=FwGetArea()
    Local Lret   :=.F.
    Local oModel
    Local oSA2Mod
    Local aErro  :={}
    Local cCodFor:=""
    
    //pegando o modelo de dados, setando a operação de inclusão
    oModel:=FWLoadModel("MATA020")
    oModel:SetOperation(3)
    oModel:Activate()

    //pegando o model dos campos da SA2
    oSA2Mod:=oModel:getModel("SA2MASTER")
    /*
    //proximo código GetSXENum("SA2","A2_COD") já está implicito no CFG da SX3 campo A2_COD
    cCodFor:= oSA2Mod:GetValue("A2_COD")
    If Empty( cCodFor )
    // Não tinha inicializado — gera manualmente
        cCodFor := GetSXENum( "SA2", xFilial( "SA2" ), 1, 6 )
        oSA2Mod:SetValue( "A2_COD", cCodFor )
        FWLogMsg( "Código SA2 gerado manualmente: " + cCodFor )
    else
        FWLogMsg( "Código SA2 já inicializado pelo SX3: " + cCodFor )
    EndIf    
    */
    oSA2Mod:setValue("A2_LOJA",     "01")
    oSA2Mod:setValue("A2_NOME",     "Net Computadores Ltda")
    oSA2Mod:setValue("A2_NREDUZ",   "Net Computadores")
    oSA2Mod:setValue("A2_END",      "Avenida dos Imigrantes")
    oSA2Mod:setValue("A2_BAIRRO",   "Portal das Flores")
    oSA2Mod:setValue("A2_TIPO",     "J")
    oSA2Mod:setValue("A2_EST",      "SP")
    oSA2Mod:setValue("A2_COD_MUN",  "50407")
    oSA2Mod:setValue("A2_MUN",      "São Pedro")
    oSA2Mod:setValue("A2_CGC",      "02465944000160")

    //se conseguir validar as informações
    If oModel:VldData()
        //tenta realizar o comit
        If oModel:CommitData()
            lRet:=.T.
        else
            lRet:=.F.               
        EndIf
    //n�o validado    
    else    
        lRet:=.F.        
    EndIf

    
    If lRet
        FwAlertSuccess("Cacastrado com sucesso!"+CRLF+"Fornecedor: "+ cCodFor,"Sucesso")
    //se nao comitou mostra o erro, volta o cod no sx8
    else
        //busca o erro no modelo de dados
        aErro:= oModel:GetErrorMessage()
        //Monta o texto que será exibido na tela
        
        AutoGrLog("Id do formulário de origem:"+ "["+ AllToChar(aErro[01])+"]") 
        AutoGrLog("Id do campo de origem:"     + "["+ AllToChar(aErro[02])+"]") 
        AutoGrLog("Id do formulário de erro:"  + "["+ AllToChar(aErro[03])+"]") 
        AutoGrLog("Id do campo de erro:"       + "["+ AllToChar(aErro[04])+"]") 
        AutoGrLog("Id do erro:"                + "["+ AllToChar(aErro[05])+"]") 
        AutoGrLog("Mensagem do erro:"          + "["+ AllToChar(aErro[06])+"]") 
        AutoGrLog("Mensagem de solução:"       + "["+ AllToChar(aErro[07])+"]") 
        AutoGrLog("Valor atribuido :"          + "["+ AllToChar(aErro[08])+"]") 
        AutoGrLog("Valor anterior :"           + "["+ AllToChar(aErro[09])+"]") 

        MostraErro()
    EndIf

    //desativa modelo de dados
    oModel:DeActivate()    
    FwRestArea(aArea)
return


User Function xEAuto()
    Local aArea     :=FwGetArea()
    Local aDados    :={}
    Private lMsErroAuto :=.F.

    aAdd(aDados,{"A2_LOJA",     "01", Nil})
    aAdd(aDados,{"A2_NOME",     "INCOFLANDRES LTDA", Nil})
    aAdd(aDados,{"A2_NREDUZ",   "CINBAL ", Nil})
    aAdd(aDados,{"A2_END",      "Av. Paulo Erlei Alves Abrantes", Nil})
    aAdd(aDados,{"A2_BAIRRO",   "Tres Poços", Nil})
    aAdd(aDados,{"A2_TIPO",     "J", Nil})
    aAdd(aDados,{"A2_EST",      "RJ", Nil})
    aAdd(aDados,{"A2_COD_MUN",  "06305", Nil})
    aAdd(aDados,{"A2_MUN",      "Volta Redonda", Nil})
    aAdd(aDados,{"A2_CGC",      "62100581000190", Nil})

    Begin Transaction
    //	MsExecAuto({|x,y| MATA020(x,y)}, aItens, nOperacao)
        MSExecAuto({|x,y| MATA020(x,y)},aDados,3)// 3 - Inclusao, 4 - Alteração, 5 - Exclusão

        if lMsErroAuto
            MostraErro()
            DisarmTransaction()
        else
            FwAlertSuccess("Cacastrado com sucesso!","Sucesso")
        EndIf   

    end Transaction
    FwRestArea(aArea)
return

User Function xRecLock()
    Local aArea  :=FwGetArea()
    Local cEnd   :=""
    Local cSCgc :=Space(TamSX3('A2_CGC')[01])
    Local cSEnd :=Space(TamSX3('A2_END')[01])
    Local cCGC   :=""
    Local aPergs := {}
    
    aAdd(aPergs, {1,"Fornecedor CNPJ:", cSCgc, "@R 99.999.999/9999-99",".T.",, ".T.", 100,.F. } )
    aAdd(aPergs, {1,"Novo Endereço:"  , cSEnd, ""                     ,".T.",, ".T.", 120,.F. } ) 
//ParamBox(aParametros ,cTitle,aRet,bOk,aButtons,lCentered,nPosX,nPosY,oDlgWizard,cLoad,lCanSave,lUserSave )    
    If ParamBox( aPergs, "Atualização do Fornecedor:",,,,,,,,.F.,.F.)
        cCGC:=cValToChar(MV_PAR01)    
        cEnd:=Alltrim(MV_PAR02)
        FWAlertInfo( "CNPJ informado: " + cCGC,"Informativo" )
        DBSelectArea("SA2")
        SA2->(DBSetOrder(3))//A2_COd + A2_LOJA
        If SA2->(DBSeek(FwxFilial("SA2")+cCGC))
            RecLock("SA2",.F.)
            SA2->A2_END:=cEnd
            SA2->(MSUnlock())
            FwAlertSuccess("Atualziado com sucesso!"+CRLF+"Fornecedor CGC: "+ cCGC,"Sucesso")
        EndIf
    Else
        FWAlertInfo( "Usuário cancelou." ,"Cancelado")
    EndIf    
    
    FwRestArea(aArea)
return

