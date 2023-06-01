#include "Protheus.ch"
#include "TopConn.ch"
#include "RWMake.ch"
#xtranslate bSetGet(<uVar>) => {|u| If(PCount()== 0, <uVar>,<uVar> := u)}
/*++++LOJA++++|++++AUTOR+++++|++++++++++++++++DESCRIÇÂO+++++++++++++
  15/10/2022  | Filipe Souza | Modelo 2 convencional, movimentação interna de produtos
@see https://thiagocoimbra.com.br/2014/06/09/exemplo-completo-msnewgetdados/
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/

User Function xModelo21()

    Local aHead1 := {}
    Local aSizeAuto := MsAdvSize()

    Private aCols1 := {}
    Private dEmissao := dDataBase
    Private cPicture := PesqPict("SD3","D3_QUANT")
    //Private bValProduto := {|| fValid("PRODUTO")}
    //Private bValQuant := {|| fValid("QUANT")}
    //Private bValAlmox := {|| fValid("ALMOX")}
    //Private bValEnderec := {|| fValid("ENDEREC")}
    //Private bValNumSeri := {|| fValid("NUMSERI")}
    //Private bLinOk := {|| fValid("LINHA")}
    //Private bfDeleta := {|| fDeleta()}
    Private nPosProduto
    Private nPosDesc
    Private nPosUnidade
    Private nPosQuant
    Private nPosAlmox
    Private nPosEnderec
    Private nPosNumSeri
    Private nColDel

    aHead1 := fHeader()

    nPosProduto := aScan(aHead1, {|x| AllTrim(x[2]) == "PRODUTO"})
    nPosDesc := aScan(aHead1, {|x| AllTrim(x[2]) == "DESC"})
    nPosUnidade := aScan(aHead1, {|x| AllTrim(x[2]) == "UNIDADE"})
    nPosQuant := aScan(aHead1, {|x| AllTrim(x[2]) == "QUANT"})
    nPosAlmox := aScan(aHead1, {|x| AllTrim(x[2]) == "ALMOX"})
    nPosEnderec := aScan(aHead1, {|x| AllTrim(x[2]) == "ENDEREC"})
    nPosNumSeri := aScan(aHead1, {|x| AllTrim(x[2]) == "NUMSERI"})

    aCols1 := fCols()

    nColDel := Len(aCols1[1])

    nOpc := GD_INSERT + GD_UPDATE + GD_DELETE

    oDlgSep  := MSDialog():New(aSizeAuto[7], 020, aSizeAuto[6]-20, aSizeAuto[5]-40,"Entrada de Produtos no Estoque",,,.F.,,,,,,.T.,,,.T. )
    oSayEmiss:= TSay():New( 10,10 ,{||"Emissão:"} ,oDlgSep,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,024,008)
    oGetEmiss:= TGet():New( 10,42 ,bSetGet(dEmissao),oDlgSep,044,008,"",,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
    nBrwLarg := (oDlgSep:nClientWidth / 2) – 10
    nBrwAlt  := (oDlgSep:nClientHeight / 2) – 52 
    oBrw1    := MsNewGetDados():New( 32 , 10, nBrwAlt, nBrwLarg,nOpc,'Eval(bLinOk)','AllwaysTrue()',"",{"PRODUTO","QUANT","ALMOX","ENDEREC","NUMSERI"},0,99,'AllwaysTrue()',,'Eval(bfDeleta)',oDlgSep,aHead1,aCols1)
    oBtConf  := TButton():New( nBrwAlt + 10 , nBrwLarg – 075,"Confirmar",oDlgSep,{|| If(fValid("TODOS"),fGrava(),)},037,012,,,,.T.,,"",,,,.F. )
    oBtCanc  := TButton():New( nBrwAlt + 10 , nBrwLarg – 035,"Cancelar" ,oDlgSep,{|| RollBackSX8(),oDlgSep:End()} ,037,012,,,,.T.,,"",,,,.F. )

    oGetEmiss:Disable()

    oDlgSep:Activate(,,,.T.)

Return

 

Static Function fDeleta()

    oBrw1:aCols[oBrw1:nAt, nColDel] := !oBrw1:aCols[oBrw1:nAt, nColDel]

    oBrw1:Refresh()

Return()
 

Static Function fHeader()

    Local aAux := {}

    aAdd(aAux,{"Produto" ,"PRODUTO" ,"@!" ,TamSX3("D3_COD")[1] ,0 ,/*"Eval(bValProduto)" */,"","C","SB1","" })
    aAdd(aAux,{"Descrição" ,"DESC" ,"@!" ,TamSX3("B1_DESC")[1] ,0 ,"" ,"","C","" ,"" })
    aAdd(aAux,{"UM" ,"UNIDADE" ,"@!" ,TamSX3("B1_UM")[1] ,0 ,"" ,"","C","" ,"" })
    aAdd(aAux,{"Quant" ,"QUANT" ,cPicture ,TamSX3("D3_QUANT")[1] ,TamSX3("D3_QUANT")[2] ,/*"Eval(bValQuant)"*/ ,"","N","" ,"" })
    aAdd(aAux,{"Local" ,"ALMOX" ,"@!" ,TamSX3("D3_LOCAL")[1] ,0 ,/*"Eval(bValAlmox)" */,"","C","" ,"" })
    aAdd(aAux,{"Endereço" ,"ENDEREC" ,"@!" ,TamSX3("D3_LOCALIZ")[1] ,0 ,/*"Eval(bValEnderec)"*/ ,"","C","SBE","" })
    aAdd(aAux,{"Num.Série" ,"NUMSERI" ,"@!" ,TamSX3("D3_NUMSERI")[1] ,0 ,/*"Eval(bValNumSeri)" */,"","C","" ,"" })

