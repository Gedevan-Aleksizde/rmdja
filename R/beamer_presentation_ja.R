#' XeLaTeX + beamer + XeCJK 
#'
#' @inheritParams rmarkdown::beamer_presentation
#' @title R Markdown 上で XeLaTeX を使い日本語 beamer スライドを作成するフォーマット
#' @description  rmarkdownで \LaTeX を使う場合, 日本語を適切に表示するためにいろいろ必要だった調整を済ませたフォーマット
#' 基本的なオプションだけに限定することで簡単にポンチ絵スライドになってしまうことを回避する画期的な機能もあります
#' 
#' @param keep_tex logical. 出力時に .tex ファイルを残すかどうか. 経験的にknit時エラーのほとんどは生成された.texファイルに問題があるためデバッグ用に **TRUEを推奨する**. デフォルト: TRUE
#' @param keep_md logical. 出力時に .md ファイルを残すかどうか. デフォルト: FALSE
#' @param theme chracter. beamer テーマ. デフォルトは "default"
#' @param theme_options character. テーマオプション. デフォルトはフレームタイトルの下にプログレスバーをつけて, ブロックの背景色を描画するというもの
#' @param fonttheme character. フォントテーマ. デフォルトでは数式にローマン体を使う. デフォルト: "default"
#' @param colortheme character. 色テーマ. デフォルト: "default"
#' @param toc logical. 目次をスライド冒頭に出力するかどうか. 白紙フレームになるので見栄えが悪い. examples のように自分で書いたほうが良いと思う. デフォルト: FALSE
#' @param fig_width numeric. 画像保存時の幅. 単位インチ. デフォルトはbeamerのデフォルト幅と同じ 5.03937
#' @param fig_height numeric. 画像保存時の高さ. 単位インチ. デフォルトはbeamerのデフォルト高と同じ 3.77953
#' @param fig_caption logical. 画像にキャプションを付けるか否か. デフォルト: TRUE
#' @param fig_crop logical. pdfcrop を使ってpdf画像の余白を削るかどうか. デフォルト: TRUE
#' @param out.width character. 画像を貼り付ける際のサイズ. チャンクごとに指定することも可能. デフォルト: "100%"
#' @param out.heigt character. `out.height` 参照. デフォルト: "100%"
#' @param highlight character. チャンク内のコードのシンタックスハイライトのデザイン. `rmarkdown::beamer_presentation` 参照. デフォルト: default
#' @param rownumber_chunk logical チャンクに行番号を付けるかどうか. デフォルト: FALSE
#' @param citation_package character.  本文中の引用トークンに関するパッケージ. デフォルト: default
#' @param citation_options character. `citation_package` のオプション. デフォルトの natbib+numbersでは "[1]" のような引用トークンが生成される. デフォルト: numbers.
#' @param figurename character. 図X の「図」の部分のテキスト. デフォルト: "図"
#' @param tablename character. 表Y の「表」の部分のテキスト. デフォルト: "表"
#' @param number_sections logical. セクション見出しに番号を付けるかどうか. デフォルト: FALSE
#' @param slide_level integer. フレームタイトルに対応する markdown の節レベル. デフォルト: 2. つまり `#` はセクションタイトルで, `##` がフレームタイトルになる
#' @param incremental logical. 箇条書きが順番に現れるやつ. 文字が回転するアニメーション機能はない. デフォルト: FALSE『...遠慮のないマッポ関係者が失笑した。ナムサン！プレゼンテーションにおける典型的なセンスレス文字操作だ。』--- B. ボンド& F. モーゼズ
#' @param self_contained logical. (TRUE) LaTeX のプリアンブルも生成する, (FALSE)本文のみ生成する. デフォルト: TRUE
#' @param includes named list. texファイルに追加するファイルパス. `in_header`, `before_body`, `after_body`, にはファイルパス, `preamble` は `document` 環境直前のプリアンブル記述をインラインで書くことができる. 詳細は `rmarkdown::includes` 参照. デフォルト: NULL
#' @param template character. ユーザー定義のpandocテンプレートを使いたい場合はパスを指定する. デフォルト: default
#' @param latex_engine character. LaTeXエンジンの指定. `xelatex` または `lualatex` を想定. `pdflatex` は現状**非推奨**. デフォルト: xelatex
#' @param dev character. グラフィックデバイス. 日本語を使う限りデフォルト値から変更する意義はほぼない. デフォルト: cairo_pdf
#' @param md_extensions. named_list. pandoc 変換の際にmdフォーマットに付けるオプション. 詳細は `rmarkdown::rmarkdown_format` 参照. デフォルト: NULL
#' @param pandoc_args. named list. pandoc に渡す引数. yamlヘッダのトップレベルに概ね対応する. 詳細は `rmarkdown::pdf_document`, `rmarkdown::rmd_metadata` や pandoc の公式ドキュメント参照. デフォルト: NULL
#' @param opts_chunk named list. Rmdファイルのチャンク内で `knitr::opts_chunk$set(...)` で記入するものと同じ. 画像サイズなどチャンク出力の設定がbeamer向けになるようデフォルト値を変更している 主なデフォルト: list(message = FALSE, echo = FALSE, comment = NA, fig.align = "center")
#' @return rmarkdown_output_format

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
  out.width = "100%",
  out.height = "100%",
  highlight = "default",
  rownumber_chunk = FALSE,
  citation_package = "default",
  citation_options = "default",
  figurename = "図",
  tablename = "表",
  number_sections = FALSE,
  slide_level = 2,
  incremental = FALSE,
  self_contained = TRUE,
  includes = NULL,
  latex_engine = c("lualatex", "xelatex"),
  dev = "cairo_pdf",
  template = "default",
  md_extensions = NULL,
  pandoc_args = NULL,
  opts_chunk = NULL
){
  # ----- check arguments class & value -----
  match.arg(latex_engine, c("xelatex", "lualatex"))
  
  # ----- reshape arguments -----

  pandoc_args_base <- c()

  if(!identical(theme_options, "default")){
    if(!is.null(theme_options) && !identical(theme_options, "")){
      pandoc_args_base <- c(pandoc_args_base, "-V", paste0('themeoptions:', paste0(theme_options, collapse = ","))) #FIXME: how to handle '=' contained values/what does mean the """list""" in Pandoc commandline arguments?  
    }
  }
  if(identical(citation_package, "natbib")){
    if(!identical(citation_options, "default")){
      pandoc_args_base <- c(pandoc_args_base, rmarkdown::pandoc_variable_arg("natbiboptions", citation_options))
    }
  }
  if(!missing(figurename) || !identical(figurename, "")){
    pandoc_args_base <- c(pandoc_args_base, rmarkdown::pandoc_variable_arg("figurename", figurename))
  } else {
    pandoc_args_base <- c(pandoc_args_base, rmarkdown::pandoc_variable_arg("figurename", "図"))
  }
  if(!missing(tablename) || !identical(tablename, "")){
    pandoc_args_base <- c(pandoc_args_base, rmarkdown::pandoc_variable_arg("tablename", tablename))
  } else {
    pandoc_args_base <- c(pandoc_args_base, rmarkdown::pandoc_variable_arg("tablename", "図"))
  }
  if(missing(template) || identical(template, "") || identical(template, "default")){
    template <- system.file("resources/pandoc-templates/beamer-ja.tex.template", package = "rmdja")
  }
  
  if("preamble" %in% names(includes)){
    file_in_header_extra <- tempfile(fileext = ".tex")
    if(!is.null(includes$in_header)){
      txt_in_header <- readLines(includes$in_header)
      write(txt_in_header, file_in_header_extra)
    }
    write(includes$preamble, file_in_header_extra, append = T)
    includes$in_header <- file_in_header_extra
  }
  
  # ----- generate output format -----
  args_beamer <- list(
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
    pandoc_args = c(pandoc_args_base, pandoc_args)
  )
  base <- do.call(rmarkdown::beamer_presentation, args_beamer)

  args_opts_chunk <- list(
    include = TRUE,
    eval = TRUE,
    echo = FALSE,
    message = FALSE,
    warning = TRUE,
    error = TRUE,
    comment = NA,
    tidy.opts = list(width.cutoff = 40),
    tidy = F,
    fig.align = "center",
    out.extra = "keepaspectratio",
    out.width = out.width,
    out.height = out.height,
    dev = dev
    )
  if(rownumber_chunk) args_opts_chunk$class.source <- "numberLines LineAnchors"
  
  args_pandoc_options <- list(to = "beamer",
                              from = rmarkdown::from_rmarkdown(fig_caption, md_extensions),
                              args = NULL,
                              keep_tex = keep_tex,
                              latex_engine = latex_engine)
  
  preproc <- function(metadata, input_file, runtime, knit_meta, files_dir, output_dir){
    if(identical(citation_package, "natbib")){
      copy_latexmkrc(...)
    }
    return(autodetect_and_set_jfont(metadata, input_file, runtime, knit_meta, files_dir, output_dir, latex_engine))
  }
  out <- rmarkdown::output_format(
    pre_knit = adjust_fontsize,
    knitr = do.call(rmarkdown::knitr_options, list(opts_chunk = args_opts_chunk)),
    pandoc = do.call(rmarkdown::pandoc_options, args_pandoc_options),
    pre_processor = preproc,
    clean_supporting = !keep_tex,
    keep_md = keep_md,
    base_format = base
    )
  
  return(out)
}
