#' beamer presentation format for Japanese typesetting with XeLaTeX or LuaLaTeX
#'
#' @inheritParams rmarkdown::beamer_presentation
#' @inheritParams pdf_book_ja
#' @family pdf formats
#' @title R Markdown 上で XeLaTeX を使い日本語 beamer スライドを作成するフォーマット
#' @description \code{bookdown::\link{beamer_presentation2}} wrapper format for Japanese typesetting with XeLaTeX or LuaLaTeX
#' 
#' XeLaTeX または LuaLaTeX で `bookdown::beamer_presentation2` で日本語タイプセットをするためのラッパフォーマット.
#' @details rmarkdownで \LaTeX を使う場合, 日本語を適切に表示するためにいろいろ必要だった調整を済ませたフォーマット
#' 基本的なオプションだけに限定することで簡単にポンチ絵スライドになってしまうことを回避する画期的な機能もあります.
#' 
#' テンプレートファイルも変更しているため, 厳密に同じではないですが, 既存のパッケージで表現するならデフォルトは概ねこうなります:
#' 
#' 
#' ```
#' output:
#'   bookdown::beamer_presentation2:
#'     latex_engine: xelatex
#'     theme: default
#'     citation_package: biblatex
#'     dev: cairo_pdf
#'     keep_tex: yes
#' classoption: aspectratio=43
#' mainfont: ...
#' sansfont: ...
#' monofont: ...
#' biblatexoption:
#'   - style=jauthoryear
#'   - citestyle=numeric
#' ```
#' 
#' @param theme chracter. beamer テーマ. 
#' @param theme_options character. テーマオプション. デフォルトはフレームタイトルの下にプログレスバーをつけて, ブロックの背景色を描画するというもの
#' @param fonttheme character. フォントテーマ. デフォルトでは数式にローマン体を使う.
#' @param colortheme character. 色テーマ.
#' @param toc logical. 目次をスライド冒頭に出力するかどうか. examples のように自分で書いたほうが良いかもしれません.
#' @param citation_options character. `citation_package` のオプション. `"default"`, 空の文字列, \code{NULL} などを指定すると特に何もしない. \code{citation_package = "natbib"} を選んだ場合, \code{"default"} は \code{`numbers`} に書き換えられる. 
#' @param figurename character. 図X の「図」の部分のテキスト.
#' @param tablename character. 表Y の「表」の部分のテキスト.
#' @param slide_level integer. フレームタイトルに対応する markdown の節レベル. デフォルト: 2. つまり `#` はセクションタイトルで, `##` がフレームタイトルになる.
#' @param incremental logical. 箇条書きが順番に現れるやつ. 文字が回転するアニメーション機能はない. 
#' 『...遠慮のないマッポ関係者が失笑した。ナムサン！プレゼンテーションにおける典型的なセンスレス文字操作だ。』--- B. ボンド& F. モーゼズ
#' @param self_contained logical. tex ファイルのプリアンブルも生成するかどうか. texソースを手動で書き換えたいのでない限り `TRUE`.
#' @return \code{rmarkdown_output_format} class

