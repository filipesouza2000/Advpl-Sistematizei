#INCLUDE 'protheus.ch'
#INCLUDE "TopConn.ch"
#INCLUDE "XMLXFUN.CH"
#INCLUDE 'totvs.ch'

/*++++DATA++++|++++AUTOR+++++|++++++++++++++++DESCRIÇÂO+++++++++++++
  22/06/2023  | Filipe Souza |  Exercício ConexãoNF-e:
                                Desenvolver um programa que tenha a função de processar um arquivo XML e 
                                retornar para o usuário se o documento de entrada está ou não lançado no Protheus.  
    Requisitos
    -O programa deve solicitar o arquivo XML para o usuário por meio da função cGetFile (utilizar como exemplo o arquivo: 99221704876700009490006008031800463126653400-nfe.xml). 
    -Após capturar o arquivo, processar o conteúdo do XML utilizando a classe TXmlManager. 
    -Capturar número, série e CNPJ do emissor do XML. 
    -Utilizar o CNPJ para procurar o cadastro do fornecedor (SA2). 
    -Com o código e loja do fornecedor, procurar no documento de entrada (SF1) se existe um registro com o mesmo número, série, fornecedor e loja (utilizar TCGenQry ou BeginSql nas buscas de fornecedor e documento de entrada). 
    -No final, apresentar um alerta indicando se foi ou não encontrado o documento de entrada.
  __________________________________________________________________________
  15/07/2024  | Filipe Souza |  Nova estrutura de leitura do xml, formando json
                                Identificar existencia do Nó, por oXml:CNAME
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/

User Function procXML()
    RpcSetEnv("99","01",,,"COM")
    Local oXml,oJson
    Local lRead     :=.F.
    Local cL        :=Chr(10)+Chr(13)
    Local aIde      :={}
    Local aEmit     :={}
    Local aForn     :={}
    Local aArea     := GetArea()
    Local cXMl,cCodF, cLojaF,cCNPJ,cNota ,cSerie ,ckey,cTp,cDoc,cWhere
    Local cJson     :=''
    Local cError    :=''
    Local nX        :=0
    Local lIde      :=.F.
    Local lEmit     :=.F.

    cXMl := cGetFile('*.xml','Buscar arquivo XML',0,'C:\TOTVS12133\Protheus\protheus_data\xmlnfe\new',.F.,GETF_LOCALHARD + GETF_NOCHANGEDIR,.T.)
    If cXMl == '' .OR. cXMl == nil
        FWAlertError("Xml não selecionado ","XMl Info erro")
        return
    else
        oXml := TXmlManager():New()
        lRead := oXml:Parse(MemoRead(cXml))
        If lRead == .F.
            FWAlertError('Erro na leitura'+cL+oXML:Error(),'Error')
            return
        EndIf
         //nfeProc
        for nX := 1 to oXML:DOMChildCount()// para cada nó filho
            iif(nX==1, oXML:DOMChildNode(),)          
            If oXml:CNAME == "NFe"
                exit 
            else
                if oXML:DOMHasNextNode()
                    oXML:DOMNextNode()
                else
                    FWAlertError("-Estrutura XML incompleta, <NFe> inexistente")
                    return
                endif                            
            EndIf            
        next nX
        //NFe
        for nX := 1 to oXML:DOMChildCount()// para cada nó filho
            iif(nX==1, oXML:DOMChildNode(),)          
            If oXml:CNAME == "infNFe"
                ckey := oXml:DOMGetAtt('Id')//chave da nfe
                exit 
            else
                if oXML:DOMHasNextNode()
                    oXML:DOMNextNode()
                else
                    FWAlertError("-Estrutura XML incompleta, <infNFe> inexistente")
                    return
                endif                            
            EndIf            
        next nX
        //infNFe
        for nX := 1 to oXML:DOMChildCount()// para cada nó filho
            iif(nX==1, oXML:DOMChildNode(),)          
            If oXml:CNAME == "ide"
                cError:=''
                cJson :=''
                FreeObj(oJson)
                aIde    := oXML:DOMGetChildArray()
                cJson   :=arrToJson(aIde)
                oJson   := JsonObject():New()
                cError  := oJson:FromJson(cJson)
                lIde:=.T. 
                 //ide
                IF Empty(cError)
                    if oJson:hasProperty('serie')
                        cSerie := oJson:GetJsonObject('serie')
                    else
                        FWAlertError("-Estrutura XML incompleta, <serie> inexistente")
                        return
                    endif 
                    if  oJson:hasProperty('nnf')
                        cNota := oJson:GetJsonObject('nnf')
                    else
                        FWAlertError("-Estrutura XML incompleta, <nnf> inexistente")
                        return
                    endif     
                    if  oJson:hasProperty('tpnf')
                        cTp := oJson:GetJsonObject('tpnf')
                    else
                        FWAlertError("-Estrutura XML incompleta, <tpnf> inexistente")
                        return
                    endif  
                            
                else
                    FWAlertError(cError)
                    return
                endif 
                if oXML:DOMHasNextNode()
                    oXML:DOMNextNode() 
                else 
                    exit
                endif    
            elseif oXml:CNAME == "emit"
                cError:=''
                cJson :=''
                FreeObj(oJson)
                aEmit   := oXML:DOMGetChildArray()
                cJson   :=arrToJson(aEmit)
                oJson   := JsonObject():New()
                cError  := oJson:FromJson(cJson)
                lEmit:=.T.
                IF Empty(cError)
                    if oJson:hasProperty('cnpj')
                        cCNPJ := oJson:GetJsonObject('cnpj')
                    else
                        FWAlertError("-Estrutura XML incompleta, <cnpj> inexistente")
                        return
                    endif            
                else
                    FWAlertError(cError)
                    return
                endif 
                if oXML:DOMHasNextNode()
                    oXML:DOMNextNode() 
                else 
                    exit
                endif 
            else
                if oXML:DOMHasNextNode()
                    oXML:DOMNextNode()
                else
                    If !lIde
                        FWAlertError("-Estrutura XML incompleta, <ide> inexistente") 
                        return   
                    EndIf                    
                    If !lEmit
                        FWAlertError("-Estrutura XML incompleta, <emit> inexistente") 
                        return   
                    EndIf
                    
                endif                            
            EndIf            
        next nX
        /*
            aForn := GetAdvFVal("SA2", {"A2_COD","A2_LOJA"}, xFilial('SA2')+cCNPJ, 3, {"",""})
            cCodF :=''
            cLojaF:=''        
            If Len(aForn)>0
                cCodF := aForn[1]
                cLojaF:= aForn[2]
            EndIf
        */
        cQuery := "SELECT A2_COD,A2_LOJA "
        cQuery += " FROM "+RetSqlName("SA2")
        cQuery += " WHERE D_E_L_E_T_ = '' AND A2_FILIAl ='"+ FwXFilial('SA2')+ "' AND A2_CGC = '"+cCNPJ+"'"
        
        cQuery:= ChangeQuery(cQuery)   
        DBUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),'A2',.F.,.T.)
        cCodF :=''
        cLojaF:=''
        If A2->(!EOF())
            cCodF := Alltrim(A2->A2_COD)
            cLojaF:= Alltrim(A2->A2_LOJA)
            A2->(DBSKIP())
        EndIf
        If Alltrim(cCodF)=='' .AND. Alltrim(cLojaF)==''
            FWAlertWarning( "Fornecedor não econtrado com CGC:"+cCNPJ +cL+;
                    "Será preciso efetuar seu registro.", "Erro na importação XML" )
            return
        EndIf    
        //procurar no documento de entrada (SF1)
        //F1 order 1 Filial+Doc+Serie+Fornece+Loja+Tipo
        //cDoc :=Posicione("SF1", 1, xFilial("SF1")+cNota+cSerie+cCodF+cLojaF+cTp, "F1_DOC")
       
        cWhere :=" AND F1_FILIAL = '"+ FwXFilial("SF1")+"' AND F1_DOC='"+cNota+"' AND F1_SERIE = '"+cSerie+"'"+cL+;
                " AND F1_FORNECE = '"+cCodF+"' AND F1_LOJA='"+cLojaF+"' AND F1_TIPO='"+cTp+"' "
        cWhere := "%"+cWhere+"%"
        
        cF1 := GetNextAlias()
        BeginSql Alias cF1
            SELECT  F1_DOC
            FROM	%table:SF1%  F1
            WHERE   F1.%NOTDEL%
            %exp:cwhere%
        EndSql         
        cDoc:=F1_DOC

        IF !Empty(Alltrim(cDoc))
            FWAlertWarning( "Já existe documento de entrada com o número "+cNota, "Importação de XML" )
        else
            FWAlertSuccess( "Documento de entrada "+cNota+cL+"registrado com sucesso.", "Importação de XML" )
        endif    
         
    EndIf  
    FreeObj(oJson)
    RestArea(aArea)
return 
