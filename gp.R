## Using Zero-Truncated Negative Binomial Regression model 
## on the Abalone Dataset.
##
## The Abalone Dataset used in this script can be found at the link below:
##   https://www.kaggle.com/rodolfomendes/abalone-dataset
##
## Author: Zi Wang (tlwangzi@umich.edu)
## Updated: Nov 27, 2018

# Libraries: ------------------------------------------------------------------
library(VGAM)
library(tidyverse)
library(MASS)

# Load the data: --------------------------------------------------------------
abalone_full = read.csv("abalone.csv")

# Do data cleaning, show the dimension, summary  and head of the new data: ----
abalone = abalone_full %>%
  distinct(Rings, Sex, Length)
dim(abalone)
summary(abalone)
abalone[1:10,]

# Test whether our dataset is suitable to use 
# the Zero-Truncated Negative Binomial Regression model.
sprintf("The Mean of Rings = %4.3f, and the SD of Rings = %4.3f", 
        mean(abalone$Rings), sd(abalone$Rings))
hist(abalone$Rings, xlab = "Rings", main = "Histogram of Rings")

# Use Zero-Truncated Negative Binomial Regression
t_nb1= vglm(Rings ~ Sex + Length, 
            family = posnegbinomial(), data = abalone)
summary(t_nb1)
# Log-likelihood: -4294.895, higher than below, fits better.
# Compare to NB regression

# Use Negative Binomial Regression
nb1 = glm.nb(Rings ~ Sex + Length, data = abalone)
summary(nb1)
# Log-likelihood: -8590.748/2 = -4295.874
