library(ggplot2)
library(ggstatsplot)
library(viridis)
library("here")

getwd()

results <- read.csv("results.csv")

#plot mean and SE of data
r <- ggplot(results, aes(timepoint, normalized_area, color = construct)) +
  labs(y = "y", x = "x") +  ggtitle("") +
  guides(colour = guide_legend(title = "")) +
  stat_summary(fun = mean, geom = "line") +
  stat_summary(fun.data = mean_se, geom = "pointrange", size = 0.25)
r

#lay out panels in a grid
s <- r + facet_grid(cols = vars(rapa))
s

#colorblind-friendly color map viridis
#viridis uses sequential but ggstatsplot needs discrete color maps (use paletteer)
palette <- paletteer::paletteer_c("viridis::viridis", 5)

t <- s + scale_color_manual(values = palette)
t

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

n <- p + scale_color_manual(values = palette)
n