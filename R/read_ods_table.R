
#' Read the data in from a specified table in an OpenDocument Spreadsheet (ODS) file.
#'
#' @param file Path to the ODS file.
#' @param tbl_name Name of the table to be extracted.
#'
#' @return A dataframe of the dats from the specified.
#'
#' @importFrom dplyr filter
#' @importFrom readODS read_ods
#'
#' @export

read_ods_table <- function(file, tbl_name){
  ##Return list of tables in sheet
  tbl_range <- extract_table_ranges(file)

  if(nrow(tbl_range) == 0){
    stop("File ", file, " contains no marked up tables. Consider using read_ods function from the readODS package instead")
  }

  chosen_tbl <- tbl_range %>%
    dplyr::filter(table_name == tbl_name)

  ##Check we've got only one table to read in
  if(nrow(chosen_tbl) == 0){
    stop("Table ", tbl_name, " not found in this file")
  }

  ##Read in the file and table
  readODS::read_ods(path = file,
                    sheet = chosen_tbl$sheet_name,
                    range = chosen_tbl$cell_range,
                    na = c("[x]", "..", "[z]", "x"))

}
