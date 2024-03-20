# odsTableReadr

This R package allows users to read data in from named tables in ODS files, either by specifying a file and table name, or reading in every named table in an ODS file.

## Installation

This package can be installed directly from Github with:

```
install.packages("remotes")
remotes::install_github("department-for-transport-public/odsTableReadr")

```

## Usage

This package has three functions:

* `extract_table_ranges`: extract metadata about the tables in an ODS file, including name, sheet name, and cell range
* `read_ods_table`: read in a single named table from an ODS file
* `read_all_tables`: read in every named table from an ODS file. Choose to exclude common metadata sheets e.g. "Notes" or "Contents"
