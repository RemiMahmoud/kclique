


#' @title  Plot multipartite graph
#' @description  Function to plot a multipartite graph with a given layout
#'
#' @param G a k-partite graph, from class graph (package igraph).
#' @param dat a datasets with multiple columns, each column containing each factor composing the k sets of the G
#' @param layout_name The type of layout to create. Either a valid string, a function, a matrix, or a data.frame (see help(ggraph::ggraph))
#' @param size_text a numeric passed to the size argument of function geom_node_text, default 3.5
#' @param color_text a character passed to the colour argument of function geom_node_text, default "black"
#' @param color_edges a character passed to the colour argument of function geom_edge_link, default "black"

#' @return  An object of class ggraph::gg onto which layers, scales,
#'   etc. can be added.
#' @import magrittr
#' @importFrom tidygraph as_tbl_graph activate .N
#' @importFrom dplyr mutate
#' @importFrom ggraph ggraph geom_edge_link geom_node_point geom_node_text
#' @importFrom ggplot2 theme aes
#' @export
#'

plot_graph <- function(G, dat, layout_name = "in_circle", size_text = 3.5, color_text = "black", color_edges = "black"){

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
    geom_edge_link(colour = color_edges) +
    geom_node_point(size = 10, aes(colour = variable)) +
    geom_node_text(aes(label = name), colour = color_text, vjust = 0.4, size = size_text) +
    theme(legend.position = "bottom")

  # + xlim(c(-1.1,1.1))

  return(plot_G)
}






#' @title  Assign node to a set
#' @description  Function to add each node to a given set

#' @param dat a datasets with multiple columns, each column containing each factor composing the k sets of the G
#' @param node_names the vector of node names of the graph
#'
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






#' @title  Plot a kclique
#' @description  Function to highlight a kclique one a graph
#'
#' @param G a k-partite graph, from class graph (package igraph).
#' @param dataset a datasets with multiple columns, each column containing each factor composing the k sets of the G
#' @param layout_name The type of layout to create. Either a valid string, a function, a matrix, or a data.frame (see help(ggraph::ggraph))
#' @param tibble_kcliques An output of the function function_list_kcliques_to_tibble
#' @param vector_kcliques a vector containing the rows of the tibble containing the kcliques you want to highlight
#' @param automatic_nodes a logical telling if the nodes have to be colored accordingly to their partite's belonging
#' @param show_legend_edges a logical telling if the edges' color legend has to be shown
#' @param color_edge_kclique a string indicating the color of the edges members of the kclique
#' @param color_edge_no_kclique a string indicating the color of the edges that are not members of the kclique
#' @param size_text a numeric passed to the size argument of function geom_node_text, default 3.5
#'
#'

#' @return  An object of class ggraph::gg onto which layers, scales,
#'   etc. can be added.
#' @importFrom stringr str_replace_all str_split
#' @importFrom igraph degree
#' @importFrom tidygraph as_tbl_graph activate .N edge_is_to edge_is_from
#' @importFrom dplyr mutate filter
#' @importFrom ggraph ggraph geom_edge_link geom_node_point geom_node_text scale_edge_color_manual
#' @importFrom ggplot2 theme aes
#' @export
#'
plot_kclique <- function(G, tibble_kcliques, dataset, vector_kcliques = 1,
                             automatic_nodes = TRUE, show_legend_edges = FALSE,
                             color_edge_kclique = "black", color_edge_no_kclique = "grey75",
                             layout_name = "in_circle",
                         size_text = 3.5){

  if(length(vector_kcliques) > 1){stop("for now only possible to plot one kclique (i.e provide vector_kcliques of length 1)")}

  variable = NULL
  nodes = NULL
  edges = NULL
  name = NULL
  Var1 = NULL
  Var2 = NULL
  kclique = NULL

  plotlist <- list()

  for(i in seq_along(vector_kcliques)){
    v = vector_kcliques[i]
    current_kclique <- tibble_kcliques[v,] %>%
      as.data.frame %>%
      as.vector %>%
      paste(collapse = ";") %>%
      stringr::str_replace_all("-", ";")

    list_modalities <- stringr::str_split(current_kclique, ";")[[1]]
    index_modalities <- which(names(degree(G))%in%list_modalities  )

    grid_from_to <- expand.grid(index_modalities, index_modalities) %>%
      filter(Var1 !=Var2)


    tbl_graph <- G %>%
      as_tbl_graph() %>%
      activate(edges) %>%
      mutate(kclique = edge_is_from(from = grid_from_to$Var1) & edge_is_to(grid_from_to$Var2))

    if(automatic_nodes){tbl_graph <- tbl_graph %>%
      activate(nodes)  %>%
      mutate(variable = function_assign_node_to_partite(.N()$name, dat= dataset))
    }
    plot_kclique <- tbl_graph %>%
      ggraph(layout = layout_name ) +
      geom_edge_link(aes(colour = kclique), show.legend = show_legend_edges) +
      scale_edge_color_manual(values = c("FALSE" = color_edge_no_kclique, "TRUE" = color_edge_kclique))

    if(automatic_nodes){
      plot_kclique <- plot_kclique +
      geom_node_point(size = 10, aes(color = variable))+
      geom_node_text(aes(label = name), colour = 'black', vjust = 0.4, size = size_text) +
      theme(legend.position = "bottom")}
    else{
        plot_kclique <- plot_kclique +
        geom_node_point(size = 10, color = "lightblue")+
        geom_node_text(aes(label = name), colour = 'black', vjust = 0.4, size = size_text) +
        theme(legend.position = "bottom") }


  }
  # return(plotlist)
  return(plot_kclique)
}

