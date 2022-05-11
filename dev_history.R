usethis::use_vignette("How-to-use-kclique")
usethis::use_r("list_kcliques.R")
usethis::use_package("magrittr")
usethis::use_package("igraph")
usethis::use_package("dplyr")
usethis::use_package("stringr")
usethis::use_citation()
usethis::use_r("create_graphs.R")


data_example <- structure(list(factor_A = c("A02", "A15", "A04", "A01", "A11",
"A13", "A05", "A05", "A05", "A05", "A08", "A06", "A14", "A14",
"A14", "A14", "A14", "A09", "A09", "A09", "A09", "A07", "A12",
"A12", "A10", "A10", "A10", "A03", "A03", "A03"), factor_B = c("B1",
"B1", "B1", "B1", "B1", "B1", "B1", "B1", "B1", "B1", "B2", "B2",
"B1", "B1", "B1", "B1", "B1", "B1", "B1", "B1", "B1", "B1", "B1",
"B1", "B1", "B1", "B1", "B1", "B1", "B1"), factor_C = c("C01",
"C01", "C01", "C01", "C01", "C01", "C06", "C08", "C01", "C02",
"C01", "C01", "C07", "C11", "C03", "C10", "C01", "C07", "C11",
"C03", "C01", "C03", "C12", "C04", "C09", "C11", "C05", "C09",
"C11", "C05")), row.names = c(NA, -30L), class = c("tbl_df",
"tbl", "data.frame"))
usethis::use_data(data_example, overwrite = TRUE)

# ?usethis::use_data()
usethis::use_r("data.R")


attachment::att_to_description()

usethis::use_r("plot_graph.R")

usethis::use_readme_rmd()
devtools::build_readme()
