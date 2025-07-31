#include "protheus.ch"
#include "TOTVS.ch"

/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
---Data---|-----Autor-------|-------Descriçãoo------------
11/04/2023| Filipe Souza    | 050-Conversão de Array para HashMap com a função AToHM

@see Terminal da Informação
@see https://tdn.totvs.com/display/tec/AToHM
@obs 
    Função AToHM
    Parâmetros
        + aMatriz   , Array      , Indica o nome do array que será transformado em objeto
        + nColuna_1 , Numérico   , Indica o número da coluna que será a chave da pesquisa
        + nTrim_1   , Numérico   , Indica o tipo de trim que será aplicado em dados caractere (0 = mantém; 1 = tira espaços a esquerda; 2 = tira espaços a direita; 3 = tira espaços de ambos os lados)
        + nColuna_2 , Numérico   , Indica o número da coluna que será a chave da pesquisa
        + nTrim_2   , Numérico   , Indica o tipo de trim que será aplicado em dados caractere (0 = mantém; 1 = tira espaços a esquerda; 2 = tira espaços a direita; 3 = tira espaços de ambos os lados)
        + nColuna_3 , Numérico   , Indica o número da coluna que será a chave da pesquisa
        + nTrim_3   , Numérico   , Indica o tipo de trim que será aplicado em dados caractere (0 = mantém; 1 = tira espaços a esquerda; 2 = tira espaços a direita; 3 = tira espaços de ambos os lados)
        + nColuna_4 , Numérico   , Indica o número da coluna que será a chave da pesquisa
        + nTrim_4   , Numérico   , Indica o tipo de trim que será aplicado em dados caractere (0 = mantém; 1 = tira espaços a esquerda; 2 = tira espaços a direita; 3 = tira espaços de ambos os lados)
        + nColuna_5 , Numérico   , Indica o número da coluna que será a chave da pesquisa
        + nTrim_5   , Numérico   , Indica o tipo de trim que será aplicado em dados caractere (0 = mantém; 1 = tira espaços a esquerda; 2 = tira espaços a direita; 3 = tira espaços de ambos os lados)
        + nColuna_6 , Numérico   , Indica o número da coluna que será a chave da pesquisa
        + nTrim_6   , Numérico   , Indica o tipo de trim que será aplicado em dados caractere (0 = mantém; 1 = tira espaços a esquerda; 2 = tira espaços a direita; 3 = tira espaços de ambos os lados)
        + nColuna_7 , Numérico   , Indica o número da coluna que será a chave da pesquisa
        + nTrim_7   , Numérico   , Indica o tipo de trim que será aplicado em dados caractere (0 = mantém; 1 = tira espaços a esquerda; 2 = tira espaços a direita; 3 = tira espaços de ambos os lados)
        + nColuna_8 , Numérico   , Indica o número da coluna que será a chave da pesquisa
        + nTrim_8   , Numérico   , Indica o tipo de trim que será aplicado em dados caractere (0 = mantém; 1 = tira espaços a esquerda; 2 = tira espaços a direita; 3 = tira espaços de ambos os lados)
    Retorno
        + oHash     , Objeto     , Objeto instanciado da classe THashMap
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
*/
user function xArToHM()
    Local aArea     := FwGetArea()
    Local aNomes    :={}
    Local aRow      :={}
    Local cSearch   :=""
    Local oHashMap

    aAdd(aNomes,{"00001","Filipe",  1})
    aAdd(aNomes,{"00002","Michelle",2})
    aAdd(aNomes,{"00003","Alcione", 3})
    //Converte o array para um objeto HashMap,colocando como chave a coluna 1
    oHashMap:=AToHM(aNomes,1,0)

    cSearch:="00003"
    //efetua busca do codigo, colocando o array aRow    
    If HMGet(oHashMap,cSearch,aRow)
        ShowLog( ;
            VarInfo("aRow", aRow, , .F.) ;
        )
    EndIf
    HMClean(oHashMap)
    FreeObj(oHashMap)
    
    FwRestArea(aArea)
return
