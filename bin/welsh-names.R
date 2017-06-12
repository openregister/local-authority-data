# Extract the welsh names from the docx supplied by welsh-government

library(tidyverse)
library(docxtractr)

welsh_names_docx <- "../lists/welsh-government/welsh-names.docx"
welsh_names_tsv <- "../lists/welsh-government/welsh-names.tsv"
register_tsv <- "../data/principal-local-authority/principal-local-authority.tsv"

welsh_names <-
  read_docx(welsh_names_docx) %>%
  docx_extract_tbl() %>%
  set_names(c("official-name", "official-name-cy")) %>%
  write_tsv(welsh_names_tsv)

# Do the provided names match the existing register?

register <- read_tsv(register_tsv)

anti_join(welsh_names, register, by = "official-name")

# "City & County of Swansea" doesn't match "City and County of Swansea Council"

swansea_row <- which(welsh_names$`official-name` == "City & County of Swansea")
welsh_names[swansea_row, "official-name"] <- "City and County of Swansea Council"

register %>%
  inner_join(welsh_names, by = "official-name") %>%
  select(`principal-local-authority`,
         name,
         `name-cy`,
         `official-name`,
         `official-name-cy`,
         `start-date`,
         `end-date`) %>%
  write_tsv(register_tsv, na = "")
