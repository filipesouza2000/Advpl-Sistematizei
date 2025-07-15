#INCLUDE 'Protheus.ch'
#INCLUDE 'TOTVS.ch'

/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
---Data---|-----Autor-------|-------Descrição------------
10/03/2023| Filipe Souza    | 10 - PE antes da gravação, Gravação das alterações
                                Gerar log com informações alteradas

@see Terminal da Informação
Pontos de Entrada na rotina "Pedidos de Venda (MATA410)"
@see https://centraldeatendimento.totvs.com/hc/pt-br/articles/7381576110871-Cross-Segmentos-Backoffice-Protheus-SIGAFAT-Pontos-de-Entrada-na-rotina-Pedidos-de-Venda-MATA410
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
*/
User Function M410AGRV()
    Local aArea     := FwGetArea()
    Local nOption   :=Paramixb[1]
    Local cPasta    :="C:\TOTVS12133\Protheus\protheus_data\x_logs\"
    Local cFile     :=""
    Local cMsg      :=""
    Local aCampos   :={"C5_VEND1","C5_TRANSP","C5_MENNOTA"}
    Local nAtual    :=0
    Local cCampoAtu :=""
    Local cAntes    :=""
    Local cDepois    :=""
    Local oLogGen

    //se ALTERA, verifica se algum campo foi altedao para gravar no log.
    If nOption==2
        //se a pasta não existir, cria ela
        If !ExistDir(cPasta)
            MakeDir(cPasta)
        EndIf
        //nome do arquivo: filial + pedido +data + hora
        cFile:= SC5->C5_FILIAL+SC5->C5_NUM+"_"+DToS(Date())+"_"+StrTran(Time(),":","-")+".log"
        
        //percorre os campos que serão validados
        for nAtual := 1 to Len(aCampos)
            cCampoAtu:=aCampos[nAtual]
            cAntes   :=&("SC5->"+cCampoAtu)
            cDepois  :=&("M->"  +cCampoAtu)

            //se o campo estiver diferente, incrementa o log
            If cAntes!= cDepois
                cMsg+="Campo ["+cCampoAtu+"]"+CRLF 
                cMsg+="+ Antes: '"+cAntes+ "'" +CRLF
                cMsg+="+ Depois:'"+cDepois+"'" +CRLF
                cMsg+= CRLF
            EndIf            
        next
        If !Empty(cMsg)
            //cria o log
            oLogGen:=xLogGeneric():New(cPasta,cFile,.F.,.F.)
            oLogGen:addText(cMsg)
            oLogGen:Finish()
        EndIf

    EndIf
    



    FwRestArea(aArea)    
return 
