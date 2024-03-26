#include "TOTVS.ch"
#include "Protheus.ch"

/*££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££
	Data	|	Autor		| Descricao
 25/03/2024 | Filipe Souza  | Validando se último registro esta travado
 @see https://terminaldeinformacao.com/2024/03/23/validando-se-um-registro-esta-travado-com-islocked-maratona-advpl-e-tl-311/

£££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££*/   
User Function xIsLocked()
    Local aArea      := FWGetArea()
    Local nRecAtu    := 0
    Local cCod       :=''

    DbSelectArea('SB1')
    SB1->(DbSetOrder(1)) //B1_FILIAL + B1_COD
    SB1->(DBGoBottom())  // ir no último registro
    cCod:=AllTrim(SB1->B1_COD)//retornar o Codigo do ultimo registro
    SB1->(DBGoTop())    //ir para o inicio, para iniciar DBSeek(busca)
    //Se conseguir posicionar no produto
    If SB1->( DBSeek(FWxFilial('SB1') + cCod))
        //Busca o Recno atual
        nRecAtu := SB1->(RecNo())
 
        //Trava o registro para atualizações
        RecLock('SB1', .F.)
 
        //Valida se o registro já foi travado
        If IsLocked("SB1", nRecAtu)
            FWAlertInfo("O registro já foi travado anteriormente!", "Teste IsLocked")
        Else
            FWAlertInfo("O registro esta disponível para ser travado!", "Teste IsLocked")
        EndIf
 
        //Destrava o registro
        SB1->(MsUnlock())
    EndIf
 
    FWRestArea(aArea)
Return