Return(aAux)
 

Static Function fCols()

    Local aAux := {}

    aAdd(aAux,{ Space(TamSX3("D3_COD")[1]),;
    Space(TamSX3("B1_DESC")[1]),;
    Space(TamSX3("B1_UM")[1]),;
    0,;
    Space(TamSX3("D3_LOCAL")[1]),;
    Space(TamSX3("D3_LOCALIZ")[1]),;
    Space(TamSX3("D3_NUMSERI")[1]),;
    .F.})

    Return(aAux)

    

Static Function fValid(cCampo)
    Local lRet := .T.
    Local nY
    // Revalida todas as linhas
    If cCampo == "TODOS"
        For nY := 1 to Len(oBrw1:aCols)
            If !oBrw1:aCols[nY][nColDel]    
            /*If  !fValCampo("PRODUTO",nY,.F.) .Or.;
                    !fValCampo("QUANT",nY,.F.) .Or.;
                    !fValCampo("ALMOX",nY,.F.) .Or.;
                    !fValCampo("ENDEREC",nY,.F.) .Or.;
                    !fValCampo("NUMSERI",nY,.F.)
                    Aviso("Atenção!","Problema encontrado na linha "+AllTrim(Str(nY))+".",{"OK"})
                    Return .F.
                EndIf
                */
            EndIf
        Next nY
        // Valida a linha
        ElseIf cCampo == "LINHA"
            nY := oBrw1:nAt
            If !oBrw1:aCols[nY][nColDel]
                If !fValCampo("PRODUTO",nY,.F.) .Or.;
                !fValCampo("QUANT",nY,.F.) .Or.;
                !fValCampo("ALMOX",nY,.F.) .Or.;
                !fValCampo("ENDEREC",nY,.F.) .Or.;
                !fValCampo("NUMSERI",nY,.F.)
                Return .F.
            EndIf        
        EndIf
    // Valida o campo digitado
    Else
    lRet := fValCampo(cCampo,oBrw1:nAt,.T.)
    EndIf
Return (lRet)
 

