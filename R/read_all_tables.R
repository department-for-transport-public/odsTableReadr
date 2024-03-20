#' Read all tables from an OpenDocument Spreadsheet (ODS) file, with the option to include or exclude common metadata sheets
#'
#' @param file Path to the ODS file containing the tables.
#' @param exclude_meta Logical indicating whether to exclude metadata tables. Default is TRUE.
#'
#' @return A list of dataframes, each representing a table from the ODS file.
#'
#' @importFrom dplyr filter
#' @importFrom purrr map
#'
#' @export

read_all_tables <- function(file, exclude_meta = TRUE){

  ##Return list of tables in sheet
  tbl_range <- extract_table_ranges(file)

  ##Exclude metadata if we need to
  if(exclude_meta){

    tbl_range_dropped <- tbl_range %>%
    ##Drop common metadata sheet names
    dplyr::filter(!grepl("cover|content|notes", sheet_name, ignore.case = TRUE))

    message(nrow(tbl_range) - nrow(tbl_range_dropped),
            " metadata tables excluded from read")

    tbl_range <- tbl_range_dropped

  }

  ##Turn table range into a named vector
  tbl_names <- tbl_range$table_name
  names(tbl_names) <- tbl_range$table_name

  ##Read in all the tables. Nice.
  purrr::map(.x = tbl_names,
             .f = read_ods_table,
             file = file)

}


