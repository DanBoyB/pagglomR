#' Calculate effective densities
#'
#' This function reads in a matrix of generalised costs and calculates the
#' effective densities for each origin destination pair
#'
#' @param gen_costs dataframe of generalised costs
#' @param jobs dataframe of jobs
#' @param year modelled year
#' @keywords agglomeration, effective density
#' @return A list containing the modelled year and an effective density matrix
#' @export

calc_eff_dens <- function(gen_costs, jobs, year) {

    # calculate number of zones and number of sectors
    no_zones <- length(unique(gen_costs$o_zone))
    no_sectors <- nrow(parameters)

    # convert gen. costs to matrix
    gc_matrix <- matrix(gen_costs$gen_cost, no_zones, no_zones, byrow = TRUE)

    # calculate total jobs per zone
    total_jobs <- matrix(rowSums(jobs), nrow = no_zones, ncol = 1)

    # convert jobs by sector to matrix
    jobs_matrix <- data.matrix(jobs)

    # named vector of decay parameters
    decay_parameters <- parameters$decay_parameter
    names(decay_parameters) <- parameters$sector

    output_eff_dens <- function(jobs, gen_costs, decay_parameter) {

        # initialise output matrices
        eff_dens_zone <- matrix(0, no_zones, no_zones)

        for(i in 1:no_zones) {

            # calc matrix of effective densities
            eff_dens_zone[i, ] <- total_jobs / (gen_costs[i, ] ^ decay_parameter)

            # convert Infs and NaNs to zeros
            eff_dens_zone[is.infinite(eff_dens_zone) | is.nan(eff_dens_zone)] <- 0
        }

        # total effective densities by zone
        eff_dens_zone <- rowSums(eff_dens_zone)

        return(eff_dens_zone)
    }

    # calculate effective densities for each sector
    eff_dens_sector <- lapply(decay_parameters,
                            function(x) {
                             output_eff_dens(total_jobs,
                                             gc_matrix,
                                             x)
                           })

    # combine into effective density matrix
    eff_dens <- cbind(eff_dens_sector$Manufacturing,
                      eff_dens_sector$Construction,
                      eff_dens_sector$Wholesale_Retail,
                      eff_dens_sector$Transport,
                      eff_dens_sector$Inf_Comm_Tech,
                      eff_dens_sector$Fin_Bus_Services)

    return(list(year = year, eff_dens = eff_dens))
}
