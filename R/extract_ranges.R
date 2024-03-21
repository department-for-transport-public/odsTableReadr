
#' Extract Table Ranges
#'
#' Extracts table metadata from an ODS file, with table and sheet name, and cell range span.
#'
#' @param x Path to an ODS file containing tables to be extracted.
#'
#' @return A dataframe with three columns: table_name, sheet_name, and cell_range.
#'         The table_name column contains the names of the tables, sheet_name contains
#'         the names of the sheets, and cell_range contains the cell ranges of the tables.
#'
#' @importFrom xml2 read_xml xml_find_all xml_attr
#' @importFrom dplyr filter mutate select
#' @importFrom tidyr separate pivot_longer pivot_wider
#' @importFrom utils unzip
#' @importFrom magrittr "%>%"
#'
#' @export

extract_table_ranges <- function(x) {
  ##Extract table spans from file
  tmp <- tempdir()

  ##Unzip into temp folder
  utils::unzip(x, exdir = tmp, files = "content.xml")

  ##Find all tables
  all_tables <- xml2::read_xml(file.path(tmp, "content.xml")) %>%
    xml2::xml_find_all("//table:database-range")

  ##Extract names, sheets and ranges into a dataframe
  table_details <- data.frame(
    "table_name" = xml2::xml_attr(all_tables, "name"),
    "table_address" = xml2::xml_attr(all_tables, "target-range-address")
  )

  ##Skip processing if there are no tables in the sheet
  if(nrow(table_details) == 0){
    table_details <- NULL
    warning("No tables found in this workbook")
  } else{

    table_details <- table_details %>%
    ##Drop any pseudo tables
    dplyr::filter(!grepl("^__", table_name)) %>%
    ##Split table sheets and cell addresses
    tidyr::separate(table_address,
                    into = c("start", "end"),
                    sep = "[:]") %>%
    tidyr::pivot_longer(cols = c(start, end)) %>%
    tidyr::separate(value,
                    into = c("sheet_name", "cell"),
                    sep = "[.]") %>%
    ##Combine cell values into a range
    tidyr::pivot_wider(names_from = name,
                       values_from = cell) %>%
    dplyr::mutate(cell_range = paste0(start, ":", end)) %>%
    dplyr::select(table_name, sheet_name, cell_range) %>%
    ##Scrub any quotation marks from sheet name
    dplyr::mutate(sheet_name = gsub("\\'", "", sheet_name))
  }

  #Remove content file
  unlink(file.path(tmp, "content.xml"))

  return(table_details)
}
