#' bookdown::pdf_book wrapper for Japanese typesetting with XeLaTeX/LuaLaTeX 
#'

#' @title `rmarkdown` + `bookdown` で簡単に日本語文書を作るためのプリセットフォーマット
#' @description  `rmarkdown` + `bookdown` で PDF文書をビルドする場合, 日本語を適切に表示するためにいろいろ必要だった調整を済ませたフォーマット. 基本的に YAML フロントマター (+ `_ouput.yml`) や knitr チャンクオプションで設定できることをデフォルト値として埋め込んだだけ. `index.Rmd` 
#' @inheritParams bookdown::pdf_book
#'  
#' @param code_rownumber デフォルト: TRUE. logical. コードセルに行番号を表示するかどうか. 
#' @param tombow logical. デフォルト: FALSE. 製本時に必要なトンボ (trim markers) を付けるかどうか. トンボは `gentombow.sty` で作成される. 
#' @param add_folio logica. デフォルト: FALSE. 製本時に全ページにノンブルが必要な場合があるらしいので全ページに表示したい時に.
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
  code_rownumber = TRUE,
  tombow = FALSE,
  add_folio = FALSE,
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
  # --- check values ---
  match.arg(latex_engine, c("xelatex", "lualatex"))
  match.arg(citation_package, c("default", "biblatex", "natbib"))
  
  top_level <- "chapter"
  if(identical(citation_package, "natbib")){
    if(!identical(citation_options, "default")){
      pandoc_args <- c(pandoc_args, rmarkdown::pandoc_variable_arg("natbiboptions", citation_options))
    }
  }
  if(missing(template) || identical(template, "") || identical(template, "default")){
    template <- system.file("resources/pandoc-templates/document-ja.tex.template", package = "rmdja")
  }
  if(identical(code_rownumber, T)){
    attr_source <- c(".numberLines .lineAnchors")
  } else {
    attr_source <- NULL
  }
  if(!any(grepl("^--top-level-division", pandoc_args))){
    pandoc_args <- c(pandoc_args, paste0('--top-level-division=', top_level))
  }
  if(!any(grepl("^--extract-media", pandoc_args)))
  pandoc_args <- c(pandoc_args, "--extract-media", '.')
  if(identical(extra_dependencies, NULL)){
    if(identical(tombow, T)){
      extra_dependencies <- list(gentombow = "pdfbox")
    }
  } else if(is.list(extra_dependencies)){
    if(identical(tombow, T)){
      extra_dependencies <- c(extra_dependencies, list(gentombow = "pdfbox"))
    }
  } 
  if(identical(add_folio, T)){
    if(is.null(includes)){
      includes <- rmarkdown::includes(before_body = system.file("resources/styles/latex/folio.tex", package = "rmdja"))
    } else {
      includes$before_body <- c(includes$before_body, system.file("resources/styles/latex/folio.tex", package = "rmdja"))
    }
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
      extra_dependencies = extra_dependencies,
      quote_footer = quote_footer,
      pandoc_args = pandoc_args,
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
      ),
      opts_hooks = list(
        dev = hook_python_pdf_dev,
        echo = hook_display_block
        )
    )
  )
  
  preproc <- function(metadata, input_file, runtime, knit_meta, files_dir, output_dir){
    if(identical(citation_package, "natbib")) copy_latexmkrc(metadata, input_file, runtime, knit_meta, files_dir, output_dir)
    args_extra <- autodetect_and_set_jfont(metadata, input_file, runtime, knit_meta, files_dir, output_dir, latex_engine = latex_engine)
    icon_dir <- file.path(output_dir, "_latex/_img")
    if(!file.exists(icon_dir)) dir.create(path = icon_dir, recursive = T, showWarnings = T)
    file.copy(file.path(system.file("resources/styles/img", package = "rmdja"), ICON_FILES()), icon_dir)
    args_extra <- c(args_extra,
                    if(!identical(metadata$fontsize, "10pt") & tombow) "-Mclassoption=nomag" else NULL
                    )
    if(is.null(metadata$documentclass)) args_extra <- c(args_extra, "-Mdocumentclass=bxjsbook")
    if(is.null(metadata[["biblio-title"]])) args_extra <- c(args_extra, "-Mbiblio-title=参考文献")
    return(args_extra)
  }
  base_format_ <- do.call(
    what = base_format,
    args = if("..." %in% formalArgs(base_format)) args$base else args$base[names(args$base) %in% formalArgs(base_format)]
    )
  base_ <- function(){
    knitr_options <- do.call(rmarkdown::knitr_options, args$knitr)
    out <- rmarkdown::output_format(
      pre_knit = adjust_fontsize,
      knitr = args$knitr,
      pre_processor = preproc,
      pandoc = NULL,
      keep_md = keep_md,
      clean_supporting = NULL,
      base_format = base_format_
    )
    return(out)
  }
  out <- do.call(what = bookdown::pdf_book, args = list(base_format = base_))
  return(out)
}

