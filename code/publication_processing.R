# This processes figures for STAT guidelines...

library(tidyverse)
library(stringr)

# --- Pull out all figure captions and reference names ---
chunks <- readLines("index.tex")
figures_start <- which(str_detect(chunks, "\\\\begin.figure."))
figures_end <-  which(str_detect(chunks, "\\\\end.figure."))

# doesn't work with subcaptions yet
get_info <- function(lines, start, end) {
  x <- lines[start:end] %>% paste(collapse = " ")
  res <- tibble(file = str_extract_all(x, "\\\\includegraphics(?:\\[(.*?)\\])?\\{(.*?)\\}") %>% str_remove_all("\\\\includegraphics\\[(.*)\\]\\{|\\}$"),
                caption = str_extract(x, "\\\\caption(?:\\[(.*?)\\])?\\{.*\\}") %>% 
                  str_remove_all("\\\\caption(?:\\[(.*?)\\])?") %>%
                  str_remove_all("\\\\label\\{.*?\\}") %>%
                  str_remove_all("\\\\end\\{figure\\}") %>%
                  str_remove_all("(^\\{)|(\\}\\s{1,})$") %>%
                  str_trim(),
                label = str_extract(x, "\\\\label\\{.*?\\}") %>% str_remove_all("\\\\label\\{|\\}$"),
                output = paste0("file: ", file, "\\n", "caption:", "\\n", caption, "\\nlabel: ", label, "\\n\\n")
  )
}

res <- purrr::map2_dfr(figures_start, figures_end, get_info, lines = chunks, .id = "figure") %>%
  mutate(output = paste0("figure: ", figure, "\\n", output)) %>%
  mutate(figure = sprintf("%03d", as.numeric(figure))) %>%
  group_by(figure) %>%
  mutate(subfig = ifelse(n() > 1, paste0("-", as.character(row_number())), ""))
res$output %>% str_split("\\\\n") %>% unlist() %>%
  writeLines(con = "figure_summary")

# --- Rename figures as author-figure-1 ---

res <- res %>%
  mutate(files = map(file, ~list.files(dirname(.), pattern = basename(.), full.names = T))) %>%
  unnest(files) %>%
  mutate(new_filename = paste0("figure/vanderplas-figure-", figure, subfig, str_replace(basename(files), "^(.*?)\\.(.*?)$", ".\\2")))
  

file.copy(res$files, res$new_filename, overwrite = T)


