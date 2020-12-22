#' Produce summary table of productivity benefits
#'
#' This function generates a summary table of the productivity benefits in
#' present value terms using an input object generated from the
#' \code{\link{discounted_prod}} function. These benefits are expressed in
#' present value terms for the 30 appraisal period and the residual value
#' period. They can be added to the Present Value of Benefits (PVB) from the
#' transport user benefits element of the Cost Benefit Analysis as part of the
#' sensitivity testing process.
#'
#' @param prod_table objects containing the productivity benefits for each
#' modelled year output using the \code{calc_prod_impacts} function.
#' @keywords agglomeration, benefits, discounting
#' @import dplyr
#' @return A productivity benefits summary table
#' @export

prod_summary <- function(prod_table) {

    benefits_30 <- prod_table %>%
        dplyr::filter(modelled > 0) %>%
        dplyr::slice(1:30) %>%
        dplyr::summarise(discounted = sum(.data$discounted)) %>%
        dplyr::mutate(period = "30 year benefits")

    benefits_resid <- prod_table %>%
        dplyr::filter(modelled > 0) %>%
        dplyr::slice(31:60) %>%
        dplyr::summarise(discounted = sum(.data$discounted)) %>%
        dplyr::mutate(period = "Residual value benefits")

    total_benefits <- benefits_30 %>%
        dplyr::bind_rows(benefits_resid) %>%
        dplyr::select(.data$period, .data$discounted) %>%
        dplyr::rename(pv_benefits = .data$discounted)

    return(total_benefits)
}
