#' internal

DUMMY_ENGINES <- function(){
  c("cat", "asis", "block", "block2",
    "theorem", "lemma", "corollary", "proposition", "conjecture", "definition",
    "example", "exercise", "proof", "remark", "solution")
}
ICON_FILES <- function(){
  c("caution.png", "tip.png", "important.png", "note.png", "warning.png")
}

CSS_FILES <- function(){
  c("style.css", "toc.css")
}

fontsize_as_integer <- function(fontsize = "12pt"){
  if(is.null(fontsize)) fontsize = "12pt"
  ps <- as.integer(regmatches(fontsize, regexpr("^[0-9]+", fontsize)))
  return(ps)
}

# equalize frontmatter fontsize and graph pointsize
# call at pre_knit
adjust_fontsize <- function(input, ...) {
  font_pt <- fontsize_as_integer(rmarkdown::metadata$fontsize)
  knitr::opts_chunk$set(dev.args = list(pointsize = font_pt))
  return(input)
}

# 指定がない場合にフォントを勝手に決める
# call at pre_processor
autodetect_and_set_jfont <- function(metadata, input_file, runtime, knit_meta, files_dir, output_dir, latex_engine){
  sysinfo <- Sys.info()
  if(is.null(sysinfo)){
    name <- .Platform$OS.type
    if (grepl("^darwin", R.version$os))
      name <- "Darwin"
    if (grepl("linux-gnu", R.version$os))
      name <- "Linux"
  } else {
    name = sysinfo["sysname"]
  }
  
  osinfo <- list(
    name = tolower(name),
    version = sysinfo["version"]
  )
  latex_engine <- if(is.null(latex_engine)) metadata$latex_engine else latex_engine
  font <- if(osinfo$name == "linux"){
    list(mainfont = 'DejaVu Serif', sansfont = 'DejaVu Sans', monofont = 'DejaVu Sans Mono')
  }  else if(osinfo$name == "windows") {
    list(mainfont = "Times New Roman", sansfont = "Arial", monofont = "Courier New")
  } else if(osinfo$name == "darwin") {
    list(mainfont = "Times New Roman", sansfont = "Arial", monofont = "Courier New")
  } else {
    list()
  }
  for(f in names(font)){
    if(f %in% names(metadata)) font[f] <- NULL
  }
  no_jafontset <- all(
    any(
      is.null(metadata$jmainfont),
      is.null(metadata$jsansfont),
      is.null(metadata$jmonofont)),
    is.null(metadata$jfontpreset)
  )
  if(no_jafontset){
    if(osinfo$name == "linux"){
      if(identical(latex_engine, "xelatex")){
        jfontpreset <- "noto"
      }
      else if(identical(latex_engine, "lualatex")){
        jfontpreset <- "noto"
      }
    }
    else if(osinfo$name == "darwin"){
      if(identical(latex_engine, "lualatex")) {
        jfontpreset <- "hiragino-pron"
      }
      else if(identical(latex_engine, "xelatex")){
        jfontpreset <- "yu-osx"
      }
    }
    else if(osinfo$name == "windows"){
      if(latex_engine %in% c("xelatex", "lualatex")){
        if(identical(osinfo$version,"10")){
          jfontpreset <- "yu-win10"
        }
        else if(identical(osinfo$version, "8")){
          jfontpreset <- "yu-win"
        }
        else {
          jfontpreset <- "ms"
        }
      }
    } else {
      jfontpreset <- NULL
    }
    font <- c(font, jfontpreset = jfontpreset)
  }
  return(paste0("-M", names(font), "=", font))
}

# tinytex が upbibtex 対応するまで
# call at pre_processor
copy_latexmkrc <- function(metadata, input_file, runtime, knit_meta, files_dir, output_dir){
  if(!file.exists(file.path(output_dir, ".latexmkrc"))){
    file.copy(file.path(system.file("resources/latexmk", package = "rmdja"), ".latexmkrc"), to = output_dir, overwrite = F)
  }
  return(NULL)
}