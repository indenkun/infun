
<!-- README.md is generated from README.Rmd. Please edit that file -->

# infun

<!-- badges: start -->
<!-- badges: end -->

This is a collection of R utilities functions for me, but maybe also for
you.

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

### `add.str()`

Combine all the items in a specific column of a data frame with any
string of characters in the original data frame.

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
#>  [1] "2021-01-02" "2021-02-18" "2021-01-31" "2021-03-14" "2021-02-14"
#>  [6] "2021-03-10" "2021-01-09" "2021-01-14" "2021-03-09" "2021-02-20"
```

### `age.cal()`

`age.cal()` is a function that calculates the number of years (age by
default), months, and days from a specified date to a specified date.

``` r
age.cal(from = c("2000/1/1", "2010/1/1"), to = "2021/4/1")
#> [1] 21 11
```

### `tableone.overall.rename()`

This function is used to change the “Overall” character in the item name
of a table created with `{tableone}`’s `CreateTableOne()` to any
character.

``` r
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
tableone.overall.rename(iris.table, rename.str = "ALL")
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

## `seq_geometric()`

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

## Imports packages

-   `{purrr}`

## Suggests packages

-   `{tableone}`

## License

MIT.
