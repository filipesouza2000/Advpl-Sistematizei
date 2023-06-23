#INCLUDE 'protheus.ch'
#INCLUDE "TopConn.ch"
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
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/

User Function procXML()
    Local oXml
    Local lRead     :=.F.
    Local cL        :=Chr(10)+Chr(13)
    Local aIde      :={}
    Local aEmit     :={}
    Local nX
    Local aArea     := GetArea()
    Local cXMl,cCodF, cLojaF,cCNPJ,cNota ,cSerie ,ckey, cQuery,cWhere,cTp

    cXMl := cGetFile('*.xml','Buscar arquivo XML',0,'C:\TOTVS12133\Protheus\protheus_data\xmlnfe\new',.F.,GETF_LOCALHARD + GETF_NOCHANGEDIR,.T.)
    If cXMl == '' .OR. cXMl == nil
        FWAlertError("Xml não selecionado ","XMl Info erro")
    else
        oXml := TXmlManager():New()
        lRead := oXml:Parse(MemoRead(cXml))
        If lRead == .F.
            FWAlertError('Erro na leitura'+cL+oXML:Error(),'Error')
            return
        EndIf
        oXML :DOMChildNode()//<NFe
        oXML :DOMChildNode()//<infNFe
        ckey := oXml:DOMGetAtt('Id')//chave da nfe
        oXML :DOMChildNode()//<ide
        aIde := oXML:DOMGetChildArray()
        For nX:= 1 to Len(aIde)
            If UPPER(aIde[nX][1])=='SERIE'
                cSerie := aIde[nX][2]
            ELSEIF UPPER(aIde[nX][1])=='NNF'
                cNota  := aIde[nX][2]
            ELSEIF UPPER(aIde[nX][1])=='TPNF'
                cTp    := aIde[nX][2]
            EndIf            
        Next
        oXML:DOMPrevNode()
        oXML:DOMNextNode()//<emit
        aEmit := oXML:DOMGetChildArray()
        For nX:= 1 to Len(aEmit)
            If UPPER(aEmit[nX][1])=='CNPJ'
                cCNPJ := aEmit[nX][2]            
            EndIf            
        Next

        //-Utilizar o CNPJ para procurar o cadastro do fornecedor (SA2). A2_CGC 14   A2_COD  6    
        /*DBSelectArea("SA2")
        SA2->(DbSetOrder(3))// A2_FILIAL + A2_CGC
        If !SA2->(DBSEEK(xFilial('SA2')+cCNPJ))
            MSGALERT( "Fornecedor não econtrado com CGC:"+cCNPJ +cL+;
                    "Será preciso efetuar seu registro.", "Erro na importação XML" )
        EndIf*/
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
            A2->(DBCloseArea())
            return
        EndIf    
        A2->(DBCloseArea())
        //procurar no documento de entrada (SF1)
        //F1 order 1 Filial+Doc+Serie+Fornece+Loja+Tipo
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

        IF Alltrim(F1_DOC) != ''
            FWAlertWarning( "Já existe documento de entrada com o número "+cNota, "Importação de XML" )
        else
            FWAlertSuccess( "Documento de entrada "+cNota+cL+"registrado com sucesso.", "Importação de XML" )
        endif    
        (cF1)->(DBCloseArea())
         
    EndIf  
    RestArea(aArea)
return 
