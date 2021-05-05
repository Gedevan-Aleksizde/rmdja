#' @title PDF でもSVG画像を貼り付けるためのラッパ関数
#' @inheritDotParams knitr::include_graphics
#' @details 使用法は \code{knitr::\link{include_graphics}} と基本的に同じ. PDF 出力かつ SVG のときに `rsvg` パッケージを使用して画像を PDF に変換する. https://stackoverflow.com/questions/50165404/how-to-make-a-pdf-using-bookdown-including-svg-images に基づいて作成. 
# 
include_graphics_svg = function(path, ...) {
  if (knitr::is_latex_output() && xfun::file_ext(path, "svg")) {
    output = xfun::with_ext(path, 'pdf')
    rsvg::rsvg_pdf(svg = x, file = output)
  } else {
    output = path
  }
  knitr::include_graphics(output, ...)
}