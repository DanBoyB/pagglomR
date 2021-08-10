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
#' @param scheme_name input the scheme name to be included in the MS Word report
#' @param report_date input the date to be included in the MS Word report
#' @param file_name input name of file for .docx or .csv output
#' @keywords agglomeration, benefits, report, output, results
#' @importFrom rmarkdown render word_document
#' @importFrom here here
#' @return A table of benefits over the 60 year appraisal period
#' @export
#'
export_results <- function(benefits_summary,
                           benefits_discounted,
                           output_format = c("report",
                                             "csv"),
                           scheme_name,
                           report_date,
                           file_name) {

    # error messages
    if(missing(file_name)) {
        stop("Specify a file name using the file_name argument")
    }

    if(output_format == "csv" && missing(benefits_summary)) {
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
            "output-results-word.Rmd",
            output_format = rmarkdown::word_document(
                reference_docx = "template.docx"
                ),
            output_file = here::here(paste0(file_name, ".docx"))
            )
    }

    if(output_format == "csv-summary") {

        write.csv(benefits_discounted,
                  here::here(paste0(file_name, ".csv"))
                  )

    }


}
