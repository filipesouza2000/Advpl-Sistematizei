#INCLUDE 'Protheus.ch'

/*++++DATA++++|++++AUTOR+++++|++++++++++++++++DESCRIÇÂO+++++++++++++
  27/03/2023  | Filipe Souza | Escopo: Pedido de venda não aceitar quantidade > 10 unidades por item de produto, C6_QTDVEN
                               Validar para não inserir produto igual já existende 
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/

User Function M410LIOK()
    Local lRet      := .T.
    Local cL        :=CHR( 19 )+Chr(13)
    Local nAcolsQtd := ASCAN( aHeader, {|x| AllTrim(x[2]) == "C6_QTDVEN"})
    Local nQuant    := aCols[n,nAcolsQtd]
    Local nAcolsProd:= ASCAN( aHeader, {|x| Alltrim(x[2]) == "C6_PRODUTO"} )
    Local cCodProd  := aCols[n,nAcolsProd]
    Local nColItem  := ASCAN( aHeader, {|x| AllTrim(x[2]) == "C6_ITEM"})
    Local cItem     := aCols[n,nColItem]
    Local nCount    :=0
    Local nIguais   :=0

    For nCount:= 1 to Len(aCols)
      if aCols[nCount,nAcolsProd] = cCodProd
        nIguais ++      
      endif  
    Next

    if nIguais > 1
      lRet:=.F.
      FWAlertWarning('Não é permitido colocar produtos iguais no mesmo pedido.'+cL+;
      'Item : '+cItem +'  '+ cCodProd ,'Operação não permitida.')
    elseif nQuant > 10
      FWAlertWarning('Não é permitido item do pedido maior que 10 unidades!'+cL+;
      'Item : '+cItem +'  '+ cCodProd +'  '+ Str(nQuant)  ,'Operação não permitida.')
      lRet:=.F.
  endif
return lRet
