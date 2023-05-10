#INCLUDE 'Protheus.ch'

/*++++DATA++++|++++AUTOR+++++|++++++++++++++++DESCRIÇÂO+++++++++++++
  27/03/2023  | Filipe Souza | Escopo: No item do documento de entrada, quando o item possuir qtd
                                maior de 4 unidades por item, só poderá ser incluso se for usada alguns TES específicas, 
                                presentes no parâmetro MV_XTESQTD
                                impossibilitando sua alteração no formulário.
                                Foi adicionado na base de dados no campo F1_DOC o inicializador GETXENUM 
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
User function MT100LOK()
    Local lRet      := .T.
    Local cL        :=CHR( 19 )+Chr(13)
    Local cMVTES    :=SUPERGETMV( 'MV_XTESQTD')
    Local nAcolsTes := ASCAN( aHeader, {|x| AllTrim(x[2]) == "D1_TES"})
    Local nAcolsQtd := ASCAN( aHeader, {|x| AllTrim(x[2]) == "D1_QUANT"})
    Local cTES      := aCols[n,nAcolsTes]
    Local nQuant    := aCols[n,nAcolsQtd]

  if nQuant > 4 .AND. !(cTES $ cMVTES)// 003,004,010
    FWAlertWarning('Para quantidades maior que 4, deve-se usar TES específica,'+cL+;
    'Consulte o setor Financeiro.'+cl+;
    'TES:'+cMVTES,'Alerta')
    lRet:=.F.
  endif


RETURN lRet
