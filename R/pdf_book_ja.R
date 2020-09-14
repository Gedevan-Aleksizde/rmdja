#' bookdown::pdf_book wrapper for Japanese typesetting with XeLaTeX/LuaLaTeX 
#'
#' @inheritParams bookdown::pdf_book
#' @title `rmarkdown` + `bookdown` で簡単に日本語文書を作るためのプリセットフォーマット
#' @description  `rmarkdown` + `bookdown` で PDF文書をビルドする場合, 日本語を適切に表示するためにいろいろ必要だった調整を済ませたフォーマット. 基本的に YAML フロントマター (+ `_ouput.yml`) や knitr チャンクオプションで設定できることをデフォルト値として埋め込んだだけ.
#'  
#' @param chunk_number デフォルト: TRUE. boolean. コードセルに行番号を表示するかどうか. 
#' @param tombow boolean. デフォルト: FALSE. 製本時に必要なトンボ (trim markers) を付けるかどうか. トンボは `gentombow.sty` で作成される. 
#' @return rmarkdown_output_format
#'
#' @export
pdf_book_ja <- function (
  toc = TRUE,
  toc_unnumbered = TRUE,
  toc_depth = 3,
  toc_bib = FALSE,
  toc_appendix = FALSE,
  number_sections = TRUE,
  fig_align = "center",
  fig_caption = TRUE,
  fig_crop = TRUE,
  fig_height = 4.5,
  fig_width = 6.5,
  dev = "cairo_pdf",
  dev_args = NULL,
  out_width = "100%",
  out_height = "100%",
  out_extra = 'keepaspectratio',
  df_print = "default",
  quote_footer = NULL,
  highlight = "default",
  highlight_bw = FALSE,
  chunk_number = TRUE,
  tombow = FALSE,
  template = "default",
  keep_tex = TRUE,
  keep_md = TRUE,
  latex_engine = "xelatex",
  citation_package = "natbib",
  citation_options = "default",
  includes = NULL,
  md_extensions = NULL,
  output_extensions = NULL,
  pandoc_args = NULL,
  extra_dependencies = NULL,
  base_format = rmarkdown::pdf_document,
  ...
  )
{
  # knitr のデフォルト値設定
  # 動的な設定: エンジンごとのデフォルト値変更
  # --- check values ---
  match.arg(latex_engine, c("xelatex", "lualatex"))
  match.arg(citation_package, c("default", "biblatex", "natbib"))
  if(identical(citation_package, "natbib")){
    if(!identical(citation_options, "default")){
      pandoc_args <- c(pandoc_args, rmarkdown::pandoc_variable_arg("natbiboptions", citation_options))
    }
  }
  if(missing(template) || identical(template, "") || identical(template, "default")){
    template <- file.path(system.file("resources", package = "rmdja"), "pandoc-templates/document-ja.tex.template")
    # template <- "~/Documents/developping/my_latex_templates/rmdja/inst/resources/pandoc-templates/document-ja.tex.template"
  }
  if(identical(chunk_number, T)){
    attr_source <- c(".numberLines .lineAnchors") 
  } else {
    attr_source <- NULL
  }
  if(identical(pandoc_args, NULL)){
    pandoc_args <- c('--top-level-division=chapter', "--extract-media", '.')
  }
  if(identical(extra_dependencies, NULL)){
    if(identical(tombow, T)){
      extra_dependencies <- "gentombow"
    }
  } else if(is.list(extra_dependencies)){
    if(identical(tombow, T)){
      extra_dependencies <- c(extra_dependencies, gentombow = NULL)
    }
  }  #TODO: latex_dependency() を引数に想定するときの使い方が不明
  fontsize_as_integer <- function(fontsize = fontsize){
    if(is.null(fontsize)) fontsize = "12pt"
    ps <- as.integer(regmatches(fontsize, regexpr("^[0-9]+", fontsize)))
    return(ps)
  }
  
  args <- list(
    base = list(
      toc = toc,
      toc_depth = toc_depth,
      toc_appendix = toc_appendix,
      toc_bib = toc_bib,
      number_sections = number_sections,
      fig_width = fig_width,
      fig_height = fig_height,
      fig_caption = fig_caption,
      dev = dev,
      df_print = df_print,
      highlight = highlight,
      highlight_bw = highlight_bw,
      template = template,
      keep_tex = keep_tex,
      keep_md = keep_md,
      latex_engine = latex_engine,
      citation_package = citation_package,
      includes = includes,
      md_extensions = md_extensions,
      pandoc_args = pandoc_args,
      extra_dependencies = extra_dependencies,
      quote_footer = quote_footer,
      ...
      ),
    knitr = list(
      opts_chunk = list(
        dev = dev,
        dev.args = dev_args,
        fig.align = fig_align,
        out.width = out_width,
        out.height = out_height,
        out.extra = out_extra,
        attr.source = attr_source
      )
    )
  )
  base_format_ <- do.call(
    what = base_format,
    args = if("..." %in% formalArgs(base_format)) args$base else args$base[names(args$base) %in% formalArgs(base_format)]
    )
  base_ <- function(...){
    knitr_options <- do.call(rmarkdown::knitr_options, args$knitr)
    out <- rmarkdown::output_format(
      pre_knit = function(input, ...) {
        knitr::opts_chunk$set(dev.args = list(pointsize = fontsize_as_integer(rmarkdown::metadata$fontsize)))
        return(input)
      },
      knitr = args$knitr,
      pandoc =  do.call(rmarkdown::pandoc_options(base_format_$pandoc)),
      keep_md = keep_md,
      clean_supporting = NULL, base_format = base_format_
    )
    return(out)
  }
  args$bookdown_format <- args$base
  args$bookdown_format$base <- base_
  if(identical(citation_package, "natbib")){
    if(!file.exists("./.latexmkrc")){
      file.copy(file.path(system.file("resources", package = "rmdja"),
                          "latexmk/.latexmkrc"), to = "./")
    }
  }
  out <- do.call(what = bookdown::pdf_book, args = args$bookdown_format)
  return(out)
}
