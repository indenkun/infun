
<!-- README.md is generated from README.Rmd. Please edit that file -->

# infun

<!-- badges: start -->
<!-- badges: end -->

This is a collection of R utilities functions for me, but maybe also for
you.

Functions may be added, specifications of functions may change or become
obsolete, and names may change without notice.

## Installation

install the development version install from GitHub:

``` r
install.packages("remotes")
remotes::install_github("indenkun/infun")
```

## Example

load library.

``` r
library(infun)
```

Make a sample data for README (`example.data`).

``` r
example.data <- data.frame(value1 = 1:10,
                           value2 = c(1:3, "strings", 5:10),
                           value3 = c(1:3, "strings", 5:10),
                           value4 = 11:20)
```

### `find.not.numeric.value()`

This function is used to find the where in the vector there are values
that cannot be converted to numbers.

The fourth data in value2 of `example.data` will be a string.
`find.not.numeric.value()` will show where all the data in the vector is
located if there is a value that will be forced to NA when converted to
numeric type by `as.numeric()`. If there is no value to be converted, NA
is returned.

``` r
find.not.numeric.value(example.data$value1)
#> [1] NA
find.not.numeric.value(example.data$value2)
#> [1] 4
```

### `find.same.value.col()`

This function is used to find a column consisting of the same value in a
data frame.

If you run `same.value.col()` on `example.data`, you will see that the
second and third columns of the sample data all have the same value.

The result is returned in a list format.

``` r
find.same.value.col(example.data)
#> [[1]]
#> NULL
#> 
#> [[2]]
#> [1] 3
#> 
#> [[3]]
#> [1] 2
#> 
#> [[4]]
#> NULL
```

`unique_col()` is a function to remove duplicate columns in a data
frame, the column version of `{base}`’s `unique()`.

``` r
unique_col(example.data)
#>    value1  value2 value4
#> 1       1       1     11
#> 2       2       2     12
#> 3       3       3     13
#> 4       4 strings     14
#> 5       5       5     15
#> 6       6       6     16
#> 7       7       7     17
#> 8       8       8     18
#> 9       9       9     19
#> 10     10      10     20
```

### `add.str()`

Combine all the items in a specific column of a data frame with any
string of characters in the original data frame. The converted column
will be a string because it contains strings such as ALL.

You need to specify any column as `key` with the column name.

``` r
example.data.add.all <- add.str(example.data, "value1")
head(example.data.add.all, 20)
#>    value1  value2  value3 value4
#> 1       1       1       1     11
#> 2       2       2       2     12
#> 3       3       3       3     13
#> 4       4 strings strings     14
#> 5       5       5       5     15
#> 6       6       6       6     16
#> 7       7       7       7     17
#> 8       8       8       8     18
#> 9       9       9       9     19
#> 10     10      10      10     20
#> 11    ALL       1       1     11
#> 12    ALL       2       2     12
#> 13    ALL       3       3     13
#> 14    ALL strings strings     14
#> 15    ALL       5       5     15
#> 16    ALL       6       6     16
#> 17    ALL       7       7     17
#> 18    ALL       8       8     18
#> 19    ALL       9       9     19
#> 20    ALL      10      10     20
```

### `random.Date()`

`random.Date()` is a function that randomly creates a vector of dates at
a specified sample size between a specified date and a date.

``` r
random.Date(from = "2021/1/1", to = "2021/4/1", size = 10)
#>  [1] "2021-01-21" "2021-03-17" "2021-03-09" "2021-02-20" "2021-02-24"
#>  [6] "2021-02-22" "2021-02-06" "2021-03-24" "2021-02-03" "2021-03-11"
```

### `age.cal()`

`age.cal()` is a function that calculates the number of years (age by
default), months, and days from a specified date to a specified date.

``` r
age.cal(from = c("2000/1/1", "2010/1/1"), to = "2021/4/1")
#> [1] 21 11
```

### `tableone.rename.*()`

These functions are used to change the headline character in the item
name of a table created with `{tableone}`’s to any character.

`tableone.rename.overall()` is used to change the “Overall” character in
the item name of a table created with `{tableone}`’s `CreateTableOne()`
to any character.

