#include "TOTVS.CH"

/*++++DATA++++|++++AUTOR+++++|++++++++++++++++DESCRI��O+++++++++++++
  08/11/2024  | Filipe Souza | Fun��o que realiza a importa��o do CSV como Pr� Nota

@see    https://terminaldeinformacao.com/2022/07/11/importacao-de-pre-nota-de-entrada-via-csv-ou-txt-ti-responde-013/
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
User Function xImpPreCsv()
    Local aArea     :=FwGetArea()
    Local cDirIni   :=GetTempPath()
    Local cTipArq   :="Arquivos com Separa��o (*.csv)"
    Local cTitulo   :="Sele��o de arquivos para processamento"
    Local lSalvar   := .F.
    Local cArqSel   :=""

    //se n�o estiver sendo executado via Job
    If !isBlind()
        cArqSel := tFileDialog(;
        cTipArq,;  // Filtragem de tipos de arquivos que ser�o selecionados
        cTitulo,;  // T�tulo da Janela para sele��o dos arquivos
        ,;         // Compatibilidade
        cDirIni,;  // Diret�rio inicial da busca de arquivos
        lSalvar,;  // Se for .T., ser� uma Save Dialog, sen�o ser� Open Dialog
        ;          // Se n�o passar par�metro, ir� pegar apenas 1 arquivo; Se for informado GETF_MULTISELECT ser� poss�vel pegar mais de 1 arquivo; Se for informado GETF_RETDIRECTORY ser� poss�vel selecionar o diret�rio
        )
        //Se tiver o arquivo selecionado e ele existir
        If ! Empty(cArqSel) .And. File(cArqSel)
            Processa({|| fImporta(cArqSel) }, "Importando...")
        EndIf
    EndIf
    FWRestArea(aArea)
Return 


Static Function fImporta(cArqSel)
    Local cDirLog    := GetTempPath()
    Local cArqLog    := "zFat07Im_" + dToS(Date()) + "_" + StrTran(Time(), ':', '-') + ".log"
    Local nTotLinhas := 0
    Local cLinAtu    := ""
    Local nLinhaAtu  := 0
    Local aLinha     := {}
    Local oArquivo
    Local aLinhas
    Local aLinhaSD1 := {}
    Local cItem     := StrTran(Space(TamSX3('D1_ITEM')[01]), ' ', '0')
    //Primeira coluna do Excel, ser� o tipo da linha
    Private nPosTip  := 1 //SF1 ou SD1
    //Posi��es do Cabe�alho (SF1)
    Private nCabTipo := 2 //F1_TIPO
    Private nCabForm := 3 //F1_FORMUL
    Private nCabDocu := 4 //F1_DOC
    Private nCabSeri := 5 //F1_SERIE
    Private nCabEmis := 6 //F1_EMISSAO
    Private nCabForn := 7 //F1_FORNECE
    Private nCabLoja := 8 //F1_LOJA
    Private nCabEspe := 9 //F1_ESPECIE
    Private nCabCond := 10 //F1_COND
    //Posi��es dos Itens (SD1)
    Private nIteProd := 2 //D1_COD
    Private nIteQtde := 3 //D1_QUANT
    Private nIteVUni := 4 //D1_VUNIT
    Private nIteTpES := 5 //D1_TES
    //Vari�veis do ExecAuto
    Private aCabecSF1       := {}
    Private aItensSD1       := {}
    Private lMSHelpAuto     := .T.
    Private lAutoErrNoFile  := .T.
    Private lMsErroAuto     := .F.
    Private cLog            := ""
    Private cChaveSF1       := ""

    DBSelectArea("SF1")
    SF1->(DBSetOrder(1))

    oArquivo    :=FwFileReader():New(cArqSel)
    If (oArquivo:Open())

        If !(oArquivo:Eof())
            aLinhas     := oArquivo:GetAllLines()
            nTotLinhas  := Len(aLinhas)
            ProcRegua(nTotLinhas)
            //M�todo GoTop n�o funciona (dependendo da vers�o da LIB), deve fechar e abrir novamente o arquivo
            oArquivo:Close()
            oArquivo:=FwFileReader():New(cArqSel)
            oArquivo:Open()

            //iniciando a transa��o
            Begin Transaction
                while (oArquivo:HasLine())
                    nLinhaAtu++
                    IncProc("Analisando linha " + cValToChar(nLinhaAtu) + " de " + cValToChar(nTotLinhas) + "...")
                     
                    //Pegando a linha atual e transformando em array
                    cLinAtu := oArquivo:GetLine()
                    aLinha  := StrTokArr(cLinAtu, ";")
                    
                    //se houver posi��es no array
                    If len(aLinha) >0
                        If Upper(aLinha[nPosTip])=="SF1"
                            fPreNota()/*---------------------------------*/

                            aCabecSF1:={}
                            aItensSD1:={}
                            cItem    :=StrTran(Space(TamSX3('D1_ITEM')[01]),' ','0')
                            cChaveSF1:=""
                            //Se tiver o mesmo numero de colunas, adiciona no array da sf1, e monta a chave que ser� pesquisada no seek
                            //If Len(aLinha) == nCabCond
                                //Transforma a data
                                If "/" $ aLinha[nCabEmis]
                                    aLinha[nCabEmis] := cToD(aLinha[nCabEmis])
                                Else
                                    aLinha[nCabEmis] := sToD(aLinha[nCabEmis])
                                EndIf
                                aLinha[nCabTipo] := PadR(aLinha[nCabTipo], TamSX3("F1_TIPO")[1], ' ')
                                aLinha[nCabForm] := PadR(aLinha[nCabForm], TamSX3("F1_FORMUL")[1], ' ')
                                aLinha[nCabDocu] := PadL(aLinha[nCabDocu], TamSX3("F1_DOC")[1], '0')
                                aLinha[nCabSeri] := PadR(aLinha[nCabSeri], TamSX3("F1_SERIE")[1], ' ')
                                aLinha[nCabForn] := PadL(aLinha[nCabForn], TamSX3("F1_FORNECE")[1], '0')
                                aLinha[nCabLoja] := PadL(aLinha[nCabLoja], TamSX3("F1_LOJA")[1], '0')
                                

                                aAdd(aCabecSF1, {"F1_TIPO"    , aLinha[nCabTipo] , Nil})
                                aAdd(aCabecSF1, {"F1_FORMUL"  , aLinha[nCabForm] , Nil})
                                aAdd(aCabecSF1, {"F1_DOC"     , aLinha[nCabDocu] , Nil})
                                aAdd(aCabecSF1, {"F1_SERIE"   , aLinha[nCabSeri] , Nil})
                                aAdd(aCabecSF1, {"F1_EMISSAO" , aLinha[nCabEmis] , Nil})
                                aAdd(aCabecSF1, {"F1_FORNECE" , aLinha[nCabForn] , Nil})
                                aAdd(aCabecSF1, {"F1_LOJA"    , aLinha[nCabLoja] , Nil})
                                aAdd(aCabecSF1, {"F1_ESPECIE" , aLinha[nCabEspe] , Nil})
                                aAdd(aCabecSF1, {"F1_COND"    , aLinha[nCabCond] , Nil})
 
                                cChaveSF1 := FWxFilial("SF1") +;
                                    PadL(aLinha[nCabDocu], TamSX3("F1_DOC")[1], '0') +;
                                    PadR(aLinha[nCabSeri], TamSX3("F1_SERIE")[1], ' ') +;
                                    PadL(aLinha[nCabForn], TamSX3("F1_FORNECE")[1], '0') +;
                                    PadR(aLinha[nCabLoja], TamSX3("F1_LOJA")[1], '0') +;
                                    PadR(aLinha[nCabTipo], TamSX3("F1_TIPO")[1], ' ')
                            //EndIf
                         //Se for itens (e tiver todas as posi��es)
                        ElseIf Upper(aLinha[nPosTip]) == "SD1" //.And. Len(aLinha) == nIteTpES
                            //Campos num�ricos, retira ponto, transforma v�rgula em ponto e converte para num�rico
                            aLinha[nIteQtde] := Alltrim(aLinha[nIteQtde])
                            aLinha[nIteQtde] := StrTran(aLinha[nIteQtde], ".", "")
                            aLinha[nIteQtde] := StrTran(aLinha[nIteQtde], ",", ".")
                            aLinha[nIteQtde] := Val(aLinha[nIteQtde])
                            aLinha[nIteVUni] := Alltrim(aLinha[nIteVUni])
                            aLinha[nIteVUni] := StrTran(aLinha[nIteVUni], ".", "")
                            aLinha[nIteVUni] := StrTran(aLinha[nIteVUni], ",", ".")
                            aLinha[nIteVUni] := Val(aLinha[nIteVUni])
 
                            //Adiciona no array de Itens
                            cItem := Soma1(cItem)
                            aLinhaSD1 := {}
                            aAdd(aLinhaSD1, {"D1_ITEM"  , cItem                               , Nil} )
                            aAdd(aLinhaSD1, {"D1_COD"   , aLinha[nIteProd]                    , Nil} )
                            aAdd(aLinhaSD1, {"D1_QUANT" , aLinha[nIteQtde]                    , Nil} )
                            aAdd(aLinhaSD1, {"D1_VUNIT" , aLinha[nIteVUni]                    , Nil} )
                            aAdd(aLinhaSD1, {"D1_TOTAL" , aLinha[nIteQtde] * aLinha[nIteVUni] , Nil} )
                            aAdd(aLinhaSD1, {"D1_TES"   , aLinha[nIteTpES]                    , Nil} )
                            aAdd(aItensSD1, aClone(aLinhaSD1))    
                        EndIf
                    EndIf
                enddo
                 //Chama novamente a rotina de pr�-nota pois pode ser que sobrou um cabec e itens para processar
                fPreNota()
            End Transaction
            //Se tiver log, mostra ele
            If ! Empty(cLog)
                MemoWrite(cDirLog + cArqLog, cLog)
                ShellExecute("OPEN", cArqLog, "", cDirLog, 1)
            EndIf
        Else
            MsgStop("Arquivo n�o tem conte�do!", "Aten��o")    
        EndIf
        //Fecha o arquivo
        oArquivo:Close()
    Else
        MsgStop("Arquivo n�o pode ser aberto!", "Aten��o")
        
    EndIf
    

