
# rmdja 0.4.7

-   主要OS以外を検知した場合のデフォルトフォントを原ノ味フォントに変更
-   テンプレートをパッケージの要件内で動作するよう修正

# rmdja 0.4.6

-   `pdf_document2_ja`, `pdf_book_ja` それぞれで LaTeX
    エンジンに対応したデフォルトの文書クラスを自動設定するように
    -   document2\_ja -&gt; `*jsarticle`, book\_ja -&gt; `*jsbook`
    -   `xelatex` -&gt; `bx*`, `lualatex` -&gt; `lt*`
-   BibLaTeX のデフォルト引用スタイルのエラー修正

# rmdja 0.4.5

-   (u)pBibTeX (`citation_package = natbib`)
    選択時に手動設定の必要があった `tinytex.latexmk.emuration = F`
    を自動化
    -   `natbib` と `tinytex.latexmk.emulation = T`
        を両立したい場合のために `latexmk_emulation` 引数を追加.
-   『R Markdown
    クックブック』で紹介されているテクニックをすぐ実行できるよう,
    テンプレートに内蔵
    -   `tcolorbox.sty` をプリアンブルに追記せずに使用できるように
        (`block_style = "tcolorbox"`)
-   `pdf_book_ja` からレポート用の `pdf_doucment2_ja` を分離独立
-   `gitbook_ja` からレポート用の `html_document2_ja` を分離独立,
    ただしやっつけ仕事.
-   アイコン付きブロックの名称を変更 (`{block, type="..."}` の部分)
    -   `rmdnote` -&gt; `memo`
    -   `rmdtip` -&gt; `tip`
    -   `rmdimportant` -&gt; `important`
    -   `rmdcaution` -&gt; `caution`
    -   `rmdwarning` -&gt; `warning`
-   デフォルトの引用スタイル `.css`. `.bbx` の設定を改善
-   細かい修正
    -   `tectonic` 対応 (要 v2.8 以降の **rmarkdown**)
    -   `beamer_presentation_ja` でも **bookdown**
        方式の相互参照ができるように
    -   `beamer_presentation_ja` でも Pandoc 引数 `--extract-media .`
        をデフォルトに
    -   `beamer_presentation_ja` で **kableExtra**
        の機能を使う際に必要なパッケージの読み込みをデフォルトに
    -   (u)pLaTeX 使用時の修正が多少楽になった気がする

# rmdja 0.4.3

-   `texlogo()` の内部処理改善
-   `knitr::kable()` および `kableExtra::kbl()` の簡易ラッパー関数導入
-   コードブロックの自動整形のデフォルト設定を追加
-   PDF でコードブロックの自動折り返しを設定するオプションを追加
-   ドキュメントの加筆と整理

# rmdja 0.4.2

-   参考文献の出力は `biblatex` をデフォルトに, `jauthoryear.bbx`
    を想定した設計に
-   `ggplot2` と標準グラフィックスのデフォルトフォントを一括設定する関数
-   ドキュメントの整理
    -   `kableExtra`, `gt`, `huxtable`
        パッケージによる簡単な作表の例を追加

# rmdja 0.4.1

-   ライセンスの明記

# rmdja 0.4

-   パッケージ変更箇所追跡のため, `NEWS.md` ファイルを追加
-   論文形式PDFのテンプレートを追加
-   縦書き文書PDFのテンプレートを追加
-   Pythonスクリプト埋め込み用の機能追加
-   ドキュメントの更新
    -   Python の解説追加
    -   序文で綴られていたフラストレーション全開の記述を削減
    -   引用文献処理に関する説明
    -   「卒業論文フォーマット」の解説追加
    -   縦書き文書の解説追加
-   バグフィックス
    -   Pandocオプションのトップレベル見出しの設定ができなかった問題
    -   `texlogo()` のタイポ
    -   HTMLのデフォルトスタイルが反映されていなかった問題

# rmdja 0.3.2

-   それ以前は `README.md` を見てください.
