#Include "Protheus.ch"

/*++++DATA++++|++++AUTOR+++++|++++++++++++++++DESCRIÇÂO+++++++++++++
  23/03/2024  | Filipe Souza | Ao copiar pedido de compra, adicionar botão
                              para poder atualizar data de entrega dos itens, pois vem com data atual.
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/


User Function MA120BUT() 
    Local aButtons := {} 
    Local cOption := ProcName(3)
    
    If cOption=='A120COPIA'
        aadd(aButtons,{'Atualizar Dt entrega',{|| U_xDlgUp()},'Atualizar','Atualizar Dt entrega'})
    EndIf
Return (aButtons )

User Function xDlgUp()
    Local btcancel
    Local btOk
    Local oData
    Local dData := Date()
    Local oGroup1
    Local oSay1

    Static oDlg

      DEFINE MSDIALOG oDlg TITLE "Atualizar Data de entrega" FROM 000, 000  TO 200, 300 COLORS 0, 16777215 PIXEL

        @ 012, 012 GROUP oGroup1 TO 078, 134 PROMPT "Data da Entrega" OF oDlg COLOR 0, 16777215 PIXEL
        @ 029, 024 SAY   oSay1 PROMPT "Dt. entrega:" SIZE 033, 007 OF oDlg COLORS 0, 16777215 PIXEL
        @ 028, 057 MSGET oData VAR dData SIZE 060, 010 OF oDlg PICTURE "@D" COLORS 0, 16777215 PIXEL
        @ 049, 029 BUTTON btOk     PROMPT "OK"     SIZE 037, 012 OF oDlg ACTION {|| U_xUpDtEnt(dData),oDlg:end()} PIXEL
        @ 049, 071 BUTTON btcancel PROMPT "Cancel" SIZE 037, 012 OF oDlg ACTION {|| oDlg:end()} PIXEL

    ACTIVATE MSDIALOG oDlg CENTERED
    
return

User Function xUpDtEnt(dData)
        Local nX    :=1
        If dData <> NIL .AND. ValType(dData)<>'U'
            for nX =1 to Len(aCols)
                aCols[nX][17] = dData
            next
        EndIf
return
