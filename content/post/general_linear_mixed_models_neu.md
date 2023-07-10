---
title: General Linear Mixed Models in R
subtitle: Example of a GLMM using lme4
author: Julia Schräder
date: 2023-04-19
tags: ["General Linear Mixed Model", "lme4", "R"]
output: md_document
---

This is an example for a general linear mixed model. A Generalized Linear Mixed Model (GLMM) is a statistical framework that combines elements of generalized linear models and mixed-effects models. GLMMs are used to analyze data with non-normal response variables while accounting for random effects. They model various types of response variables, such as binary or count outcomes, and consider the correlation structure in the data through random effects. GLMMs are useful in analyzing complex data structures with hierarchical or nested relationships and are applied in various fields.

The script uses a dataset from this study:

https://doi.org/10.1016/j.concog.2023.103493

# Study design

![A = Study 1; B = Study 2](https://user-images.githubusercontent.com/54576554/204008729-5d3d16d1-6b93-4a4b-96ca-2b17e66a0614.png)

# Load packages


```{r}
library(lme4)         # mixed model package
library(lmerTest)     # library providing p-values for mixed models in lme4
library(readxl)       # read excel
library(ggplot2)      # graphics
#library(tidyverse)    # library with various tools (e.g. ggplot, pivot_long, pipes etc.)
library(emmeans)      # library for post-hoc tests
library(pbkrtest)     # needed for post-hoc tests in mixed models
library(jtools)       # post hoc tests
library(interactions) 
```

# Load the dataset:


```{r}
data <- read.csv("Path/GLMM_Model1_data.csv")
head(data)
```

# Remove missing values:


```{r}
data$X <- NULL
data <-data[complete.cases(data), ]
head(data)
```

- We have one column `block` includes information about the block number 1,2 or 3 starting with 0
- `conditions` include information about the task condition whether the primer was presented for 141ms, 25ms, 16ms or 8ms showing a happy, neutral or sad face
- `correct` labels if the given response was correct = 1 or incorrect = 0
- `level` indicates whether the stimulus was presented for 8ms, 25ms, 16ms or 141ms
- `primer_time` indicates the primer presentation time in s
- `real_trial_number` indicates the trial number 0-360
- `response` indicates which response was given, if the primer was rated as sad = 7/7.0, neutral = 8/8.0, happy = 9/9.0
- `rt` includes the reaction time in s
- `stim` labels the presented stimulus type (happy, neutral, sad)
- `study_number` labels if the participant did task 1 (study 1) or task 2 (study 2)
- `subj_idx` labels the subject name
- "trial" labels the trial number within a block (0-120), 120 trials per block


Since we have different values in e.g. `response`, we have to adjust the values


```{r}
data$response[data$response == "8.0"] <- 1                                       #neutral
data$response[data$response == "7.0"] <- 2                                       #sad
data$response[data$response == "9.0"] <- 3                                       #happy

data$response[data$response == "8"] <- 1                                         #neutral
data$response[data$response == "7"] <- 2                                         #sad
data$response[data$response == "9"] <- 3                                         #happy
```



Maybe change strings into numeric values


```{r}
#Define variables
data$study_number[data$study_number == "study2"] <- 2
data$study_number[data$study_number == "study1"] <- 1

data$level[data$level == "141ms"] <- 4
data$level[data$level == "25ms"] <- 3
data$level[data$level == "16ms"] <- 2
data$level[data$level == "8ms"] <- 1
```


To reduce dimensionality, we sometimes have to transform specific variables. lme will suggest certain variables to be transformed when testing models. In this study, we had to transform the trial number variable. We did a z-transformation 


```{r}
data$real_trial_number <- as.integer(data$real_trial_number)
data$real_trial_number.z <- data$real_trial_number/sd(data$real_trial_number) 
```


To estimate GLMM, some variables have to be factorized


```{r}
data$level               <- factor(data$level, ordered = FALSE) 
data$subj_idx            <- factor(data$subj_idx, ordered = FALSE)
data$block               <- factor(data$block, ordered = FALSE)
data$study_number        <- factor(data$study_number, ordered = FALSE)
data$response            <- factor(data$response, ordered = FALSE)
data$stim                <- factor(data$stim, ordered = FALSE)
```


If you want to look at data collected only in study 1, you can divide your dataset as following:


```{r}
data_study1<- subset(data, study_number != 2) 
```


Now we take a look at our data we are interested in:


```{r}
plot(density(data$correct),main="Density estimate of data")
```




# Let´s estimate our first GLMM


```{r}
Model1.study1 <- glmer(correct ~  stim + level + real_trial_number.z +
                + (1|subj_idx),
                data = data_study1,
                family = "binomial")
```

   
 `correct` is our dependent variable. We want to explain our dependent variable with the independent variables which we manipulated within the experiment. We changed the presented emotion `stim` and the presentation duration `level`. We also want to check if the trial number has an effect (e.g. habituation effect over time)
 
 
# Formalization of the model in R
The general formula of mixed effects models in R (or `lmer`) is very similar to the formulation using the `lm` function from the stats package in R.


```{r echo = FALSE, results = TRUE}
Formula <- c("`y ~ x`", "`a + b`", "`a : b`", "`a * b`", "`a + b + a : b`","`y ~ a * b`", "`+ (1` $\\mid$ `unit)`", "`y ~ a * b + (1` $\\mid$ `unit)`", "`y ~ a * b + (b ` $\\mid$ `unit)`")
Meaning <- c("predict dependent variable `y` from (fixed effects) variable `x`", "fixed main effect `a` and fixed main effect `b`", "only (fixed) interaction term `a` $\\times$ `b`", "all main effects and interactions of `a` and `b`", "same as above", "predict `y` from main effects and interaction of `a` and `b`", "add a random intercept for the random effects variable `unit`", "predict `y` from fixed main effects and interaction of `a` and `b` with a random intercept for random variable `unit`", "same as above and add a random slope of variable `unit` for variable `b`")
Forms <- data.frame(Formula, Meaning)
knitr::kable(Forms, escape = FALSE)
```
 
from: Bates, D., Mächler, M., Bolker, B., & Walker, S. (2014). Fitting linear mixed-effects models using lme4. arXiv preprint arXiv:1406.5823. 
https://doi.org/10.48550/arXiv.1406.5823

 
Since we have binary data in our `correct` variable, we can can assume: family = "binomial". If you are interested in non-binary data and don't know which family you should assume, you can plot your data as specific distributions and check which suits best.

E.g. fit distribution of the reaction time variable (rt)


```{r}
x <- data$rt
den <- density(x)
dat <- data.frame(x = den$x, y = den$y)

#Fit distributions
library(fitdistrplus)
fit.weibull <- fitdist(x, "weibull")
fit.normal <- fitdist(x,"norm")
fit.gamma <- fitdist(x, "gamma", lower = c(0, 0))


# Compare fits graphically
plot.legend <- c("Weibull", "Gamma","Normal")
par(mfrow = c(2, 2)) #show 4 pictures
denscomp(list(fit.weibull, fit.gamma, fit.normal), fitcol = c("red", "blue","green"), legendtext = plot.legend)
qqcomp(list(fit.weibull, fit.gamma, fit.normal), fitcol = c("red", "blue","green"), legendtext = plot.legend)
cdfcomp(list(fit.weibull, fit.gamma, fit.normal), fitcol = c("red", "blue","green"), legendtext = plot.legend)
ppcomp(list(fit.weibull, fit.gamma, fit.normal), fitcol = c("red", "blue","green"), legendtext = plot.legend)

```


 
# Get Statistics

You can look at the statistics of your model either using the `anova` function or `summary` function. The summary function provides more information than anova.


```{r}
anova(Model1.study1)
```

```{r}
summary(Model1.study1)
```

To report results, you can export the anova as csv document. Choose type II anova if your model includes NO interaction effects. With interactions, choose type III anova. 

```{r}
anova.s<-anova(Model1.study1, type = 2, ddf= "Kenward-Roger")
print(anova.s)

#write_excel_csv(anova.s,
#                delim = ";",
#                "C:/Users/juhoffmann/OneDrive - Uniklinik RWTH Aachen/Code/GLMModel_anova.csv")
```


## Plot effects

With `allEffects` you can estimates all effects included in your model. These effects can be plotted in one graph:


```{r}
library(effects)
effectsmodel<-allEffects(Model1.study1)
plot(effectsmodel)
print(effectsmodel)
```

## Post Hoc tests

Post Hoc tests can be applied as following:


```{r}
stim <- emmeans(Model1.study1, pairwise ~ stim)
level <- emmeans(Model1.study1, pairwise ~ level)
stim
level
```


### Additional analysis:

You can also estimate the probability of making a correct response using the logit


```{r}
fixef(Model1.study1)
```

level 1 = 8ms
level 2 = 16ms
level 3 = 25ms
level 4 = 140ms

### Get logit for Level 
the logit function is the quantile function associated with the standard logistic distribution


```{r}
level1.logit    <-fixef(Model1.study1)[[4]]    
level2.logit    <-fixef(Model1.study1)[[5]]    
level3.logit    <-fixef(Model1.study1)[[6]]
level4.logit    <- -(fixef(Model1.study1)[[4]]+fixef(Model1.study1)[[5]]+fixef(Model1.study1)[[6]])
```


### Backtransform logit into p value


```{r}
1/(1+exp(-level1.logit))    # probability of making a correct response during level1 trials
1/(1+exp(-level2.logit))    # probability of making a correct response during level2 trials
1/(1+exp(-level3.logit))    # probability of making a correct response during level3 trials
1/(1+exp(-level4.logit))    # probability of making a correct response during level4 trials
```