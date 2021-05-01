#' bookdown packages's pdf_document2 format for Japanese typesetting with XeLaTeX/LuaLaTeX 
#' 
#' @title `rmarkdown` + `bookdown` で簡単に日本語文書を作るためのプリセットフォーマット, document 版
#' @family pdf formats
#' @description  bookdown::pdf_book wrapper format for Japanese typesetting with XeLaTeX or LuaLaTeX /`bookdown` で PDF文書をビルドする場合, 日本語を適切に表示するためにいろいろ必要だった調整を済ませたフォーマット. 
#' 
#' @details 基本的に YAML フロントマター (+ `_ouput.yml`) や knitr チャンクオプションで設定できることをデフォルト値として埋め込んだだけ. `index.Rmd` 
#' @inheritParams bookdown::pdf_book
#' @param code_rownumber logical. コードセルに行番号を表示するかどうか. 
#' @param code_softwrap logical チャンク内のコードを自動折り返しするかどうか. YAML メタデータ `code-softwrapped` でも可.
#' @param tombow logical. 製本時に必要なトンボ (trim markers) を付けるかどうか. トンボは `gentombow.sty` で作成される. 
#' @param block_style character. `block`/`block2` チャンクや Fenced Div. 用のスタイル定義. `default`, `kframe`, `tcolorbox` に対応. `default` は `kframe` と同じ. YAML メタデータに `block-style: tcolorbox`, `kframe: true` などと書くこともできる. `awesomebox.sty` にも近日対応予定.
#' @param add_folio logical. 製本時に全ページにノンブルが必要な場合があるらしいので全ページに表示したい時に.
#' @param latexmk_emulation logical. パッケージオプション `tinytex.latexmk.emulation` に連動する. デフォルトでは, 文献引用エンジンを natbib にしたときのみ `FALSE`, それ以外は `TRUE`. これは `tinytex` が (u)pBibTeX に対応していないため. どうしても BibTeX を使いたい場合以外は操作する必要のない不要なオプションですが, 日本語を含む文書を作成する限りそのような場面はないと思われます. 
#' @param citation_options character. `citation_package` のオプション.
#' @param extract_media logical. markdown 構文の画像貼り付けに URL が使用されていた場合, ダウンロードするかどうか. Pandoc の `--extract-media .` に対応. TODO: 現時点では　TRUE にすると余計な画像ファイルが生成される副作用があります. これは rmarkdown にもある不具合です. 
#' @return rmarkdown_output_format
#'
#' @export
pdf_document2_ja <- function (
  toc = FALSE,
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
  code_softwrapped = TRUE,
  block_style = c("default", "kframe", "tcolorbox"),
  tombow = FALSE,
  add_folio = FALSE,
  template = "default",
  keep_tex = TRUE,
  keep_md = TRUE,
  latex_engine = c("xelatex", "lualatex", "tectonic"),
  citation_package = "biblatex",
  citation_options = "default",
  latexmk_emulation = !citation_package == "natbib",
  extract_media = FALSE,
  includes = NULL,
  md_extensions = NULL,
  output_extensions = NULL,
  pandoc_args = NULL,
  extra_dependencies = NULL,
  ...
)
{
  # --- check values ---
  latex_engine <- latex_engine[1]
  match.arg(latex_engine, LATEX_ENGINES)
  if(latex_engine == "pdflatex"){
    message("You selected `pdflatex` engine. It is not good choice for Japanese documents. Possibly `xelatex` or `lualatex` is better.")
  }
  if(latex_engine %in% c("xelatex", "tectonic")){
    doc_class_default <- "bxjsarticle"
  } else {
    doc_class_default <- "ltjsarticle"
  }
   
  match.arg(citation_package, BIBLIO_ENGINES)
  block_style <- block_style[1]
  match.arg(block_style, c("default", BLOCK_STYLES))
  
  extra_metadata <- list()
  extra_metadata <- c(extra_metadata, merge_bibliography_args(citation_package, citation_options))
  
  if(is_not_specified(template)){
    template <- system.file("resources/pandoc-templates/document-ja.tex.template", package = "rmdja")
    pandoc_args <- c(pandoc_args, "--variable", "graphics=yes")
  }
  if(identical(code_rownumber, T)){
    attr_source <- c(".numberLines .lineAnchors")
  } else {
    attr_source <- NULL
  }
  if(extract_media){
    pandoc_args <- add_pandoc_arg(pandoc_args, "--extract-media", ".")
  }
  
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
    latex_folio <- system.file("resources/styles/latex/folio.tex", package = "rmdja")
    if(is.null(includes)){
      includes <- rmarkdown::includes(before_body = latex_folio)
    } else {
      includes$before_body <- c(latex_folio, includes$before_body)
    }
  }
  tinytex_latexmk_default <- getOption("tinytex.latexmk.emulation")
  
  knitr_options <- merge_lists(
    rmarkdown::knitr_options_pdf(fig_width, fig_height, fig_crop, dev = dev),
    list(
      opts_chunk = list(
        dev = dev,
        dev.args = dev_args,
        fig.align = fig_align,
        out.width = out_width,
        out.height = out_height,
        out.extra = out_extra,
        attr.source = attr_source,
        tidy = 'styler'
      ),
      opts_hooks = list(
        dev = hook_python_pdf_dev,
        echo = hook_display_block
      ),
      opts_knit = list(global.par = T)
    ),
    ignore_null_overlay = T
    )
  
  
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
      fig_crop = fig_crop,
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
    knitr = knitr_options,
    pandoc = rmarkdown::pandoc_options(
      to = "latex",
      ext = ".tex",
      args = args$pandoc_args,
      keep_tex = keep_tex, latex_engine = latex_engine
    )
  )
  
  preproc <- function(metadata, input_file, runtime, knit_meta, files_dir, output_dir){
    args_extra <- merge_lists(
      metadata[c("biblio-style", "natbiboptions", "biblatexoptions")],
      extra_metadata[c("biblio-style", "natbiboptions", "biblatexoptions")])
    args_extra <- args_extra[!is.na(names(args_extra))]
    if(identical(code_softwrapped, T)){
      args_extra[["code-softwrapped"]] <- T
    }
    if(identical(citation_package, "natbib")){
      copy_latexmkrc(metadata, input_file, runtime, knit_meta, files_dir, output_dir)
      if(latexmk_emulation == F){
        options(tinytex.latexmk.emulation = F)
        message(gettext("Preprocessing"), ": ",
                gettext("latexmk emulation is temporarily disabled to use (u)pBibTeX."))
      }
    } else if(identical(citation_package, "biblatex")){
      if(is.null(args_extra[["biblio-style"]])){
        args_extra[["biblio-style"]] <- "jauthoryear"
      }
      if(is.null(args_extra[["biblatexoptions"]])){
        args_extra["biblatexoptions"] <- "natbib=true"
      }
      if(args_extra[["biblio-style"]] == "jauthoryear"){
        copy_biblatexstyle(metadata, input_file, runtime, knit_meata, files_dir, output_dir)
      }
    }
    if(block_style == "default"){
      if(any(!is.null(args_extra[["block-style"]]), F) && args_extra[["block-style"]] %in% BLOCK_STYLES){
        args_extra[[args_extra[["block-style"]]]] <- T
      } else if(any(unlist(args_extra[BLOCK_STYLES]))){
        for(s in BLOCK_STYLES){
          args_extra[[s]] <- T
        }
      } else {
        args_extra[["kframe"]] <- T
      }
    } else {
      args_extra[[block_style]] <- T
      for(s in BLOCK_STYLES){
        if(s != block_style) args_extra[[s]] <- NULL
      }
    }
    args_extra <- paste0("-M", names(args_extra), "=", args_extra)
    
    args_extra <- c(
      args_extra,
      autodetect_and_set_jfont(metadata, input_file, runtime, knit_meta, files_dir, output_dir, latex_engine = latex_engine)
    )
    icon_dir <- file.path(output_dir, "_latex/_img")
    if(!file.exists(icon_dir)) dir.create(path = icon_dir, recursive = T, showWarnings = T)
    file.copy(file.path(system.file("resources/styles/img", package = "rmdja"), ICON_FILES()), icon_dir)
    args_extra <- c(args_extra,
                    if(!identical(metadata$fontsize, "10pt") & tombow) "-Mclassoption=nomag" else NULL
    )
    if(is.null(metadata$documentclass)) args_extra <- c(args_extra, sprintf("-Mdocumentclass=%s", doc_class_default))
    if(is.null(metadata[["biblio-title"]])) args_extra <- c(args_extra, "-Mbiblio-title=参考文献")
    return(args_extra)
  }

  out <- do.call(bookdown::pdf_document2, args$base)

  out <- rmarkdown::output_format(
    knitr = args$knitr,
    pandoc = args$pandoc,
    pre_knit = adjust_fontsize,
    pre_processor = preproc,
    keep_md = keep_md,
    clean_supporting = TRUE,
    base_format = out,
    on_exit = function(x){options(tinytex.latexmk.emulation = tinytex_latexmk_default)}
  )
  out$bookdown_output_format <- "latex"
  
  return(out)
}

