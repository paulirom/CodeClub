---
title: Canonical Correlations
subtitle: Example of canonical correlation analysis with speech and brain data
author: Julia Schräder
date: 2024-010-30
tags: ["markdown", "template"]
output: md_document
---

---
title: "Canonical Correlations"
output: html_notebook
---

Canonical correlation analysis (CCA) is a powerful statistical technique used to explore and quantify the relationships between two sets of multidimensional variables.
Developed by Harold Hotelling in the 1930s, CCA extends the concept of correlation beyond pairs of variables to entire sets, enabling researchers to examine how patterns in one variable set (such as psychological attributes) relate to patterns in another (like physiological measures).
This makes it particularly valuable in fields like psychology, neuroscience, finance, and genomics, where understanding complex, multivariate relationships is often essential.

In CCA, the objective is to find linear combinations of variables within each set that are maximally correlated with one another.
By creating these combinations, known as canonical variates, CCA reduces high-dimensional data to a more interpretable form, highlighting the primary associations between two data domains.
Unlike simple correlation, which measures the association between individual variables, canonical correlation considers entire variable sets, providing a comprehensive view of their interdependencies.

Through this analysis, CCA offers insights into shared variance structures, allowing researchers to interpret how two data domains may influence or correspond to each other.
This can inform data-driven decisions in applications such as predicting psychological outcomes from brain imaging data, linking economic indicators across countries, or associating gene expression profiles with disease traits.

# Load required packages

```{r}
# Load necessary libraries 
library(psych) 
library(lavaan) 
library(R.matlab) #read in matlab variable library(CCP) #test which correlations are significant
library(dplyr) # to use %>% 
#install.packages("tidyverse")
library(tidyverse) # to transform data 
library(reshape2)
library(CCA) #perform canonical correlation 
library(CCP) #test which correlations are significant
library(reshape2)
```

# Read in Dataset

```{r}
df <- read.csv("C:/Users/juhoffmann/OneDrive - Uniklinik RWTH Aachen/Code/speech_and_ROI.csv")
```

## Filter Data

```{r}
# Speech 
X <- df[, c(
  "pos_frequency_related", "pos_energy_related", "pos_spectral_balance", 
  "pos_temporal", "pos_lexical_richness", "pos_sentiment", 
  "pos_word_types", "pos_syntactic_complexity", 
  "neg_frequency_related", "neg_energy_related", "neg_spectral_balance", 
  "neg_temporal", "neg_lexical_richness", "neg_sentiment", 
  "neg_word_types", "neg_syntactic_complexity"
)]

# Brain
Y2 <- df[, c("AP_aInsula_BA13", "AP_Amygdala","AP_aSTG_BA22","AP_aSTG_BA22_2",
"AP_Caudate_nucleus","AP_Cerebellum","AP_IFG_pOp_BA44","AP_IFG_pOp_BA44_2",
"AP_IFG_pOrb_BA47","AP_IFG_pOrb_BA47_2","AP_IFG_pOrb_BA47_3","AP_IFG_pTri_BA45",
"AP_MFG_BA9","AP_MFG_BA10","AP_MTG_BA21","AP_Parahippocampal_gyrus_BA28",
"AP_pSTG_BA22","AP_pSTG_BA22_2","AP_pSTG_BA22_3","AP_Putamen","AP_SMA_BA6",
"AP_SMA_BA6_3","AP_SMG_BA40","AP_SMG_BA40_7","AP_SMG_BA40_7_2","AP_Subcallosal_gyrus_BA34",
"AP_Thalamus","LP_aInsula_BA13","LP_aInsula_BA13_2","LP_Caudate_nucleus","LP_Cerebellum",
"LP_Cerebellum_2","LP_Cerebellum_3","LP_Claustrum","LP_Cuneus_BA17",
"LP_Heschls_gyrus_BA41","LP_IFG_pOp_BA44","LP_IFG_pOp_BA44_2","LP_IFG_pOrb_BA47",
"LP_Insula_BA13","LP_MFG_BA9","LP_MFG_BA9_2","LP_pSTG_BA22","LP_pSTG_BA22_2","LP_SMA_BA6", "LP_SMA_BA6_2","LP_SMG_BA40","LP_SMG_BA40_2","LP_SMG_BA40_7")]
```

```{r}
set.seed(123)

X_scaled <- scale(X) #speech
Y_scaled <- scale(Y2) #brain
```

# Perform CCA

```{r}
# Perform CCA using the cc() function from the CCA package
cca_result <- cc(X_scaled, Y_scaled)
#cca_result <- rcc(X_scaled, Y_scaled, lambda1 = 0.1, lambda2 = 0.1)
# View the canonical correlations
print(cca_result$cor)
```

## Interpretation of the Canonical Correlations:

