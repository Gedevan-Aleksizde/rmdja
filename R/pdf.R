#'
#' @title `rmarkdown` + `bookdown` で簡単に日本語文書を作るためのプリセットフォーマット
#' @family pdf formats
#' @description  bookdown::pdf_book wrapper format for Japanese typesetting with XeLaTeX or LuaLaTeX /`bookdown` で PDF文書をビルドする場合, 日本語を適切に表示するためにいろいろ必要だった調整を済ませたラッパフォーマット. 
#' 
#' @details 基本的に YAML フロントマター (+ `_ouput.yml`) や knitr チャンクオプションで設定できることをデフォルト値として埋め込んだだけです.
#' * pdf_book_ja は \code{\link{pdf_book}} の日本語版です
#' * pdf_document2_ja は \code{\link{pdf_document2}} の日本語版です
#' * pdf_document2_platex はさらに uplatex によるコンパイルを想定したバージョンです.
#' `pdf_book_ja()` は `index.Rmd` を必ずルートディレクトリに用意してください. `pdf_book_ja` は **bookdown** パッケージの \code{\link{pdf_book}} と同様に, Knit では書籍をビルドできません. 詳細は **bookdown** の解説を参考にしてください. それ以外は Knit でビルドできます.
#' 
#' テンプレートファイルも変更しているため, 厳密に同じではないですが, 既存のパッケージで表現するなら book の場合はデフォルトは概ねこうなります:
#' 
#' ```
#' output:
#'   bookdown::pdf_book:
#'     latex_engine: xelatex
#'     citation_package: biblatex
#'     dev: cairo_pdf
#'     keep_tex: yes
#' documentclass: bxjsbook
#' mainfont: ...
#' sansfont: ...
#' monofont: ...
#' biblatexoption:
#'   - style=jauthoryear
#' ```
#' 
#' 加えて knitr のチャンクオプションやフックもいろいろ変更していますが, 基本的にはストレスにならないような動的な設定にしたつもりです. (例: テキストの自動折返し, 文字化けしないようなグラフィックデバイスの選択, 「図」「表」などの頻出キーワードのローカライズなど.)
#' 
#' \code{rmarkdown::\link{pdf_document}} と \code{bookdown::\link{pdf_document2}} の違いは相互参照をサポートしているかどうかです. 技術文書や論文では相互参照は良く使うので後者をベースに日本語文書向けの設定を内蔵しました. 
#' 
#' TODO: _platex は 動作確認すらしてません. たぶんまだ動かない
#' 
#' @inheritParams bookdown::pdf_book
#' @param toc logical. \code{rmarkdown::\linl(pdf_document)} と同じ. 目次の表示.
#' @param toc_unnumbered logical. 付番されていない見出しも目次に表示するかどうか.
#' @param toc_bib logical. 参考文献のセクションも目次に表示するかどうか.
#' @param toc_appendix logical. 補遺のセクションも目次に表示するかどうか.
#' @param highlight_bw logical. グラフの表示をグレースケールに強制変換するかどうか.
#' @param code_rownumber logical. コードセルに行番号を表示するかどうか. 
#' @param code_softwrapped logical. チャンク内のコードを自動折り返しするかどうか. YAML メタデータ `code-softwrapped` でも可.
#' @param block_style character. `block`/`block2` チャンクや Fenced Div. 用のスタイル定義. `default`, `kframe`, `tcolorbox` に対応. `default` は `kframe` と同じ. YAML メタデータに `block-style: tcolorbox`, `kframe: true` などと書くこともできます. `awesomebox.sty` にも近日対応予定.
#' @param tombow logical. 製本時に必要なトンボ (trim markers) を付けるかどうか. トンボは `gentombow.sty` で作成される. 
#' @param add_folio logical. 製本時に全ページにノンブルが必要な場合があるらしいので全ページに表示したい時に.
#' @param latexmk_emulation logical. パッケージオプション `tinytex.latexmk.emulation` に連動する. デフォルトでは, 文献引用エンジンを natbib にしたときのみ `FALSE`, それ以外は `TRUE`. これは `tinytex` が (u)pBibTeX に対応していないため. どうしても BibTeX を使いたい場合以外は操作する必要のない不要なオプションですが, 日本語を含む文書を作成する限りそのような場面はないと思われます. 
#' @param citation_options character. `citation_package` のオプション.
#' @param extract_media logical. markdown 構文の画像貼り付けに URL が使用されていた場合, ダウンロードするかどうか. Pandoc の `--extract-media .` に対応. TODO: 現時点では　TRUE にすると余計な画像ファイルが生成される副作用があります. これは rmarkdown にもある不具合です. 
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
    doc_class_default <- "bxjsbook"
  } else {
    doc_class_default <- "ltjsbook"
  }
  block_style <- block_style[1]
  match.arg(block_style, c("default", BLOCK_STYLES))
  
  match.arg(citation_package, BIBLIO_ENGINES)
  
  base_format <- rmarkdown::pdf_document
  
  top_level <- "chapter"
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
  pandoc_args <- add_pandoc_arg(pandoc_args, "--top-level-division", top_level)
  if(extract_media) pandoc_args <- add_pandoc_arg(pandoc_args, "--extract-media", ".")
  
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
    rmarkdown::knitr_options_pdf(fig_width, fig_height, fig_crop, dev),
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
      args = pandoc_args,
      keep_tex = keep_tex,
      latex_engine = latex_engine
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
        args_extra["biblatexoptions"] <- list("natbib=true")
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
  out_ <- do.call(
    what = base_format,
    args = if("..." %in% formalArgs(base_format)) args$base else args$base[names(args$base) %in% formalArgs(base_format)]
  )
  base_ <- function() rmarkdown::output_format(
    knitr = args$knitr,
    pandoc = args$pandoc, 
    keep_md = keep_md,
    clean_supporting = TRUE,
    df_print = df_print,
    pre_knit = adjust_fontsize,
    post_knit = NULL,
    pre_processor = preproc,
    intermediates_generator = NULL,
    post_processor = NULL,
    on_exit = function(x){options(tinytex.latexmk.emulation = tinytex_latexmk_default)},
    file_scope = NULL,
    base_format = out_
  )
  out <- do.call(what = bookdown::pdf_book, args = list(base_format = base_, pandoc_args = args$pandoc))
  return(out)
}