Static Function fValCampo(cCampo,nY,lDigitado)

    Local cAlias

    If cCampo == "PRODUTO"
        SB1->(DbSetOrder(1))
        If !SB1->(DbSeek(xFilial("SB1")+If(lDigitado,M->PRODUTO,oBrw1:aCols[nY][nPosProduto]))) .Or. SB1->B1_MSBLQL == "1"
            Aviso("Atenção!","Produto inválido ou bloqueado!",{"OK"})
            Return(.F.)
        EndIf
        If Empty(If(lDigitado,M->PRODUTO,oBrw1:aCols[nY][nPosProduto]))
            Aviso("Atenção!","Preencha o código do produto.",{"OK"})
            Return(.F.)
        EndIf

        If lDigitado
            If M->PRODUTO != oBrw1:aCols[nY][nPosProduto]
                oBrw1:aCols[nY][nPosDesc] := SB1->B1_DESC
                oBrw1:aCols[nY][nPosUnidade] := SB1->B1_UM
                oBrw1:aCols[nY][nPosQuant] := 1
                oBrw1:aCols[nY][nPosAlmox] := SB1->B1_LOCPAD
                oBrw1:aCols[nY][nPosEnderec] := Space(TamSX3("D3_LOCALIZ")[1])
                oBrw1:aCols[nY][nPosNumSeri] := Space(TamSX3("D3_NUMSERI")[1])
            EndIf
        EndIf

    Else
        SB1->(DbSetOrder(1))
        SB1->(DbSeek(xFilial("SB1")+oBrw1:aCols[nY][nPosProduto]))

    EndIf

    If cCampo == "QUANT"
        If If(lDigitado,M->QUANT,oBrw1:aCols[nY][nPosQuant]) <= 0
            Aviso("Atenção!","Preencha a quantidade a ser ajustada.",{"OK"})
            Return(.F.)
        EndIf

        If SB1->B1_LOCALIZ == "S" .And. SB1->B1_XXCSER == "S" .And. If(lDigitado,M->QUANT,oBrw1:aCols[nY][nPosQuant]) > 1
            Aviso("Atenção!","Produto controla número de série. A quantidade não pode ser diferente de 1.",{"OK"})
            Return(.F.)
        EndIf
    EndIf

    If cCampo == "ALMOX"
        If Empty(If(lDigitado,M->ALMOX,oBrw1:aCols[nY][nPosAlmox]))
            Aviso("Atenção!","Digite um local para a entrada.",{"OK"})
            Return(.F.)
        EndIf

        SB2->(DbSetOrder(1)) // B2_FILIAL+B2_COD+B2_LOCAL
        If !SB2->(DbSeek(xFilial("SB2")+oBrw1:aCols[nY][nPosProduto]+If(lDigitado,M->ALMOX,oBrw1:aCols[nY][nPosAlmox])))
            Aviso("Atenção!","Este produto não possui controle de saldo cadastrado neste armazém. Corrija o armazém ou cadastre saldo inicial no estoque.",{"OK"})
            Return(.F.)
        EndIf
    EndIf

    If cCampo == "ENDEREC"
        SBE->(DbSetOrder(1)) // BE_FILIAL+BE_LOCAL+BE_LOCALIZ
        If SB1->B1_LOCALIZ == "S" .And. Empty(If(lDigitado,M->ENDEREC,oBrw1:aCols[nY][nPosEnderec]))
            Aviso("Atenção!","É obrigatória a digitação do endereço pois o produto controla endereçamento.",{"OK"})        Return(.F.)
        ElseIf SB1->B1_LOCALIZ != "S" .And. !Empty(If(lDigitado,M->ENDEREC,oBrw1:aCols[nY][nPosEnderec]))
            Aviso("Atenção!","Não é permitido a digitação do endereço pois o produto não controla endereçamento.",{"OK"})
            Return(.F.)
        ElseIf SB1->B1_LOCALIZ == "S" .And. !Empty(If(lDigitado,M->ENDEREC,oBrw1:aCols[nY][nPosEnderec])) .And. !SBE->(DbSeek(xFilial("SBE")+oBrw1:aCols[nY][nPosAlmox]+If(lDigitado,M->ENDEREC,oBrw1:aCols[nY][nPosEnderec])))
            Aviso("Atenção!","O endereço digitado não existe. Verifique a digitação e o armazém.",{"OK"})
            Return(.F.)
        EndIf
    EndIf

    If cCampo == "NUMSERI"
        If SB1->B1_XXCSER == "S" .And. Empty(If(lDigitado,M->NUMSERI,oBrw1:aCols[nY][nPosNumSeri]))
            Aviso("Atenção!","A digitação do número de série é obrigatória pois o produto controla número de série.",{"OK"})
            Return(.F.)
        ElseIf SB1->B1_XXCSER != "S" .And. !Empty(If(lDigitado,M->NUMSERI,oBrw1:aCols[nY][nPosNumSeri]))
            Aviso("Atenção!","Não é permitida a digitação de número de série pois o produto não controla número de série.",{"OK"})
            Return(.F.)
        ElseIf SB1->B1_XXCSER == "S" .And. !Empty(If(lDigitado,M->NUMSERI,oBrw1:aCols[nY][nPosNumSeri]))
            // Verifica se já digitou o mesmo produto e número de série no grid
            For nX := 1 to Len(oBrw1:aCols)
                If nX != nY .And. !oBrw1:aCols[nX][8]
                    If oBrw1:aCols[nY][nPosProduto]+If(lDigitado,M->NUMSERI,oBrw1:aCols[nY][nPosNumSeri]) == oBrw1:aCols[nX][nPosProduto]+oBrw1:aCols[nX][nPosNumSeri]
                        Aviso("Atenção!","Este número de série já foi lançado na linha "+AllTrim(Str(nX))+".",{"OK"})
                        Return(.F.)
                    EndIf
                EndIf
            Next
            // Verificando se já existe saldo
            SBF->(DbSetOrder(4)) // BF_FILIAL+BF_PRODUTO+BF_NUMSERI
            SBF->(DbSeek(xFilial("SBF")+oBrw1:aCols[nY][nPosProduto]+If(lDigitado,M->NUMSERI,oBrw1:aCols[nY][nPosNumSeri])))

            While !SBF->(Eof()) .And. SBF->(BF_FILIAL+BF_PRODUTO+BF_NUMSERI) == xFilial("SBF")+oBrw1:aCols[nY][nPosProduto]+If(lDigitado,M->NUMSERI,oBrw1:aCols[nY][nPosNumSeri])
                If SBF->BF_QUANT > 0
                    Aviso("Atenção!","A entrada deste número de série não será permitida pois este já se encontra atualmente no estoque da empresa. Armazém "+AllTrim(SBF->BF_LOCAL)+" e endereço "+AllTrim(SBF->BF_LOCALIZ)+".",{"OK"})
                    Return(.F.)
                EndIf
                SBF->(DbSkip())
            End
        EndIf
    EndIf
