#' beamer presentation format for Japanese typesetting with XeLaTeX or LuaLaTeX
#'
#' @inheritParams rmarkdown::beamer_presentation
#' @family pdf formats
#' @title R Markdown 上で XeLaTeX を使い日本語 beamer スライドを作成するフォーマット
#' @description bookdown::beamer_presentation2 wrapper format for Japanese typesetting with XeLaTeX or LuaLaTeX / XeLaTeX または LuaLaTeX で `bookdown::beamer_presentation2` で日本語タイプセットをするためのラッパフォーマット.
#' @details rmarkdownで \LaTeX を使う場合, 日本語を適切に表示するためにいろいろ必要だった調整を済ませたフォーマット
#' 基本的なオプションだけに限定することで簡単にポンチ絵スライドになってしまうことを回避する画期的な機能もあります.
#' 
#' @param keep_tex logical. 出力時に .tex ファイルを残すかどうか. 経験的にknit時エラーのほとんどは生成された.texファイルに問題があるためデバッグ用に **\code{TRUE}を推奨する**. 
#' @param keep_md logical. 出力時に .md ファイルを残すかどうか. 
#' @param theme chracter. beamer テーマ. 
#' @param theme_options character. テーマオプション. デフォルトはフレームタイトルの下にプログレスバーをつけて, ブロックの背景色を描画するというもの
#' @param fonttheme character. フォントテーマ. デフォルトでは数式にローマン体を使う.
#' @param colortheme character. 色テーマ.
#' @param toc logical. 目次をスライド冒頭に出力するかどうか. 白紙フレームになるので見栄えが悪い. examples のように自分で書いたほうが良いと思う. 
#' @param fig_width numeric. 画像保存時の幅. 単位インチ. デフォルトはbeamerのデフォルト幅と同じ.
#' @param fig_height numeric. 画像保存時の高さ. 単位インチ. デフォルトはbeamerのデフォルト高と同じ.
#' @param fig_caption logical. 画像にキャプションを付けるか否か.
#' @param fig_crop logical. `pdfcrop` を使ってpdf画像の余白を削るかどうか.
#' @param out.width character. 画像を貼り付ける際のサイズ. チャンクごとに指定することも可能. 
#' @param out.heigt character. `out.height` 参照. 
#' @param highlight character. チャンク内のコードのシンタックスハイライトのデザイン. \code{\link[rmarkdown]{beamer_presentation}} 参照. 
#' @param code_rownumber logical チャンクに行番号を付けるかどうか. 
#' @param code_softwrap logical チャンク内のコードを自動折り返しするかどうか.
#' @param citation_package character. 本文中の引用トークンに関するパッケージ. \code{"default"}, \code{"natbib"} or \code{"biblatex"}. \code{"default"} は pandoc-citeproc を, \code{"natbib"} は bibtex を使用する. よって \code{"natbib"} で日本語文献を引用する場合はオプション \code{options(tinytex.latexmk.emulation = F)} が必要. 詳細は \link[=https://gedevan-aleksizde.github.io/rmdja/%E6%96%87%E7%8C%AE%E5%BC%95%E7%94%A8.html#%E3%82%92%E4%BD%BF%E3%81%86]{rmdja の公式ドキュメント} を参照.
#' @param citation_options character. `citation_package` のオプション. `"default"`, 空の文字列, \code{NULL} などを指定すると特に何もしない. \code{citation_package = "natbib"} を選んだ場合, \code{"default"} は \code{`numbers`} に書き換えられる. 
#' @param figurename character. 図X の「図」の部分のテキスト.
#' @param tablename character. 表Y の「表」の部分のテキスト.
#' @param number_sections logical. セクション見出しに番号を付けるかどうか.
#' @param slide_level integer. フレームタイトルに対応する markdown の節レベル. デフォルト: 2. つまり `#` はセクションタイトルで, `##` がフレームタイトルになる.
#' @param incremental logical. 箇条書きが順番に現れるやつ. 文字が回転するアニメーション機能はない. 
#' 『...遠慮のないマッポ関係者が失笑した。ナムサン！プレゼンテーションにおける典型的なセンスレス文字操作だ。』--- B. ボンド& F. モーゼズ
#' @param self_contained logical. tex ファイルのプリアンブルも生成するかどうか. texソースを手動で書き換えたいのでない限り `TRUE`.
#' @param includes named list. texファイルに追加するファイルパス. \code{"in_header"}, \code{"before_body"}, \code{"after_body"}, にはファイルパス, \code{"preamble"} は \code{document} 環境直前のプリアンブル記述をインラインで書くことができる. 詳細は \code{\link[rmarkdown]{includes}} 参照.
#' @param template character. ユーザー定義のpandocテンプレートを使いたい場合はパスを指定する.
#' @param latex_engine character. LaTeXエンジンの指定. `xelatex` または `lualatex` を想定. `pdflatex`での日本語表示は**サポートしていない**.
#' @param dev character. グラフィックデバイス. 日本語を使う限りデフォルト値から変更する利点はほぼない. ただし Mac のみ `"quartz"` の選択も考慮する余地がある.
#' @param md_extensions. named_list. pandoc 変換の際にmdフォーマットに付けるオプション. 詳細は \code{\link[rmarkdown]{rmarkdown_format}} 参照.
#' @param pandoc_args. named list. pandoc に渡す引数. yamlヘッダのトップレベルに概ね対応する. 詳細は \code{\link[rmarkdown]{pdf_document}}, \code{\link[rmarkdown]{rmd_metadata}} や pandoc の公式ドキュメント参照.
#' @param opts_chunk named list. Rmdファイルのチャンク内で `knitr::opts_chunk$set(...)` で記入するものと同じ. 画像サイズなどチャンク出力の設定がbeamer向けになるようデフォルト値を変更している 多くの場合は次のように設定される: \code{list(message = FALSE, echo = FALSE, comment = NA, fig.align = "center")}
#' @param latexmk_emulation logical. パッケージオプション `tinytex.latexmk.emulation` に連動する. デフォルトでは, 文献引用エンジンを natbib にしたときのみ `FALSE`, それ以外は `TRUE`. これは `tinytex` が (u)pBibTeX に対応していないため. どうしても BibTeX を使いたい場合以外は操作する必要のない不要なオプションですが, 日本語を含む文書を作成する限りそのような場面はないと思われます. 
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
  out.width = "100%",
  out.height = "100%",
  highlight = "default",
  code_rownumber = FALSE,
  code_softwrap = TRUE,
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
  template = "default",
  md_extensions = NULL,
  pandoc_args = NULL,
  opts_chunk = NULL
){
  # ----- check arguments class & value -----
  latex_engine <- latex_engine[1]
  match.arg(latex_engine, c("xelatex", "lualatex", "tectonic", "pdflatex"))
  if(latex_engine == "pdflatex"){
    message("You selected `pdflatex` engine. It is not good choice for Japanese documents. Possibly `xelatex` or `lualatex` is better.")
  }
  # ----- reshape arguments -----
  pandoc_args_base <- c()
  extra_metadata <- list()

  if(!identical(theme_options, "default")){
    if(!is.null(theme_options) && !identical(theme_options, "")){
      pandoc_args_base <- c(pandoc_args_base, "-V", paste0('themeoptions:', paste0(theme_options, collapse = ","))) #FIXME: how to handle '=' contained values/what does mean the """list""" in Pandoc command line arguments?
    }
  }
  extra_metadata <- c(extra_metadata, merge_bibliography_args(citation_package, citation_options))
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
  pandoc_args <- c(pandoc_args_base, pandoc_args)
  pandoc_args <- add_pandoc_arg(pandoc_args, "--extract-media", ".")
  
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
  if(identical(code_softwrap, T)){
    latex_preamble_code_softwrap <- system.file("resources/styles/latex/code-softwrap.tex", package = "rmdja")
    if(is.null(includes)){
      includes <- rmarkdown::includes(in_header = latex_preamble_code_softwrap)
    } else {
      includes$in_header <- c(latex_preamble_code_softwrap, includes$in_header)
    }
  }
  tinytex_latexmk_default <- getOption("tinytex.latexmk.emulation")
  
  # ----- generate output format -----
  args_beamer_base <- list(
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
  )
  base <- do.call(bookdown::beamer_presentation2, args_beamer_base)

  opts_chunk_default <- list(
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
    dev = dev
    )
  if(code_rownumber) opts_chunk_default$class.source <- "numberLines LineAnchors"
  args_opts_chunk <- rmarkdown:::merge_lists(opts_chunk_default, opts_chunk)
  
  args_pandoc_options <- list(to = "beamer",
                              from = rmarkdown::from_rmarkdown(fig_caption, md_extensions),
                              args = NULL,
                              keep_tex = keep_tex,
                              latex_engine = latex_engine)
  
  preproc <- function(metadata, input_file, runtime, knit_meta, files_dir, output_dir){
    bib_args <- rmarkdown:::merge_lists(
      metadata[c("biblio-style", "natbiboptions", "biblatexoptions")],
      extra_metadata[c("biblio-style", "natbiboptions", "biblatexoptions")])
    bib_args <- bib_args[!is.na(names(bib_args))]
    if(identical(citation_package, "natbib")){
      if(is.null(bib_args[["natbiboptions"]])){
        bib_args[["natbiboptions"]] <- "numbers"
      }
      copy_latexmkrc(metadata, input_file, runtime, knit_meta, files_dir, output_dir)
      if(latexmk_emulation == F){
        options(tinytex.latexmk.emulation = F)
        message(gettext("Preprocessing"), ": ",
                gettext("latexmk emulation is temporarily disabled to use (u)pBibTeX."))
      }
    } else if(identical(citation_package, "biblatex")){
      if(is.null(bib_args[["biblio-style"]])){
        bib_args[["biblio-style"]] <- "jauthoryear"
      }
      if(is.null(bib_args[["biblatexoptions"]])){
        bib_args["biblatexoptions"] <- c("natbib=true,citestyle=numeric")
      }
      if(bib_args[["biblio-style"]] == "jauthoryear"){
        copy_biblatexstyle(metadata, input_file, runtime, knit_meata, files_dir, output_dir)
      }
    }
    if(is.null(metadata[["biblio-title"]])) bib_args <- c(bib_args, list(`biblio-title`="参考文献"))
    return(
      c(
        autodetect_and_set_jfont(metadata, input_file, runtime, knit_meta, files_dir, output_dir, latex_engine),
        paste0("-M", names(bib_args), "=", bib_args)
      )
    )
  }
  out <- rmarkdown::output_format(
    pre_knit = adjust_fontsize,
    knitr = do.call(rmarkdown::knitr_options, list(
      opts_chunk = args_opts_chunk,
      opts_knit = list(global.par = T))
      ),
    pandoc = do.call(rmarkdown::pandoc_options, args_pandoc_options),
    pre_processor = preproc,
    clean_supporting = !keep_tex,
    keep_md = keep_md,
    base_format = base,
    on_exit = function(x){options(tinytex.latexmk.emulation = tinytex_latexmk_default)}
    )
  return(out)
}
