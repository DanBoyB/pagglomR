#' GVA Factors
#'
#' Factors to apply growth to future year GVA values and to discount to present
#' value
#'
#' @format A data frame with fout variables: \code{year}: year,
#'  \code{discount}: discount rate, \code{gva_growth}: GVA growth rates from
#'  PAG, \code{gva_compound}: GVA growth compounded
"gva_factors"

#' Agglomeration Parameters
#'
#' Sectoral agglomeration parameters
#'
#' @format A data frame with 2 variables: \code{sector}: Sector,
#' \code{gva_person}: GVA per person, \code{decay_parameter}: distance decay
#' parameter, \code{elasticity}: elasticity of effictive density to productivity
"parameters"

#' Do Minimum 2024
#'
#' Sample generalised cost outputs from a transport model for a 2024 forecast
#' year and a Do Minimum scenario.
#'
#' @format A tibble with 3 variables: \code{o_zone}: Origin Zone,
#' \code{d_zone}: Destination Zone, \code{gen_cost}: generalised cost for each
#' OD pair
"dm_2024"

#' Do Minimum 2039
#'
#' Sample generalised cost outputs from a transport model for a 2039 forecast
#' year and a Do Minimum scenario.
#'
#' @format A tibble with 3 variables: \code{o_zone}: Origin Zone,
#' \code{d_zone}: Destination Zone, \code{gen_cost}: generalised cost for each
#' OD pair
"dm_2039"

#' Do Minimum 2054
#'
#' Sample generalised cost outputs from a transport model for a 2054 forecast
#' year and a Do Minimum scenario.
#'
#' @format A tibble with 3 variables: \code{o_zone}: Origin Zone,
#' \code{d_zone}: Destination Zone, \code{gen_cost}: generalised cost for each
#' OD pair
"dm_2054"

#' Do Something 2024
#'
#' Sample generalised cost outputs from a transport model for a 2024 forecast
#' year and a Do Something scenario.
#'
#' @format A tibble with 3 variables: \code{o_zone}: Origin Zone,
#' \code{d_zone}: Destination Zone, \code{gen_cost}: generalised cost for each
#' OD pair
"ds_2024"

#' Do Something 2039
#'
#' Sample generalised cost outputs from a transport model for a 2039 forecast
#' year and a Do Something scenario.
#'
#' @format A tibble with 3 variables: \code{o_zone}: Origin Zone,
#' \code{d_zone}: Destination Zone, \code{gen_cost}: generalised cost for each
#' OD pair
"ds_2039"

#' Do Something 2054
#'
#' Sample generalised cost outputs from a transport model for a 2054 forecast
#' year and a Do Something scenario.
#'
#' @format A tibble with 3 variables: \code{o_zone}: Origin Zone,
#' \code{d_zone}: Destination Zone, \code{gen_cost}: generalised cost for each
#' OD pair
"ds_2054"

#' Sample Jobs
#'
#' Sample jobs data for demo of \code{pagglomR} package.
#'
#' @format A dataframe with 6 variables: \code{Manufacturing}: jobs
#' in manufacturing sector, \code{Construction}: jobs in construction sector,
#' \code{Wholesale_Retail}: jobs in wholesale & retail sector,
#' \code{Inf_Comm_Tech}: jobs in information, communication & technology
#'  sector, #' \code{Fin_Bus_Services}: jobs in financial & business services
#'  sector.
"jobs"
