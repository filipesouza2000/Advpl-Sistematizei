SELECT	A1_FILIAL,A1_COD, A1_NOME, ZD4_CLI,ZD4_COD,ZD4_NOME
FROM	SA1990 A1 INNER JOIN ZD4990 D4
ON		A1.A1_COD=D4.ZD4_CLI AND A1.D_E_L_E_T_ = D4.D_E_L_E_T_
WHERE	A1.D_E_L_E_T_ = ''

SELECT	DISTINCT(ZD4_CLI) as ZD4_CLI
FROM	ZD4990

Select * FROM	ZD5990 WHERE D_E_L_E_T_ ='' and ZD5_COD ='000000008'
SELECT * FROM SB1990 WHERE D_E_L_E_T_='' and B1_TIPO='CD' and B1_COD = 'CD00000081'
Select * FROM	ZD3990 WHERE D_E_L_E_T_ ='' and ZD3_CODCD = 'CD00000081'


