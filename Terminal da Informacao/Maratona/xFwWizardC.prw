#include "TOTVS.ch"
#include "Protheus.ch"

/*££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££
	Data	|	Autor		| Descricao
 25/03/2024 | Filipe Souza  | Classe para criar uma uma navegação de Wizard (com opção de avançar ou retroceder)
 @see https://terminaldeinformacao.com/2024/02/26/criando-uma-navegacao-de-passos-com-a-fwwizardcontrol-maratona-advpl-e-tl-258/
 @see https://tdn.totvs.com/display/public/framework/FWWizardControl

£££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££*/   

User Function xFwWizardC()
    Local aArea         := FWGetArea()
    Local nCorFundo     := RGB(238, 238, 238)
    Local nJanAltura    := 400
    Local nJanLargur    := 600 
    Local cJanTitulo    := 'FWWizardControl'
    Local lCentraliz    := .T. 
    Private lDimPixels  := .T. 
    Private nObjLinha   := 0
    Private nObjColun   := 0
    Private nObjLargu   := 0
    Private nObjAltur   := 0
    Private cFontNome   := 'Tahoma'
    Private oFontPadrao := TFont():New(cFontNome, , -12)
    Private oDialog 
    Private bBlocoIni   := {|| /*fSuaFuncao()*/ } //Aqui voce pode acionar funcoes customizadas que irao ser acionadas ao abrir a dialog 
    //objeto1 
    Private oSayIn 
    Private cSayInsira    := 'Insira o Texto:'
    //objeto2 
    Private oGetTexto 
    Private cGetTexto    := "https://grupotrigo.com.br/" + Space(200)
    //objeto3
    Private oQrCode
    //objeto4
    Private oSayFim 
    Private cSayFim    := 'Wizard concluído!'
    //Objetos do Wizard
    Private oPanelGer
    Private oWizard

    //Cria a dialog
    oDialog := TDialog():New(0, 0, nJanAltura, nJanLargur, cJanTitulo, , , , , , nCorFundo, , , lDimPixels)
         
        //Cria um painel geral
        oPanelGer := TPanel():New(001, 001, "", oDialog, , , , RGB(000,000,000), RGB(254,254,254), (nJanLargur/2)-1, (nJanAltura/2)-3)
 
        //Instancia o Wizard
        oWizard := FWWizardControl():New(oPanelGer)
        oWizard:ActiveUISteps()
 
        //Página 1 do Wizard (terá um campo para o usuário digitar)
        oNewStep := oWizard:AddStep("1")
        oNewStep:SetStepDescription("Definição para usar o QRCode")
        oNewStep:SetConstruction({|oPanel| xStep1(oPanel)})
        oNewStep:SetNextAction({|| xValStep1()})
        oNewStep:SetCancelAction({|| xClose()})
 
        //Página 2 do Wizard
        oNewStep := oWizard:AddStep("2", {|oPanel| xStep2(oPanel)})
        oNewStep:SetStepDescription("QRCode Gerado")
        oNewStep:SetNextAction({|| .T.})
        oNewStep:SetPrevAction({|| .T.})
        oNewStep:SetCancelAction({|| xClose()})
 
        //Página 3 do Wizard
        oNewStep := oWizard:AddStep("3", {|oPanel| xStep3(oPanel)})
        oNewStep:SetStepDescription("Concluído")
        oNewStep:SetNextAction({|| xClose()})
        oNewStep:SetPrevAction({|| .T.})
        oNewStep:SetCancelAction({|| xClose()})
      
        //Ativa o Wizard para visualização
        oWizard:Activate()
 
    //Ativa e exibe a janela
    oDialog:Activate(, , , lCentraliz, , , bBlocoIni)
      
    FWRestArea(aArea)

return

Static Function xClose()
    oDialog:End()
Return .T.
 
Static Function xValStep1()
    Local lRet := .T.
 
    //Se não houver texto para montar o QRCode, não permite prosseguir
    If Empty(cGetTexto)
        FWAlertError("Preencha o campo antes de prosseguir!", "Atenção")
        lRet := .F.
 
    Else
 
        //Se o QRCode já tiver sido criado, atualiza ele
        If ValType(oQrCode) == "O"
            oQrCode:SetCodeBar(cGetTexto)
            oQrCode:Refresh()
        EndIf
    EndIf
Return lRet
 
Static Function xStep1(oPanel)
    //objeto1 - usando a classe TSay
    nObjLinha := 4
    nObjColun := 4
    nObjLargu := 70
    nObjAltur := 6
    oSayIn  := TSay():New(nObjLinha, nObjColun, {|| cSayInsira}, oPanel, /*cPicture*/, oFontPadrao, , , , lDimPixels, /*nClrText*/, /*nClrBack*/, nObjLargu, nObjAltur, , , , , , /*lHTML*/)
 
    //objeto2 - usando a classe TGet
    nObjLinha := 3
    nObjColun := 64
    nObjLargu := 110
    nObjAltur := 10
    oGetTexto  := TGet():New(nObjLinha, nObjColun, {|u| Iif(PCount() > 0 , cGetTexto := u, cGetTexto)}, oPanel, nObjLargu, nObjAltur, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels)
Return
 
Static Function xStep2(oPanel)
    //objeto3 - usando a classe FWQRCode
    nObjLinha := 4
    nObjColun := 110
    nObjLargu := 160
    nObjAltur := 160
    oQrCode := FwQrCode():New({nObjLinha, nObjColun, nObjLargu, nObjAltur}, oPanel, cGetTexto)
Return
 
Static Function xStep3(oPanel)
    //objeto4 - usando a classe TSay
    nObjLinha := 4
    nObjColun := 4
    nObjLargu := 200
    nObjAltur := 6
    oSayFim   := TSay():New(nObjLinha, nObjColun, {|| cSayFim}, oPanel, /*cPicture*/, oFontPadrao, , , , lDimPixels, /*nClrText*/, /*nClrBack*/, nObjLargu, nObjAltur, , , , , , /*lHTML*/)
Return
