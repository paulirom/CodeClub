---
title: Tables with gtsummary
subtitle: Using the gtsummary package to create manuscript-ready tables
author: Stella Glasmacher
date: 2023-05-17
output: md_document
tags: ["regression", "correlation", "tables", "data preparation"]
---

### Introduction to gtsummary
gtsummary is a package to create manuscript-ready tables in R. It can create several types of tables. 
In this code club session we will use the iris dataset in R to explore the features of several functions in the gt summary package.

First we need to install the package using the install.packages() command. Then we need to load it into our library. We also need the dplyr package. 

To name the variables, it is helpful to use the package "labelled". This also needs to be installed.

```{r, eval=FALSE} 
library(gtsummary)
library(dplyr)
library(labelled)
```

The iris dataset is already integrated in R. We can have a look at the dataset first.

```{r pressure, eval=FALSE}
View(iris)
str(iris)
```

# Naming variables
We will give each variable a name that will show in the tables that we create below.

```{r}
var_label(iris$Sepal.Length) <- "Sepal Length"
var_label(iris$Sepal.Width) <- "Sepal Width"
var_label(iris$Petal.Length) <- "Petal Length"
var_label(iris$Petal.Width) <- "Petal Width"
```

# Table summary function

The first function we will look at is the tbl_summary function, which is useful to create a table of baseline characteristics for a manuscript.

```{r, eval=FALSE}
iris %>%
  tbl_summary(by = Species,
              missing = "no") %>%
  add_overall() %>%
  as_flex_table()
```


## Univariate regression table
You can create tables that contain the results of a univariate or multivariable regression analysis. 

```{r}

table_uv <- iris %>%
  tbl_uvregression(
    method = lm,
    y = Sepal.Width,
    hide_n = TRUE,
    )

```

# Multivariable regression

The same is possible for multivariable regression analysis. 

```{r}

lm_iris <- lm(Sepal.Width ~ Sepal.Length + Petal.Length + Petal.Width + Species,
              data = iris)

table_mv <- lm_iris %>% 
  tbl_regression()

```

# Combining Tables

You can combine tables using the tbl_merge function

```{r}
tbl_merge(
  list(table_uv, table_mv),
  tab_spanner = c("**Univariate Regression**", "**Adults Multivariable regression**")
) %>%
  as_flex_table()
```

