#include 'Protheus.ch'
#include 'TOTVS.ch'
/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
---Data---|-----Autor-------|-------Descriçãoo------------
11/04/2023| Filipe Souza    | Aula 6 -Criando uma numeração automática com GetMV e PutMV
                                tabela SA4-Transportadora, campo A4_COD colocado com inicializador padrão essa função.

@see Terminal da Informação
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
*/
User Function xCodSA4()
    Local aArea :=FwGetArea()
    Local cCod  :=""

    //busca conteúdo do parâmetro com codigo atual    
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
