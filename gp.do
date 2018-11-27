clear
import delimited abalone.csv, case(preserve)
keep Rings Sex Length
sort Rings Sex Length 
duplicates drop
gen Sex1 = 0
replace Sex1 = 1 if Sex == "I"
replace Sex1 = 2 if Sex == "M"
label define Sex_codes 0 "F" 1 "I" 2 "M", replace
label values Sex1 Sex_codes
save abalone, replace
tab1 Sex1
summarize Length Rings
histogram Rings, discret

tnbreg Rings i.Sex1 Length, ll(0)

nbreg Rings i.Sex1 Length
