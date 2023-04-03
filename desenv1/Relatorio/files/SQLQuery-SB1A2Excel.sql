/*
SELECT B1_COD , B1_DESC ,B1_TIPO ,B1_UM, A2_COD , A2_LOJA , A2_NREDUZ , A2_TIPO , A2_EST , A2_MUN 
FROM SB1990 SB1 
INNER JOIN SA5990 SA5
ON SB1.B1_COD = SA5.A5_PRODUTO AND SB1.D_E_L_E_T_ = SA5.D_E_L_E_T_
INNER JOIN SA2990 SA2
ON SA5.A5_FORNECE = SA2.A2_COD AND SA2.D_E_L_E_T_ = SA5.D_E_L_E_T_
WHERE SA5.D_E_L_E_T_ = ''
*/

SELECT		Z7_NUM,Z7_FORNECE,A2_COD, A2_NOME, Z7_EMISSAO,Z7_PRODUTO,B1_DESC,Z7_QUANT,Z7_PRECO,Z7_TOTAL
FROM		SZ7990 Z7 
INNER JOIN	SA2990 A2
ON	Z7.Z7_LOJA   = A2.A2_LOJA
--AND Z7.Z7_FILIAL = A2.A2_FILIAL
AND Z7.Z7_FORNECE= A2.A2_COD
AND Z7.D_E_L_E_T_ = A2.D_E_L_E_T_
INNER JOIN SB1990 B1
ON B1_COD = Z7_PRODUTO
WHERE A2.D_E_L_E_T_ = ''

SELECT  C5.C5_NUM, A1_NOME, C5_EMISSAO, C6_PRODUTO, C6_QTDVEN, C6_VALOR
FROM	SC5990 C5
INNER JOIN SC6990 C6 
ON		C5.C5_FILIAL = C6.C6_FILIAL AND C5.C5_NUM = C6.C6_NUM AND C5.C5_SERIE = C6.C6_SERIE AND C5.D_E_L_E_T_ = C6.D_E_L_E_T_
INNER JOIN SA1990 A1
ON		C5.C5_CLIENTE = A1.A1_COD AND C5.C5_LOJACLI = A1.A1_LOJA AND C5.D_E_L_E_T_= A1.D_E_L_E_T_
WHERE	C5.D_E_L_E_T_ = ''

SELECT B1_COD, B1_DESC, B1_GRUPO, B1_TIPO, B2_QATU, B2_VATU1
FROM SB2990 B2 
INNER JOIN SB1990 B1
ON B2.B2_COD = B1.B1_COD AND B1.D_E_L_E_T_ = B2.D_E_L_E_T_
WHERE B1.D_E_L_E_T_ = ''
AND B1.B1_COD BETWEEN '' AND 'zzzz'

--SELECT * FROM SC5990
--SELECT * FROM SC6990
--SELECT * FROM SA1990
--SELECT  * FROM SB1990 order by R_E_C_N_O_ desc
--SELECT * FROM SB2990
select count(*) from information_schema.columns
Where Table_Name='SB1990'

SELECT MAX(R_E_C_N_O_) FROM SB1990
