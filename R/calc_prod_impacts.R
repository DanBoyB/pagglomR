#' Calculate effective densities
#'
#' This function reads in Do Minimum and Do Something effective density matrices,
#' and jobs data and applies the PAG agglomeration parameters to calculate
#' producvity impacts for the inputted model year
#'
#' @param eff_dens_dm Do Minimum effective density object create by
#' \code{\link{calc_eff_dens}}
#' @param eff_dens_ds Do Something effective density object create by
#' \code{\link{calc_eff_dens}}
#' @param jobs dataframe of jobs
#' @keywords agglomeration, productivity
#' @return A list containing the modelled year and a productivity matrix
#' @export

calc_prod_impacts <- function(eff_dens_dm, eff_dens_ds, jobs) {

    # calculate number of zones and number of sectors
    no_zones <- nrow(eff_dens_dm$eff_dens)
    no_sectors <- nrow(parameters)

    # convert jobs by sector to matrix
    jobs_matrix <- data.matrix(jobs)

    # initialise output matrix
    productivity <- matrix(0, no_zones, no_sectors)

    for(i in 1:no_sectors) {
        productivity[, i] <- (((eff_dens_ds$eff_dens[, i] / eff_dens_dm$eff_dens[, i]) ^
                                   parameters$elasticity[i]) - 1) *
            parameters$gva_person[i] * jobs_matrix[, i]
    }

    # convert Infs and NaNs to zeros
    productivity[is.infinite(productivity) | is.nan(productivity)] <- 0

    # calculate productivity per sector
    sectoral_productivity <- colSums(productivity)
    names(sectoral_productivity) <- c("Manufacturing",
                                      "Construction",
                                      "Wholesale_Retail",
                                      "Transport",
                                      "Inf_Comm_Tech",
                                      "Fin_Bus_Services")

    # calculate total productivity
    total_productivity <- sum(productivity)

    return(list(year = eff_dens_dm$year,
                prod_total = total_productivity
                # ,
                # prod_sector = sectoral_productivity
                ))
}
