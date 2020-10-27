#' 
#' @title set font family for ggplot2 and standard graphic device 
#' @description \code{ggplot2} とグラフィックスのテキストのフォント設定を一括で行う
#' @details \code{ggplot2} の \code{theme()} および \code{geom_text()}, \code{geom_label()}, そして \code{ggrepel]} をロードしているなら \code{geom_text_repel()}, \code{geom_label_repel()} のフォントファミリを一括設定する.
#' @param family: character. フォントファミリ.
#' @export
set_graphics_font <- function(family){
  par(family = family)
  if("ggplot2" %in% rownames(installed.packages())){
    text_settings <- ggplot2::theme_get()$text
    text_settings$family <- family
    ggplot2::theme_set(ggplot2::theme_get() + ggplot2::theme(text = text_settings))
    ggplot2::update_geom_defaults("text", list(family = ggplot2::theme_get()$text$family))
    ggplot2::update_geom_defaults("label", list(family = ggplot2::theme_get()$text$family))
    if("ggrepel" %in% (.packages())){
      ggplot2::update_geom_defaults("text_repel", list(family = ggplot2::theme_get()$text$family))
      ggplot2::update_geom_defaults("label_repel", list(family = ggplot2::theme_get()$text$family))
    }
  }
}