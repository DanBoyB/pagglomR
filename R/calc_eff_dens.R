#' Calculate effective densities
#'
#' This function reads in a list of generalised costs by origin-destination pair
#' and also a dataframe of jobs by sector. It calculates the effective densities
#' for each modelled zone and for each employment sector.
#'
#' @param gen_costs a dataframe of generalised costs in the following format:
#'  `origin_zone`, `destination_zone`, `generalised_cost`
#' @param jobs a dataframe of jobs in each sector for each modelled zone. If the
#' analysis is being undertaken using the TII National Transport Model, the
#' \code{\link{ntpm_jobs}} data file provided with the `pagglomR` package can be
#' used. For other models, this file needs to be prepared for the transport
#' zone system in question.
#' @param year the modelled year. It is important that this is correctly
#' specified for the purposes of the productivity calculations and subsequent
#' discounting required.
#' @keywords agglomeration, effective density
#' @return A list containing the modelled year and an effective density matrix
#' that are required for the productivity calculations.
#' @export

calc_eff_dens <- function(gen_costs, jobs, year) {

    # check if no. zones in costs skim and jobs file are equal, or return error
    error_fn <- function(skim, jobs) {
        skim_zones <- length(unique(skim[[1]]))
        jobs_zones <- nrow(jobs)
        skim_zones == jobs_zones
    }

    if (error_fn(gen_costs, jobs) == FALSE)
        stop("No. of zones in jobs file must equal no. of zones in cost skim")

    # calculate number of zones
    no_zones <- length(unique(gen_costs$o_zone))

    # convert gen. costs to matrix
    gc_matrix <- matrix(gen_costs$gen_cost, no_zones, no_zones, byrow = TRUE)

    # calculate total jobs per zone
    total_jobs <- matrix(rowSums(jobs), nrow = no_zones, ncol = 1)

    # named vector of decay parameters
    decay_parameters <- parameters$decay_parameter
    names(decay_parameters) <- parameters$sector

    output_eff_dens <- function(jobs, gen_costs, decay_parameter) {

        # initialise output matrices
        eff_dens_zone <- matrix(0, no_zones, no_zones)

        for (i in 1:no_zones) {

            # calc matrix of effective densities
            eff_dens_zone[i, ] <- total_jobs /
                (gen_costs[i, ] ^ decay_parameter)

        }

        # convert Infs and NaNs to zeros
        eff_dens_zone[is.infinite(eff_dens_zone) | is.nan(eff_dens_zone)] <- 0

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
