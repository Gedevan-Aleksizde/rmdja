#' Creative Commons のアイコンを取得する関数
#' 
#' @description Creative Commons のアイコン画像を簡単に文書に埋め込むための関数
#' @param adapt: character. `yes`, `no`, `inherit` から選択. 再配布の許諾に関する選択.
#' @param commercial: logical. 商用利用を許可するかどうか
#' @param size: character. `normal`, `compact` から選択. 画像のサイズ.
#' @param language: character. default: `ja`. 声明文の言語を選択.
#' @return character. ハイパーリンク付き画像と評価される Markdown の構文
#' @export
get_CC <- function(adapt = c("yes", "no", "inherit"),
                  commercial = T,
                  size = c("normal", "compact"),
                  language="ja"
){
  match.arg(adapt, c("yes", "no", "inherit"))
  match.arg(size, c("normal", "compact"))
  if(commercial){
    nc <- ""
  } else {
    nc <- "nc"
  }
  cc <- switch (adapt,
                "yes" = "",
                "no"  = "nd",
                "inherit" = "sa"
  )
  if(commercial){
    cc <- paste("by", cc, sep = "-")
  } else {
    cc <- paste("by", "nc", cc, sep = "-")
  }
  cc <- sub("-$", "", cc)
  file_name <- switch(
    size,
    "normal" = "88x31.png",
    "compact" = "80x15.png"
  )
  url_icon <- paste0("https://i.creativecommons.org/l/", cc, "/4.0/", file_name)
  url_text <- paste0("https://creativecommons.org/licenses/", cc, "/4.0")
  if(!is.null(language)){
    url_text <- paste0(url_text, "/deed.", language)
  }
  text <- paste0("[![](", url_icon, ")](", url_text, ")")
  cat(text)
}
