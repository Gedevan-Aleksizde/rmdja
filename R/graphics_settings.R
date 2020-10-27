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

#' @title get OS standard font family for ggplot2 and standard graphic device 
#' @description 使用中のOSから標準仕様のフォントファミリ名を取得する
#' @param character. LaTeX エンジンの標準フォントと合わせるため 
#' @export
get_default_font_family <- function(engine = "xelatex"){
  fam <- autodetect_jfont(engine)["jfontpreset"]
  if(grepl("^noto", fam)){
    font <- c(serif = "Noto Serif CJK JP", sans = "Noto Sans CJK JP")
  } else if(fam == "hiragino-pron") {
    font <- c(serif = "Hiragino Mincho ProN", sans = "Hiragino Sans")
  } else if(fam == "yu-osx") {
    font <- c(serif = "YuMicho", sans = "YuGothic")
  } else if(grepl("^yu-win", fam)) {
    font <- c(serif = "Yu Mincho", sans = "Yu Gothic")
  } else if(fam == "ms"){
    font <- c(serif = "MS Mincho", sans = "MS Gothic")
  } else {
    font <- c(serif = "IPAExMincho", sans = "IPAExMincho")
  }
  return(font)
}
