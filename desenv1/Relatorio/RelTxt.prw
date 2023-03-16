#INCLUDE 'Protheus.ch'
#INCLUDE 'TOPCONN.ch'
/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
---Data---|-----Autor-------|-------Descrição------------
01/03/2023| Filipe Souza    | Relatório de produtos gerado em arquivo TXT

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
*/

User Function RelTxt()
    if MsgNoYes("Gerar aquivo em TXT?","Relatório .TXT")
        //Processa({|| MntQry()},"Espere","Consultando....")
        //MsAguarde({|| GeraArq()},"O arquivo TXT está sendo gerado. ")
        U_MntQry()
        GeraArq()
    Else 
        Alert("Cancelada pelo usuário.")
    endif
Return 

//monta query
User Function MntQry()
    Local cQuery := ''

    cQuery := "SELECT B1_FILIAL as filial,B1_COD as cod, B1_DESC as descr, B1_TIPO as tipo, B1_UM as um "
    cQuery += "FROM "+RetSqlName("SB1")+" SB1 "
    cQuery += "WHERE D_E_L_E_T_ = '' "
    
    cQuery:= ChangeQuery(cQuery)    
                          //https://tdn.totvs.com/display/tec/TCGenQry
    DBUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),'tmpb1',.F.,.T.)

return

//Função que conterá funções  internas do Protheus
Static Function GeraArq()
    Local cDir      := "C:\TOTVS12133\Protheus\protheus_data\report\"
    Local cFile      := "File-"+DToS(DATE())+".txt"
    Local nHandle   := FCreate(cDir+cFile)
    Private lAbortPrint:=.F.
    //Local nX
    if nHandle < 0
        MSGALERT( "Erro ao criar aquivo.", "ERRO" )
    else  
        While !tmpb1->(EOF()) .and. !lAbortPrint
            FWRITE( nHandle, tmpb1->(filial)+" | "+ tmpb1->(cod)+" | "+ tmpb1->(descr)+" | "+ tmpb1->(um)+ CRLF)
            tmpb1->(DbSkip())
        End
        
        /*For nX:= 1 to 200
            FWRITE( nHandle, "Gravando a linha "+ StrZero(nX,3) + CRLF )            
        Next nX
        */
        FClose(nHandle)        
    endif

    if FILE( cDir + cFile)
        MsgInfo("Arquivo gerado com Sucesso.","Relatório TXT")
    Else
        MSGALERT( "Não foi possível criar o arquivo!", "ERRO" )    
    endif

return