return    

Static Function fPreNota()
    Local cPastaErro := ""
    Local cNomeErro  := ""
    Local cTextoErro := ""
    Local aLogErro   := {}
    Local nLinhaErro := 0
 
    //Se tiver cabe�alho e itens
    If Len(aCabecSF1) > 0 .And. Len(aItensSD1) > 0
        //Se conseguir posicionar na nota, grava no log que j� existe
        If SF1->(MsSeek(cChaveSF1))
            cLog += "- NF j� existe na base, chave de pesquisa: " + cChaveSF1 + CRLF
 
        //Aciona o ExecAuto
        Else
            lMsErroAuto := .F.
            MSExecAuto({|x, y, z| MATA140(x, y, z)}, aCabecSF1, aItensSD1, 3)
             
            //Se houve erro, gera o log
            If lMsErroAuto
                cPastaErro := "\x_logs\"
                cNomeErro  := "pre_nota_" + dToS(Date()) + "_" + StrTran(Time(), ":", "-") + ".txt"
 
                //Se a pasta de erro n�o existir, cria ela
                If ! ExistDir(cPastaErro)
                    MakeDir(cPastaErro)
                EndIf
 
                //Pegando log do ExecAuto, percorrendo e incrementando o texto
                aLogErro := GetAutoGRLog()
                For nLinhaErro := 1 To Len(aLogErro)
                    cTextoErro += aLogErro[nLinhaErro] + CRLF
                Next
                 
                //Criando o arquivo txt e incrementa o log
                MemoWrite(cPastaErro + cNomeErro, cTextoErro)
                cLog += "- Falha ao incluir NF, chave de pesquisa: " + cChaveSF1 + ", arquivo de log em '" + cPastaErro + cNomeErro + "' " + CRLF
            Else
                cLog += "- NF incluida como pr�-nota, chave de pesquisa: " + cChaveSF1 + CRLF
            EndIf
        EndIf
    EndIf
Return
