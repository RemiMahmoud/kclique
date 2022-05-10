


#' @title  Plot multipartite graph
#' @description  Function to plot a multipartite graph with a given layout
#'
#' @param G a k-partite graph, from class graph (package igraph).
#' @param dat a datasets with multiple columns, each column containing each factor composing the k sets of the G
#' @param layout_name The type of layout to create. Either a valid string, a function, a matrix, or a data.frame (see help(ggraph::ggraph))

#' @return  An object of class ggraph::gg onto which layers, scales,
#'   etc. can be added.
#' @import magrittr
#' @importFrom tidygraph as_tbl_graph activate .N
#' @importFrom dplyr mutate
#' @importFrom ggraph ggraph geom_edge_link geom_node_point geom_node_text
#' @importFrom ggplot2 theme aes
#' @export
#'

plot_graph <- function(G, dat, layout_name = "in_circle"){

  variable = NULL
  nodes = NULL
  name = NULL

  tbl_graph <- G %>%
    as_tbl_graph %>%
    activate(nodes) %>%
    mutate(variable = function_assign_node_to_partite(.N()$name, dat))

  plot_G <- tbl_graph %>%
    ggraph(layout = layout_name ) +
    # ggraph(layout = 'manual',x = coords$x, y= coords$y, circular= FALSE ) +
    geom_edge_link() +
    geom_node_point(size = 10, aes(colour = variable)) +
    geom_node_text(aes(label = name), colour = 'black', vjust = 0.4, size = 3.5) +
    theme(legend.position = "bottom")

  # + xlim(c(-1.1,1.1))

  return(plot_G)
}






#' @title  Assign node to a set
#' @description  Function to add each node to a given set

#' @param dat a datasets with multiple columns, each column containing each factor composing the k sets of the G
#' @param node_names the vector of node names of the graph
function_assign_node_to_partite <- function(node_names, dat){

  factors <- colnames(dat)
  number_factors <- length(factors)


  list_modalities_factor <- lapply(dat, unique)

  vec_output <- rep(NA_character_, length(node_names))

  for(i in seq_along(node_names)){

    tmp_node_name <- node_names[i]
    ind_factor <- which(sapply(list_modalities_factor, function(x) tmp_node_name %in% x))
    vec_output[i] <- factors[ind_factor]
  }

  return(vec_output)

}
