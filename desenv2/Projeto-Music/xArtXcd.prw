#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"


/*++++DATA++++|++++AUTOR+++++|++++++++++++++++DESCRIÇÂO+++++++++++++
  18/07/2023  | Filipe Souza | Função para filtrar produtos que possuem  artistas, sendo CD.
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/

User Function xArtXcd()
        Local cQuery
        Local cRet :=''
        
        cQuery := " SELECT DISTINCT(B1_XART) as art"
        cQuery += " FROM "+RetSqlName("SB1")
        cQuery += " WHERE D_E_L_E_T_ = '' AND B1_FILIAl ='"+ FwXFilial('SB1')+"'
        
        cQuery:= ChangeQuery(cQuery)   
        DBUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),'xArt',.F.,.T.)
        While xArt->(!EOF())
            cRet+= "|"+xArt->art
            xArt->(DBSKIP())
        EndDo
        IIF(Alltrim(cRet)=='|',cRet:='',cRet)
        xArt->(DBCloseArea())
    
Return cRet