``` r
# This is the code to create a sample table in `{tableone}`.
library(tableone)

iris.table <- CreateTableOne(data = iris)
iris.table
#>                           
#>                            Overall     
#>   n                         150        
#>   Sepal.Length (mean (SD)) 5.84 (0.83) 
#>   Sepal.Width (mean (SD))  3.06 (0.44) 
#>   Petal.Length (mean (SD)) 3.76 (1.77) 
#>   Petal.Width (mean (SD))  1.20 (0.76) 
#>   Species (%)                          
#>      setosa                  50 (33.3) 
#>      versicolor              50 (33.3) 
#>      virginica               50 (33.3)

# Rename "Overall" to "ALL".
tableone.rename.overall(iris.table, rename.str = "ALL")
#>                           
#>                            ALL         
#>   n                         150        
#>   Sepal.Length (mean (SD)) 5.84 (0.83) 
#>   Sepal.Width (mean (SD))  3.06 (0.44) 
#>   Petal.Length (mean (SD)) 3.76 (1.77) 
#>   Petal.Width (mean (SD))  1.20 (0.76) 
#>   Species (%)                          
#>      setosa                  50 (33.3) 
#>      versicolor              50 (33.3) 
#>      virginica               50 (33.3)
```

`tableone.rename.headline()` is a function that change any heading
(including Overall) to any character by setting the table heading as an
formula before and after the change.

