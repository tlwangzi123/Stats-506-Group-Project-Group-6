/* read in the dataset we chose*/
data abalone_full;
  infile './abalone.csv' dlm = ',' dsd missover firstobs = 2;
  input Sex $
        Length
		Diameter
		Height
        Whole_weight
        Shucked_weight
		Viscera_weight
		Shell_weight
        Rings;
run;
/*keep columns we need*/
data abalone;
set abalone_full;
keep Rings Sex Length;
/*choose unique rows and sort the data by Rings Sex Length*/
proc sort data = abalone out = abalone noduplicates;
by Rings Sex Length;
run;
/*show the first 10 rows of our dataset*/
proc print data = abalone(obs=10);
run;
/*show the frequence summary about variable sex*/
proc freq data = abalone;
  tables Sex;
run;
/*show the summay about variable length*/
proc means data = abalone;
var Length;
run;
/*show the summary about variable Rings*/
proc means data = abalone;
var Rings;
run;
/*make the histogram about Rings*/
proc univariate data = abalone noprint;
var Rings;
histogram;
run;
/*factor the variable sex*/
data abalone;
set abalone;
  if Sex = 'F' then SexF = 1;
    else SexF = 0;
  if Sex = 'I' then SexI = 1;
    else SexI = 0;
  if Sex = 'M' then SexM = 1;
    else SexM = 0;
run;
/*run the zero-truncated negative binomial regression*/
proc nlmixed data = abalone;
  log_mu = intercept + b_SexI*SexI + b_SexM*SexM + b_Length*Length;
  mu = exp(log_mu);
  het = 1/alpha;
  ll = lgamma(Rings+het) - lgamma(Rings+1) - lgamma(het) 
       - het*log(1+alpha*mu) + Rings*log(alpha*mu) 
       - Rings*log(1+alpha*mu) - log(1 - (1 + alpha * mu)**-het);
  model Rings ~ general(ll);
run;
/*run the negative binomial regression*/
proc genmod data = abalone;
  class Sex (param = ref ref = first);
  model Rings = Sex Length / type3 dist = negbin;
run;