1.  **Understanding the Values**:

    -   The canonical correlations represent the strength of the relationship between pairs of canonical variates (linear combinations of variables) from your `X` and `Y` datasets.

    -   **Higher values** (e.g., 0.89, 0.86, 0.83) indicate a strong relationship between the canonical variates.

    -   **Lower values** (e.g., 0.29, 0.35) suggest a weaker relationship.

2.  **General Interpretation**:

    -   **Strong Canonical Correlations (\> 0.7)**: The first few canonical correlations are relatively high, which means that there are strong linear relationships between the first few pairs of canonical variates.
        These are likely the most interpretable and meaningful pairs.

    -   **Moderate Canonical Correlations (0.5 - 0.7)**: Mid-range correlations suggest moderate relationships, which may still be meaningful but warrant closer examination.

    -   **Weak Canonical Correlations (\< 0.5)**: The lower correlations indicate weaker relationships, and these pairs of canonical variates might not contribute much to the overall relationship between the datasets.

3.  **Key Points for Interpretation**:

    -   **First Pair of Canonical Variates**: The first canonical correlation (0.893) is typically the most important, representing the strongest linear relationship between the two datasets.

    -   **Diminishing Importance**: As you move to the right in the list of canonical correlations, the importance of each subsequent pair diminishes.
        Often, only the first few pairs are of practical significance.

    -   **Number of Significant Canonical Correlations**: You might want to focus on the first few canonical correlations that are significantly different from zero.
        This can be assessed using a statistical test, such as Wilks' Lambda.

### Canonical Variates:

You can examine the canonical variates and their loadings to understand which variables in your `X` and `Y` datasets are contributing the most to the relationships:

```{r}
# Canonical variates for X 
X_canonical <- cca_result$xcoef  

# Canonical variates for Y 
Y_canonical <- cca_result$ycoef  

# View the first few rows of canonical variates 
head(X_canonical) 
head(Y_canonical)
```

### **Number of Canonical Correlations**:

-   The number of canonical correlations is equal to the minimum number of variables in the `X` and `Y` datasets. Since you have 16 canonical correlations, it suggests that either `X` or `Y` (or both) have at least 16 variables. If one set had fewer than 16 variables, the number of canonical correlations would be limited to that smaller number.

1.  **Canonical Variates**:

    -   Each canonical correlation corresponds to a pair of canonical variates-linear combinations of the original variables in `X` and `Y`.

    -   The first pair of canonical variates corresponds to the largest canonical correlation, representing the strongest linear relationship between the two datasets.

    -   The second pair corresponds to the second-largest correlation, and so on, with each subsequent pair representing progressively weaker relationships.

2.  **Interpreting Multiple Canonical Correlations**:

    -   **First Canonical Correlation**: This is usually the most important and strongest relationship between the datasets.
        It often captures the primary pattern of association.

    -   **Subsequent Canonical Correlations**: These capture additional patterns of association, but they are usually weaker and may explain more subtle or less pronounced relationships.

    -   **Significance Testing**: Typically, not all canonical correlations are statistically significant.
        Higher-order canonical correlations (those with smaller values) might not be significantly different from zero, meaning they don't represent meaningful relationships between the datasets.

# What to Do with the 16 Canonical Correlations:

## **1. Focus on Significant Correlations**:

-   After performing CCA, you would normally assess which of these correlations are statistically significant.
    Often, only the first few canonical correlations are significant and meaningful for interpretation.

-   Use a Wilks' Lambda test or similar to determine which canonical correlations are significant.

### Test which correlations are significant

Wilks' Lambda test

```{r}
# Calculate the p-values for the canonical correlations 
p_values <- p.asym(cca_result$cor, nrow(X_scaled), ncol(X_scaled), ncol(Y_scaled)) 
print(p_values)
```

```{r}
# Create a data frame to store the results 
canonical_significance <- data.frame(Canonical_Variates = paste0(1:length(p_values$stat),
                                                                 " to 16"),   
                                     Wilks_Stat = p_values$stat,   
                                     Approx_F = p_values$approx,   
                                     DF1 = p_values$df1,   
                                     DF2 = p_values$df2,   
                                     P_Value = p_values$p.value ) 

canonical_significance
```

**12th to 16th cannonical**: The p-values are above 0.05, with values like p=0.12p = 0.12p=0.12, p=0.495p = 0.495p=0.495, etc., indicating these correlations are not statistically significant.

The first 9 canonical correlations are statistically significant, and these are the pairs of canonical variates that explain meaningful relationships between your speech features and brain region activities.

Focus on interpreting the canonical variates for the first few significant correlations.
Look at the canonical loadings (coefficients) to determine which variables in `X` and `Y` are contributing most to these relationships.

## **2. Interpret the First Few Canonical Correlations**:

-   The first few canonical correlations (typically 1st and 2nd) usually capture the most interpretable and strongest relationships between the speech features and brain activities.

-   For these, examine the canonical variates to see which specific variables in `X` and `Y` are driving these relationships.

### Get variance explained and correlation for each Canonical

