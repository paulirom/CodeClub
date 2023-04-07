---
title: APA-Style Tables
subtitle: Create APA-Style Correlation and Regression Tables
author: Roman Pauli
date: 2023-04-06
categories: ["Tables"]
tags: ["apaTables", "correlation", "regression"]
---

Many journals require authors to report results in the style required by
the American Psychological Association (APA Style).  
The **apaTables** package creates .doc files with tables that conform to
APA Style.  
In addition, we will need the **tidyverse** package to prepare our data:

    library(apaTables)
    library(tidyverse)

The **apaTables** package comes with build in data sets we can use for
practice, one of which is the **goggles** data set. The **goggles** data
set contains four variables:

-   **participant** Participant identification number  
-   **gender** Gender of participant  
-   **alcohol** Amount alcohol consumed  
-   **attractiveness** Perceived attractiveness

### Data preparation

Let’s save the **goggles** data set to an object we call **d** and have
a look at the few top rows.

    d <- goggles
    View(d)

The Variables *gender* and *alcohol* are characters, i.e. they contain
letters instead of numbers. Since we want to do some simple statistical
analyses with metric data, we’ll have to recode these two variables into
numerics.  
There are several ways to do this. I prefer using the pipe operator
**%&gt;%** from the **dyplr** package that comes within **tidyverse**:

    d <- d %>% 
      mutate(gender = as.numeric(recode(gender, 
                              Female = 1, 
                              Male = 0))) %>% 
      mutate(pints = as.numeric(recode(alcohol, 
                              "None" = 0,
                              "2 Pints" = 2,
                              "4 Pints" = 4))) %>% 
      relocate(pints, .after = gender) %>% 
      select(.,-c(participant, alcohol))

The pipe operator allows us to conduct a series of data transformations,
neatly organized in a single block of code. We can read the pipe
operator as AND THEN, i.e., do this line of code AND THEN do that line
of code AND THEN …  
With the new numeric variable *pints*, *alcohol* is redundant in our
data frame; also we don’t want to correlate our study variables with the
*participant* ID, so we drop *alcohol* and *participant* from the data
frame in the last code line of the pipe. As a results we get:

    head(d)

    ##   gender pints attractiveness
    ## 1      1     0             65
    ## 2      1     0             70
    ## 3      1     0             60
    ## 4      1     0             60
    ## 5      1     0             60
    ## 6      1     0             55

### Correlation table

Let’s say we want to do a correlation table of all the study
variables.  
Thanks to **apaTables** we don’t have to do any computation for this! We
can simply feed our data frame into the **apa.cor.table** function and
have the function do the heavy lifting for us:

    apa.cor.table(d, filename="Table1_APA.doc", table.number=1)

As a result, we get Means, Standard Deviations and Correlations with
Confidence Intervals neatly arranged in APA-style and saved as a
word.doc to our working directory.

![Table 1: Correlations of Study Variables](https://raw.githubusercontent.com/paulirom/CodeClub/main/Table1_APA.png)

### Regression table

Suppose we are interested in how the number of pints drunk affects the
perceived attractiveness of our subjects, controlling for gender. To do
this, we would set up a simple linear regression model and check the
results using the **summary** function:

    our.model <- lm(attractiveness ~ pints + gender, data = d)
    summary(our.model)

    ## 
    ## Call:
    ## lm(formula = attractiveness ~ pints + gender, data = d)
    ## 
    ## Residuals:
    ##      Min       1Q   Median       3Q      Max 
    ## -27.8646  -8.8021  -0.0521   8.4245  28.5417 
    ## 
    ## Coefficients:
    ##             Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)   65.052      3.229  20.146  < 2e-16 ***
    ## pints         -4.297      1.057  -4.065  0.00019 ***
    ## gender         3.750      3.452   1.086  0.28311    
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 11.96 on 45 degrees of freedom
    ## Multiple R-squared:  0.2824, Adjusted R-squared:  0.2505 
    ## F-statistic: 8.854 on 2 and 45 DF,  p-value: 0.0005723

Try and copy-paste these results into word or excel and reorganise them
in an APA-style tables. I’ll wait …  
Again, this is where **apaTables** comes in handy: We can simply feed
our model into the **apa.reg.table** function and get a regression table
with confidence intervals based on the **lm** output, neatly organized
and saved as a word.doc.

    apa.reg.table(our.model, filename = "Table2_APA.doc", table.number = 2)

![Table 2: Regression Results](https://raw.githubusercontent.com/paulirom/CodeClub/main/Table2_APA.png)

Note that our original model summary did not include standardized (i.e.,
beta) weights, but only unstandardized regression (i.e., b) weights. It
would take additional packages and code to have R include these in our
output. However, **apaTables** already computed these additional
statistics for us and included them in the table without requiring us to
do any additional analyses.

### Other Options

**apaTables** holds a number of additional functions to plot the results
e.g. from nested regression models or different ANOVA models.  
To learn more, have a look at the [reference
manual](https://cran.r-project.org/web/packages/apaTables/apaTables.pdf)
or work your way through this [short
tutorial](https://dstanley4.github.io/apaTables/articles/apaTables.html).
