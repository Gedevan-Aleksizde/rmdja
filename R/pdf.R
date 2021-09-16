#' @inherit pdf_output_base
#' @inheritDotParams pdf_output_base
#' @export
pdf_book_ja <- function (toc = TRUE, tombow = FALSE, add_folio = FALSE, ...)
{
  do.call(pdf_output_base, list(OUTPUT_TYPE = "book", toc = toc, tombow = tombow, add_folio = add_folio, ...))
}

#' @family pdf formats
#' @name pdf_book_ja
#' @inherit pdf_output_base
#' @inheritDotParams pdf_output_base
#' @export
pdf_document2_ja <- function (toc = FALSE, ...)
{
  do.call(pdf_output_base, list(OUTPUT_TYPE = "article", toc = toc, ...))
}


# common processes
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
#'     templatex: japanese.templatex
#'     dev: cairo_pdf
#'     keep_tex: yes
#'     md_extensions: '+raw_tex'
#' documentclass: bxjsbook
#' jfontpreset: ...
#' mainfont: ...
#' sansfont: ...
#' monofont: ...
#' jmainfont: ...
#' biblatexoption:
#'   - style=jauthoryear
#' ```
#' 
#' 加えて knitr のチャンクオプションやフックもいろいろ変更していますが, 基本的にはストレスにならないような動的な設定にしたつもりです. (例: テキストの自動折返し, 文字化けしないようなグラフィックデバイスの選択, 「図」「表」などの頻出キーワードのローカライズなど.)
#' 
#' \code{rmarkdown::\link{pdf_document}} と \code{bookdown::\link{pdf_document2}} の違いは相互参照をサポートしているかどうかです. 技術文書や論文では相互参照は良く使うので後者をベースに日本語文書向けの設定を内蔵しました. 
#' 
#' 
#' @inheritParams bookdown::pdf_book
#' 
#' @param toc logical. \code{rmarkdown::\link{pdf_document}} と同じ. 目次の表示.
#' @param toc_unnumbered logical. 付番されていない見出しも目次に表示するかどうか.
#' @param toc_bib logical. 参考文献のセクションも目次に表示するかどうか.
#' @param toc_appendix logical. 補遺のセクションも目次に表示するかどうか.
#' @param number_sections logical. セクション見出しに番号を付けるかどうか.
#' @param highlight_bw logical. グラフの表示をグレースケールに強制変換するかどうか.
#' @param code_rownumber logical. コードセルに行番号を表示するかどうか. 
#' @param code_softwrapped logical. チャンク内のコードを自動折り返しするかどうか. YAML メタデータ `code-softwrapped` でも可.
#' @param block_style character. `block`/`block2` チャンクや Fenced Div. 用のスタイル定義. `default`, `kframe`, `tcolorbox` に対応. `default` は `kframe` と同じ. YAML メタデータに `block-style: tcolorbox`, `kframe: true` などと書くこともできます. `awesomebox.sty` にも近日対応予定.
#' @param dev character. グラフィックデバイス. 日本語を使う限りデフォルト値から変更する利点はほぼない. ただし Mac のみ `"quartz"` の選択も考慮する余地がある.
#' @param fig_width numeric. 画像保存時の幅. 単位インチ. デフォルトはbeamerのデフォルト幅と同じ.
#' @param fig_height numeric. 画像保存時の高さ. 単位インチ. デフォルトはbeamerのデフォルト高と同じ.
#' @param fig_caption logical. 画像にキャプションを付けるか否か.
#' @param fig_crop logical. `pdfcrop` を使ってpdf画像の余白を削るかどうか.
#' @param fig_auto_font logical. グラフのフォントをOSの標準フォントに自動設定するかどうか
#' @param fig_font character. グラフのフォントに一括指定するフォント. `fig_auto_font = TRUE` のときのみ有効. デフォルトでは `latex_engine` ごとのデフォルトの本文フォントと同じものが選ばれます.
#' @param dev character. グラフィックデバイス. 日本語を使う限りデフォルト値から変更する利点はほぼない. ただし Mac のみ `"quartz"` の選択も考慮する余地があります.
#' @param out.width character. 画像を貼り付ける際のサイズ. チャンクごとに指定することも可能. 
#' @param out.heigt character. `out.height` 参照. 
#' @param out.extra character. その他の画像貼り付けに関するオプション. デフォルト `NULL` では `keepaspectratio` を追加し, アスペクト比を維持する.
#' @param df_print character.  データフレームの表示方法. `"default"`, `"kable"`, `"tibble"`, `"paged"` のいずれかを指定可能. グローバルオプション の `rmarkdown.df_print` を `FALSE` にするとこの機能を無効にできます.
#' @param highlight character. シンタックスハイライトのスタイル. `"default"`, `"tango"`, `"pygments"`, `"kate"`, `"monochrome"`, `"espresso"`, `"zenburn"`, `"haddock"`, `NULL` が指定可能. `NULL` ならばシンタックスハイライト機能を無効にします.
#' @param quote_footer 長さ2の character. 第1要素は引用ブロックの `---` の後に挿入される. `NULL` ならば動作しない.
#' @param keep_tex logical. 出力時に .tex ファイルを残すかどうか. 経験的に knit 時エラーのほとんどは生成された .tex ファイルに問題の原因があるため, デバッグ用に **\code{TRUE}を推奨します**.
#' @param tombow logical. 製本時に必要なトンボ (trim markers) を付けるかどうか. トンボは `gentombow.sty` で作成される. 
#' @param add_folio logical. 製本時に全ページにノンブルが必要な場合があるらしいので全ページに表示したい時に.
#' @param includes named list. texファイルに追加するファイルパス. \code{"in_header"}, \code{"before_body"}, \code{"after_body"}, にはファイルパス, \code{"preamble"} は \code{document} 環境直前のプリアンブル記述をインラインで書くことができる. 詳細は \code{\link[rmarkdown]{includes}} 参照.
#' @param latex_engine character. LaTeXエンジンの指定. `xelatex` または `lualatex` を想定. `pdflatex`での日本語表示は**サポートしていない**.
#' @param latexmk_emulation logical. パッケージオプション `tinytex.latexmk.emulation` に連動する. デフォルトでは, 文献引用エンジンを `citation_package="natbib"` または `latex_engine = "uplatex"` にしたときのみ自動で `FALSE` となります. これは `tinytex` が (u)pLaTeX および (u)pBibTeX に対応していないための措置です. どうしても BibTeX を使いたい場合以外は操作する必要のない不要なオプションですが, 日本語を含む文書を作成する限りそのような場面はほぼないと思われます.
#' @param md_extentions: character. Pandoc の `--from` オプションに追加する値です. 文書全体の変換処理に関係します. デフォルトの `+raw_tex` は, Pandoc の予測しづらい LaTeX コマンドのエスケープ処理を抑止する効果があります. それ以外の詳細は rmarkdown::\link{rmarkdown_format} を参照してください.
#' @param citation_package character. 引用文献処理エンジンの設定. `default` は CSL, `biblatex` は BibLaTeX, `natbib` は BibTeX と natbib.sty の併用を意味します. 日本語表示のため, 紛らわしいですがデフォルトは `default` ではなく `biblatex` になっていることに注意してください. また, `natbib` を指定した場合, デフォルトでは latexmk のエミュレーションモードが無効になります. 
#' @param citation_options character. `citation_package` のオプション.
#' @param extract_media logical. markdown 構文の画像貼り付けに URL が使用されていた場合, ダウンロードするかどうか. Pandoc の `--extract-media .` に対応. TODO: 現時点では　TRUE にすると余計な画像ファイルが生成される副作用があります. これは rmarkdown にもある不具合です. 
#' @param inculudes named list. 文書に挿入するファイル名を指定します. 構造は \code{rmarkdown::\link{includes}} を参考にしてください.
#' @param knitr_options list. `knitr$opts_chunk$set(...)` などで設定できるチャンクオプションのデフォルト値をリストで与えられます. リスト構造の詳細は \code{rmarkdown::\link{knitr_options}} などを参考にしてください. デフォルトの `NULL` は日本語文書に適した設定に自動で書き換えられることを意味します.
#' @param pandoc_args named list. pandoc に渡す引数. yamlヘッダのトップレベルに概ね対応します. 詳細は \code{\link[rmarkdown]{pdf_document}}, \code{\link[rmarkdown]{rmd_metadata}} や pandoc の公式ドキュメント参照.
#' @param extra_dependencies list. LaTeX に追加で読み込ませるパッケージのリスト. `list(hyperef = c("unicode=true", "breaklinks=true"), lmodern = NULL))` のようにオプションを指定することも可能です.
#' @return \code{rmarkdown_output_format} class
pdf_output_base <- function(
  OUTPUT_TYPE,
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
  fig_auto_font = TRUE,
  fig_font = NULL,
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
  template = "default",
  keep_tex = TRUE,
  keep_md = TRUE,
  latex_engine = c("xelatex", "lualatex", "tectonic", "uplatex", "none"),
  citation_package = c("biblatex", "default", "natbib"),
  citation_options = "default",
  latexmk_emulation = !citation_package == "natbib",
  extract_media = FALSE,
  includes = NULL,
  md_extensions = "+raw_tex",
  knitr_options = NULL,
  output_extensions = NULL,
  pandoc_args = NULL,
  extra_dependencies = NULL,
  tombow = FALSE,
  add_folio = FALSE
  ){
  match.arg(OUTPUT_TYPE, c("book", "article"))
  
  latex_engine <- latex_engine[1]
  match.arg(latex_engine, LATEX_ENGINES_EXT)
  if(!latex_engine %in% LATEX_ENGINES){
    use_platex_ <- T
    platex_engine_ <- latex_engine
    latex_engine <- "xelatex"
  } else{
    use_platex_ <- F
  }
  if(latex_engine == "pdflatex"){
    message("You selected `pdflatex` engine. It is not good choice for Japanese documents. Possibly `xelatex` or `lualatex` is better.")
  }
  if(latex_engine %in% c("xelatex", "tectonic")){
    if(OUTPUT_TYPE == "book"){
      doc_class_default <- "bxjsbook"
    } else if(OUTPUT_TYPE == "article") {
      doc_class_default <- "bxjsarticle"
    }
    
  } else {
    if(OUTPUT_TYPE == "book"){
      doc_class_default <- "ltjsbook"
    } else if(OUTPUT_TYPE == "article") {
      doc_class_default <- "ltjsarticle"
    }
  }
  citation_package <- citation_package[1]
  match.arg(citation_package, BIBLIO_ENGINES)
  block_style <- block_style[1]
  match.arg(block_style, c("default", BLOCK_STYLES))
  
  match.arg(citation_package, BIBLIO_ENGINES)
  
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
  if(extract_media) pandoc_args <- add_pandoc_arg(pandoc_args, "--extract-media", ".")
  
  # book specific settings
  if(OUTPUT_TYPE == "book"){
    base_format <- rmarkdown::pdf_document
    top_level <- "chapter"
    
    pandoc_args <- add_pandoc_arg(pandoc_args, "--top-level-division", top_level)
    
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
  }
  # book specific settings over
  tinytex_latexmk_default <- getOption("tinytex.latexmk.emulation")
  knitr_options_ <- merge_lists(
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
  knitr_options <- merge_lists(knitr_options_, knitr_options, ignore_null_overlay = T)
  knitr_options$knit_hooks$plot <- svg2pdf_hook
  if(fig_auto_font){
    knitr_options$knit_hooks$label <- generate_graphics_font_hook(
      if(is.null(fig_font)) setNames(rmdja::get_default_font_family(latex_engine)["serif"], "") else fig_font
      )
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
      pandoc_args = pandoc_args
    ),
    knitr = knitr_options,
    pandoc = rmarkdown::pandoc_options(
      from = rmarkdown::rmarkdown_format(extensions = md_extensions),
      to = "latex",
      ext = ".tex",
      args = pandoc_args,
      keep_tex = keep_tex,
      latex_engine = latex_engine
    )
  )
  
  preproc <- function(metadata, input_file, runtime, knit_meta, files_dir, output_dir){
    # TODO: 複雑になったので全部 metadata を書き換えてからまとめて更新
    # TODO: ユーザが行儀よく1行毎にオプションを書いてくれるとは限らない
    metadata[["classoption"]] <- paste(metadata[["classoption"]], collapse = ",")
    metadata_origin <- metadata
    metadata[["classoption"]] <- unlist(strsplit(metadata[["classoption"]], ",", fixed = T))
    #args_extra <- merge_lists(
    #  metadata[c("biblio-style", "natbiboptions", "biblatexoptions")],
    #  extra_metadata[c("biblio-style", "natbiboptions", "biblatexoptions")])
    #args_extra <- args_extra[!is.na(names(args_extra))]
    metadata <- complete_font_settings(latex_engine, metadata)
    
    if(is.null(metadata[["documentclass"]])) metadata[["documentclass"]] <- doc_class_default
    
    # BXjscls-specific settings
    if(latex_engine %in% c("xelatex", "lualatex", metadata[["classoption"]] %in% BXJSCLS_NAMES)){
      metadata[["bxjscls"]] <- "yes"
      # edit classoptions to [<latex_engine>,ja=standard,...]
      pos_ja_engine <- which(grepl("^\\s*ja\\s*=", metadata[["classoption"]]))
      if(length(pos_ja_engine) == 0){
        metadata[["classoption"]] <- c("ja=standard", metadata[["classoption"]])
      }
      pos_engine <- which(metadata[["classoption"]] %in% c("xelatex", "lualatex"))
      if(length(pos_engine) == 0){
        metadata[["classoption"]] <- c(latex_engine, metadata[["classoption"]])
      } else{
        metadata[["classoption"]][pos_engine] <- latex_engine
      }
      pos_jafont <- which(grepl("^\\s*jafont\\s*=", metadata[["classoption"]]))
      if(length(pos_jafont) == 0){
        metadata[["classoption"]] <- c(metadata[["classoption"]], sprintf("jafont=%s", metadata[["jfontpreset"]]))
      }
      if(!is.null(metadata[["jfontpresetoption"]])){
        metadata[["classoption"]] <- c(metadata[["classoption"]], metadata[["jfontpresetoption"]])
      }
      if(!identical(metadata[["fontsize"]], "10pt") & tombow){
        metadata[["classoption"]] <- c(metadata[["classoption"]], "nomag")
      }
      # flatten
      metadata[["classoption"]] <- paste(metadata[["classoption"]], collapse = ",")
    }
    # bibilogpahic options
    if(identical(citation_package, "natbib")){
      copy_latexmkrc(output_dir)
      if(latexmk_emulation == F){
        options(tinytex.latexmk.emulation = F)
        message(gettext("Preprocessing"), ": ",
                gettext("latexmk emulation is temporarily disabled to use (u)pBibTeX."))
      }
    } else if(identical(citation_package, "biblatex")){
      if(is.null(metadata[["biblio-style"]])){
        metadata[["biblio-style"]] <- "jauthoryear"
      }
      if(is.null(metadata[["biblatexoptions"]])){
        metadata[["biblatexoptions"]] <- c("natbib=true")
      }
      if(metadata[["biblio-style"]] == "jauthoryear"){
        copy_biblatexstyle(metadata, input_file, runtime, knit_meta, files_dir, output_dir)
      }
    }
    
    # set custom block styles
    if(block_style == "default"){
      if(any(!is.null(metadata[["block-style"]]), F) && metadata[["block-style"]] %in% BLOCK_STYLES){
        metadata[[metadata[["block-style"]]]] <- "yes"
      } else if(any(unlist(metadata[BLOCK_STYLES]))){
        for(s in BLOCK_STYLES){
          metadata[[s]] <- "yes"
        }
      } else {
        metadata[["kframe"]] <- "yes"
      }
    } else {
      metadata[[block_style]] <- "yes"
      for(s in BLOCK_STYLES){
        if(s != block_style) metadata[[s]] <- NULL
      }
    }
    
    if(identical(code_softwrapped, T)){
      metadata[["code-softwrapped"]] <- "yes"
    }

    icon_dir <- file.path(output_dir, "_latex/_img")
    if(!file.exists(icon_dir)) dir.create(path = icon_dir, recursive = T, showWarnings = T)
    file.copy(file.path(system.file("resources/styles/img", package = "rmdja"), ICON_FILES()), icon_dir)
    new_and_updated <- c(
      names(metadata_origin)[unlist(
        lapply(names(metadata_origin),
               function(x) !identical(metadata_origin[[x]], metadata[[x]]))
        )],
      setdiff(names(metadata), names(metadata_origin))
    )
    metadata <- metadata[new_and_updated]
    args_extra <- mapply(function(name, val){ paste0("-M", name, "=", val) }, names(metadata), metadata)
    return(args_extra)
  }

  # for (u)platex
  postproc <- function(metadata, input, output, clean, verbose) {
    # if (is.function(post)) output = post(metadata, input, output, clean, verbose)
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
    if(platex_engine_ != "none"){
      message(gettext("Japanese-specific compiling mode..."))
      message(gettextf("LaTeX engine: %s", platex_engine_))
      copy_latexmkrc(dirname(output))
      tinytex::latexmk(
        f, engine = "latex",
        bib_engine = 'bibtex',
        engine_args = "-latex=uplatex -gg -pdfdvi",
        emulation = F,
        clean = F
      )
      system2("latexmk", c("-c", "-pdfdvi"))
      system2("rm", with_ext(output, '.dvi'))
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
      message(gettext(".pdf file is not generated. Only .tex file is created. plseae complile manually using `tinytex::latexmk()` if needed."))
      return(output)
    }
  }
  
  # make output format object
  if(OUTPUT_TYPE == "book"){
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
  } else if(OUTPUT_TYPE == "article") {
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
  }
  
  # if so, regular latexmk is executed in post_processor, not regular rmarkdown::render function
  if(use_platex_){
    out$post_processor <- postproc
  }
  
  return(out)
}

