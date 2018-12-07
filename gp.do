* Stat 506 Group Project Group 6
* Zero-truncated negative binomial regression Tutorial
* Data: The Abalone Dataset(https://www.kaggle.com/rodolfomendes/abalone-dataset)
* Author: Junfeng Luo
* Date: 12/07/2018

* Import data
clear
import delimited abalone.csv, case(preserve)

* Keep and sort interesting variables in the dataset, and then remove duplicates
keep Rings Sex Length
sort Rings Sex Length 
duplicates drop

* Generate a new column named Sex1 that denotes the genre
gen Sex1 = 0
replace Sex1 = 1 if Sex == "I"
replace Sex1 = 2 if Sex == "M"

* Relabel Sex1
label define Sex_codes 0 "F" 1 "I" 2 "M", replace
label values Sex1 Sex_codes
save abalone, replace

* Visualize the tabulation of Sex1, and the summarize of Length and Rings
tab1 Sex1
summarize Length Rings

* Visualize the histogram of Rings
histogram Rings, discret

* ZTNB Regression
tnbreg Rings i.Sex1 Length, ll(0)

* NB Regression
nbreg Rings i.Sex1 Length
