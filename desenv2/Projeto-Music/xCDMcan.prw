#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"


/*++++DATA++++|++++AUTOR+++++|++++++++++++++++DESCRIÇÂO+++++++++++++
  18/07/2023  | Filipe Souza | função chamada no evento CENCELAR, 
                               para zerar a variável Private cRegCd que guarda o código que ainda não foi gravado.
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/

User Function xCDMcan(cRegCd)
    cRegCd :=NIL
    //FwFreeVar(cRegCd)
return .T.