#' @family pdf formats
#' @name pdf_book_ja
#' @inheritParams bookdown::pdf_book
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
      args = pandoc_args,
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
  print("unko")
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

#' @name pdf_book_ja
#' @rdname pdf_book_ja
#' @param platex character. platex を使う場合のエンジン. TODO: てか UTF8 以外で動かせるの?
#' @export
pdf_document2_platex <- function(platex = c("uplatex", "platex", "none"), ...){
  platex <- platex[1]
  match.arg(platex, c("uplatex", "platex", "none"))
  out <- pdf_document2_ja(...)
  out$post_processor <- function(metadata, input, output, clean, verbose) {
    if (is.function(post)) output = post(metadata, input, output, clean, verbose)
    f = with_ext(output, '.tex')
    x = read_utf8(f)
    x = restore_block2(x, !number_sections)
    x = resolve_refs_latex(x)
    x = resolve_ref_links_latex(x)
    x = restore_part_latex(x)
    x = restore_appendix_latex(x, toc_appendix)
    if (!toc_unnumbered) x = remove_toc_items(x)
    if (toc_bib) x = add_toc_bib(x)
    if (!is.null(quote_footer)) {
      if (length(quote_footer) != 2 || !is.character(quote_footer)) warning(
        "The 'quote_footer' argument should be a character vector of length 2"
      ) else x = process_quote_latex(x, quote_footer)
    }
    if (highlight_bw) x = highlight_grayscale_latex(x)
    post = getOption('bookdown.post.latex')
    if (is.function(post)) x = post(x)
    write_utf8(x, f)
    if(!is.null(metadata$platex) && meatadata$platex != "none"){
      print(gettext("Japanese-specific compiling mode..."))
      print(gettextf("LaTeX engine: %s", metadata$platex))
      print(gettextf("Bibliography engine: %s", citation_package))
      tinytex::latexmk(
        f, bib_engine = if (is_not_specified(citation_package)) 'biber' else 'bibtex',
        emulation = F, engine_args = "-gg -pdfdvi"
      )
      output = with_ext(output, '.pdf')
      o = opts$get('output_dir')
      keep_tex = isTRUE(keep_tex)
      if (!keep_tex) file.remove(f)
      if (is.null(o)) return(output)
      
      output2 = file.path(o, output)
      file.rename(output, output2)
      if (keep_tex) file.rename(f, file.path(o, f))
      return(output2)
    } else {
      print(gettext(".pdf file is not generated. Only .tex file is created. plseae complile manually using `tinytex::latexmk()` if needed."))
      return(output)
    }
  }
}

# ---- copy from bookdown package v0.22 ----
# https://github.com/rstudio/bookdown/blob/master/R/latex.R

resolve_ref_links_latex = function(x) {
  res = parse_ref_links(x, '^%s (.+)$')
  if (is.null(res)) return(x)
  x = res$content; txts = res$txts; i = res$matches
  # text for a tag may be wrapped into multiple lines; collect them until the
  # empty line
  for (j in seq_along(i)) {
    k = 1
    while (x[i[j] + k] != '') {
      txts[j] = paste(txts[j], x[i[j] + k], sep = '\n')
      x[i[j] + k] = ''
      k = k + 1
    }
  }
  restore_ref_links(x, '(?<!\\\\texttt{)%s', res$tags, txts, FALSE)
}

