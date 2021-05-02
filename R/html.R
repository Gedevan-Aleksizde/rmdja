#' @title bookdown::gitbook wrapper for Japanese
#' @description bookdown::gitbook 日本語版
#' @details PDF に比べて大したことはしてないです. というか gitbook/pdf_document でも気にならないかも.
#' 
#' * `gitbook_ja` は \code{bookdown::\link{gitbook}} の日本語版です.
#' * `html_document2_ja` は \code{bookdown::\link{html_document2}} の日本語版です.
#' 
#' @inheritParams bookdown::gitbook
#' @param split_by character. デフォルト: 'chapter'. 'chapter', 'chapter+number', 'section', 'section+number', 'rmd', 'none' から選ぶ. ページを区切る単位.
#' @param config: list. デフォルト: 実際に出力して確認したほうが早い. 詳しくは bookdown のマニュアル.
#' @param dev: character. デフォルト: `png` しかし将来 `ragg_png` にするかもしれない.
#' @param code_rownumber: logical. デフォルト: TRUE. 行番号を表示するかどうか
#' @export
gitbook_ja <- function(
  fig_caption = TRUE,
  fig_align = "center",
  fig_width = 7,
  fig_height = 5,
  fig_retina = 2,
  table_css = TRUE,
  toc_depth = 3,
  number_sections = TRUE,
  section_divs = TRUE,
  split_by = c("chapter", "chapter+number", "section", "section+number", "rmd", "none"),
  self_contained = FALSE,
  split_bib = TRUE,
  code_folding = c("none", "show", "hide"),
  code_download = FALSE,
  code_rownumber = TRUE,
  highlight = "default",
  dev = 'png',
  dev.args = list(res = 200),
  df_print = "default",
  mathjax = "default",
  template = "default",
  config = list(),
  extra_dependencies = NULL,
  css = NULL,
  includes = NULL,
  keep_md = FALSE,
  lib_dir = 'libs',
  knitr_options = NULL,
  md_extensions = NULL,
  pandoc_args = NULL,
  ...){
  
  code_folding <- code_folding[1]
  split_by <- split_by[1]
  match.arg(code_folding, c("none", "show", "hide"))
  match.arg(split_by, c('chapter', 'chapter+number', 'section', 'section+number', 'rmd', 'none'))
  
  if(missing(config) || is.null(config) || length(config) <= 0){
    config <- list(
      toc = list(
        collapse = "none",
        before = '<li><a href="index.html">Top</a></li>',
        after = '<li><a href="https://bookdown.org" target="_blank">Published with bookdown</a></li>'
        ),
      toolbar = list(position = "fixed"),
      edit = NULL,
      download = c("pdf", "epub", "mobi"),
      search = TRUE,
      fontsettings = list(
        theme = "white",
        family = "serif",
        size = 2
      ),
      info = TRUE,
      sharing = list(
        github = TRUE,
        twitter = TRUE,
        facebook = TRUE,
        all = c('linkedin', 'vk', 'weibo', 'instapaper')
      )
    )
  }
  opts_chunk_default <- list()
  if(code_rownumber) {
    opts_chunk_default <- c(opts_chunk_default, list(attr.source = c(".numberLines .lineAnchors")))
  }
  if(!missing(fig_align) || !is.null(fig_align)){
    opts_chunk_default <- c(opts_chunk_default, list(fig.align = fig_align))
  }
  opts_chunk_default <- c(opts_chunk_default, list(tidy = T, tidy.opts = list(indent = getOption("formatR.indent", 2), width = 60)))

  preproc_css <- function(metadata, input_file, runtime, knit_meta, files_dir, output_dir){
    args_extra <- c()
    img_list <- list(d = "styles/img", f = ICON_FILES())
    css_list <- list(d = "styles/css", f = CSS_FILES())
    for(x in list(img_list, css_list)){
      dir_copy_to <- file.path(files_dir, x$d)
      if(!file.exists(dir_copy_to)) dir.create(dir_copy_to, recursive = T)
      file.copy(system.file(file.path("resources", x$d, x$f), package = "rmdja"),
                dir_copy_to)
      for(css_file in file.path(dir_copy_to, subset(x$f, subset = substr(x$f, nchar(x$f) - 3, nchar(x$f)) == ".css"))){
        args_extra <- c(args_extra, c("--css", css_file))
        }
    }
    if(is.null(metadata[["biblio-title"]])) args_extra <- c(args_extra, "-Mbiblio-title=参考文献")
    return(args_extra)
  }
  knitr_options_ <- merge_lists(
    rmarkdown::knitr_options_html(fig_width, fig_height, fig_retina, keep_md, dev),
    rmarkdown::knitr_options(
      opts_chunk = opts_chunk_default,
      opts_hooks = list(echo = hook_display_block),
      opts_knit = list(global.par = T)
    ),
    ignore_null_overlay = T
  )
  knitr_options_ <- merge_lists(knitr_options_, list(opts_chunk = opts_chunk_default), ignore_null_overlay = T)
    
  args <- list(
    base = list(
      fig_caption = fig_caption,
      number_sections = number_sections,
      self_contained = self_contained,
      lib_dir = lib_dir,
      pandoc_args = pandoc_args,
      toc_depth = toc_depth,
      fig_align = fig_align,
      fig_width = fig_width,
      fig_height = fig_height,
      fig_retina = fig_retina,
      section_divs = section_divs,
      code_folding = code_folding,
      code_download = code_download,
      highlight = highlight,
      dev = dev,
      dev.args = dev.args,
      df_print = df_print,
      mathjax = mathjax,
      extra_dependencies = extra_dependencies,
      css = css,
      includes = includes,
      keep_md = keep_md,
      md_extensions = md_extensions,
      template = template,
      split_by = split_by,
      split_bib = split_bib,
      config = config,
      table_css = table_css,
      ...
    ),
    knitr = knitr_options_,
    pandoc = NULL
  )
  base_ <- do.call(
    rmarkdown::output_format,
    list(pandoc = args$pandoc,
         knitr = args$knitr,
         pre_processor = preproc_css,
         base_format = rmarkdown::html_document()
    )
  )

  out <- do.call(bookdown::gitbook, c(args$base, base_format = base_))
  # TODO refactoring
  preproc_base <- out$pre_processor
  out$pre_processor <- function(metadata, input_file, runtime, knit_meta, files_dir, output_dir){
    a1 <- preproc_css(metadata, input_file, runtime, knit_meta, files_dir, output_dir)
    a2 <- preproc_base(metadata, input_file, runtime, knit_meta, files_dir, output_dir)
    return(c(a1, a2))
  }
  out$knitr$opts_hooks <- list(echo = hook_display_block)
  if(code_rownumber) out$knitr$opts_chunk <- merge_lists(out$knitr$opts_chunk, opts_chunk_default)
  return(out)
}



