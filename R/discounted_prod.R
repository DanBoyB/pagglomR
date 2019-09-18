#' Produce table of modelled, nominal and discounted productivity benefits
#'
#' This function generates a table of the modelled, nominal and discounted
#' productivity benefits over the 60 year appraisal period. It reads in the
#' producitivty benefits calculated for each modelled year and interpolates
#' values for years in between the modelled years. It also calculates nominal
#' productivity benefits per annum by applying GVA growth based on the rates in
#' Table X of PAG Unit 6.11. Discounted benefits are then calculated by applying
#' the test discount rate to the nominal benefits.
#'
#' @param ... objects containing the productivity benefits for each modelled
#' year output using the \code{calc_prod_impacts} function.
#' @keywords agglomeration, benefits, discounting
#' @import dplyr
#' @importFrom zoo na.approx
#' @importFrom tibble as_tibble
#' @return A table of benefits over the 60 year appraisal period
#' @export

discounted_prod <- function(...) {

    x <- list(...)
    prod_df <- data.frame(year = as.integer(),
                      modelled = as.numeric())

    for(i in 1:length(x)) {
        prod_df[i, ] <- unlist(x[i])
    }

    years <- prod_df[, 1]

    # NEED TO MAKE THIS GENERALISABLE TO ACCOMMODATE VARIABLE INPUTS
    # E.G. RESULTS FROM > 3 YEARS (for loop to add rows based on no. years)
    # prod_df <- prod_df %>%
    #     dplyr::add_row(year = (years[1] + 1):(years[2] - 1), .before = 2) %>%
    #     dplyr::add_row(year = (years[2] + 1):(years[3] - 1),
    #             .after = years[2] - years[1] + 1)
    #
    # prod_df <- prod_df %>%
    #     dplyr::mutate(modelled = zoo::na.approx(.data$modelled)) %>%
    #     dplyr::add_row(year = (years[3] + 1):(years[1] + 59)) %>%
    #     dplyr::mutate(modelled = case_when(
    #         .data$year <= years[3] ~ .data$modelled,
    #         .data$year > years[3]  ~ nth(.data$modelled, years[3] - years[1] + 1)))
    #
    # prod_df <- prod_df %>%
    #     dplyr::left_join(select(gva_factors, .data$year, .data$gva_compound, .data$discount),
    #               by = "year") %>%
    #     dplyr::mutate(nominal = .data$modelled * .data$gva_compound,
    #            discounted = .data$nominal * .data$discount) %>%
    #     dplyr::select(-.data$discount, -.data$gva_compound)

    discounting_df <- data.frame(year = years[1]:years[length(years)]) %>%
        left_join(prod_df, by = "year") %>%
        dplyr::mutate(modelled = zoo::na.approx(.data$modelled)) %>%
        dplyr::add_row(year = (years[length(years)] + 1):(years[1] + 59)) %>%
        dplyr::mutate(modelled = case_when(
            .data$year <= years[length(years)] ~ .data$modelled,
            .data$year > years[length(years)]  ~ nth(.data$modelled,
                                                     years[length(years)] - years[1] + 1))) %>%
        dplyr::left_join(select(gva_factors, .data$year, .data$gva_compound, .data$discount),
                         by = "year") %>%
        dplyr::mutate(nominal = .data$modelled * .data$gva_compound,
                      discounted = .data$nominal * .data$discount) %>%
        dplyr::select(-.data$discount, -.data$gva_compound)

    return(tibble::as_tibble(discounting_df))
}
