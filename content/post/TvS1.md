---
title: Tidyverse Session I 
subtitle: Getting started with Tidyverse
author: Nicolas Nusser
date: 2024-08-07
tags: ["tidyverse", "tibbles", "data import", "pipe operator"]
editor_options: 
  markdown: 
    wrap: 72
---

------------------------------------------------------------------------

## 1.1 General principle

The "tidyverse" is one of the most versatile and powerful packages of R
and it has become an indispensable tool for many people working with R.
But what is the tidyverse and what makes it so magical?

The tidyverse is a collection of packages (9 core packages, ~ 25 total
packages) for data handling - from importing datasets to data wrangling
and plotting. This means, that the tidyverse can be seen as its very
own, stand-alone universe that "happens" inside R. For many applications
the tidyverse provides all necessary functions to fit your needs - but
since everything happens inside R, it can be easily combined with other
packages if necessary.

But what really makes the tidyverse so great is its philosophy: it's a
**coding-language with very good and easy readability and coherent
grammar**! Which means that the language can be very intuitive even for
non-coders and beginners.

![Figure 1: Basics of the tidyverse and its core
packages](https://github.com/paulirom/CodeClub/blob/main/content/post/Tidyverse%20Session%20I%20files/fig1.png?raw=true)

*Figure 1: Basics of the tidyverse and its core packages*

When installing the tidyverse, all 20+ packages of the tidyverse will
automatically get installed as well. Therefore, packages like "magrittr"
can be called directly without the need to separately install them.

```         
install.packages("tidyverse")
```

Loading the tidyverse will only load the core packages, as well as
individual functions of the other packages.

```         
library(tidyverse)

## ── Attaching core tidyverse packages ──────────────────────── tidyverse 2.0.0 ──
## ✔ dplyr     1.1.4     ✔ readr     2.1.5
## ✔ forcats   1.0.0     ✔ stringr   1.5.1
## ✔ ggplot2   3.5.0     ✔ tibble    3.2.1
## ✔ lubridate 1.9.3     ✔ tidyr     1.3.1
## ✔ purrr     1.0.2     
## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
## ✖ dplyr::filter() masks stats::filter()
## ✖ dplyr::lag()    masks stats::lag()
## ℹ Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors
```

These core packages are:

**readr**: a convenient way to load your raw data (as .csv) into R

**tibble**: the so-called "modern dataframe" to display the data in a
tidy format

**tidyr**: a tool to get untidy data into a workable format

**dplyr**: a powerful tool for data wrangling

**forcats**: for working with factors

**stringr**: for working with strings

**lubridate**: for working with time data

**purrr**: for functional programming

**ggplot2**: for easy and comprehensible plotting

------------------------------------------------------------------------

## 1.2 Tibbles - the "modern dataframe"

Working with raw data can be very confusing - especially when there are
many different variables and thousands of datapoints. Tibbles try to
mitigate this confusion by condensing the data into a very neat and
clear format. Don't get me wrong: The tibble doesn't do anything to your
data - the tibble IS your data, just displayed in a way that is easier
on the eyes. Let's take a look at a "tibble" by calling the "*starwars*"
tibble (part of the dplyr-package):

```         
starwars

## # A tibble: 87 × 14
##    name     height  mass hair_color skin_color eye_color birth_year sex   gender
##    <chr>     <int> <dbl> <chr>      <chr>      <chr>          <dbl> <chr> <chr> 
##  1 Luke Sk…    172    77 blond      fair       blue            19   male  mascu…
##  2 C-3PO       167    75 <NA>       gold       yellow         112   none  mascu…
##  3 R2-D2        96    32 <NA>       white, bl… red             33   none  mascu…
##  4 Darth V…    202   136 none       white      yellow          41.9 male  mascu…
##  5 Leia Or…    150    49 brown      light      brown           19   fema… femin…
##  6 Owen La…    178   120 brown, gr… light      blue            52   male  mascu…
##  7 Beru Wh…    165    75 brown      light      blue            47   fema… femin…
##  8 R5-D4        97    32 <NA>       white, red red             NA   none  mascu…
##  9 Biggs D…    183    84 black      light      brown           24   male  mascu…
## 10 Obi-Wan…    182    77 auburn, w… fair       blue-gray       57   male  mascu…
## # ℹ 77 more rows
## # ℹ 5 more variables: homeworld <chr>, species <chr>, films <list>,
## #   vehicles <list>, starships <list>
```

One thing that immediately becomes apparent: a tibble always performs
**lazy loading**. This means, that it will only load a small fraction of
your data: from the initial 87 x 14 dataset, only 10 rows and a hand
full of variables (i.e. columns) are loaded.

While this might not seem like a big deal at first, let's think about it
quickly: when we take a look at our raw data - do we really need to see
every single datapoint in our dataset? Let's say we want to perform any
operation on our data, and then we want to check our data to see whether
our function had the desired effect or not - 10 rows are usually more
than enough to verify this! So why should we want R to show us all 87
rows every time? And in case we want to see more, a tibble can just be
extended using the function "print(n=x)", where x is the amount of rows
to display.

Another very convenient benefit of tibbles is the fact, that it will
always show the **type of variable** for all columns (directly beneath
the name of the column). These are abbreviated as:

<span style="color: #001bc5;">**\<chr\> character**: a string vector
(i.e. just text)

<span style="color: #001bc5;">**\<int\> integer**: a numerical vector
with whole numbers

<span style="color: #001bc5;">**\<dbl\> doubles**: a floating-point
numerical vector (default variable type for numbers)

<span style="color: #001bc5;">**\<fct\> factors**: a variable containing
factors

<span style="color: #001bc5;">**\<lgl\> logical**: a TRUE/FALSE variable

<span style="color: #001bc5;">**\<date\> date**: a variable containing
time data (see lubridate)

etc.

This is extremely powerful, as it gives a lot of information about a
given variable. Let's say we have a numeric variable like height, but
due to wrong formatting it is stored as a character vector. Now, it
would (rightfully so) not be possible to calculate anything like an
average or a standard deviation, since that would make no sense for a
non-numeric variable like text. Being able to see the variable type of
all variables gives you a better understanding of your data and also
prevents mistakes like this.

------------------------------------------------------------------------

## 1.3 magrittr - the Pipe operators

This is probably THE most powerful function of the tidyverse:
<span style="color: #996c34;">**the Pipe (%\>%)**</span>.

But what does <span style="color: #996c34;">%\>%</span> do? Generally
speaking: it takes whatever is to the left of the pipe and "pipes" it as
the first argument of the function to the right of the pipe.

<span style="color: #996c34;">**a %\>% f(b) == f(a,b)**</span>

```         
1 %>% c(2,3)

## [1] 1 2 3
```

A more general version of this can be achieved by using a "." inside the
function. In this case, the part to the left of the pipe would get piped
directly into the position of ".".

<span style="color: #996c34;">**b %\>% f(a,.) == f(a,b)**</span>

```         
2 %>% c(1,.,3)

## [1] 1 2 3
```

And now comes the magic: Since most R functions (and especially **all**
tidyverse functions) have "data" (or "x") as their first argument, the
pipe basically can be read as <span style="color: #996c34;">"**and
then**"</span>.

**Let's run a quick example using various other tidyverse functions**:

<span style="color: #001bc5;">***filter(.data,...)***: Removes cases
which do not fulfill certain criteria

<span style="color: #001bc5;">***count(x,...)***: Counts unique values
of variables

For example, let's look at all characters in Star Wars, that are taller
than 170 cm. Since we assume that height could be species-dependent, we
next count the different species. Then we remove all species, where
there is only one entry. Our result now shows how many characters of a
certain species are taller than 170 cm. And our code reads like this:

```         
filter(count(filter(starwars,height>170),species),n>1)

## # A tibble: 7 × 2
##   species      n
##   <chr>    <int>
## 1 Gungan       3
## 2 Human       21
## 3 Kaminoan     2
## 4 Twi'lek      2
## 5 Wookiee      2
## 6 Zabrak       2
## 7 <NA>         3
```

This is not very intuitive to read... one has to read the function from
inside out, since each "step" gives a new dataset, that has to be used
as the first argument of the next function.

Now, let's try this again - but this time using pipes:

```         
starwars %>% 
  filter(height>170) %>% 
  count(species) %>% 
  filter(n>1)

## # A tibble: 7 × 2
##   species      n
##   <chr>    <int>
## 1 Gungan       3
## 2 Human       21
## 3 Kaminoan     2
## 4 Twi'lek      2
## 5 Wookiee      2
## 6 Zabrak       2
## 7 <NA>         3
```

**Basically the code now reads as**:

Take my dataset called <span style="color: #339fff;">"*starwars*"</span>
<span style="color: #996c34;">**and then**</span>
<span style="color: #339fff;">filter</span> all cases, where the
numerical variable <span style="color: #339fff;">"*height*"</span> in my
dataset is <span style="color: #339fff;">greater than 170</span>,
<span style="color: #996c34;">**and
then**</span><span style="color: #339fff;">count</span> all unique
entries in the character variable
<span style="color: #339fff;">"*species*"</span> (generates a new tibble
with "species" and "n" for the amount of entries of a certain species),
<span style="color: #996c34;">**and
then**</span><span style="color: #339fff;">filter</span> all
<span style="color: #339fff;">species with more than 1 entry</span>.

The code does exactly the same thing as earlier, but this time it is
significantly more readable - thanks to the pipe! Now it should be
apparent why pipes are so powerful. And the best thing: Pipes can be
summoned quickly using <span style="color: #996c34;">**CTRL+SHIFT+M**

magrittr also contains a "tee pipe" (%T\>%), an "exposition pipe" (%\$%)
and an "assignment pipe" (%\<\>%) - all with different features that may
be interesting for your applications.

------------------------------------------------------------------------

## 1.4 readr - importing data

While Base-R already contains options to import data as .csv to R, the
tidyverse equivalent "readr" offers some additional quality-of-life
improvements. Let's look at a dataset from a fictional study.

![Figure 2: Rawdata
(Excel)](https://github.com/paulirom/CodeClub/blob/main/content/post/Tidyverse%20Session%20I%20files/fig2.PNG?raw=true)

*Figure 2: Rawdata (Excel)*

To import this dataset, we can either write the code manually, or go to
the <span style="color: #339fff;">***Environment***</span> (upper-right
window) click on <span style="color: #339fff;">"***Import
Dataset***"</span> and <span style="color: #339fff;">"***From Text
(readr)***"</span>.

This opens a new window (see figure 3) where we can browse for our
.csv-file and change the name \[1\] and various other parameters. For
example, our raw data has an undesirable shape, as the first two rows
are irrelevant (as seen in figure 2). Instead of manually changing the
data structure in e.g. Excel, we can simply tell readr to skip \[2\] the
first 2 rows. We can also change the delimiter \[3\] of each column to
semicolon (";") or tell readr how to handle missing or NA-values.

![Figure 3: Importing data with
readr](https://github.com/paulirom/CodeClub/blob/main/content/post/Tidyverse%20Session%20I%20files/fig3.png?raw=true)

*Figure 3: Importing data with readr*

Once we're happy with the data, we can either directly import it into R
(which results in a new tibble under the name set under \[1\]), or - if
this type of data will be recurring - we can simply copy the code \[4\]
and insert it in our own script.

<span style="color: #118306;">*Another tip for recurring data: we can
combine readr with **file.choose()**. This function allows to browse
your system and "prints" the path of any file. This way, running the
code allows to browse for a file and format it automatically.*

```         
data <- file.choose() %>% 
  read_delim(delim = ";", escape_double = FALSE, trim_ws = TRUE,
             skip = 2)

data

## # A tibble: 23 × 9
##    ID    Birthyear Birthday Height Weight `Shoe size` Gender Nationality Pets   
##    <chr>     <dbl> <chr>     <dbl>  <dbl>       <dbl> <chr>  <chr>       <chr>  
##  1 A-001      2000 31.08.      172     74          44 M      Austria     none   
##  2 A-002      2002 21.07.      160     60          38 F      Austria     cat    
##  3 B-003      1995 18.02.      168     70          42 M      Switzerland dog, c…
##  4 B-004      1966 03.05.      168     64          38 F      Germany     cat    
##  5 A-005      1975 18.07.      160     75          36 F      Austria     dog, c…
##  6 A-006      1998 21.10.      178     68          41 M      Germany     dog    
##  7 A-007      2022 13.08.       65     15          23 M      Switzerland dog, c…
##  8 B-008      1970 04.04.      182    102          43 M      Germany     dog, c…
##  9 A-009      1997 21.10.      165     60          37 F      Germany     cat, f…
## 10 B-010      1985 03.09.      155     89          39 F      Germany     fish   
## # ℹ 13 more rows
```

------------------------------------------------------------------------

## 1.5 tidyr and dplyr - Basics in data wrangling

Let's start with tidyr to clean up our data and bring it into a format
to work with. For example, our ID-variable contains several pieces of
information that we want to extract: a letter (A or B) which could point
to an affiliation (e.g. A for "control group" and B for "test group")
and a number which points to the person. So in order to **separate**
these pieces of information "horizontally" (to generate more columns),
we can use *separate_wider*:

<span style="color: #001bc5;">***separate_wider_delim()***: separates
columns by a common delimiter (in this case "-")

<span style="color: #001bc5;">***separate_wider_position()***: separates
columns by fixed widths (in this case **1** for the letter, **1** to
drop the "-" and **3** for the numbers)

<span style="color: #001bc5;">***separate_wider_regex()***: separates
columns by a regular expression (more complex, but significantly more
powerful)

Let's separate our <span style="color: #339fff;">"*ID*"
***column***</span> by the common
<span style="color: #339fff;">***delimiter*** "-"</span> into two new
variables <span style="color: #339fff;">***named*** "Code" and
"Number"</span>:

```         
data %>% separate_wider_delim(cols=ID,
                              names=c("Code","Number"),
                              delim="-")

## # A tibble: 23 × 10
##    Code  Number Birthyear Birthday Height Weight `Shoe size` Gender Nationality
##    <chr> <chr>      <dbl> <chr>     <dbl>  <dbl>       <dbl> <chr>  <chr>      
##  1 A     001         2000 31.08.      172     74          44 M      Austria    
##  2 A     002         2002 21.07.      160     60          38 F      Austria    
##  3 B     003         1995 18.02.      168     70          42 M      Switzerland
##  4 B     004         1966 03.05.      168     64          38 F      Germany    
##  5 A     005         1975 18.07.      160     75          36 F      Austria    
##  6 A     006         1998 21.10.      178     68          41 M      Germany    
##  7 A     007         2022 13.08.       65     15          23 M      Switzerland
##  8 B     008         1970 04.04.      182    102          43 M      Germany    
##  9 A     009         1997 21.10.      165     60          37 F      Germany    
## 10 B     010         1985 03.09.      155     89          39 F      Germany    
## # ℹ 13 more rows
## # ℹ 1 more variable: Pets <chr>
```

Now we have new variables containing the information that was previously
"locked" inside the ID-variable. This allows us to e.g. group by their
**affiliation** (A or B) to evaluate their data separately or to sort
all rows by the patient **number**.

If we want to **separate** pieces of information "vertically", we can
use *separate_longer*. So let's look at the "*Pets*" column, where in a
few cases multiple pets are listed (e.g. "dog, cat"). So if we want to
evaluate our data by pets, we might need to separate our data.
(alternatively, this could be for example a "medications" column with
various medications, etc.).

<span style="color: #001bc5;">***separate_longer_delim()***: separates
columns into rows by a common delimiter (in this case "," (beware the
additional space))

<span style="color: #001bc5;">***separate_longer_position()***:
separates columns into rows by fixed widths (makes no sense in this
case, since not all pets have the same length, e.g. "dog" vs. "fish")

Let's separate our <span style="color: #339fff;">"*Pets*"
***column***</span> by the common
<span style="color: #339fff;">***delimiter*** ","</span>:

```         
data %>% separate_wider_delim(cols=ID,
                              names=c("Code","Number"),
                              delim="-") %>%
  separate_longer_delim(cols=Pets,
                        delim=", ") %>% 
  relocate(Pets, .after="Number")

## # A tibble: 29 × 10
##    Code  Number Pets  Birthyear Birthday Height Weight `Shoe size` Gender
##    <chr> <chr>  <chr>     <dbl> <chr>     <dbl>  <dbl>       <dbl> <chr> 
##  1 A     001    none       2000 31.08.      172     74          44 M     
##  2 A     002    cat        2002 21.07.      160     60          38 F     
##  3 B     003    dog        1995 18.02.      168     70          42 M     
##  4 B     003    cat        1995 18.02.      168     70          42 M     
##  5 B     004    cat        1966 03.05.      168     64          38 F     
##  6 A     005    dog        1975 18.07.      160     75          36 F     
##  7 A     005    cat        1975 18.07.      160     75          36 F     
##  8 A     006    dog        1998 21.10.      178     68          41 M     
##  9 A     007    dog        2022 13.08.       65     15          23 M     
## 10 A     007    cat        2022 13.08.       65     15          23 M     
## # ℹ 19 more rows
## # ℹ 1 more variable: Nationality <chr>
```

<span style="color: #118306;">Note that ***relocate()*** was used to
relocate the *Pets* column **after** the *Number* column, since it would
otherwise by not visible due to the lazy loading of tibbles.

We can see, that our tibble now has several more rows: all people with
multiple pets show up more than once now (e.g. Person number "005", who
has both a cat and a dog). This has to be kept in mind if we want to
calculate e.g. averages or standard deviations for the entire dataset,
since those rows would have a stronger impact.

On the contrary if we want to **unite** information of multiple columns
into one column, we can use *unite()*. So for example we could combine
Birthday and Birthyear:

<span style="color: #001bc5;">***unite()***: combines multiple columns
into one column

Let's unite <span style="color: #339fff;">Birthday and Birthyear</span>
(in this order) <span style="color: #339fff;">**separated** by nothing
("")</span> into a new <span style="color: #339fff;">**column** named
"Born"</span>:

```         
data %>% separate_wider_delim(cols=ID,
                              names=c("Code","Number"),
                              delim="-") %>% 
  unite(col=Born,
        Birthday,Birthyear,
        sep="")

## # A tibble: 23 × 9
##    Code  Number Born       Height Weight `Shoe size` Gender Nationality Pets    
##    <chr> <chr>  <chr>       <dbl>  <dbl>       <dbl> <chr>  <chr>       <chr>   
##  1 A     001    31.08.2000    172     74          44 M      Austria     none    
##  2 A     002    21.07.2002    160     60          38 F      Austria     cat     
##  3 B     003    18.02.1995    168     70          42 M      Switzerland dog, cat
##  4 B     004    03.05.1966    168     64          38 F      Germany     cat     
##  5 A     005    18.07.1975    160     75          36 F      Austria     dog, cat
##  6 A     006    21.10.1998    178     68          41 M      Germany     dog     
##  7 A     007    13.08.2022     65     15          23 M      Switzerland dog, cat
##  8 B     008    04.04.1970    182    102          43 M      Germany     dog, cat
##  9 A     009    21.10.1997    165     60          37 F      Germany     cat, fi…
## 10 B     010    03.09.1985    155     89          39 F      Germany     fish    
## # ℹ 13 more rows
```

Thanks to the power of tibbles, we can see that "*Born*" is a character
vector. So we can not calculate anything with it yet. But we can use
other tidyverse functions to change this:

<span style="color: #001bc5;">***mutate()***: creates a new variable (or
overwrites an existing variable) as a function of existing variables
(i.e. it mutates existing variables)

Let's start slowly: we want to have the "*Height*" variable in
**meters** instead of **centimeters**. We can modify
<span style="color: #339fff;">"*Height*", by dividing it by 100</span>:

```         
data %>% separate_wider_delim(cols=ID,
                              names=c("Code","Number"),
                              delim="-") %>% 
  unite(col=Born,
        Birthday,Birthyear,
        sep="") %>% 
  mutate(Height=Height/100)

## # A tibble: 23 × 9
##    Code  Number Born       Height Weight `Shoe size` Gender Nationality Pets    
##    <chr> <chr>  <chr>       <dbl>  <dbl>       <dbl> <chr>  <chr>       <chr>   
##  1 A     001    31.08.2000   1.72     74          44 M      Austria     none    
##  2 A     002    21.07.2002   1.6      60          38 F      Austria     cat     
##  3 B     003    18.02.1995   1.68     70          42 M      Switzerland dog, cat
##  4 B     004    03.05.1966   1.68     64          38 F      Germany     cat     
##  5 A     005    18.07.1975   1.6      75          36 F      Austria     dog, cat
##  6 A     006    21.10.1998   1.78     68          41 M      Germany     dog     
##  7 A     007    13.08.2022   0.65     15          23 M      Switzerland dog, cat
##  8 B     008    04.04.1970   1.82    102          43 M      Germany     dog, cat
##  9 A     009    21.10.1997   1.65     60          37 F      Germany     cat, fi…
## 10 B     010    03.09.1985   1.55     89          39 F      Germany     fish    
## # ℹ 13 more rows
```

We can also use other tidyverse functions inside mutate. For example we
can convert "*Born*" from a **character** vector into a **date** vector
using lubridate functions:

<span style="color: #001bc5;">***dmy()***: transforms a character or
numeric vector with the format Day-Month-Year into a date vector
(lubridate functions recognize most separators (in this case ".")
automatically. lubridate functions also come in many variations, such as
***mdy()***, ***ymd()***, etc.)

```         
data %>% separate_wider_delim(cols=ID,
                              names=c("Code","Number"),
                              delim="-") %>% 
  unite(col=Born,
        Birthday,Birthyear,
        sep="") %>% 
  mutate(Height=Height/100,
         Born=dmy(Born))

## # A tibble: 23 × 9
##    Code  Number Born       Height Weight `Shoe size` Gender Nationality Pets    
##    <chr> <chr>  <date>      <dbl>  <dbl>       <dbl> <chr>  <chr>       <chr>   
##  1 A     001    2000-08-31   1.72     74          44 M      Austria     none    
##  2 A     002    2002-07-21   1.6      60          38 F      Austria     cat     
##  3 B     003    1995-02-18   1.68     70          42 M      Switzerland dog, cat
##  4 B     004    1966-05-03   1.68     64          38 F      Germany     cat     
##  5 A     005    1975-07-18   1.6      75          36 F      Austria     dog, cat
##  6 A     006    1998-10-21   1.78     68          41 M      Germany     dog     
##  7 A     007    2022-08-13   0.65     15          23 M      Switzerland dog, cat
##  8 B     008    1970-04-04   1.82    102          43 M      Germany     dog, cat
##  9 A     009    1997-10-21   1.65     60          37 F      Germany     cat, fi…
## 10 B     010    1985-09-03   1.55     89          39 F      Germany     fish    
## # ℹ 13 more rows
```

Now that "*Born*" is a date vector, we can use other lubridate functions
to calculate the age. Once again, we use the ***mutate()*** function,
but this time we generate a new variable named "*Age*".

For this, we will use more lubridate functions - I will not go into too
much detail in this session (we can take a closer look at lubridate at
another time):

<span style="color: #001bc5;">***interval()***: gives the time
difference between two days (in this case "Born" and today)

<span style="color: #001bc5;">***today()***: prints the current day and
time

<span style="color: #001bc5;">***as.period()***: converts the *interval*
(from earlier) into a *period* (i.e. from "*2000-08-31 UTC--2024-09-15
UTC*" to "*24y 0m 15d 0H 0M 0S*")

<span style="color: #001bc5;">***year()***: reduces the period "*24y 0m
15d 0H 0M 0S*" to the year "*24*"

```         
data %>% separate_wider_delim(cols=ID,
                              names=c("Code","Number"),
                              delim="-") %>% 
  unite(col=Born,
        Birthday,Birthyear,
        sep="") %>% 
  mutate(Height=Height/100,
         Born=dmy(Born),
         Age=interval(Born,today()) %>% 
           as.period() %>% 
           year()) %>% 
  relocate(Age, .after=Born)

## # A tibble: 23 × 10
##    Code  Number Born         Age Height Weight `Shoe size` Gender Nationality
##    <chr> <chr>  <date>     <dbl>  <dbl>  <dbl>       <dbl> <chr>  <chr>      
##  1 A     001    2000-08-31    24   1.72     74          44 M      Austria    
##  2 A     002    2002-07-21    22   1.6      60          38 F      Austria    
##  3 B     003    1995-02-18    29   1.68     70          42 M      Switzerland
##  4 B     004    1966-05-03    58   1.68     64          38 F      Germany    
##  5 A     005    1975-07-18    49   1.6      75          36 F      Austria    
##  6 A     006    1998-10-21    25   1.78     68          41 M      Germany    
##  7 A     007    2022-08-13     2   0.65     15          23 M      Switzerland
##  8 B     008    1970-04-04    54   1.82    102          43 M      Germany    
##  9 A     009    1997-10-21    26   1.65     60          37 F      Germany    
## 10 B     010    1985-09-03    39   1.55     89          39 F      Germany    
## # ℹ 13 more rows
## # ℹ 1 more variable: Pets <chr>
```

Next, let's say we want to *arrange* our rows in a from the **oldest**
to the **youngest** person with our new variable "*Age*".

<span style="color: #001bc5;">***arrange()***: rearranges all rows by
sorting a variable in ascending order. Adding ***desc()***
("*descending*") reverses this order.

```         
data %>% separate_wider_delim(cols=ID,
                              names=c("Code","Number"),
                              delim="-") %>% 
  unite(col=Born,
        Birthday,Birthyear,
        sep="") %>% 
  mutate(Height=Height/100,
         Born=dmy(Born),
         Age=interval(Born,today()) %>% 
           as.period() %>% 
           year()) %>% 
  relocate(Age, .after=Born) %>% 
  arrange(desc(Age))

## # A tibble: 23 × 10
##    Code  Number Born         Age Height Weight `Shoe size` Gender Nationality
##    <chr> <chr>  <date>     <dbl>  <dbl>  <dbl>       <dbl> <chr>  <chr>      
##  1 B     023    1952-05-07    72   1.65     62          43 M      Germany    
##  2 B     004    1966-05-03    58   1.68     64          38 F      Germany    
##  3 B     008    1970-04-04    54   1.82    102          43 M      Germany    
##  4 A     005    1975-07-18    49   1.6      75          36 F      Austria    
##  5 B     017    1975-04-16    49   1.92     95          40 M      France     
##  6 B     018    1978-06-04    46   1.54     58          38 F      France     
##  7 B     010    1985-09-03    39   1.55     89          39 F      Germany    
##  8 B     011    1992-08-01    32   1.92     92          46 M      Germany    
##  9 B     003    1995-02-18    29   1.68     70          42 M      Switzerland
## 10 A     021    1995-09-11    29   1.42     50          35 F      Germany    
## # ℹ 13 more rows
## # ℹ 1 more variable: Pets <chr>
```

This concludes the first session into the tidyverse. There still are
many more functions to discover! When working with the tidyverse -
especially in the beginning - I would recommend using the tidyverse
**Cheat Sheets** (exist for each package and visually explains various
important functions). And in case you forgot how to use a certain
function, remember that selecting a function and pressing F1 will summon
the Help page for this function with exemplary application. They can be
found online and can be a huge help when working with the tidyverse.

***Cheers,***

***Nico***
