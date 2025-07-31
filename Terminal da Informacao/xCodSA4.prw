#include 'Protheus.ch'
#include 'TOTVS.ch'
/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
---Data---|-----Autor-------|-------Descri��oo------------
11/04/2023| Filipe Souza    | Aula 6 -Criando uma numera��o autom�tica com GetMV e PutMV
                                tabela SA4-Transportadora, campo A4_COD colocado com inicializador padr�o essa fun��o.

@see Terminal da Informa��o
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
*/
User Function xCodSA4()
    Local aArea :=FwGetArea()
    Local cCod  :=""

    //busca conte�do do par�metro com codigo atual    
    cCod:= GetMV('MV_CODSA4')

    //se estiver vazio, define valor inicial
    If Empty(cCod)
        cCod:='000001'
    else
    //incrementa a sequencia com +1
    cCod:=Soma1(cCod)   
    EndIf
    
    FwRestArea(aArea)
return cCod
