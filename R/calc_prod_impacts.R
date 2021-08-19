#' Calculate effective densities
#'
#' This function reads in Do Minimum and Do Something effective density matrices,
#' and jobs data and applies the TII PAG Irish agglomeration parameters to
#' calculate productivity impacts for the relevant modelled year.
#'
#' @param eff_dens_dm Do Minimum effective density object create by
#' \code{\link{calc_eff_dens}}
#' @param eff_dens_ds Do Something effective density object create by
#' \code{\link{calc_eff_dens}}
#' @param jobs a dataframe of jobs in each sector for each modelled zone. If the
#' analysis is being undertaken using the TII National Transport Model, the
#' \code{\link{ntpm_jobs}} data file provided with the `pagglomR` package can be
#' used. For other models, this file needs to be prepared for the transport
#' zone system in question.
#' @keywords agglomeration, productivity
#' @return A list containing the modelled year and a productivity matrix
#' @export

calc_prod_impacts <- function(eff_dens_dm, eff_dens_ds, jobs) {

    # check if no. zones in ed skims and jobs file are equal, or return error
    error_fn_jobs <- function(skim, jobs) {
        ed_zones <- nrow(skim[[2]])
        jobs_zones <- nrow(jobs)
        ed_zones == jobs_zones
    }

    error_fn_ed <- function(dm_skim, ds_skim) {
        dm_zones <- nrow(dm_skim[[2]])
        ds_zones <- nrow(ds_skim[[2]])
        dm_zones == ds_zones
    }

    if(error_fn_ed(eff_dens_dm, eff_dens_ds) == FALSE)
        stop("No. of zones in Do Min Effective Densities must equal no. of zones in Do Some Effective Densities")

    if(error_fn_jobs(eff_dens_dm, jobs) == FALSE)
        stop("No. of zones in jobs file must equal no. of zones in Do Min Effective Densities")

    if(error_fn_jobs(eff_dens_ds, jobs) == FALSE)
        stop("No. of zones in jobs file must equal no. of zones in Do Some Effective Densities")

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
                prod_total = total_productivity,
                by_zone = productivity,
                prod_sector = sectoral_productivity
                ))
}
