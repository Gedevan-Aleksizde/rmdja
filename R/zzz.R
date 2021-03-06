# internal

DUMMY_ENGINES <- function(){
  c("cat", "asis", "block", "block2",
    "theorem", "lemma", "corollary", "proposition", "conjecture", "definition",
    "example", "exercise", "proof", "remark", "solution")
}
ICON_FILES <- function(){
  c("caution.png", "tip.png", "important.png", "memo.png", "warning.png")
}

CSS_FILES <- function(){
  c("style.css", "toc.css")
}

LATEX_ENGINES <- c("xelatex", "lualatex", "tectonic", "pdflatex")

BIBLIO_ENGINES <- c("default", "natbib", "biblatex")

BLOCK_STYLES <- c("kframe", "tcolorbox", "awesomebox")

#### common functions ####

#####  to merge rmd parameter lists #####
# based on rmarkdown package v2.7
# https://github.com/rstudio/rmarkdown/blob/master/R/util.R#L226
merge_lists <- function (base_list, overlay_list, recursive = TRUE, ignore_null_overlay = FALSE) 
{
  if (length(base_list) == 0) 
    overlay_list
  else if (length(overlay_list) == 0) 
    base_list
  else {
    merged_list <- base_list
    for (name in names(overlay_list)) {
      base <- base_list[[name]]
      overlay <- overlay_list[[name]]
      if (is.list(base) && is.list(overlay) && recursive) 
        merged_list[[name]] <- merge_lists(base, overlay, ignore_null = ignore_null_overlay)
      else {
        if(!ignore_null_overlay || !any(sapply(overlay_list[which(names(overlay_list) %in% name)], is.null))){
          merged_list[[name]] <- NULL
          merged_list <- append(merged_list, overlay_list[which(names(overlay_list) %in% name)])
        }
      }
    }
    merged_list
  }
}

#####  to simplify checking if a parameter is default value #####
is_not_specified <- function(x = NULL){
  is.null(x) || is.na(x) || identical(x, "default") || identical(x, "")
}

##### to add PANDOC additional paramters #####
add_pandoc_arg <- function(args, key, val){
  if(!any(grepl(paste0("^", key), args))){
    args <- c(args, c(key, val))
  }
  return(args)
}

##### TODO: set default font #####
gen_opts_hook_par <- function(font_family){
  f <- function(options){
    if(options$global.par){
      par(family = font_family)
    } else {
      par(family = font_family)
    }
    return(options)
  }
  return(f)
}

##### to check if chunk engine is asis/text-like #####
hook_display_block <- function(options){
    if(options$engine %in% DUMMY_ENGINES()) options$echo <- T
    return(options)
}

##### change graphic device if using Python engine #####
hook_python_pdf_dev <- function(options){
  if(options$engine == "python") options$dev <- "pdf"
  return(options)
}

##### to remote unit symbols #####
fontsize_as_integer <- function(fontsize = "12pt"){
  if(is.null(fontsize)) fontsize = "12pt"
  ps <- as.integer(regmatches(fontsize, regexpr("^[0-9]+", fontsize)))
  return(ps)
}

##### to equalize frontmatter fontsize and graph pointsize  #####
# call at pre_knit
adjust_fontsize <- function(input, ...) {
  font_pt <- fontsize_as_integer(rmarkdown::metadata$fontsize)
  knitr::opts_chunk$set(dev.args = list(pointsize = font_pt))
  return(input)
}

##### return Japanese font if not specified #####
# 指定がない場合にフォントを勝手に決める
# return font option name depening on the output format settings
# call at pre_processor
autodetect_jfont <- function(latex_engine, metadata = NULL){
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
      if(identical(latex_engine, "xelatex") || identical(latex_engine, "tectonic")){
        jfontpreset <- "noto"
      }
      else if(identical(latex_engine, "lualatex")){
        jfontpreset <- "noto-otf"
      }
    }
    else if(osinfo$name == "darwin"){
      if(identical(latex_engine, "lualatex")) {
        jfontpreset <- "hiragino-pron"
      }
      else if(identical(latex_engine, "xelatex") || identical(latex_engine, "tectonic")){
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
      jfontpreset <- "haranoaji"
    }
    font <- c(font, jfontpreset = jfontpreset)
    return(font)
  }
}

autodetect_and_set_jfont <- function(metadata, input_file, runtime, knit_meta, files_dir, output_dir, latex_engine){
  font <- autodetect_jfont(latex_engine, metadata)
  return(paste0("-M", names(font), "=", font))
}

merge_bibliography_args <- function(citation_package, citation_options){
  extra_metadata <- list()
  if(identical(citation_package, "natbib")){
    if(identical(citation_options, "default")){
    } else {
      if(!is.null(citation_options) && all(citation_options != "") && all(!is.na(citation_options))){
        extra_metadata[["natbiboptions"]] <- paste(citation_options, collapse = ",")
      }
    }
  } else if(identical(citation_package, "biblatex")){
    if(identical(citation_options, "default")){
    } else {
      if(!is.null(citation_options) && all(citation_options != "") && all(!is.na(citation_options))){
        bstyle <- sub("^style=", "", grep("^style=", citation_options, value = T))[1]
        if(length(bstyle) == 0 || is.na(bstyle)) bstyle <- "jauthoryear"
        extra_metadata[["biblio-style"]] <- bstyle
        extra_metadata[["biblatexoptions"]] <- paste(citation_options, collapse = ",")
      }
    }
  }
  return(extra_metadata)
}

##### copy .latexmkrc for Japaese general usage #####
# tinytex が upbibtex 対応していないため
# call at pre_processor
copy_latexmkrc <- function(metadata, input_file, runtime, knit_meta, files_dir, output_dir){
  if(!file.exists(file.path(output_dir, ".latexmkrc"))){
    file.copy(file.path(system.file("resources/latexmk", package = "rmdja"), ".latexmkrc"), to = output_dir, overwrite = F)
  }
  return(NULL)
}

# TODO: bibilatex スタイルのインストールパッケージ
copy_biblatexstyle <- function(metadata, input_fike, runtime, knit_meta, files_dir, output_dir){
  if(!file.exists(file.path(output_dir, "jauthoryear.bbx"))){
    file.copy(file.path(system.file("resources/latex", package = "rmdja"), "jauthoryear.bbx"), to = output_dir, overwrite = F)
  }
  if(!file.exists(file.path(output_dir, "jauthoryear.cbx"))){
    file.copy(file.path(system.file("resources/latex", package = "rmdja"), "jauthoryear.cbx"), to = output_dir, overwrite = F)
  }
}
