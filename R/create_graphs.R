
#' @title Compute graph from matrix with factors as columns
#' @description Get the graph linked to a table where each line represents a combination of factors

#' @param dat a dataset with multiple columns, each column containing each factor composing the k sets of the G
#' @import magrittr
#' @importFrom igraph graph_from_adjacency_matrix
#' @return a k-partite graph, from class graph (package igraph).
#' @export

get_graph_from_dat <- function(dat){

  G <- graph_from_adjacency_matrix(adjmatrix = get_adjacency_matrix_from_dat(dat), mode = "undirected")
  return(G)
}

#' @title Compute adjacency matrix from matrix with factors as columns
#' @description Get the adjacency matrix linked to a table where each line represents a combination of factors

#' @param dat a dataset with multiple columns, each column containing each factor composing the k sets of the G
#' @import magrittr
#' @importFrom dplyr distinct select mutate across everything
#' @importFrom igraph graph.edgelist get.adjacency
#' @importFrom utils combn
#'
get_adjacency_matrix_from_dat <- function(dat){
  # Function to compute an adjacency matrix linking multiple modalities of different factors together


  # Get features related to the factors

  type_columns <- sapply(dat, class)

  if(any(type_columns == "numeric")){
    index_numeric <- which(type_columns == "numeric")

    if(length(index_numeric)== 1){
      warning(paste0("Type of column ", paste(names(type_columns)[index_numeric], collapse = " and "), " is numeric, converting it to character"))
    } else {
      warning(paste0("Types of columns ", paste(names(type_columns)[index_numeric], collapse = " and "), " are numeric, converting them to characters"))
      }
    dat <- dat %>% mutate(across(everything(), as.character))
  }
  factors <- colnames(dat)
  number_factors <- length(factors)
  number_modalities_factors <- apply(dat, 2,function(x){length(unique(x))})


  # Pre-allocate the space for the adjacency matrix as output
  nrow_adjacency_matrix_all <- sum(number_modalities_factors)
  rownames_adjacency_matrix <- rep(NA_character_, nrow_adjacency_matrix_all)
  ind_tab <- c(0,cumsum(number_modalities_factors[1:number_factors]))

  for(i in 1:number_factors){
    rownames_adjacency_matrix[(1+ind_tab[i]):(ind_tab[i+1] )] <- unique(dat[[i]])

  }

  adj_matrix_all <-  matrix(0, nrow = sum(number_modalities_factors),
                            ncol = sum(number_modalities_factors),
                            dimnames = list(rownames_adjacency_matrix,
                                            rownames_adjacency_matrix))


  #all pairs of factors
  combn_factors <- combn(1:number_factors,2)

  for(d in 1:ncol(combn_factors)){


    ind_columns <- combn_factors[,d]

    names_adj_matrix <- c(unique(dat[[ind_columns[1]]]),unique(dat[[ind_columns[2]]]))

    # create the adjacency matrix related to the subgraph made of the two current factors
    adj_matrix <- dat %>%
      select(source = ind_columns[1], target = ind_columns[2])%>%
      distinct  %>%
      as.matrix %>%
      graph.edgelist(directed = F) %>%
      get.adjacency() %>%
      as.matrix

    adj_matrix <- adj_matrix[names_adj_matrix,names_adj_matrix] # Reorder rows and col to put them in right order

    # Put the sub-adjacency_matrix into the big one
    adj_matrix_all[names_adj_matrix, names_adj_matrix] <- adj_matrix
  }

  return(adj_matrix_all)
}

