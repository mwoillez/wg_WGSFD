
# packages
library(RODBC)
# settings
dbConnection <- 'Driver={SQL Server};Server=SQL06;Database=VMS;Trusted_Connection=yes'

# create directories
if (!dir.exists("data")) dir.create("data")
if (!dir.exists("data/fishingPressure")) dir.create("data/fishingPressure")

# connect to DB
conn <- odbcDriverConnect(connection = dbConnection)

years <- 2015
datacallyears <- 2016:2017

for (datacallyear in datacallyears) {

datatable <- sprintf("_%s_ICES_VMS_Datacall_VMS", datacallyear)

if (!dir.exists(paste0("data/fishingPressure/", datatable))) dir.create(paste0("data/fishingPressure/", datatable))


for (year in years) {
  cat("downloading Fishing pressure total data for ... ", year, "\n")
  flush.console()
  
  # set up sql command
  sqlq <- paste(readLines("rawDataProc/create_total_template.sql"), collapse = "\n")
  sqlq <- sprintf(paste("select * FROM (", sprintf(sqlq, datatable) , ") as x  WHERE year = '%s'"), year)
  fname <- paste0("data/fishingPressure/", datatable,"/OSPAR_intensity_data_total_", year, ".csv")
  
  # fetch
  out <- sqlQuery(conn, sqlq)
  # save to file
  write.csv(out, file = fname, row.names = FALSE)
}


for (year in years) {
  cat("downloading Fishing pressure JNCC grouping data for ... ", year, "\n")
  flush.console()
  
  # set up sql command
  sqlq <- paste(readLines("rawDataProc/create_JNCC_groups_template.sql"), collapse = "\n")
  sqlq <- sprintf(paste("select * FROM (", sprintf(sqlq, datatable), ") as x  WHERE year = '%s'"), year)
  fname <- paste0("data/fishingPressure/", datatable,"/OSPAR_intensity_data_jncc_", year, ".csv")

  # fetch
  out <- sqlQuery(conn, sqlq)
  # save to file
  write.csv(out, file = fname, row.names = FALSE)
}


for (year in years) {
  cat("downloading Fishing pressure Benthis grouping data for ... ", year, "\n")
  flush.console()
  
  # set up sql command
  sqlq <- paste(readLines("rawDataProc/create_Benthis_groups_template.sql"), collapse = "\n")
  sqlq <- sprintf(paste("select * FROM (", sprintf(sqlq, datatable), ") as x  WHERE year = '%s'"), year)
  fname <- paste0("data/fishingPressure/", datatable,"/OSPAR_intensity_data_benthis_", year, ".csv")
  
  # fetch
  out <- sqlQuery(conn, sqlq)
  # save to file
  write.csv(out, file = fname, row.names = FALSE)
}

}

# disconnect
odbcClose(conn)
