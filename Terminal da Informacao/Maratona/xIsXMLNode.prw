#include "TOTVS.ch"
#include "Protheus.ch"

/*££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££
	Data	|	Autor		| Descricao
 25/03/2024 | Filipe Souza  | Classe para criar uma uma navegação de Wizard (com opção de avançar ou retroceder)
 @see https://terminaldeinformacao.com/2024/03/25/validando-se-no-existe-em-um-xml-com-isxmlnode-maratona-advpl-e-tl-315/

£££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££*/   
User Function xIsXMLNode()
    Local aArea      := FWGetArea()
    Local cXML       := ""
    Local oXML
    Local oDetalhes
    Local cAviso     := ""
    Local cErro      := ""
  
    //Monta o XML que será convertido em um Objeto
    cXML := '<?xml version="1.0"?>' + CRLF
    cXML += '<detalhes>' + CRLF
    cXML += '  <nome>Atilio</nome>' + CRLF
    cXML += '  <idade>29</idade>' + CRLF
    cXML += '  <gostaDeLer>sim</gostaDeLer>' + CRLF
    cXML += '  <sites>' + CRLF
    cXML += '    <site item="1">' + CRLF
    cXML += '      <nome>Terminal de Informacao</nome>' + CRLF
    cXML += '      <url>terminaldeinformacao.com</url>' + CRLF
    cXML += '    </site>' + CRLF
    cXML += '    <site item="2">' + CRLF
    cXML += '      <nome>Atilio Sistemas</nome>' + CRLF
    cXML += '      <url>atiliosistemas.com</url>' + CRLF
    cXML += '    </site>' + CRLF
    cXML += '  </sites>' + CRLF
    cXML += '</detalhes>' + CRLF
  
    //Transformando o XML (texto) em um objeto
    oXML := XmlParser(cXML, "_", @cAviso, @cErro)
  
    //Se houve alguma falha
    If ! Empty(cErro)
        FWAlertError("Houve um erro na conversão do texto para objeto: " + cErro, "Falha no 'parse' do XML")
    Else
  
        //Pega a "subtag" de detalhes
        oDetalhes := oXML:_detalhes
  
        //Realizando a procura de tag (similar a XMLChildEx)
        If IsXmlNode(oDetalhes, "_gostaDeLer")
            FWAlertInfo("A tag 'gostaDeLer' foi encontrada no objeto, sendo: " + oDetalhes:_gostaDeLer:TEXT, "Exemplo de IsXmlNode")
        EndIf
  
    EndIf
  
    FWRestArea(aArea)
Return