restore_part_latex = function(x) {
  r = '^\\\\(chapter|section)\\*\\{\\(PART(\\*)?\\)( |$)'
  i = grep(r, x)
  if (length(i) == 0) return(x)
  x[i] = gsub(r, '\\\\part\\2{', x[i])
  # remove (PART*) from the TOC lines for unnumbered parts
  r = '^(\\\\addcontentsline\\{toc\\}\\{)(chapter|section)(\\}\\{)\\(PART\\*\\)( |$)'
  x = gsub(r, '\\1part\\3', x)
  # for numbered parts, remove the line \addcontentsline since it is not really
  # a chapter title and should not be added to TOC
  j = grep('^\\\\addcontentsline\\{toc\\}\\{(chapter|section)\\}\\{\\(PART\\)( |$)', x)
  k = j; n = length(x)
  for (i in seq_along(j)) {
    # figure out how many lines \addcontentsline{toc} spans over (search until
    # it finds an empty line)
    l = 1
    while (j[i] + l <= n && x[j[i] + l] != '') {
      k = c(k, j[i] + l)
      l = l + 1
    }
  }
  if (length(k)) x = x[-k]
  x
}

restore_appendix_latex = function(x, toc = FALSE) {
  r = '^\\\\(chapter|section)\\*\\{\\(APPENDIX\\) .*'
  i = find_appendix_line(r, x)
  if (length(i) == 0) return(x)
  level = gsub(r, '\\1', x[i])
  brace = grepl('}}$', x[i])
  x[i] = '\\appendix'
  if (toc) x[i] = paste(
    x[i], sprintf('\\addcontentsline{toc}{%s}{\\appendixname}', level)
  )
  if (brace) x[i] = paste0(x[i], '}')  # pandoc 2.0
  if (grepl('^\\\\addcontentsline', x[i + 1])) x[i + 1] = ''
  x
}

find_appendix_line = function(r, x) {
  i = grep(r, x)
  if (length(i) > 1) stop('You must not have more than one appendix title')
  i
}

remove_toc_items = function(x) {
  r = '^\\\\addcontentsline\\{toc\\}\\{(part|chapter|section|subsection|subsubsection)\\}\\{.+\\}$'
  x[grep(r, x)] = ''
  x
}

add_toc_bib = function(x) {
  # natbib
  r = '^\\s*\\\\bibliography\\{.+\\}$'
  i = grep(r, x)
  if (length(i) != 0) {
    # natbib - add toc manually using \bibname
    # e.g adding \addcontentsline{toc}{chapter}{\bibname}
    i = i[1]
    level = if (length(grep('^\\\\chapter\\*?\\{', x))) 'chapter' else 'section'
    x[i] = sprintf('%s\n\\addcontentsline{toc}{%s}{\\bibname}', x[i], level)
  } else {
    # biblatex - add heading=bibintoc in options
    # e.g \printbibliography[title=References,heading=bibintoc]
    r = '^(\\s*\\\\printbibliography)(\\[.*\\])?$'
    i = grep(r, x)
    if (length(i) == 0) return(x)
    opts = gsub(r, "\\2", x[i])
    bibintoc = "heading=bibintoc"
    if (nzchar(opts)) {
      opts2 = gsub("^\\[(.*)\\]$", "\\1", opts)
      opts = if (!grepl("heading=", opts2)) sprintf("[%s,%s]", opts2, bibintoc)
    } else (
      opts = sprintf("[%s]", bibintoc)
    )
    x[i] = sprintf('%s%s', gsub(r, "\\1", x[i]), opts)
  }
  x
}

