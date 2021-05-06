svg2pdf_hook <- function(x, options){
  if(knitr::is_latex_output() && xfun::file_ext(x) == "svg"){
    output = xfun::with_ext(x, 'pdf')
    rsvg::rsvg_pdf(svg = x, file = xfun::with_ext(x, "pdf"))
    knitr::hook_plot_md(output, options)
  } else {
    knitr::hook_plot_md(x, options)
  }
}

generate_graphics_font_hook <- function(family){
  f <- function(before, options, envir){
    if(before){
      # TODO: ggplot2 用の設定
      par(family = family)
    }
  }
  return(f)
}