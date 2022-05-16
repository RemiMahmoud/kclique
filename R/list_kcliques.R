#' @title  Maximal multipartite clique enumeration
#' @description  Function to enumerate all maximal kcliques within a k-partite graph. It is a direct implementation of
#' the algorithms used come from this paper Phillips et al. <doi:10.3390/a12010023>.
#'
#' @param G a k-partite graph, from class graph (package igraph).
#' @param dat a dataset with multiple columns, each column containing each factor composing the k sets of the G

#' @return A character vector containing all maximal kcliques ; each element of the vector is a maximal kclique ; each member of each clique is separated by a ";"
#' @import magrittr
#' @importFrom igraph get.adjacency graph_from_adjacency_matrix neighborhood degree
#' @importFrom stringr str_split
#' @export
#'
maximal_kclique_enumeration <- function(G, dat){
  #References to line correspond to the article of Philips et al. 2019 <doi:10.3390/a12010023>.

  adj_matrix_G_with_intrapartite <- G %>% get.adjacency() %>% as.matrix
  factors <- colnames(dat)
  number_factors <- length(factors)
  number_modalities_factors <- apply(dat, 2,function(x){length(unique(x))})


  # Pre-allocate the space for the adjacency matrix as output
  partition <- as.list(rep(NA,number_factors))
  for(i in 1:number_factors){
    temp_rownames <- c(unique(dat[[i]]))
    adj_matrix_G_with_intrapartite[temp_rownames, temp_rownames] <- 1
    partition[[i]] = temp_rownames
  }
  diag(adj_matrix_G_with_intrapartite) <- 0


  G_with_intrapartite <-  adj_matrix_G_with_intrapartite %>%
    graph_from_adjacency_matrix(mode = "undirected")


  # R contains the current clique;
  # P contains vertices that can extend the current clique;
  # X contains vertices that have already been considered
  # line 4
  R <- character(0)
  P <- degree(G_with_intrapartite) %>% names # Set of vertices as characters
  X <- character(0)
  kcliques_discovered <- character(0)
  output <- enumerate(G_with_intrapartite, R, P, X, partition, kcliques_discovered)


  output <- stringr::str_split(output, pattern = "//")[[1]] #Separate kcliques
  output <- output[-length(output)] # Remove last element of output that is a " "
  return(output)


}

#' Check if a set covers a partition
#' check if a set covers a partition, that is: "it contains at least one element from each cell of the partition"
#'
#' @param set a character vector containing members of the set
#' @param partition a list of character vector containing members of the partition
#'
#' @return A logical: TRUE if the set covers the partition and FALSE if not
#'
covers <- function(set, partition){
  flag <- TRUE
  for(i in partition){
    if(!any(set %in% i)){
      flag <- FALSE
    }
  }
  return(flag)
}


#' Enumerate the cliques of a graph
#' @description Sub Routine enumerate described in <doi:10.3390/a12010023>.
#'
#' @param G a k-partite graph, from class graph (package igraph).
#' @param R character vector containing the current clique
#' @param P character vector containing the vertices that can extend the current clique
#' @param X character vector containing the vertices thathave already been considered
#' @param partition a list of character vector containing members of the partition
#' @param cliques_discovered a list of the previously discovered kcliques
#' @return A logical: TRUE if the set covers the partition and FALSE if not
#'
enumerate <- function(G, R, P, X, partition, cliques_discovered){
  if(length(P) == 0 & length(X) == 0){
    if(covers(set = R, partition =partition)){
      return(paste(paste(R, collapse = ";"), cliques_discovered, sep = "//" ))
    } else {
      return(cliques_discovered)
    }
  } else{

    # choose a pivot vertex u in choose a pivot vertex u inP union X that maximizes |P inter N(u)|;
    PuX <- unique(c(P,X))
    max_pinterNu <- 0
    candidate <- character(0)

    for(u in PuX){
      PinterNu <- intersect(P,names(neighborhood(G, nodes = u)[[1]])[-1])
      if(length(PinterNu) >= max_pinterNu) {max_pinterNu <- length(PinterNu) ; candidate <- u}

    }

    P_minus_Nu <- setdiff(P,names(neighborhood(G, nodes = candidate)[[1]])[-1])

    for(v in P_minus_Nu){

      Ruv = unique(c(R, v))
      PinterNv <- intersect(P,names(neighborhood(G, nodes = v)[[1]])[-1])
      XinterNv <- intersect(X,names(neighborhood(G, nodes = v)[[1]])[-1])
      cliques_discovered <- enumerate(G, Ruv, PinterNv, XinterNv, partition, cliques_discovered) #line9
      P <- setdiff(P, v) #line10
      X <- unique(c(X,v)) #line11
    }
  }
  return(cliques_discovered)
}




