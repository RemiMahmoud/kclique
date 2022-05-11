
<!-- README.md is generated from README.Rmd. Please edit that file -->

# kclique

<!-- badges: start -->
<!-- badges: end -->

The goal of kclique is to enumerate all maximal kcliques within a
k-partite graph.

## Installation

You can install the development version of kclique from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("RemiMahmoud/kclique")
#> Downloading GitHub repo RemiMahmoud/kclique@HEAD
#> utf8         (1.2.1       -> 1.2.2     ) [CRAN]
#> crayon       (1.5.0       -> 1.5.1     ) [CRAN]
#> fansi        (0.5.0       -> 1.0.3     ) [CRAN]
#> vctrs        (0.3.8       -> 0.4.1     ) [CRAN]
#> tidyselect   (1.1.1       -> 1.1.2     ) [CRAN]
#> tibble       (3.1.2       -> 3.1.7     ) [CRAN]
#> magrittr     (2.0.1       -> 2.0.3     ) [CRAN]
#> dplyr        (1.0.6       -> 1.0.9     ) [CRAN]
#> RcppArmad... (0.9.860.2.0 -> 0.11.0.0.0) [CRAN]
#> Rcpp         (1.0.7       -> 1.0.8.3   ) [CRAN]
#> igraph       (1.3.0       -> 1.3.1     ) [CRAN]
#> tidyr        (1.1.3       -> 1.2.0     ) [CRAN]
#> colorspace   (2.0-1       -> 2.0-3     ) [CRAN]
#> RColorBrewer (1.1-2       -> 1.1-3     ) [CRAN]
#> withr        (2.4.3       -> 2.5.0     ) [CRAN]
#> scales       (1.1.1       -> 1.2.0     ) [CRAN]
#> digest       (0.6.27      -> 0.6.29    ) [CRAN]
#> ggplot2      (3.3.3       -> 3.3.6     ) [CRAN]
#> RcppEigen    (0.3.3.7.0   -> 0.3.3.9.2 ) [CRAN]
#> tweenr       (1.0.1       -> 1.0.2     ) [CRAN]
#> stringi      (1.6.2       -> 1.7.6     ) [CRAN]
#> viridis      (0.5.1       -> 0.6.2     ) [CRAN]
#> ggrepel      (0.8.2       -> 0.9.1     ) [CRAN]
#> ggforce      (0.3.1       -> 0.3.3     ) [CRAN]
#> Installing 24 packages: utf8, crayon, fansi, vctrs, tidyselect, tibble, magrittr, dplyr, RcppArmadillo, Rcpp, igraph, tidyr, colorspace, RColorBrewer, withr, scales, digest, ggplot2, RcppEigen, tweenr, stringi, viridis, ggrepel, ggforce
#> Installation des packages dans 'C:/Users/rmahmoud/AppData/Local/Temp/RtmpIfeWpI/temp_libpath31d839df4832'
#> (car 'lib' n'est pas spécifié)
#> package 'utf8' successfully unpacked and MD5 sums checked
#> package 'crayon' successfully unpacked and MD5 sums checked
#> package 'fansi' successfully unpacked and MD5 sums checked
#> package 'vctrs' successfully unpacked and MD5 sums checked
#> package 'tidyselect' successfully unpacked and MD5 sums checked
#> package 'tibble' successfully unpacked and MD5 sums checked
#> package 'magrittr' successfully unpacked and MD5 sums checked
#> package 'dplyr' successfully unpacked and MD5 sums checked
#> package 'RcppArmadillo' successfully unpacked and MD5 sums checked
#> package 'Rcpp' successfully unpacked and MD5 sums checked
#> package 'igraph' successfully unpacked and MD5 sums checked
#> package 'tidyr' successfully unpacked and MD5 sums checked
#> package 'colorspace' successfully unpacked and MD5 sums checked
#> package 'RColorBrewer' successfully unpacked and MD5 sums checked
#> package 'withr' successfully unpacked and MD5 sums checked
#> package 'scales' successfully unpacked and MD5 sums checked
#> package 'digest' successfully unpacked and MD5 sums checked
#> package 'ggplot2' successfully unpacked and MD5 sums checked
#> package 'RcppEigen' successfully unpacked and MD5 sums checked
#> package 'tweenr' successfully unpacked and MD5 sums checked
#> package 'stringi' successfully unpacked and MD5 sums checked
#> package 'viridis' successfully unpacked and MD5 sums checked
#> package 'ggrepel' successfully unpacked and MD5 sums checked
#> package 'ggforce' successfully unpacked and MD5 sums checked
#> 
#> The downloaded binary packages are in
#>  C:\Users\rmahmoud\AppData\Local\Temp\Rtmp6rhewG\downloaded_packages
#>          checking for file 'C:\Users\rmahmoud\AppData\Local\Temp\Rtmp6rhewG\remotes28b4182d5707\RemiMahmoud-kclique-b974aba/DESCRIPTION' ...     checking for file 'C:\Users\rmahmoud\AppData\Local\Temp\Rtmp6rhewG\remotes28b4182d5707\RemiMahmoud-kclique-b974aba/DESCRIPTION' ...   v  checking for file 'C:\Users\rmahmoud\AppData\Local\Temp\Rtmp6rhewG\remotes28b4182d5707\RemiMahmoud-kclique-b974aba/DESCRIPTION' (651ms)
#>       -  preparing 'kclique':
#>    checking DESCRIPTION meta-information ...     checking DESCRIPTION meta-information ...   v  checking DESCRIPTION meta-information
#>       -  checking for LF line-endings in source and make files and shell scripts
#>       -  checking for empty or unneeded directories
#>       -  building 'kclique_0.0.0.9000.tar.gz'
#>      
#> 
#> Installation du package dans 'C:/Users/rmahmoud/AppData/Local/Temp/RtmpIfeWpI/temp_libpath31d839df4832'
#> (car 'lib' n'est pas spécifié)
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(kclique)

