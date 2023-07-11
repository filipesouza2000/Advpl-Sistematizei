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
    //Local cGrupo:=''
    Local cTipo:=''
    //cGrupo  := AllTrim(M->B1_GRUPO)
    cTipo  := AllTrim(M->B1_TIPO)
    
    If Empty(cRegCd)
        BeginSql ALIAS cAlias
        SELECT MAX(R_E_C_N_O_) REC FROM %table:SB1% B1
        EndSql
        cRec   := cValToChar(REC+1)
        cRegCd := cRec
    else//se houver valor de registro corrente, incrementa 1
        cRegCd := ALLTRIM(cValToChar(VAL(cRegCd)+1))
        cRec   := cRegCd    
    EndIf   
    

    //criar prefixo do codigo referente ao TIPO
    //depois inserir no final o próximo R_E_C_N_O_ completando 10 digitos
    DO CASE
        CASE cTipo=='BB' ////.AND cGrupo=='0010'//bobina  de flandres
            cCod :='BFLA'+PADL(cRec,6,'0')
        CASE cTipo=='FL'//.AND cGrupo=='0011'//folha de flandres
            cCod :='FFLA'+PADL(cRec,6,'0')
        CASE cTipo=='FL'//.AND cGrupo=='0012'//folha cromada 
            cCod :='FCRA'+PADL(cRec,6,'0')
        CASE cTipo=='CH'//.AND cGrupo=='0013'//CHAPA ZINCADA 
            cCod :='CZCA'+PADL(cRec,6,'0')
        CASE cTipo=='CH'//.AND cGrupo=='0014'//CHAPA GROSSA
            cCod :='CGCA'+PADL(cRec,6,'0')
        CASE cTipo=='CH'//.AND cGrupo=='0015'//CHAPA LAMINADA   
            cCod :='CLCA'+PADL(cRec,6,'0')
        CASE cTipo=='CH'//.AND cGrupo=='0016'//CHAPA FINA
            cCod :='CFCA'+PADL(cRec,6,'0')
        CASE cTipo=='CD'//.AND cGrupo=='0017'// tipo cd
            cCod :='CD'+PADL(cRec,8,'0')  
        CASE cTipo=='DVD'//.AND cGrupo=='0017'// tipo dvd
            cCod :='DVD'+PADL(cRec,7,'0')        
        OTHERWISE
            cCod:=Year2Str(Date())+PADL(cRec,6,'0')       
    ENDCASE
    
    //(cAlias)->(DBCLOSEAREA())
return cCod
