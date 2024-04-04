* 1. Loop through all units and store the results of synth via the keep option.

* load dataset
clear
ssc install synth
import excel using "C:\Users\jcase\OneDrive\Joao\Insper\6 semestre\Problemas em Economia\Econometria\Estimacao\Viscondao.xlsx", sheet("PEE1TWN") firstrow clear

** tsset

tsset country_id year
egen tratamento_2001 = total(year == 2001) if China_entrada_OMC == 1

** loop through units

forvalues i = 1/34 {
    
    qui synth wage cresc_GDP n Price_to_c_index exports imports dot_K dot_L unemployment wage(2000) wage(1999) wage(1998) wage(1997), trunit(`i') trperiod(2001) xperiod(1997(1)2000) keep(test`i',replace)
}

**********************************************************************

* 2. Now I loop through all saved datasets and create the relevant variables (years and treatment effect). Furthermore, I drop missing observations.

forval i=1/34{

use test`i', clear

rename _time years

gen tr_effect_`i' = _Y_treated - _Y_synthetic

keep years tr_effect_`i'

drop if missing(years)

save test`i', replace
}

**********************************************************************


* 3. Now I load the first dataset and merge all the remaining datasets.

use test1, clear

forval i=1/34{

qui merge 1:1 years using test`i', nogenerate
}

**********************************************************************


* 4. Now the dataset should consist of 40 variables. One named "years" and 34 variables *with the treatment effect of the respective unit. To plot these variables in one graph, I *use a solution offered by Nicholas J. Cox (see *http://www.stata.com/statalist/archi.../msg01370.html) to plot all the lines with one *color. Then I add HKG (unit = 1) with a different color to the plot.

local lp

forval i=1/34 {
   local lp `lp' line tr_effect_`i' years, lcolor(gs12) ||
}
*

* create plot

twoway `lp' || line tr_effect_1 years, ///
lcolor(orange) legend(off) xline(2001, lpattern(dash))

**********************************************************************

*5. Test statistics

clear
ssc install synth
import excel using "C:\Users\jcase\OneDrive\Joao\Insper\6 semestre\Problemas em Economia\Econometria\Estimacao\Viscondao.xlsx", sheet("PEE1TWN") firstrow clear

tsset country_id year
egen tratamento_2001 = total(year == 2001) if China_entrada_OMC == 1


* Defina as variáveis de interesse e controle (substitua com suas variáveis)
global Y "wage"
global X "cresc_GDP n Price_to_c_index exports imports dot_K dot_L unemployment wage(2000) wage(1999) wage(1998) wage(1997)"

* Execute o teste de placebo com synth_runner
synth_runner $Y $X, trunit(1) trperiod(2001) gen_vars

single_treatment_graphs, do_color(gray%15)
effect_graphs
pval_graphs
