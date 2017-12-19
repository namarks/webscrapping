# Helper function for parsing overview
parse_overview <- function(x){
  tibble(date = html_text(html_nodes(x, ".date"), TRUE),
         text_1 = html_text(html_nodes(x, ".recherche_montrer"), TRUE),
         title = html_text(html_nodes(x, ".titre a"), TRUE),
         link = str_trim(html_attr(html_nodes(x, ".titre a"), "href")))
}

# Helper function for collapse multi-line output like person and text
collapse_to_text <- function(x){
  p <- html_text(x, trim = TRUE)
  p <- p[p != ""] # drop empty lines
  paste(p, collapse = "\n")
}

# Parse the result itself
parse_result <- function(x){
  tibble(section = html_text(html_node(x, ".level1 a"), trim = TRUE),
         sub_section = html_text(html_node(x, ".level2 a"), trim = TRUE),
         person = html_nodes(x, "p:nth-child(2) , .article p:nth-child(1)") %>% collapse_to_text,
         text_2 = html_nodes(x, ".col1 > p") %>% collapse_to_text)
}

