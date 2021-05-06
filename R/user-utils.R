#' @title PDF でもSVG画像を貼り付けるためのラッパ関数
#' @export
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

#' @title TeX 環境構築用関数
#' @export
#' @details rmdja に必要な Tinytex とかの設定を一括して実行する. tinytex や TeX Live 以外の方法で TeX をインストールしている場合の動作は保証しません. 
#' 1. TeX が未インストールなら tinytex::install_tinytex() でインストール
#' 2. 念の為最低限必要なパッケージをインストール
setup_tinytex_rmdja <- function(){
  if(!tinytex::is_tinytex()) {
    if(tinytex::tinytex_root(F) != ""){ # TODO
      message(gettextf("TeX is already installed at %s. installation skipped.", tinytex::tinytex_root(F)))
    } else {
      message(gettext("TeX system not found in your operating system."))
      message("starting to install now...")
      tinytex::install_tinytex()
    }
  } else {
    message("TeX is already isntalled by tinytex package. installation skipped.")
  }
  message("trying to install TeX packages")
  tinytex::tlmgr_install(c("pdfcrops", "haranoaji", "bxjscls", "luatex-ja"))
}