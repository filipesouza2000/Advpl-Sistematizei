#INCLUDE 'PROTHEUS.ch'
#INCLUDE 'parmtype.ch'

/*++++DATA++++|++++AUTOR+++++|++++++++++++++++DESCRIÇÂO+++++++++++++
  10/10/2022  | Filipe Souza | Modelo 1 convencional
                              O AxCadastro() é uma funcionalidade de cadastro simples, com poucas opções de
                              customização, a qual é composta de:
                              -Browse padrão para visualização das informações da base de dados, de acordo com as
                              configurações do SX3 – Dicionário de Dados (campo browse).
                              -Funções de pesquisa, visualização, inclusão, alteração e exclusão padrões para
                              visualização de registros simples, sem a opção de cabeçalho e itens.
                              -Sintaxe: AxCadastro(cAlias, cTitulo, cVldExc, cVldAlt)
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/

User Function xModelo1()
       
    AxCadastro("SB1", "Produtos - Modelo 1",".T.",".T.")
RETURN

