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
  toc_depth = 3,
  number_sections = TRUE,
  section_divs = TRUE,
  split_by = 'chapter',
  self_contained = FALSE,
  split_bib = TRUE,
  code_folding = "none",
  code_download = FALSE,
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

  preproc <- function(metadata, input_file, runtime, knit_meta, files_dir, output_dir){
    print(files_dir)
    print(output_dir)
    for(x in list(list(d = "styles/img", f = ICON_FILES()), list(d = "styles/css", f = CSS_FILES()))){
      print(file.path(output_dir, x$d))
      if(!file.exists(file.path(output_dir, x$d))) dir.create(output_dir, recursive = T)
      file.copy(system.file(file.path("resources", x$d, x$f), package = "rmdja"),
                file.path(output_dir, x$d))
    }
  }
  postproc <- function(metadata, input_file, output_file, clean, verbose){
    print("postproc called")
    print(input_file)
    print(output_file)
  }

  args <- list(
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
    base_format = do.call(
      rmarkdown::output_format,
      list(pandoc = NULL,
           knitr = list(opts_hooks = list(echo = hook_display_block)),
           pre_processor = preproc,
           post_processor = postproc,
           base_format = rmarkdown::html_document()
           )
      ),
    ...
  )
  out <- do.call(bookdown::gitbook, args)
  out$knitr$opts_hooks <- list(echo = hook_display_block)  # bookdown の修正待ち
  # """ヤバ"""イ
  # out$pre_processor <- preproc
  out$post_processor <- function(metadata, input_file, output_file, clean, verbose){
    print("--- postporc called ---")
    print(input_file)
    print(output_file)
    print(metadata)
    bookdownpost(metadata, input_file, output_file, clean, verbose)
  }
  return(out)
}
