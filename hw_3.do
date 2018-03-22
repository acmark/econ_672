*Question 3 Monte Carlo Exercise
cd /Users/aaronmarkiewitz/Documents/research/stata/econ_672

clear all
postutil clear
tempfile monte
tempfile monte_full
set seed 672
local b1 0.4
local b2 0.9

set obs 1000
gen n = _n 
save `monte_full', replace 
drop _all

foreach n of numlist 100 500 1000 {

postfile buffer b1_hat b2_hat using `monte', replace

forvalues i=1/1000 {

qui{
		 drop _all
         set obs `n'
		 gen x1 = 1
		 gen x2 = 1+runiform()
		 gen u = sqrt(2)*rnormal()
		 gen y = `b1'*x1 + `b2'*x2 + u
		 reg y x1 x2, nocons 
		 }
         post buffer (_b[x1]) (_b[x2])
 
 
 }

postclose buffer
use `monte', clear

gen ratio_`n' = sqrt(`n')*b1_hat/b2_hat 
sum ratio_`n' 

gen zn_`n' = sqrt(`n') * (b1_hat/b2_hat - `b1'/`b2') /(r(sd))
gen n = _n 


merge 1:1 n using `monte_full', nogen
save `monte_full', replace 
}

use `monte_full', clear

*standard deviation of your beta hats and then root n

sum  zn*

local c = 1
foreach n of numlist 100 500 1000 {

kdensity zn_`n' ,  subtitle("n: `n' , Simulations: 1000")
graph copy plot`c', replace
graph export "Plot`c'.pdf", replace as(pdf) 

local ++c 

}


graph combine plot1 plot2 plot3 
graph export "acm_plot.pdf", replace as(pdf)
*/


*Question 6
clear all
bcuse attend
reg stndfnl atndrte frosh soph
outreg2 using attend.doc, replace ctitle(1) label

reg stndfnl atndrte ACT priGPA frosh soph
outreg2 using attend.doc, append ctitle(2) label

gen ACT_2 = ACT^2
gen priGPA_2 = priGPA^2
gen atndrte_2 = atndrte^2

reg stndfnl atndrte ACT* priGPA* frosh soph
outreg2 using attend.doc, append ctitle(3) label

test ACT ACT_2
test priGPA priGPA_2

reg stndfnl atndrte* ACT* priGPA* frosh soph
outreg2 using attend.doc, append ctitle(4) label
test ACT ACT_2
test priGPA priGPA_2
test atndrte atndrte_2