restore_block2 = function(x, global = FALSE) {
  i = grep('^\\\\begin\\{document\\}', x)[1]
  if (is.na(i)) return(x)
  # add the necessary definition in the preamble when block2 engine
  # (\BeginKnitrBlock) or pandoc fenced div (\begin) is used if not already
  # define. But don't do it with beamer and it defines already amsthm
  # environments.
  # An options allow external format to skip this part
  # (useful for rticles see rstudio/bookdown#1001)
  if (getOption("bookdown.theorem.preamble", TRUE) &&
      !knitr::pandoc_to("beamer") &&
      length(grep(sprintf('^\\\\(BeginKnitrBlock|begin)\\{(%s)\\}', paste(all_math_env, collapse = '|')), x)) &&
      length(grep('^\\s*\\\\newtheorem\\{theorem\\}', head(x, i))) == 0) {
    theorem_label = vapply(theorem_abbr, function(a) {
      label_prefix(a)()
    }, character(1), USE.NAMES = FALSE)
    theorem_defs = sprintf(
      '%s\\newtheorem{%s}{%s}%s', theorem_style(names(theorem_abbr)),
      names(theorem_abbr), str_trim(theorem_label),
      if (global) '' else {
        if (length(grep('^\\\\chapter[*]?', x))) '[chapter]' else '[section]'
      }
    )
    # the proof environment has already been defined by amsthm
    proof_envs = setdiff(names(label_names_math2), 'proof')
    proof_labels = vapply(proof_envs, function(a) {
      label_prefix(a, dict = label_names_math2)()
    }, character(1), USE.NAMES = FALSE)
    proof_defs = sprintf(
      '%s\\newtheorem*{%s}{%s}', theorem_style(proof_envs), proof_envs,
      gsub('^\\s+|[.]\\s*$', '', proof_labels)
    )
    x = append(x, c('\\usepackage{amsthm}', theorem_defs, proof_defs), i - 1)
  }
  # remove the empty lines around the block2 environments
  i3 = c(
    if (length(i1 <- grep(r1 <- '^(\\\\)BeginKnitrBlock(\\{)', x)))
      (i1 + 1)[x[i1 + 1] == ''],
    if (length(i2 <- grep(r2 <- '(\\\\)EndKnitrBlock(\\{[^}]+})$', x)))
      (i2 - 1)[x[i2 - 1] == '']
  )
  x[i1] = gsub(r1, '\\1begin\\2', x[i1])
  x[i2] = gsub(r2, '\\1end\\2',   x[i2])
  if (length(i3)) x = x[-i3]
  
  r = '^(.*\\\\begin\\{[^}]+\\})(\\\\iffalse\\{-)([-0-9]+)(-\\}\\\\fi\\{\\})(.*)$'
  if (length(i <- grep(r, x)) == 0) return(x)
  opts = sapply(strsplit(gsub(r, '\\3', x[i]), '-'), function(z) {
    intToUtf8(as.integer(z))
  }, USE.NAMES = FALSE)
  x[i] = paste0(gsub(r, '\\1', x[i]), opts, gsub(r, '\\5', x[i]))
  x
}

style_definition = c('definition', 'example', 'exercise', 'hypothesis')
style_remark = c('remark')
# which styles of theorem environments to use
theorem_style = function(env) {
  styles = character(length(env))
  styles[env %in% style_definition] = '\\theoremstyle{definition}\n'
  styles[env %in% style_remark] = '\\theoremstyle{remark}\n'
  styles
}

process_quote_latex = function(x, commands) {
  for (i in grep('^\\\\end\\{quote\\}$', x)) {
    i1 = NULL; i2 = i - 1
    k = 1
    while (k < i) {
      xk = x[i - k]
      if (grepl('^---.+', xk)) {
        i1 = i - k
        break
      }
      if (xk == '' || grepl('^\\\\begin', xk)) break
      k = k + 1
    }
    if (is.null(i1)) next
    x[i1] = paste0(commands[1], x[i1])
    x[i2] = paste0(x[i2], commands[2])
  }
  x
}

# \newenvironment{Shaded}{\begin{snugshade}}{\end{snugshade}}
# \newcommand{\KeywordTok}[1]{\textcolor[rgb]{x.xx,x.xx,x.xx}{\textbf{{#1}}}}
# \newcommand{\DataTypeTok}[1]{\textcolor[rgb]{x.xx,x.xx,x.xx}{{#1}}}
# ...
highlight_grayscale_latex = function(x) {
  i1 = grep('^\\\\newenvironment\\{Shaded\\}', x)
  if (length(i1) == 0) return(x)
  i1 = i1[1]
  r1 = '^\\\\newcommand\\{\\\\[a-zA-Z]+\\}\\[1]\\{.*\\{#1\\}.*\\}$'
  r2 = '^(.*?)([.0-9]+,[.0-9]+,[.0-9]+)(.*)$'
  i = i1 + 1
  while (grepl('^\\\\newcommand\\{.+\\}$', x[i])) {
    if (grepl(r1, x[i]) && grepl(r2, x[i])) {
      col = as.numeric(strsplit(gsub(r2, '\\2', x[i]), ',')[[1]])
      x[i] = gsub(
        r2, paste0('\\1', paste(round(rgb2gray(col), 2), collapse = ','), '\\3'),
        x[i]
      )
    }
    i = i + 1
  }
  x
}

# https://en.wikipedia.org/wiki/Grayscale
rgb2gray = function(x, maxColorValue = 1) {
  rep(sum(c(.2126, .7152, .0722) * x/maxColorValue), 3)
}


