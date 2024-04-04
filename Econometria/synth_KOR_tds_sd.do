clear

ssc install synth

import excel using "C:\Users\jcase\OneDrive\Joao\Insper\6 semestre\Problemas em Economia\Econometria\Estimacao\Viscondao.xlsx", sheet("PEEXKOR") firstrow clear

tsset country_id year

egen tratamento_2001 = total(year == 2001) if China_entrada_OMC == 1

synth wage cresc_GDP n Price_to_c_index exports imports dot_K dot_L unemployment wage(2000) wage(1999) wage(1998) wage(1997), trunit(1) trperiod(2001) xperiod(1997(1)2000) fig

*KOR, todos os países, todas as variáveis