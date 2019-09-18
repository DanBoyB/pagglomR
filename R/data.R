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
