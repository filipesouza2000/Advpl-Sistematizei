#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH'

/*++++DATA++++|++++AUTOR+++++|++++++++++++++++DESCRIÇÂO+++++++++++++
  27/03/2023  | Filipe Souza | Trigger: gerar B1_COD automaticamente
                                através do grupo de produto preenchido
                                formando 3 letras sobre o grupo. Ainda somente para folhas, boninas e chapas
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
User Function xCodProd()
    Local cAlias := GetNextAlias()
    Local cCod  
    Local cRec
    Local cGrupo:=''
    cGrupo  := AllTrim(M->B1_GRUPO)
    
    BeginSql ALIAS cAlias
        SELECT MAX(R_E_C_N_O_) REC FROM %table:SB1% B1
    EndSql
    cRec:= cValToChar(REC+1)

    //criar prefixo do codigo referente ao grupo
    //depois inserir no final o próximo R_E_C_N_O_ completando 12 digitos
    DO CASE
        CASE cGrupo=='0010'//bobina  de flandres
            cCod :='BFLA'+PADL(cRec,6,'0')
        CASE cGrupo=='0011'//folha de flandres
            cCod :='FFLA'+PADL(cRec,6,'0')
        CASE cGrupo=='0012'//folha cromada 
            cCod :='FCRA'+PADL(cRec,6,'0')
        CASE cGrupo=='0013'//CHAPA ZINCADA 
            cCod :='CZCA'+PADL(cRec,6,'0')
        CASE cGrupo=='0014'//CHAPA GROSSA
            cCod :='CGCA'+PADL(cRec,6,'0')
        CASE cGrupo=='0015'//CHAPA LAMINADA   
            cCod :='CLCA'+PADL(cRec,6,'0')
        CASE cGrupo=='0016'//CHAPA FINA
            cCod :='CFCA'+PADL(cRec,6,'0')
        OTHERWISE
            cCod:=Year2Str(Date())+PADL(cRec,6,'0')       
    ENDCASE
    
    //(cAlias)->(DBCLOSEAREA())
return cCod