``` r
# This is the code to create a sample table in `{tableone}`.
library(tableone)
library(survival)
data(pbc)

varsToFactor <- c("status","trt","ascites","hepato","spiders","edema","stage")
pbc[varsToFactor] <- lapply(pbc[varsToFactor], factor)
vars <- c("time","status","age","sex","ascites","hepato",
          "spiders","edema","bili","chol","albumin",
          "copper","alk.phos","ast","trig","platelet",
          "protime","stage")
tableOne <- CreateTableOne(vars = vars, strata = c("trt"), data = pbc, addOverall = TRUE)
tableOne
#>                       Stratified by trt
#>                        Overall           1                 2                
#>   n                        418               158               154          
#>   time (mean (SD))     1917.78 (1104.67) 2015.62 (1094.12) 1996.86 (1155.93)
#>   status (%)                                                                
#>      0                     232 (55.5)         83 (52.5)         85 (55.2)   
#>      1                      25 ( 6.0)         10 ( 6.3)          9 ( 5.8)   
#>      2                     161 (38.5)         65 (41.1)         60 (39.0)   
#>   age (mean (SD))        50.74 (10.45)     51.42 (11.01)     48.58 (9.96)   
#>   sex = f (%)              374 (89.5)        137 (86.7)        139 (90.3)   
#>   ascites = 1 (%)           24 ( 7.7)         14 ( 8.9)         10 ( 6.5)   
#>   hepato = 1 (%)           160 (51.3)         73 (46.2)         87 (56.5)   
#>   spiders = 1 (%)           90 (28.8)         45 (28.5)         45 (29.2)   
#>   edema (%)                                                                 
#>      0                     354 (84.7)        132 (83.5)        131 (85.1)   
#>      0.5                    44 (10.5)         16 (10.1)         13 ( 8.4)   
#>      1                      20 ( 4.8)         10 ( 6.3)         10 ( 6.5)   
#>   bili (mean (SD))        3.22 (4.41)       2.87 (3.63)       3.65 (5.28)   
#>   chol (mean (SD))      369.51 (231.94)   365.01 (209.54)   373.88 (252.48) 
#>   albumin (mean (SD))     3.50 (0.42)       3.52 (0.44)       3.52 (0.40)   
#>   copper (mean (SD))     97.65 (85.61)     97.64 (90.59)     97.65 (80.49)  
#>   alk.phos (mean (SD)) 1982.66 (2140.39) 2021.30 (2183.44) 1943.01 (2101.69)
#>   ast (mean (SD))       122.56 (56.70)    120.21 (54.52)    124.97 (58.93)  
#>   trig (mean (SD))      124.70 (65.15)    124.14 (71.54)    125.25 (58.52)  
#>   platelet (mean (SD))  257.02 (98.33)    258.75 (100.32)   265.20 (90.73)  
#>   protime (mean (SD))    10.73 (1.02)      10.65 (0.85)      10.80 (1.14)   
#>   stage (%)                                                                 
#>      1                      21 ( 5.1)         12 ( 7.6)          4 ( 2.6)   
#>      2                      92 (22.3)         35 (22.2)         32 (20.8)   
#>      3                     155 (37.6)         56 (35.4)         64 (41.6)   
#>      4                     144 (35.0)         55 (34.8)         54 (35.1)   
#>                       Stratified by trt
#>                        p      test
#>   n                               
#>   time (mean (SD))      0.883     
#>   status (%)            0.894     
#>      0                            
#>      1                            
#>      2                            
#>   age (mean (SD))       0.018     
#>   sex = f (%)           0.421     
#>   ascites = 1 (%)       0.567     
#>   hepato = 1 (%)        0.088     
#>   spiders = 1 (%)       0.985     
#>   edema (%)             0.877     
#>      0                            
#>      0.5                          
#>      1                            
#>   bili (mean (SD))      0.131     
#>   chol (mean (SD))      0.748     
#>   albumin (mean (SD))   0.874     
#>   copper (mean (SD))    0.999     
#>   alk.phos (mean (SD))  0.747     
#>   ast (mean (SD))       0.460     
#>   trig (mean (SD))      0.886     
#>   platelet (mean (SD))  0.555     
#>   protime (mean (SD))   0.197     
#>   stage (%)             0.201     
#>      1                            
#>      2                            
#>      3                            
#>      4

# Rename headline name "1" to "D-penicillmain", "2" to "placebo".
# Names that contain hyphens will be evaluated as negative in the formula, so they must be enclosed in quotation marks.
tableone.rename.headline(tableOne, rename.headline = list(1 ~ "D-penicillmain", 2 ~ placebo))
#>                       Stratified by trt
#>                        Overall           D-penicillmain    placebo          
#>   n                        418               158               154          
#>   time (mean (SD))     1917.78 (1104.67) 2015.62 (1094.12) 1996.86 (1155.93)
#>   status (%)                                                                
#>      0                     232 (55.5)         83 (52.5)         85 (55.2)   
#>      1                      25 ( 6.0)         10 ( 6.3)          9 ( 5.8)   
#>      2                     161 (38.5)         65 (41.1)         60 (39.0)   
#>   age (mean (SD))        50.74 (10.45)     51.42 (11.01)     48.58 (9.96)   
#>   sex = f (%)              374 (89.5)        137 (86.7)        139 (90.3)   
#>   ascites = 1 (%)           24 ( 7.7)         14 ( 8.9)         10 ( 6.5)   
#>   hepato = 1 (%)           160 (51.3)         73 (46.2)         87 (56.5)   
#>   spiders = 1 (%)           90 (28.8)         45 (28.5)         45 (29.2)   
#>   edema (%)                                                                 
#>      0                     354 (84.7)        132 (83.5)        131 (85.1)   
#>      0.5                    44 (10.5)         16 (10.1)         13 ( 8.4)   
#>      1                      20 ( 4.8)         10 ( 6.3)         10 ( 6.5)   
#>   bili (mean (SD))        3.22 (4.41)       2.87 (3.63)       3.65 (5.28)   
#>   chol (mean (SD))      369.51 (231.94)   365.01 (209.54)   373.88 (252.48) 
#>   albumin (mean (SD))     3.50 (0.42)       3.52 (0.44)       3.52 (0.40)   
#>   copper (mean (SD))     97.65 (85.61)     97.64 (90.59)     97.65 (80.49)  
#>   alk.phos (mean (SD)) 1982.66 (2140.39) 2021.30 (2183.44) 1943.01 (2101.69)
#>   ast (mean (SD))       122.56 (56.70)    120.21 (54.52)    124.97 (58.93)  
#>   trig (mean (SD))      124.70 (65.15)    124.14 (71.54)    125.25 (58.52)  
#>   platelet (mean (SD))  257.02 (98.33)    258.75 (100.32)   265.20 (90.73)  
#>   protime (mean (SD))    10.73 (1.02)      10.65 (0.85)      10.80 (1.14)   
#>   stage (%)                                                                 
#>      1                      21 ( 5.1)         12 ( 7.6)          4 ( 2.6)   
#>      2                      92 (22.3)         35 (22.2)         32 (20.8)   
#>      3                     155 (37.6)         56 (35.4)         64 (41.6)   
#>      4                     144 (35.0)         55 (34.8)         54 (35.1)   
#>                       Stratified by trt
#>                        p      test
#>   n                               
#>   time (mean (SD))      0.883     
#>   status (%)            0.894     
#>      0                            
#>      1                            
#>      2                            
#>   age (mean (SD))       0.018     
#>   sex = f (%)           0.421     
#>   ascites = 1 (%)       0.567     
#>   hepato = 1 (%)        0.088     
#>   spiders = 1 (%)       0.985     
#>   edema (%)             0.877     
#>      0                            
#>      0.5                          
#>      1                            
#>   bili (mean (SD))      0.131     
#>   chol (mean (SD))      0.748     
#>   albumin (mean (SD))   0.874     
#>   copper (mean (SD))    0.999     
#>   alk.phos (mean (SD))  0.747     
#>   ast (mean (SD))       0.460     
#>   trig (mean (SD))      0.886     
#>   platelet (mean (SD))  0.555     
#>   protime (mean (SD))   0.197     
#>   stage (%)             0.201     
#>      1                            
#>      2                            
#>      3                            
#>      4
```