# ---- copy from bookdown package v0.22 ----
# https://github.com/rstudio/bookdown/blob/master/R/latex.R

resolve_refs_latex = function(x) {
  # equation references \eqref{}
  x = gsub(
    '(?<!\\\\textbackslash{})@ref\\((eq:[-/:[:alnum:]]+)\\)', '\\\\eqref{\\1}', x,
    perl = TRUE
  )
  # normal references \ref{}
  x = gsub(
    '(?<!\\\\textbackslash{})@ref\\(([-/:[:alnum:]]+)\\)', '\\\\ref{\\1}', x,
    perl = TRUE
  )
  x = gsub(sprintf('\\(\\\\#((%s):[-/[:alnum:]]+)\\)', reg_label_types), '\\\\label{\\1}', x)
  x
}

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


# https://github.com/rstudio/bookdown/blob/df6786eb42f34c9737449f4ef9608c8e9cc76932/R/html.R



label_names = list(fig = 'Figure ', tab = 'Table ', eq = 'Equation ')

theorem_abbr = c(
  theorem = 'thm', lemma = 'lem', corollary = 'cor', proposition = 'prp', conjecture = 'cnj',
  definition = 'def', example = 'exm', exercise = 'exr', hypothesis = 'hyp'
)
# numbered math environments
label_names_math = setNames(list(
  'Theorem ', 'Lemma ', 'Corollary ', 'Proposition ', 'Conjecture ', 'Definition ', 'Example ', 'Exercise ',
  'Hypothesis '
), theorem_abbr)
# unnumbered math environments
label_names_math2 = list(proof = 'Proof. ', remark = 'Remark. ', solution = 'Solution. ')
all_math_env = c(names(theorem_abbr), names(label_names_math2))

