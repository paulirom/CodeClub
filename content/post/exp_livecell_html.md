---
title: Data Visualization
subtitle: Create Plots including Results from Statistical Tests
author: Ramona Jühlen
date: 2023-03-22
categories: ["Plots"]
tags: ["ggplot2", "viridis", "ggstatsplot"]
---


```r
library(knitr)
opts_chunk$set(
	echo = TRUE,
	message = FALSE,
	warning = FALSE
)
```

## here package

![](https://raw.githubusercontent.com/allisonhorst/stats-illustrations/master/rstats-artwork/here.png)


```r
library("here")

# getwd()
```

## ggplot2


```r
library(ggplot2)

results <- read.csv("results.csv")

#plot mean and SE of data
r <- ggplot(results, aes(timepoint, normalized_area, color = construct)) +
  labs(y = "y", x = "x") +  ggtitle("") +
  guides(colour = guide_legend(title = "")) +
  stat_summary(fun = mean, geom = "line") +
  stat_summary(fun.data = mean_se, geom = "pointrange", size = 0.25)
r
```

<img src="/post/220323 - Data Visualization/exp_livecell_html_files/figure-html/ggplot2-1.png" width="672" />

```r
#lay out panels in a grid
s <- r + facet_grid(cols = vars(rapa))
s
```

<img src="/post/220323 - Data Visualization/exp_livecell_html_files/figure-html/ggplot2-2.png" width="672" />

## viridis package
Colorblind-friendly color maps

More info [here](https://cran.r-project.org/web/packages/viridis/vignettes/intro-to-viridis.html)


```r
library(viridis)

#viridis uses sequential but ggplot2 needs discrete color maps (use paletteer)
palette <- paletteer::paletteer_c("viridis::viridis", 5)

t <- s + scale_color_manual(values = palette)
t
```

<img src="/post/220323 - Data Visualization/exp_livecell_html_files/figure-html/viridis-1.png" width="672" />

## ggstatsplot package
Extension of ggplot2 package with details from statistical tests

Much more to explore [here](https://indrajeetpatil.github.io/ggstatsplot/index.html)



```r
library(ggstatsplot)

#filter data
results_filtered <- dplyr::filter(results, timepoint == 30, rapa == "w")

#ggstatsplot
#for reproducibility
set.seed(123)

#plot filtered data
p <- ggbetweenstats(
  data = results_filtered,
  x = construct, ## grouping/independent variable
  y = normalized_area, ## dependent variables
  grouping.var = construct,
  type = "np", ## type of statistics
  xlab = "", ## label for the x-axis
  ylab = "y", ## label for the y-axis
  plot.type = "violin", ## type of plot
  outlier.tagging = F, ## whether outliers should be flagged
  outlier.coef = 1.5, ## coefficient for Tukey's rule
  ggtheme = ggplot2::theme_bw(), ## a different theme
  package = "ggsci", ## package from which color palette is to be taken
  palette = "uniform_startrek", ## choosing a different color palette
  title = ""
)
p
```

<img src="/post/220323 - Data Visualization/exp_livecell_html_files/figure-html/ggstatsplot-1.png" width="672" />

```r
#viridis uses sequential but ggstatsplot needs discrete color maps (use paletteer)
n <- p + scale_color_manual(values = palette)
n
```

<img src="/post/220323 - Data Visualization/exp_livecell_html_files/figure-html/ggstatsplot-2.png" width="672" />