### `seq_geometric()`

This function is used to generate a sequence of equal ratios, also known
as a geometric sequence.

By specifying the first term in `from`, the last term or the closest
value to the last term in `to`, and the common ratio in `by.rate`, you
can obtain an geometric sequence of “first term \* common ratio ^ n”
from “from” to the closest value to “to”.

``` r
seq_geometric(from = 1, to = 128, by.ratio = 2)
#> [1]   1   2   4   8  16  32  64 128
```

### `Rtools.pacman.package.*()`

These are functions to search for packages that can be installed by
Rtools’ pacman. In short, it is a wrapper for some of the functions of
pacman in Rtools.

Cannot be used except in a Windows environment where Rtools40 or later
is installed.

`Rtools.pacman.package.list()` is a function that outputs a list of
packages that can be installed by Rtools pacman from repository. By
specifying arguments, you can extract only those packages that are
already installed, or only those that are yet uninstalled.

``` r
package.list <- Rtools.pacman.package.list()
# It's too long, so show part of it in head()
head(package.list)
#> [1] "mingw32 mingw-w64-i686-aom 2.0.1-1"                  
#> [2] "mingw32 mingw-w64-i686-argtable 2.13-1"              
#> [3] "mingw32 mingw-w64-i686-arrow 4.0.0-1"                
#> [4] "mingw32 mingw-w64-i686-atk 2.36.0-2"                 
#> [5] "mingw32 mingw-w64-i686-aws-sdk-cpp 1.7.365-1"        
#> [6] "mingw32 mingw-w64-i686-binutils 2.33.1-1 [installed]"
```

`Rtools.pacman.package.list()` is a function that displays a list of
packages that can be installed by pacman in Rtools from repository with
the specified arguments in the string. If no matching package is found,
return NA.

``` r
Rtools.pacman.package.find("curl")
#> [1] "mingw32/mingw-w64-i686-curl 7.64.1-9202 [installed]"  
#> [2] "mingw64/mingw-w64-x86_64-curl 7.64.1-9202 [installed]"
```

### `scale.data.frame()`

`scale.data.frame()` is generic function whose default method centers
and/or scales the columns of a numeric in data frame. The non-numeric
values in the data frame will remain unchanged.

In short, it is a generic function of `{base}` `cale()`.

It is a generic function of `scale()`, so call it with `scale()` when
`{infun}` library is loaded. If the object is a data frame, this will
work by itself.

If you want to call it explicitly, use `infun:::scale.data.frame()`.

If you want to explicitly use the `{base}` `scale()` after loading
`{infun}` as a library, you can use it in `scale.default()`.

``` r
z.iris <- scale(iris)
# It's too long, so show part of it in head()
head(z.iris)
#>   Sepal.Length Sepal.Width Petal.Length Petal.Width Species
#> 1   -0.8976739  1.01560199    -1.335752   -1.311052  setosa
#> 2   -1.1392005 -0.13153881    -1.335752   -1.311052  setosa
#> 3   -1.3807271  0.32731751    -1.392399   -1.311052  setosa
#> 4   -1.5014904  0.09788935    -1.279104   -1.311052  setosa
#> 5   -1.0184372  1.24503015    -1.335752   -1.311052  setosa
#> 6   -0.5353840  1.93331463    -1.165809   -1.048667  setosa
```

