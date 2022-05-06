#' @title  Maximal multipartite clique enumeration
#' @description  Function to enumerate all maximal kcliques within a k-partite graph. It is a direct implementation of
#' the algorithms used come from this paper Phillips et al. <doi:10.3390/a12010023>.
#'
#' @param G a k-partite graph, from class graph (package igraph).
#' @param dat a datasets with multiple columns, each column containing each factor composing the k sets of the G

#' @return A character vector containing all maximal kcliques ; each element of the vector is a maximal kclique ; each member of each clique is separated by a ";"
#' @import magrittr
#' @importFrom igraph get.adjacency graph_from_adjacency_matrix neighborhood degree
#' @importFrom stringr str_split
#' @export
#'
maximal_kclique_enumeration <- function(G, dat){


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
#' check if a set covers a partition, that is: "it contains at least one element from each cell of the partition"
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

