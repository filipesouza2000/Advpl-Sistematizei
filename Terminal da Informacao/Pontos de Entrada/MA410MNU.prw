#INCLUDE 'Protheus.ch'

/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
---Data---|-----Autor-------|-------Descrição------------
10/03/2023| Filipe Souza    | 05 -PE Adicionar botões no menu do browse
                                Ponto de entrada disparado antes da abertura do Browse
                                Este ponto de entrada pode ser utilizado para inserir novas opções no array aRotina.



@see Terminal da Informação
Pontos de Entrada na rotina "Pedidos de Venda (MATA410)"
@see https://centraldeatendimento.totvs.com/hc/pt-br/articles/7381576110871-Cross-Segmentos-Backoffice-Protheus-SIGAFAT-Pontos-de-Entrada-na-rotina-Pedidos-de-Venda-MATA410
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
*/
User Function MA410MNU()
    Local aArea     := FwGetArea()
/*  1. Nome a aparecer no cabecalho, 2. Nome da Rotina associada, 3. Reservado, 
    4. Tipo de Transação a ser efetuada:
            1 - Pesquisa e Posiciona em um Banco de Dados      
            2 - Simplesmente Mostra os Campos                  
            3 - Inclui registros no Bancos de Dados            
            4 - Altera o registro corrente                     
            5 - Remove o registro corrente do Banco de Dados 
    5. Nivel de acesso                                  
    6. Habilita Menu Funcional
*/    
    aadd(aRotina,{"*Ponto de entrada","U_xPeMnu()",0,2,0,Nil})
    FwRestArea(aArea)
return

//Função adicionada no Outras Ações do browse do Pedido de Vendas
User Function xPeMnu()
    Local aArea     := FwGetArea()
    Local cMsg      :=""
    
    FWAlertInfo("05 -PE Adicionar botões no menu do browse, MA410MNU","Ponto de entrada")
    cMsg:="Está posicionado no pedido - "+ SC5->C5_NUM  + CRLF
    cMsg+="Emissão: "+ DTOC(SC5->C5_EMISSAO) + CRLF
    cMsg+="Cliente: "+ SC5->C5_CLIENTE + " - "+ Posicione('SA1',1,FwxFilial('SA1')+SC5->C5_CLIENTE+SC5->C5_LOJACLI,'A1_NREDUZ') +CRLF
    //funções que exibem uma tela de visualização de Logs
    //Exemplo usando a ShowLog (só manda texto, sem opção de alterar título)
    ShowLog(cMsg)
    //Exemplo usando a AtShowLog (além do texto, é possível enviar o título, se vai ter rolagem vertical, rolagem horizontal, se vai quebrar palavras ao trocar de linha e por último se terá botão de cancelar)
    //Nesse caso, também é possível capturar o retorno da AtShowLog, se o usuário clicar no Ok retorna .T. ou se clicar no Cancelar retorna .F.
    AtShowLog(cMsg, "AtShowLog", /*lVScroll*/, /*lHScroll*/, /*lWrdWrap*/, .T./*lCancel*/)
 
    //Exemplo usando a AutoGrLog junto com a MostraErro, sendo que além de exibir o log, também é possível salvar ele em um arquivo direto clicando em botão
    AutoGrLog(cMsg)
    MostraErro()

    FwRestArea(aArea)

return