### `save_gtsummary()`

This function is used to output the table created by the gtsummary
package in PowerPoint or Word, or as an image file. It just wraps
`{gtsummary}`’s `as_flex_table()` and `{flextalbe}`’s `save_as*()`
functions.

Supported filename extensions: .pptx, .docx, .png, .pdf, .jpg.

``` r
library(gtsummary)
library(tidyverse)

# Sample code for gtsummary
tbl_summary_ex1 <-
  trial %>%
  select(age, grade, response) %>%
  tbl_summary()
  
# Output the table created by gtsummary to PowerPoint(.pptx).
tbl_summary_ex1 %>% 
  save_gtsummary(path = "table.pptx")
```

### `round_any_*()`

`round_any()` is used to round a vector made of numbers to an
approximation of a sequence of numbers with arbitrary equidifferences.

If the value matches an arbitrary isoperimetric sequence, the value will
be output as is.

If the `type` argument is `ceiling`, it will round to the upper side of
the nearest value, and if the `type` argument is `floor`, it will round
to the lower side.

``` r
example.vector <- seq(0, 1, 0.1)
example.vector
#>  [1] 0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0

round_any(example.vector, by = 0.25, type = "ceiling")
#>  [1] 0.00 0.25 0.25 0.50 0.50 0.50 0.75 0.75 1.00 1.00 1.00

round_any(example.vector, by = 0.25, type = "floor")
#>  [1] 0.00 0.00 0.00 0.25 0.25 0.50 0.50 0.50 0.75 0.75 1.00
```

`round_any_ceiling()` is a simplified version of `round_any()`, which
outputs the result with the argument of `type` fixed to `ceiling` and
`origin` fixed to `0`. `round_any_floor()` is a simplified version of
`round_any()`, where the `type` argument is fixed to `floor` and the
`origin` is fixed to `0`. `round_any_*` is faster than `round_any()` in
most cases, because the internal processing is done as a vector.

**However, in rare cases, `round_any_*()` may not be possible to obtain
accurate values because of R’s internal floating point arithmetic.
`round_any()` creates a sequence of numbers and compares them, so it
gives accurate rounding results.**

``` r
round_any_ceiling(example.vector, 0.25)
#>  [1] 0.00 0.25 0.25 0.50 0.50 0.50 0.75 0.75 1.00 1.00 1.00

round_any_floor(example.vector, 0.25)
#>  [1] 0.00 0.00 0.00 0.25 0.25 0.50 0.50 0.50 0.75 0.75 1.00
```

### `rand_moji()`

Function to create a random Japanese (Kanji or Hiragana) string. Only
the range of regular kanji is supported.

It is also compatible and reproducible for `set.seed()`.

``` r
rand_moji(length = 3, size = 3, moji = "kanji")
#> [1] "缶販微" "症凸噴" "侍沖忌"

rand_moji(length = 3, size = 3, moji = "hiragana")
#> [1] "にうぁ" "もんゐ" "えヴり"
```

It is a random string, so it does not reflect the normal rules of
Japanese. In the case of hiragana, characters that do not normally
appear at the beginning of a string, such as Sutegana and “n”, will also
appear at the beginning.

Katakana strings are not supported and should be converted using
functions such as `stringi::stri_trans_general()` in the `{stringi}`
package.

``` r
hiragana.moji <- rand_moji(length = 3, size = 3, moji = "hiragana")
hiragana.moji
#> [1] "つざそ" "がせど" "せこへ"
katakana.moji <- stringi::stri_trans_general(hiragana.moji, "hiragana-katakana")
katakana.moji
#> [1] "ツザソ" "ガセド" "セコヘ"
```

## Imports packages

-   `{purrr}`

## Suggests packages

-   `{gtsummary}`
-   `{flextable}`
-   `{tools}`

## License

MIT.

## Notice

-   The email address listed in the DESCRIPTION is a dummy. If you have
    any questions, please post them on ISSUE.