# Other packages needed
library(dplyr)
#> Warning: le package 'dplyr' a été compilé avec la version R 4.1.3
#> 
#> Attachement du package : 'dplyr'
#> Les objets suivants sont masqués depuis 'package:stats':
#> 
#>     filter, lag
#> Les objets suivants sont masqués depuis 'package:base':
#> 
#>     intersect, setdiff, setequal, union
library(igraph)
#> Warning: le package 'igraph' a été compilé avec la version R 4.1.3
#> 
#> Attachement du package : 'igraph'
#> Les objets suivants sont masqués depuis 'package:dplyr':
#> 
#>     as_data_frame, groups, union
#> Les objets suivants sont masqués depuis 'package:stats':
#> 
#>     decompose, spectrum
#> L'objet suivant est masqué depuis 'package:base':
#> 
#>     union
library(tidygraph)
#> Warning: le package 'tidygraph' a été compilé avec la version R 4.1.3
#> 
#> Attachement du package : 'tidygraph'
#> L'objet suivant est masqué depuis 'package:igraph':
#> 
#>     groups
#> L'objet suivant est masqué depuis 'package:stats':
#> 
#>     filter
## basic example code
```

### Load toy data

``` r
data("data_example", package ="kclique")

knitr::kable(head(data_example))
```

| factor\_A | factor\_B | factor\_C |
|:----------|:----------|:----------|
| A02       | B1        | C01       |
| A15       | B1        | C01       |
| A04       | B1        | C01       |
| A01       | B1        | C01       |
| A11       | B1        | C01       |
| A13       | B1        | C01       |

As an example, imagine a set of three factors, with various modalities
and combinations of modalities. You can represent the co-occurence of
the modalities by a graph.

### Set graph

``` r
# compute adjacency_matrix
adj_matrix <- get_adjacency_matrix_from_dat(data_example)

#compute the associated graph
graph_example <- adj_matrix %>% igraph::graph_from_adjacency_matrix(mode = "undirected")
```

### Plot data

We can plot the graph, using one color for each factor

``` r
plot_graph_example <- plot_graph(G = graph_example, dat = data_example)
plot_graph_example
```

<img src="man/figures/README-unnamed-chunk-4-1.png" width="100%" />

### List maximal kcliques

If we want to look for all the maximal complete factorial design, we
need to enumerate all the maximal kcliques present in the graph.

``` r
kcliques_example <- kclique::maximal_kclique_enumeration(graph_example, data_example)

knitr::kable(kcliques_example)
```

| x                                          |
|:-------------------------------------------|
| B1;C01;C03;C11;C07;C10;A14                 |
| B1;C01;C03;C11;C07;A09;A14                 |
| B1;C01;A05;C06;C02;C08                     |
| B1;C01;A02;A09;A14;A05;A13;A11;A01;A04;A15 |
| B1;A10;A03;C11;C05;C09                     |
| B1;A10;A03;C11;A14;A09                     |
| B1;A12;C12;C04                             |
| B1;A07;A09;A14;C03                         |
| A08;A06;B2;C01                             |

### Format kclique in a nice output format

``` r
tibble_kclique <- function_list_kcliques_to_tibble(kcliques_example, data_example)

knitr::kable(tibble_kclique)
```

| factor\_A                           | factor\_B | factor\_C           |
|:------------------------------------|:----------|:--------------------|
| A14                                 | B1        | C11-C10-C07-C03-C01 |
| A14-A09                             | B1        | C11-C07-C03-C01     |
| A05                                 | B1        | C08-C06-C02-C01     |
| A15-A14-A13-A11-A09-A05-A04-A02-A01 | B1        | C01                 |
| A10-A03                             | B1        | C11-C09-C05         |
| A14-A10-A09-A03                     | B1        | C11                 |
| A12                                 | B1        | C12-C04             |
| A14-A09-A07                         | B1        | C03                 |
| A08-A06                             | B2        | C01                 |

We identified 9 maximal kcliques, involving various combinations of
factors’ modalities.

<!-- You'll still need to render `README.Rmd` regularly, to keep `README.md` up-to-date. `devtools::build_readme()` is handy for this. You could also use GitHub Actions to re-render `README.Rmd` every time you push. An example workflow can be found here: <https://github.com/r-lib/actions/tree/v1/examples>. -->
<!-- You can also embed plots, for example: -->
<!-- In that case, don't forget to commit and push the resulting figure files, so they display on GitHub and CRAN. -->