Return(.T.)

    

Static Function fGrava()
    Processa({||fProcessa1()}, "Aguarde o Processamento …")
Return


Static Function fProcessa1()

    Local nX, nY
    Local cD3Doc
    Local cD3TM := "01"//SuperGetMv("MV_XXTM001",.F.,"001")
    Local aUsuarios := ALLUSERS()
    Private lMsErroAuto := .F.

    nX := aScan(aUsuarios,{|x| x[1][1] == __cUserID})

    If nX > 0
        cUsuario := aUsuarios[nX][1][2]
    EndIf

    BEGIN TRANSACTION
        For nY := 1 to Len(oBrw1:aCols)
            If oBrw1:aCols[nY][8]
                Loop
            EndIf
            // Movimento Interno
            cD3Doc := GetSX8Num("SD3", "D3_DOC")
            aCab := { {"D3_DOC" , cD3Doc , NIL},;
                    {"D3_TM" , cD3TM , NIL},;
                    {"D3_EMISSAO" , dEmissao , NIL}}

            aItem := { {"D3_COD" , oBrw1:aCols[nY][nPosProduto] , NIL},;
            {"D3_QUANT" , oBrw1:aCols[nY][nPosQuant] , NIL},;
            {"D3_UM" , oBrw1:aCols[nY][nPosUnidade] , NIL},;
            {"D3_LOTECTL" , CriaVar("D3_LOTECTL",.F.) , NIL},;
            {"D3_LOCAL" , oBrw1:aCols[nY][nPosAlmox] , NIL},;
            {"D3_LOCALIZ" , CriaVar("D3_LOCALIZ",.F.) , NIL},;
            {"D3_NUMSERI" , CriaVar("D3_NUMSERI",.F.) , NIL},;
            {"D3_USUARIO" , cUsuario , NIL},;
            {"D3_XXFORI" , "XXX999" , NIL}}

            lMsErroAuto := .F.
            MSExecAuto({|x,y,z| MATA241(x,y,z)}, aCab, {aItem}, 3)

            If lMsErroAuto
                MostraErro()
                RollBackSX8()
                DisarmTransaction()
                Return .F.
            EndIf

            ConfirmSX8()
            // Endereçamento
            If !Empty(oBrw1:aCols[nY][nPosEnderec])
                aItem := {}
                aCab:= {{"DA_PRODUTO" ,oBrw1:aCols[nY][nPosProduto] ,NIL},;
                        {"DA_LOCAL" ,oBrw1:aCols[nY][nPosAlmox] ,NIL},;
                        {"DA_NUMSEQ" ,SD3->D3_NUMSEQ ,NIL}}

                aAdd(aItem,{{"DB_ITEM" ,"001" ,NIL},;
                            {"DB_LOCALIZ" ,oBrw1:aCols[nY][nPosEnderec] ,NIL},;
                            {"DB_DATA" ,dEmissao ,NIL},;
                            {"DB_QUANT" ,oBrw1:aCols[nY][nPosQuant] ,NIL},;
                            {"DB_NUMSERI" ,oBrw1:aCols[nY][nPosNumSeri] ,NIL},;
                            {"DB_XXFORI" ,"XXX999" ,NIL}})

                lMsErroAuto := .F.
                MSExecAuto({|x,y,z| MATA265(x,y,z)},aCab,aItem,3) //Distribui

                If lMsErroAuto
                    MostraErro()
                    DisarmTransaction()
                    Return(.F.)
                EndIf
            EndIf
        Next
    END TRANSACTION

    oDlgSep:End()

    Aviso("Sucesso","Entradas de estoque realizadas com sucesso.",{"OK"})
Return