label_names = c(label_names, label_names_math)

# types of labels currently supported, e.g. \(#fig:foo), \(#tab:bar)
label_types = names(label_names)
reg_label_types = paste(label_types, collapse = '|')
# compatibility with bookdown <= 0.4.7: ex was the prefix for Example; now it's exm
reg_label_types = paste(reg_label_types, 'ex', sep = '|')

reg_ref_links = '(\\(ref:[-/[:alnum:]]+\\))'
# parse "reference links" of the form "(ref:foo) text", and replace (ref:foo) in
# the content with `text`; this is for figure/table captions that are
# complicated in the sense that they contain special LaTeX/HTML characters (e.g.
# _), or special Markdown syntax (e.g. citations); we can just use (ref:foo) in
# the captions, and write the actual captions elsewhere using (ref:foo) text
resolve_ref_links_html = function(x) {
  res = parse_ref_links(x, '^<p>%s (.+)</p>$')
  if (is.null(res)) return(x)
  restore_ref_links(res$content, '(?<!code>)%s', res$tags, res$txts, TRUE)
}

parse_ref_links = function(x, regexp) {
  r = sprintf(regexp, reg_ref_links)
  if (length(i <- grep(r, x)) == 0) return()
  tags = gsub(r, '\\1', x[i])
  txts = gsub(r, '\\2', x[i])
  if (any(k <- duplicated(tags))) {
    warning('Possibly duplicated text reference labels: ', paste(tags[k], collapse = ', '))
    k = !k
    tags = tags[k]
    txts = txts[k]
    i = i[k]
  }
  x[i] = ''
  list(content = x, tags = tags, txts = txts, matches = i)
}

restore_ref_links = function(x, regexp, tags, txts, alt = TRUE) {
  r = sprintf(regexp, reg_ref_links)
  m = gregexpr(r, x, perl = TRUE)
  tagm = regmatches(x, m)
  for (i in seq_along(tagm)) {
    tag = tagm[[i]]
    if (length(tag) == 0) next
    k = match(tag, tags)
    tag[!is.na(k)] = txts[na.omit(k)]
    if (alt && is_img_line(x[i])) tag = strip_html(tag)
    tagm[[i]] = tag
  }
  regmatches(x, m) = tagm
  x
}