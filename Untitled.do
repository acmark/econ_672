*Question 5 
clear all
cd /Users/aaronmarkiewitz/Documents/research/stata/econ_672

cap log close 
log using card_hw
bcuse card

*a
gen lnwage=ln(wage)
gen exper_sq = exper^2
reg lnwage educ exper exper_sq  black south smsa reg661-reg668 smsa66
*b
reg educ exper exper_sq  black south smsa reg661-reg668 smsa66 nearc4
*c
ivregress 2sls lnwage exper exper_sq  black south smsa reg661-reg668 smsa66 ///
(educ = exper exper_sq  black south smsa reg661-reg668 smsa66 nearc4)
*d
reg educ nearc2
reg educ nearc4
ivregress 2sls lnwage exper exper_sq  black south smsa reg661-reg668 smsa66 ///
(educ = exper exper_sq  black south smsa reg661-reg668 smsa66 nearc2 nearc4)
*e
reg IQ nearc4
*f
reg IQ nearc4 smsa66 reg661 reg662 reg669
log close 
translate card_hw.smcl card_hw.pdf
