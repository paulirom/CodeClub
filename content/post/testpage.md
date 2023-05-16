---
title: Testpage
subtitle: Use this Template to create a Post
author: Roman Pauli
date: 2023-04-06
tags: ["markdown", "template"]
output: md_document
---

This template can be used to create weblog posts with minimal effort. It contains all the essential commands needed for easy weblog integration, as well as some sample code sections that you can use and adapt to your post.
*This section* already serves as an introduction to your post: The first few sentences will be previewed on the main page. I therefore suggest that you use this section to paraphrase in a few words what the reader of this post can expect.

Lines 1 to 9 have the YAML header for this post. Everything in between and including the two sets of "- - -" is essential for this document to work as a post on the weblog. Use lines 2 to 4 to specify your *title*, *subtitle* and *author* details. If you specify a *date* in the future, the post will appear online only after that date. The *tags* you assign to your post will automatically be listed in the index of the weblog. Please leave the *output* command as is, as the resulting *.md* file is the one that will be used to render your contribution in the weblog.

  

# Use Section Headers

Use *#* to create section headers. The number of *#* you use will indicate the section level, i.e. one *#* is indicates level 1, two *##* indicate level 2 and so on:

## This is a level 2 header
### This is a level 3 header
#### This is a level 4 header

  

# Include Code Sections

This is how **code chunks** will be embedded in the post:


```r
library(tidyverse)
```

For each code chunk, you can specify the output, e.g. whether you'd like the code, the output or the code and the output to be displayed in the post.
Here is another example of the combination of code and output:


```r
data <- mtcars
head(data)
```

```
##                    mpg cyl disp  hp drat    wt  qsec vs am gear carb
## Mazda RX4         21.0   6  160 110 3.90 2.620 16.46  0  1    4    4
## Mazda RX4 Wag     21.0   6  160 110 3.90 2.875 17.02  0  1    4    4
## Datsun 710        22.8   4  108  93 3.85 2.320 18.61  1  1    4    1
## Hornet 4 Drive    21.4   6  258 110 3.08 3.215 19.44  1  0    3    1
## Hornet Sportabout 18.7   8  360 175 3.15 3.440 17.02  0  0    3    2
## Valiant           18.1   6  225 105 2.76 3.460 20.22  1  0    3    1
```

  

# Include Images and Figures

Images and Figures can easily be linked using a combination of square brackets and parentheses.


```r
# [Name figure here](provide the file name here)
```

![Table 1: Correlations of Study Variables](https://raw.githubusercontent.com/paulirom/CodeClub/main/Table2_APA.png)

However, this only works if the image is located in the same directory as the page that will use the image. In most cases, this is the working directory of your R project.
An easy fix is to first upload the image to the weblog's Github folder and from there reference it via hyperlink.

  

# Include Hyperlinks to Additional Resources

Square brackets followed by parentheses is markdowns syntax for hyperlinks:


```r
# [Link text Here](https://link-url-here.org)
```
  
To learn more, have a look at the [markdown reference guide](https://www.rstudio.com/wp-content/uploads/2015/03/rmarkdown-reference.pdf).

  

# Contribute your .md to the blog

Check the instructions on the [About](https://ukarcodeclub.netlify.app/page/about/) page to learn how to contribute your .md to the blog.