```{r}
canonical_correlations <- cca_result$cor 
variance_explained <- canonical_correlations^2 
canonical_table <- data.frame(Canonical_Variate = paste0("Canonical ", 
                                                         1:length(canonical_correlations)),
                              Canonical_Correlation = round(canonical_correlations,3),
                              Variance_Explained = round(variance_explained, 3)) 

canonical_table
```

### Extract and Interpret the First four Canonical Variate:

Extract canonical scores

```{r}
# 'cca_result' is the result from your CCA  
# Compute canonical scores for X and Y variables 
X_scores <- X_scaled %*% cca_result$xcoef 
Y_scores <- Y_scaled %*% cca_result$ycoef  

# Convert to data frames for easier manipulation 
X_scores_df <- as.data.frame(X_scores) 
Y_scores_df <- as.data.frame(Y_scores)  

# Name the canonical scores for clarity (e.g., Canonical1, Canonical2, ...) 
colnames(X_scores_df) <- paste0("Canonical_Speech", 1:ncol(X_scores_df)) 
colnames(Y_scores_df) <- paste0("Canonical_Brain", 1:ncol(Y_scores_df))  

# Subset only the first six canonical variates 
X_scores_df <- X_scores_df[, 1:4] 
Y_scores_df <- Y_scores_df[, 1:4]
```

Interpret Canonical Loadings

```{r}
# Extract the canonical loadings for X (speech features) and Y (brain regions) 
canonical_loadings_X <- cca_result$xcoef 
canonical_loadings_Y <- cca_result$ycoef  

# Convert to data frames for easier manipulation 
canonical_loadings_X_df <- as.data.frame(canonical_loadings_X) 
canonical_loadings_Y_df <- as.data.frame(canonical_loadings_Y)  

# Name the columns to represent the canonical variates 
colnames(canonical_loadings_X_df) <- paste0("Canonical_", 1:ncol(canonical_loadings_X_df))
colnames(canonical_loadings_Y_df) <- paste0("Canonical_", 1:ncol(canonical_loadings_Y_df))  

# Add the variable names (assuming you have rownames for your speech and brain variables) 
canonical_loadings_X_df$Variable <- rownames(canonical_loadings_X_df)
canonical_loadings_Y_df$Variable <- rownames(canonical_loadings_Y_df)  

# Add dataset labels (Speech or Brain) 
canonical_loadings_X_df$Dataset <- "Speech" 
canonical_loadings_Y_df$Dataset <- "Brain" 
```

```{r}
# Combine the canonical loadings for X and Y into a single data frame
canonical_loadings_combined <- data.frame(
  Variable = c(rownames(canonical_loadings_X_df), rownames(canonical_loadings_Y_df)),
  Dataset = c(rep("Speech", nrow(canonical_loadings_X_df)), rep("Brain", nrow(canonical_loadings_Y_df))),
  Canonical_1 = c(canonical_loadings_X_df[,1], canonical_loadings_Y_df[,1]),
  Canonical_2 = c(canonical_loadings_X_df[,2], canonical_loadings_Y_df[,2]),
  Canonical_3 = c(canonical_loadings_X_df[,3], canonical_loadings_Y_df[,3]),
  Canonical_4 = c(canonical_loadings_X_df[,4], canonical_loadings_Y_df[,4])
)


head(canonical_loadings_combined)
```

Get the top loading features for the canonical

```{r}
# Function to extract top 3 contributors for each canonical variate from the speech and brain datasets
get_top_contributors <- function(canonical_data, canonical_var, dataset_label, top_n = 3) {
  # Sort by absolute values and take top_n
  top_vars <- canonical_data %>%
    arrange(desc(abs(.data[[canonical_var]]))) %>%
    slice(1:top_n) %>%
    mutate(Dataset = dataset_label, Canonical_Variate = canonical_var) %>%
    select(Variable, Dataset, Canonical_Variate, Loading = .data[[canonical_var]])
  return(top_vars)
}

# Prepare an empty data frame to store results
top_contributors <- data.frame()

# Loop over the first 6 canonical variates (using your column names Canonical_1, Canonical_2, etc.)
for (i in 1:6) {
  canonical_var <- paste0("Canonical_", i)  # Your column names are Canonical_1, Canonical_2, etc.
  
  # Get top 3 brain regions
  top_brain <- get_top_contributors(canonical_loadings_Y_df, canonical_var, "Brain")
  
  # Get top 3 speech features
  top_speech <- get_top_contributors(canonical_loadings_X_df, canonical_var, "Speech")
  
  # Combine brain and speech top variables for this canonical variate
  top_combined <- rbind(top_brain, top_speech)
  
  # Add to the main data frame
  top_contributors <- rbind(top_contributors, top_combined)
}

# Pivot the data into the desired wide format
top_contributors_wide <- top_contributors %>%
  pivot_wider(names_from = Canonical_Variate, values_from = Loading, names_prefix = "Canonical_")

# View the table in the console
print(top_contributors_wide)
```
