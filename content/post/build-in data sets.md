---
title: Data for Reproducible Examples - Part I
subtitle: Use built-in data sets for code examples
author: Roman Pauli
date: 2023-06-21
tags: ["data simulation", "build-in data", "data sets"]
output: md_document
---


To allow readers to understand and reproduce the examples of processing, plotting or modeling data provided in this weblog, we usually rely on exemplary data to which we can apply R code. However, we may not always be able or willing to **provide the original data** from our studies. This may be due to privacy restriction, because we don't want to spend additional efforts in  preparing an anonymous data set or because we simply lack the data structure and distributions needed to illustrate our specific code example.
  
Luckily, R allows us to access **build-in data** openly available for R users or to easily **simulate data** to base our code examples on. In this post, you'll learn how to do both.

# R built-in data
R comes with built-in data sets we can explore and use for our code examples. To see a list of the data sets provided in base R, we can type

```{r, eval=F}
data()
```

![data sets in package 'datasets'](https://github.com/paulirom/CodeClub/blob/main/content/post/build-in%20data%20set%20files/data().png?raw=true)

The list also includes a brief description for each data set. If we want to learn more about individual data sets, say for example the `ChickWeight` data set, we can type

```{r,eval=F}
?ChickWeight
```

![R documentation on ChickWeight data set](https://github.com/paulirom/CodeClub/blob/main/content/post/build-in%20data%20set%20files/ChickWeightdata.png?raw=true)

From the Help window, we can see that the `ChickWeight` data set comes with four columns

- `weight`for the body weight of the chick
- `Time` for the number of days since birth when the measurement was made
- `Chick` for a unique identifier for the chick
- `Diet` for the type diet the chick received

We can access the `ChickWeight` data set by directly calling it, e.g. to model the Chick's 'weight' as a function of 'Time' (i.e. their age in days) in a linear model
```{r}
summary(lm(weight ~ Time, data = ChickWeight))
```	

In addition to data sets provided in base R, many R packages come with built-in data sets that are used to demonstrate the packages' functions.
If we want, for example, check which data sets come with the `ggplot2` package, we can call
```{r}
data(package="ggplot2")
```	

![data sets in package 'ggplot2'](https://github.com/paulirom/CodeClub/blob/main/content/post/build-in%20data%20set%20files/ggplot2data.png?raw=true)


To access a data set available in a package, we can either call the data set after the package was activated or we use the pattern *packageName::datasetName*.
Here is an example of how to call the `msleep` data set from the `ggplot2` package
```{r}
# Activate package and call data set
library(ggplot2)
msleep
```	
Here is an example of how to call the `starwars` data set from the `dplyr` package, that basically means "look inside dplyr and find the starwars data frame"
```{r}
# Call data set without loading the package
dplyr::starwars
```	
Both lead to the same result. 

We can also assign data sets to objects, create data frames and work from there. As an example, let's safe the `starwars` data set from the `dplyr` package to an object we call starwarsdata
```{r}
starwarsdata <- as.data.frame(dplyr::starwars)
```	
Using that data frame, we can go on and - for example - modify, filter and plot the data according to the specific goal of our data analysis. In the following code snippet, I use `dplyr` to `filter` from the data starwars characters from the "Tatooine homeworld" that are "male" and then pipe the result into `ggplot2`, to investigate the relationship between body height and mass.

```{r}
library(dplyr)

starwarsdata %>% 
  filter(homeworld == "Tatooine", sex == "male") %>% 
  ggplot(aes(height, mass)) +
  geom_point()
```	


For an additional example, check [this contribution](https://ukarcodeclub.netlify.app/post/apatables/), where I used the `googles` data set from the `apaTables` package to demonstrate some functions of that very package as well as some data wrangling with `dplyr`. 




To list all data sets from all installed packages, you can run
```{r}
data(package = .packages(all.available = TRUE))
```	



# But which data set should I use for my code example?

Well, that heavily depends on what you want to demonstrate with your code. From the code examples given in the reference manuals of R packages, from [stackoverflow](https://stackoverflow.com/) or from other R related weblogs, you'll get to know some built-in data sets that are heavily used across the R community and that might contain exactly the type and format of data you're looking for.

Still there might be cases in which you're not satisfied with the preexisting data or simply overwhelmed by the variety of available data sets. This is when simulating your own data comes in handy - the topic of "Data for Reproducible Examples - Part I".