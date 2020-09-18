#' HTML/PDF双方でルビを表示する
#' 
#' @description `<ruby>` タグと  `pxrubrica.sty` を使いタグを出力
#' @details HTMLタグやLaTeXコードだけだとどちらか片方にしかルビが表示されないため, `<ruby>` タグと  `pxrubrica.sty` を使い分けどちらにもタグが表示されるようにした. LaTeX のほうは `\ruby[g]{...}{...} に対応したルビを出力する.`
#' @param word character. 単語.
#' @param ruby character. ルビとして表示する文字列.
#' @return character. knitr を使い html, tex それぞれのソースに応じて出力を変えるようなコード.
#' 
#' @export
ruby <- function(word, ruby){
  if(knitr::is_html_output()){
    paste0("`<ruby>", word, "<rp>(</rp><rt>", ruby, "</rt><rp>)</rp></ruby>`{=html}")
  } else if(knitr::is_latex_output()){
    paste0("`\\ruby[g]{", word, "}{", ruby, "}`{=latex}")
  } else {
    paste0(word, " (", ruby, ")")
  }
}