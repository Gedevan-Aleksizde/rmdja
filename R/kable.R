#' 
#'
#' @title knitr::kable wrapper
#' @export
#' @inherit knitr::kable
#' @family kable wrappers
#' @description kable wrapper to parse markdown syntax in caption when output latex
#' @details This function is a wrapper of \code{knitr::\link[knitr]{kable}()} to parse caption strings written in markdown syntax

kable <- function(
  x,
  format,
  digits = getOption("digits"),
  row.names = NA,
  col.names = NA,
  align,
  caption = NULL,
  label = NULL,
  format.args = list(),
  escape = TRUE,
  ...
) {
  knitr::kable(
    x = x,
    digits = digits,
    row.names = row.names,
    col.names = col.names,
    caption = if(knitr::is_latex_output()) commonmark::markdown_latex(caption) else caption,
    label = label,
    format.args = format.args,
    escape = escape,
    ...
  )
}
#' @title kableExtra::kbl wrapper
#' @export
#' @inherit kableExtra::kbl
#' @family kable wrappers
#' @description kbl wrapper to parse markdown syntax in caption when output latex
#' @details This function is a wrapper of \code{kableExtra::\link[kableExtra]{kbl}()} to parse caption strings written in markdown syntax when output of LaTeX.

kbl <- function(x,
                format,
                digits = getOption("digits"),
                
                row.names = NA,
                col.names = NA,
                align,
                caption = NULL,
                label = NULL,
                format.args = list(),
                escape = TRUE,
                table.attr = "",
                booktabs = FALSE,
                longtable = FALSE,
                valign = "t",
                position = "",
                centering = TRUE,
                vline = getOption("knitr.table.vline", if (booktabs)
                  ""
                  else
                    "|"),
                toprule = getOption("knitr.table.toprule", if (booktabs)
                  "\\toprule"
                  else
                    "\\hline"),
                bottomrule = getOption("knitr.table.bottomrule", if (booktabs)
                  "\\bottomrule"
                  else
                    "\\hline"),
                midrule = getOption("knitr.table.midrule", if (booktabs)
                  "\\midrule"
                  else
                    "\\hline"),
                linesep = if (booktabs)
                  c("", "", "", "", "\\addlinespace")
                else
                  "\\hline",
                caption.short = "",
                table.envir = if (!is.null(caption))
                  "table",
                ...) {
  if("kableExtra" %in% installed.packages()){
    kableExtra::kbl(
      x = x,
      digits = digits,
      row.names = row.names,
      col.names = col.names,
      caption = if(knitr::is_latex_output()) commonmark::markdown_latex(caption) else caption,
      label = label,
      format.args = format.args,
      escape = escape,
      table.attr = table.attr,
      booktabs = booktabs,
      longtable = longtable,
      valign = valign,
      position = position,
      centering = centering,
      vline = vline,
      toprule = toprule,
      bottomrule = bottomrule,
      midrule = midrule,
      linesep = linesep,
      caption.short = caption.short,
      table.envir = table.envir,
      ...
    )
  } else {
    stop("package `kableExtra` not found.")
  }
}