#' @export
beamer_presentation_ja <- function(
  keep_tex = TRUE,
  keep_md = FALSE,
  theme = "default",
  theme_options = "default",
  fonttheme = "default",
  colortheme = "default",
  toc = FALSE,
  fig_width = 5.03937,
  fig_height = 3.77953,
  fig_crop = TRUE,
  fig_caption = TRUE,
  fig_auto_font = TRUE,
  fig_font = NULL,
  out.width = "100%",
  out.height = "100%",
  extract_media = F,
  highlight = "default",
  code_rownumber = FALSE,
  code_softwrapped = TRUE,
  block_style = c("default", "kframe", "tcolorbox"),
  citation_package = "biblatex",
  citation_options = "default",
  latexmk_emulation = !citation_package == "natbib",
  figurename = "図",
  tablename = "表",
  number_sections = FALSE,
  slide_level = 2,
  incremental = FALSE,
  self_contained = TRUE,
  includes = NULL,
  latex_engine = c("xelatex", "lualatex", "pdflatex", "tectonic"),
  dev = "cairo_pdf",
  df_print = "default",
  template = "default",
  md_extensions = "+raw_tex",
  knitr_options = NULL,
  pandoc_args = NULL
){
  # ----- check arguments class & value -----
  latex_engine <- latex_engine[1]
  match.arg(latex_engine, LATEX_ENGINES)
  if(latex_engine == "pdflatex"){
    message("You selected `pdflatex` engine. It is not good choice for Japanese documents. Possibly `xelatex` or `lualatex` is better.")
  }
  block_style <- block_style[1]
  match.arg(block_style, c("default", BLOCK_STYLES))
  # ----- reshape arguments -----
  pandoc_vars <- c()
  extra_metadata <- list()

  if(!identical(theme_options, "default")){
    if(!is.null(theme_options) && !identical(theme_options, "")){
      pandoc_vars <- c(pandoc_vars, "-V", paste0('themeoptions:', paste0(theme_options, collapse = ","))) #FIXME: how to handle '=' contained values/what does mean the """list""" in Pandoc command line arguments?
    }
  }
  extra_metadata <- c(extra_metadata, merge_bibliography_args(citation_package, citation_options))
  if(!is_not_specified(figurename)){
    pandoc_vars <- c(pandoc_vars, rmarkdown::pandoc_variable_arg("figurename", figurename))
  } else {
    pandoc_vars <- c(pandoc_vars, rmarkdown::pandoc_variable_arg("figurename", "図"))
  }
  if(!is_not_specified(tablename)){
    pandoc_vars <- c(pandoc_vars, rmarkdown::pandoc_variable_arg("tablename", tablename))
  } else {
    pandoc_vars <- c(pandoc_vars, rmarkdown::pandoc_variable_arg("tablename", "表"))
  }
  if(!is_not_specified(extract_media)) pandoc_vars <- c(pandoc_vars, "--extract-media", ".")
  
  if(is_not_specified(template)){
    template <- system.file("resources/pandoc-templates/beamer-ja.tex.template", package = "rmdja")
  }
  if(code_rownumber){
    class.source <- "numberLines LineAnchors"
  } else {
    class.source <- NULL
  }
  if(is_not_specified(df_print)){
    df_print <- NULL
  }
  tinytex_latexmk_default <- getOption("tinytex.latexmk.emulation")
  
  knitr_options_ <- rmarkdown::knitr_options_pdf(fig_width, fig_height, fig_crop, dev = dev)
  knitr_options_ <- args_opts_chunk <- merge_lists(
    knitr_options_,
    list(
      opts_chunk = list(
        include = T,
        eval = T,
        echo = F,
        message = F,
        warning = T,
        error = T,
        comment = NA,
        tidy = 'styler',
        fig.align = "center",
        out.extra = "keepaspectratio",
        out.width = out.width,
        out.height = out.height,
        dev = dev,
        class.source = class.source
        ),
      opts_hooks = list(
        dev = hook_python_pdf_dev,
        echo = hook_display_block
      ),
      opts_knit = list(global.par = T)
      ),
    ignore_null_overlay = T
    )
  knitr_options <- merge_lists(knitr_options_, knitr_options, ignore_null_overlay = T)
  knitr_options$knit_hooks$plot <- svg2pdf_hook
  if(fig_auto_font){
    knitr_options$knit_hooks$label <- generate_graphics_font_hook(
      if(is.null(fig_font)) setNames(rmdja::get_default_font_family(latex_engine)["serif"], "") else fig_font
    )
  }
  
  pandoc_args_ <- rmarkdown::pandoc_options(
    to = "beamer",
    from = rmarkdown::from_rmarkdown(fig_caption, md_extensions),
    args = c(pandoc_vars, pandoc_args),
    ext = ".tex",
    keep_tex = keep_tex,
    latex_engine = latex_engine
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
      if(is.null(args_extra[["natbiboptions"]])){
        args_extra[["natbiboptions"]] <- "numbers"
      }
      copy_latexmkrc(output_dir)
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
        args_extra["biblatexoptions"] <- c("natbib=true,citestyle=numeric")
      }
      if(args_extra[["biblio-style"]] == "jauthoryear"){
        copy_biblatexstyle(metadata, input_file, runtime, knit_meta, files_dir, output_dir)
      }
    }
    if(is.null(metadata[["biblio-title"]])) args_extra <- c(args_extra, list(`biblio-title`="参考文献"))
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
    return(
      c(
        autodetect_and_set_jfont(metadata, input_file, runtime, knit_meta, files_dir, output_dir, latex_engine),
        paste0("-M", names(args_extra), "=", args_extra)
      )
    )
  }
  
  # ----- generate output format -----
  args <- list(
    base = list(
      toc = toc,
      slide_level = slide_level,
      number_sections = number_sections,
      incremental = incremental,
      fig_width = fig_width,
      fig_height = fig_height,
      fig_crop = fig_crop,
      fig_caption = fig_caption,
      dev = dev,
      theme = theme,
      colortheme = colortheme,
      fonttheme = fonttheme,
      highlight = highlight,
      template = template,
      keep_tex = keep_tex,
      keep_md = keep_md,
      latex_engine = latex_engine,
      citation_package = citation_package,
      self_contained = self_contained,
      includes = includes,
      md_extensions = md_extensions,
      pandoc_args = pandoc_args
    ),
    knitr = knitr_options,
    pandoc = pandoc_args_
  )
  
  
  base <- do.call(bookdown::beamer_presentation2, args$base)
  out <- rmarkdown::output_format(
    knitr = args$knitr,
    pandoc = args$pandoc,
    keep_md = keep_md,
    clean_supporting = !keep_tex,
    df_print = df_print, 
    pre_knit = adjust_fontsize,
    post_knit = NULL,
    pre_processor = preproc,
    intermediates_generator = NULL,
    post_processor = NULL,
    on_exit = function(x){options(tinytex.latexmk.emulation = tinytex_latexmk_default)},
    file_scope = NULL,
    base_format = base
    )
  out$bookdown_output_format <- "latex"
  return(out)
}
