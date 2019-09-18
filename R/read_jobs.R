#' Read in jobs data
#'
#' This function reads in tab delimited formatted jobs data
#'
#' @param path path to where the jobs data is saved
#' @keywords agglomeration, jobs
#' @import dplyr
#' @importFrom utils read.table
#' @return A dataframe of jobs
#' @export

read_jobs <- function(path) {
    jobs <- read.table(path)

    names(jobs) <- c("Manufacturing",
                     "Construction",
                     "Wholesale_Retail",
                     "Transport",
                     "Inf_Comm_Tech",
                     "Fin_Bus_Services")

    return(jobs)
}
