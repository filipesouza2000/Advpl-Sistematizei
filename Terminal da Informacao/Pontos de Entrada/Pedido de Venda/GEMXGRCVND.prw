#INCLUDE 'Protheus.ch'
#INCLUDE 'TOTVS.ch'

/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
---Data---|-----Autor-------|-------Descrição------------
10/03/2023| Filipe Souza    | 11 - PE durante a gravação
                                Incrementar descrição do estado do cliente no campo C5_MENNOTA
                                

@see Terminal da Informação
Pontos de Entrada na rotina "Pedidos de Venda (MATA410)"
@see https://centraldeatendimento.totvs.com/hc/pt-br/articles/7381576110871-Cross-Segmentos-Backoffice-Protheus-SIGAFAT-Pontos-de-Entrada-na-rotina-Pedidos-de-Venda-MATA410
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
*/
User Function GEMXGRCVND()
    Local aArea   := FwGetArea()
    Local cUF     :=""
    Local cObsAux :="Cliente de "
    Local cQuery  :=""
   
    //se pedido Normal, busca o estado do Cliente
    If SC5->C5_TIPO == "N"
        //Buscar UF co cliente.    Filial + cod Cliente + loja 
        cUF:= Posicione("SA1",1,FwxFilial("SA1")+Sc5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_EST")
        
        //consultar estados na tabela CC2   CC2_EST
        cQuery:="SELECT  DISTINCT CC2_EST AS UF,X5_DESCRI AS EST "   
        cQuery+=" FROM "+ RetSqlName("CC2") +" CC2 "
        cQuery+=" INNER JOIN SX5990 SX5 ON ( X5_FILIAL = ''
        cQuery+="   AND X5_TABELA = '12' AND X5_CHAVE = CC2_EST AND SX5.D_E_L_E_T_ = ' ' )"
        cQuery+=" WHERE  CC2.D_E_L_E_T_ = ' '  ORDER BY  UF"

        cQuery:=ChangeQuery(cQuery)
        DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"EST",.F.,.T.)
        While EST->(!EOF())
            If cUF == EST->UF .AND. !cObsAux $(SC5->C5_MENNOTA)
                SC5->C5_MENNOTA = cObsAux + Alltrim(EST->EST) +" - "+ Alltrim(SC5->C5_MENNOTA)
                exit
            EndIf     
            EST->(DBSKIP())
        EndDo
        EST->(DBCloseArea())            
    EndIf

   
    FwRestArea(aArea)    
return 