#' @inheritParams bookdown::gitbook
#' @name gitbook_ja
#' @export
html_document2_ja <- function(
  fig_caption = TRUE,
  fig_align = "center",
  fig_width = 7,
  fig_height = 5,
  fig_retina = 2,
  table_css = TRUE,
  toc_depth = 3,
  number_sections = TRUE,
  self_contained = FALSE,
  code_folding = c("none", "show", "hide"),
  code_download = FALSE,
  code_rownumber = TRUE,
  highlight = "default",
  dev = 'png',
  dev.args = list(res = 200),
  df_print = "default",
  mathjax = "default",
  template = "default",
  extra_dependencies = NULL,
  css = NULL,
  includes = NULL,
  keep_md = FALSE,
  lib_dir = 'libs',
  md_extensions = NULL,
  pandoc_args = NULL,
  ...
  ){
  
  code_folding <- code_folding[1]
  match.arg(code_folding, c("none", "show", "hide"))
  
  opts_chunk_default <- list()
  if(code_rownumber) {
    opts_chunk_default <- c(opts_chunk_default, list(attr.source = c(".numberLines .lineAnchors")))
  }
  if(!missing(fig_align) || !is.null(fig_align)){
    opts_chunk_default <- c(opts_chunk_default, list(fig.align = fig_align))
  }
  opts_chunk_default <- c(opts_chunk_default, list(tidy = T, tidy.opts = list(indent = getOption("formatR.indent", 2), width = 60)))
  
  preproc_css <- function(metadata, input_file, runtime, knit_meta, files_dir, output_dir){
    args_extra <- c()
    img_list <- list(d = "styles/img", f = ICON_FILES())
    css_list <- list(d = "styles/css", f = CSS_FILES())
    for(x in list(img_list, css_list)){
      dir_copy_to <- file.path(files_dir, x$d)
      if(!file.exists(dir_copy_to)) dir.create(dir_copy_to, recursive = T)
      file.copy(system.file(file.path("resources", x$d, x$f), package = "rmdja"),
                dir_copy_to)
      for(css_file in file.path(dir_copy_to, subset(x$f, subset = substr(x$f, nchar(x$f) - 3, nchar(x$f)) == ".css"))){
        args_extra <- c(args_extra, c("--css", css_file))
      }
    }
    if(is.null(metadata[["biblio-title"]])) args_extra <- c(args_extra, "-Mbiblio-title=参考文献")
    return(args_extra)
  }
  knitr_options_ <- merge_lists(
    rmarkdown::knitr_options_html(fig_width, fig_height, fig_retina, keep_md, dev),
    rmarkdown::knitr_options(
      opts_chunk = opts_chunk_default,
      opts_hooks = list(echo = hook_display_block),
      opts_knit = list(global.par = T)
    ),
    ignore_null_overlay = T
  )
  knitr_options_ <- merge_lists(knitr_options_, list(opts_chunk = opts_chunk_default), ignore_null_overlay = T)
  
  args <- list(
    base = list(
      fig_caption = fig_caption,
      number_sections = number_sections,
      self_contained = self_contained,
      lib_dir = lib_dir,
      pandoc_args = pandoc_args,
      toc_depth = toc_depth,
      fig_align = fig_align,
      fig_width = fig_width,
      fig_height = fig_height,
      fig_retina = fig_retina,
      code_folding = code_folding,
      code_download = code_download,
      highlight = highlight,
      dev = dev,
      dev.args = dev.args,
      df_print = df_print,
      mathjax = mathjax,
      extra_dependencies = extra_dependencies,
      css = css,
      includes = includes,
      keep_md = keep_md,
      md_extensions = md_extensions,
      template = template,
      ...
    ),
    knitr = knitr_options_,
    pandoc = NULL
  )
  out <- rmarkdown::output_format(
    knitr = args$knitr,
    pandoc = args$pandoc,
    keep_md = keep_md,
    pre_processor = preproc_css,
    base_format = do.call(bookdown::html_document2, args$base)
  )
  # TODO refactoring
  preproc_base <- out$pre_processor
  out$pre_processor <- function(metadata, input_file, runtime, knit_meta, files_dir, output_dir){
    a1 <- preproc_css(metadata, input_file, runtime, knit_meta, files_dir, output_dir)
    a2 <- preproc_base(metadata, input_file, runtime, knit_meta, files_dir, output_dir)
    return(c(a1, a2))
  }
  out$knitr$opts_hooks <- list(echo = hook_display_block)
  if(code_rownumber) out$knitr$opts_chunk <- merge_lists(out$knitr$opts_chunk, opts_chunk_default)
  return(out)
}