#' From a string containing the kcliques, detects to which set each node belongs
#'
#' @param string_input input a character vector containing members of the kcliques
#' @param dat a dataset with multiple columns, each column containing each factor composing the k sets of the G
#' @param sep separator between node names
#'
#' @importFrom stringr str_split str_remove
#' @importFrom tibble as_tibble
#' @importFrom dplyr mutate across everything
#'
function_detect_belonging <- function(string_input, dat, sep =";" ){

  factors <- colnames(dat)
  number_factors <- length(factors)

  # data_output <- as.data.frame(matrix(character(0), nrow = 1, ncol = number_factors, dimnames = list(NULL ,factors)))
  data_output <- as_tibble(matrix(character(0), nrow = 1, ncol = number_factors, dimnames = list(NULL ,factors)))

  list_modalities_factor <- lapply(dat, unique)
  string_input_splitted <- sort(stringr::str_split(string_input, pattern = sep)[[1]])


  for(s in string_input_splitted){
    ind_s <- which(sapply(list_modalities_factor, function(x) s %in% x))
    data_output[1,ind_s] <- paste( s, data_output[,ind_s], sep = "-")
  }

  return(data_output %>% mutate(across(.cols = everything() , ~stringr::str_remove(.x, "-NA"))))


}

#' @title  Formatted data from a kclique object
#'
#' @param  kcliques output of maximal_kclique_enumeration function
#' @param dat a sorted dataset with multiple columns, each column containing each factor composing the k sets of the G. Rows are sorted according to the total members in the kclique
#' @param arrange_by_n_members a logical indicating if the data has to be returned arranged by decreasing number of kclique members
#' @importFrom  dplyr bind_rows select desc arrange
#' @export

function_list_kcliques_to_tibble <- function(kcliques, dat,  arrange_by_n_members = TRUE){

  n <- NULL

  tibble_output <-bind_rows(lapply(c(kcliques), function_detect_belonging, dat = dat ))
  tibble_arranged <- function_count_members_from_tibble(tibble_output) %>%
    arrange(desc(n)) %>%
    select(-n)
  return(tibble_arranged)
}




#' @title  Function to arrange rows by number of members of the kclique
#'
#' @param  tibble_k_clique output of function_list_kcliques_to_tibble function
#' @param columns_to_select Columns to for which the number of members has to be counted, can be a character vector or some selection helper (like everything() or last_col())
#' @param sep the separator used to separate kclique members in the input tibble
#' @importFrom  dplyr any_of rowwise mutate ungroup
#' @importFrom tidyr unite
#' @export
function_count_members_from_tibble <- function(tibble_k_clique, columns_to_select = everything(), sep = "-"){

  n <- NULL
  united_column <- NULL

  tibble_arranged <- tibble_k_clique %>%
    unite("united_column", any_of(columns_to_select), remove = FALSE, sep = sep) %>%
    rowwise %>%
    mutate(n = length(stringr::str_split(united_column, pattern = sep)[[1]]) )%>%
    ungroup %>%
    # arrange(desc(n)) %>%
    select(-c( united_column))


  return(tibble_arranged)
}
