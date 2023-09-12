#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"


/*++++DATA++++|++++AUTOR+++++|++++++++++++++++DESCRIÇÂO+++++++++++++
  19/08/2023  | Filipe Souza | Função para filtrar clientes que possuem  artistas, sendo CD.
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/

User Function xArtCli()
        Local cQuery
        Local cRet :=''
        
        cQuery := " SELECT DISTINCT(ZD4_CLI) as ZD4_CLI "
        cQuery += " FROM "+RetSqlName("ZD4")
        cQuery += " WHERE D_E_L_E_T_ = '' "
        
        cQuery:= ChangeQuery(cQuery)   
        DBUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),'xCli',.F.,.T.)
        While xCli->(!EOF())
            cRet+= "|"+xCli->ZD4_CLI
            xCli->(DBSKIP())
        EndDo
        IIF(Alltrim(cRet)=='|',cRet:='',cRet)
        xCli->(DBCloseArea())
    
Return cRet
