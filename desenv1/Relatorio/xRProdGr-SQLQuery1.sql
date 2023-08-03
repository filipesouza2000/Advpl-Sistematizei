SELECT	B1.B1_COD , B1.B1_DESC, B1.B1_GRUPO, BM.BM_DESC
FROM	SB1990    as B1
INNER JOIN SBM990 as BM
ON		B1.B1_GRUPO = BM.BM_GRUPO
AND		B1.D_E_L_E_T_ = BM.D_E_L_E_T_
WHERE	B1.D_E_L_E_T_ =''
AND		B1.B1_COD BETWEEN '' AND 'CZCA000058'
AND		B1.B1_MSBLQL != '1'
ORDER By B1.B1_COD