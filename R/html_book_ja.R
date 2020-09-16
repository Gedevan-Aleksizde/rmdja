#' bookdown::gotbook wrapper for Japanese 
#'
#' @param split_by character. デフォルト: 'chapter'. 'chapter', 'chapter+number', 'section', 'section+number', 'rmd', 'none' から選ぶ. ページを区切る単位.
#' @param config list. デフォルト: 実際に出力して確認したほうが早い. 詳しくは bookdown のマニュアル. 
#' @export

gitbook_ja <- function(
  fig_caption = TRUE,
  fig_align = "center",
  fig_width = 7,
  fig_height = 5,
  fig_retina = 2,
  table_css = TRUE,
  toc = TRUE,
  toc_depth = 3,
  toc_float = TRUE,
  number_sections = TRUE,
  section_divs = TRUE,
  split_by = 'chapter',
  self_contained = FALSE,
  split_bib = TRUE,
  code_folding = "none",
  code_download = FALSE,
  theme = "default",
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
  md_extensions = NULL,
  pandoc_args = NULL,
  ...){
  
  match.arg(code_folding, c("none", "show", "hide"))
  match.arg(split_by, c('chapter', 'chapter+number', 'section', 'section+number', 'rmd', 'none'))
  
  if(missing(config) || is.null(config) || length(config) <= 0){
    config <- list(
      toc = list(
        collapse = "none",
        before = '<li><a href="./">Top</a></li>',
        after = '<li><a href="https://bookdown.org" target="_blank">Published with bookdown</a></li>'
        ),
      toolbar = list(position = "fixed"),
      edit = NULL,
      download = c("pdf", "epub", "mobi"),
      search = TRUE,
      fontsettings = list(
        theme = "white",
        family = "sans",
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
  if(missing(css) || is.null(css) || length(css) <= 0){
    css <- file.path(system.file("resources/styles/css", package = "rmdja"), c("toc.css", "style.css"))
  }
  args <- list(
    fig_caption = fig_caption,
    fig_align = fig_align,
    fig_width = fig_width,
    fig_height = fig_height,
    fig_retina = fig_retina,
    table_css = table_css,
    toc = toc,
    toc_depth = toc_depth,
    toc_float = toc_float,
    number_sections = number_sections,
    section_divs = section_divs,
    split_by = split_by,
    self_contained = self_contained,
    split_bib = split_bib,
    pandoc_args = pandoc_args,
    template = template,
    config = config,
    code_folding = code_folding,
    code_download = code_download,
    theme = theme,
    highlight = highlight,
    dev = dev,
    dev.args = dev.args,
    df_print = df_print,
    mathjax = mathjax,
    template = template,
    extra_dependencies = extra_dependencies,
    css = css,
    includes = includes,
    keep_md = keep_md,
    lib_dir = lib_dir,
    md_extensions = md_extensions,
    pandoc_args = pandoc_args,
    ...
  )
  out <- do_call(bookdown::gitbook, args)
  return(out)
}