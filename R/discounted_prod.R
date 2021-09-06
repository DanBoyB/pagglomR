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
#' @param appraisal_year Year in which appraisal is being undertaken (used to
#' apply the appropriate discount rate)
#' @param ... objects containing the productivity benefits for each modelled
#' year output using the \code{calc_prod_impacts} function.
#' @keywords agglomeration, benefits, discounting
#' @import dplyr
#' @importFrom zoo na.approx
#' @importFrom tibble as_tibble
#' @return A table of benefits over the 60 year appraisal period
#' @export

discounted_prod <- function(appraisal_year, ...) {

    x <- list(...)
    prod_df <- data.frame(year = as.integer(),
                      modelled = as.numeric())

    for (i in 1:length(x)) {
        prod_df[i, ] <- unlist(x[[i]])
    }

    years <- prod_df[, 1]
    initial_years <- appraisal_year:(prod_df[, 1][1] - 1)

    discounting_df <- data.frame(year = years[1]:years[length(years)]) %>%
        dplyr::left_join(prod_df, by = "year") %>%
        # interpolate between modelled years
        dplyr::mutate(modelled = zoo::na.approx(.data$modelled)) %>%
        # add years up to 60 year appraisal period
        dplyr::add_row(year = (years[length(years)] + 1):(years[1] + 59)) %>%
        # add sequence of years from appraisal year (current) to opening year
        dplyr::add_row(year = initial_years, .before = 1) %>%
        # add column for appraisal year number, starting with current year
        dplyr::mutate(appraisal_year = row_number()) %>%
        # apply the benefits in latest horizon year to remaining appraisal years
        dplyr::mutate(modelled = case_when(
            .data$year <= years[length(years)] ~ .data$modelled,
            .data$year > years[length(years)]  ~
                nth(.data$modelled,
                    years[length(years)] - initial_years[1] + 1))) %>%
        dplyr::mutate(modelled = case_when(
            is.na(modelled) ~ 0,
            TRUE ~ as.numeric(modelled)
        )) %>%
        dplyr::left_join(
            select(gva_factors, .data$year, .data$gva_compound, .data$discount),
            by = "year"
            ) %>%
        dplyr::mutate(nominal = .data$modelled * .data$gva_compound,
                      discounted = .data$nominal * .data$discount) %>%
        dplyr::select(-.data$discount, -.data$gva_compound)

    return(tibble::as_tibble(discounting_df))
}
