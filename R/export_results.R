#' Output productivity impacts to an MS Word report or a csv file
#'
#' This function takes the outputs of the \code{\link{discounted_prod}} and the
#' \code{\link{prod_summary}} functions to produce an MS Word report or csv
#' summary of the outputs.
#'
#' @param benefits_summary the \code{R} object output by the
#' \code{\link{prod_summary}} function
#' @param benefits_discounted the \code{R} object output by the
#' \code{\link{discounted_prod}} function
#' @param output_format specify the output format as "report" for an MS Word
#' report or "csv" for a csv table of the discounted benefits by year.
#' @param scheme_name input a text string with the scheme name to be included in
#'  the MS Word report
#' @param scheme_scenario input a text string describing the scenario being
#' tested be included in the MS Word report
#' @param scheme_opening_year specify the scheme opening year
#' @param report_date input the date to be included in the MS Word report
#' @keywords agglomeration, benefits, report, output, results
#' @importFrom rmarkdown render word_document
#' @importFrom here here
#' @importFrom utils write.csv
#' @return An MS Word report summary or a csv table of results of
#' agglomeration impacts. Allows the user to interactively set file name. N.B.
#' ensure that correct file extension is specified, i.e. .csv or .docx
#' @export
#'
export_results <- function(benefits_summary,
                           benefits_discounted,
                           output_format = c("report",
                                             "csv"),
                           scheme_name,
                           scheme_scenario,
                           scheme_opening_year,
                           report_date) {

    # error messages
    if(output_format == "report" && missing(benefits_summary)) {
        stop("Summary benefits object missing")
    }

    if(missing(benefits_discounted)) {
        stop("Discounted benefits object missing")
    }

    if(missing(output_format)) {
        stop("Specify an output format ('csv' or 'report') using the output_format argument")
    }

    if(output_format == "report") {

        rmarkdown::render(
            system.file("rmd", "output-results-word.Rmd", package = "pagglomR"),
            output_format = rmarkdown::word_document(
                reference_docx = system.file("rmd", "template.docx", package = "pagglomR")
                ),
            output_file = file.choose(new = TRUE)
            )
    }

    if(output_format == "csv") {

        write.csv(benefits_discounted,
                  file.choose(new = TRUE)
                  )

    }


}
