---
title: "`rmdja` による多様な形式の日本語技術文書の作成 "
author: "Katagiri, Satoshi (ill-identified)"
date: "2020-10-17"
site: bookdown::bookdown_site                    # RStudio GUIでビルド操作したい場合に必要
description: "bookdown でまともな日本語文書を作る資料"  # HTML <metadata> に出力されるサイト概要
url: 'https\://bookdown.org/john/awesome/'       # URL
github-repo: "Gedevan-Aleksizde/rmdja"           # Github レポジトリ
cover-image: "img/Johannes_Gutenberg.jpg"        # 表紙画像. epub でのみ有効?
apple-touch-icon: "touch-icon.png"               # iOS でホームスクリーンに登録した際に見えるもの
apple-touch-icon-size: 120                       # そのサイズ
favicon: "favicon.ico"                           # そのまんまファビコン.
link-citations: true                             # 引用に参考文献リストへのハイパーリンクをつける
mainfont: 'DejaVu Serif'
seriffont: 'DejaVu Sans'
monofont: Ricty
mainfontoptions:
  - Scale=0.8
sansfontoptions:
  - Scale=0.8
jmainfont: 'Noto Serif CJK JP'
jseriffont: 'Noto Sans CJK JP'
jmonofont: Ricty
linkcolor: blue
citecolor: blue
urlcolor: magenta
bibliography: rmdja.bib # 書誌情報ファイル
biblio-style: authoryear
# biblio-style: jecon
---



# (PART) イントロダクション {-}

# 序文 {-}

[![](https://i.creativecommons.org/l/by-nc/4.0/88x31.png)](https://creativecommons.org/licenses/by-nc/4.0/deed.ja)

**注意: 絶賛作りかけ**

<!--chapter:end:index.Rmd-->

長大な技術文書や良質な技術文書を作成するには手間がかかる. しかし時間をかければ良い文書になるわけではない. 無駄な手間を省き, 効率よく快適に文書を作成するべきである.

たとえばこういう経験はないだろうか.

* プログラムの解説のため, 外部サービスでシンタックスハイライトしてもらったテキストを**コピーペーストで貼り付ける**
* グラフや図解を専用アプリケーションで作成し貼り付ける. **修正のたびに貼り付け直す**
* 図表に言及する際に「図 1」「表 2」と**番号をタイプし, 参照先へハイパーリンクを指定する**
* 本文中で引用した参考文献のリストを巻末に**コピーペーストし, 過不足がないか目視で確認**
* $\sum_{k=1}^K\int_0^\infty f_k(x) dx$ などといった複雑な数式はプレーンテキストや HTML では表現できないため, **画像を生成して貼り付ける**
* 冒頭にかっこいいエピグラフを掲載したいので, **1時間かけて特別に枠やフォントを作成した**
* 市販のワードプロセッサで作成した文書を渡したら, **レイアウトが崩れて読めない**と言われた

本稿は文書作成者をこのような数え切れないブルシットから解放するのが目的である.

R Markdown (`rmarkdown`) は, R プログラムを埋め込んだ動的なドキュメントから pandoc を利用して PDF や HTML 形式の文書を作成するパッケージであり, 数式, 図表の挿入, シンタックスハイライトされたプログラムなどを簡単な記述で掲載できる. 名前の通り, その基本構文は Markdown である. よって, Markdown と R の知識が最低限あれば (R プログラムが必要ないなら Markdown だけでも) 文書を作成することができる.

`bookdown` パッケージは `rmarkdown` をもとに, ページ数の多い文書を作成し, 配布するための機能を拡張したものである. しかし, PDF の出力に関しては欧文を前提としたフォーマットを使用しているため, 日本語の適切な表示 (組版やフォントの埋め込みなど)   のできる文書を作成するには高いハードルが存在した.

本稿では, `rmarkdown` および `bookdown` で日本語文書を作成する際の設定を容易にしたパッケージ `rmdja` を利用した日本語技術文書の作成方法を解説する. 現在, 書籍, 論文, プレゼンテーションの体裁での文書を作成するテンプレートが用意されており, この**ドキュメント自体も `rmdja` を利用して作成されている**.

# 本稿の目的 {-}

## R Markdown の現状と問題意識 {-}

R Markdown を利用した文書作成方法について, すでにそれなりの数と質の日本語資料が存在する. R Markdown でHTMLファイルのみを作成する場合, 日本語であるか欧文であるかはあまり気にする必要はない. HTMLであれば既存の資料でも十分に役に立つ.

* kazutan 『[R Markdown再入門](https://kazutan.github.io/fukuokaR11/intro_rmarkdown_d.html)』
* kazutan 『[R Markdownによるスライド生成](https://kazutan.github.io/SappoRoR6/rmd_slide.html#/)』

しかし, PDF を出力する, あるいは HTML と PDF を同時に出力したい, となると, 組版に関して細かな設定が必要になるため難易度は一気に上昇する.

実のところPDFでも日本語を表示する最低限の設定は, YAML フロントマターだけで行える. 例えば Atusy氏が『[R Markdown + XeLaTeX で日本語含め好きなフォントを使って PDF を出力する](https://blog.atusy.net/2019/05/14/rmd2pdf-any-font/)』で紹介しているが,  よりシンプルな書き方もできる.

```yaml
output: pdf_document:
    latex_engine: xelatex
documentclass: bxjsarticle
classoption:
  - xelatex
  - ja=standard
  - jafont=noto
```

このままでも, とりあえず文字化けすることなく日本語を表示できる. しかし実際に作ってみると, いろいろな障害が立ちはだかり, 文書として整ったものにするのは難しい. このままでは参考文献リストの表示も不自然なままである. だがこれ以上のカスタマイズは Atusy 氏がやっているようにテンプレートを修正でしか対処できず,  `\LaTeX`{=latex}`LaTeX`{=html} に対するそれなりの知識が必要となる.

さらに, 同じソースファイルから HTML と PDF を同時に生成すると, また別種の問題が発生する. HTML と PDF は根本的に規格が違うため, 様々な場合分け処理が必要であり, それは pandoc だけでは対応しきれない.

HTML出力に限らない R Markdown の全般的な情報は, 既に充実した英語の (公式) ドキュメントが多く存在する[^major-docs].

* "[Dynamic Documents for R・rmarkdown](https://rmarkdown.rstudio.com/docs/index.html)"
* "[bookdown demo](https://github.com/rstudio/bookdown-demo)"
* "[_bookdown: Authoring Books and Technical Documents with R Markdown_](https://bookdown.org/yihui/bookdown/)"
* "[_R Markdown Definiteive Guide_](https://bookdown.org/yihui/rmarkdown/)"
* "[_R Markdown Cookbook_](https://bookdown.org/yihui/rmarkdown-cookbook)"[^rmd-cookbook-publish]

[^major-docs]: 基本的なことがらの多くは上記を読めば分かるのでここでは基本機能をダイジェストで伝えた上で, これらの資料に書いてない応用技を紹介する. YAML のオプションの意味についてはソースコードにコメントを書いた. 以下, 単に, **BKD*  と書けば "_`bookdown`: Authoring Books and Technical Documents with R Markdown_" [@R-bookdown] を, RDG と書けば "_R Markdown: The Definitive GUide_" [@rmarkdown2018] を, RCB と書けば "_R Markdown Cookbook_" [@xie2020Markdown] を指すことにする.

しかしながらこれらを元に1からいろいろな調整を施すのはとても骨が折れるため, `rmdja` パッケージは日本語文書でHTMLやPDFを同時に生成する場合の定番の処理をフォーマットに内蔵することにした.

## `rmdja` の利点 {-}

従来LaTeXやWord, あるいは他の媒体で文書を作成していたユーザにとっても, 文書の内容から面倒な設定を分離するため, 効率的に執筆できる.

Wordユーザにとっては, 以下のような利点がある[^word-out-of-date].

* 数十, 数百ページの文書を書いてもクラッシュすることがあまりない
* 輪郭のはっきりしたベクタ画像を簡単に貼り付けられる
* 図表の配置や相互参照を手動で書く必要がない
* 読み手の環境に依存してレイアウトが崩れにくいPDFファイルを出力できる

ただし, `.docx` ファイルの出力はできない. 私が Word を持っておらず, R Markdown や pandoc がサポートしていても動作確認のしようがないため.

`jupyter` は Python のコードチャンクとその結果を簡単に表示できる文書作成ツールである. 出力オプションの少なさ (たとえば長大なコードもそのまま掲載されてしまう) や,  IDE として見ても機能が少ないことからあまり使い勝手がよくなかったが, `rmdja` では **Python スクリプトの埋め込みにもある程度対応**している.

`\LaTeX`{=latex}`LaTeX`{=html} のユーザー (シンプルなテキストエディタで書いているユーザも, Overleaf や LyX といった強力なエディタを使用しているユーザー) にとっては, `\LaTeX`{=latex}`LaTeX`{=html} とほぼ同じ構文で数式を入力でき, かつ操作を大きく簡略化でき, 実験結果などをソースに埋め込むことができ, 外部プログラムからいちいちコピペする必要がなくなる. ただし, なるべく選択肢は広げておきたいが, なんでもありではかえって余計なことをしがちである. よって既に作成した beamer フォーマットと同様に, `\XeLaTeX`{=latex}`XeLaTeX`{=html} および `\LuaLaTeX`{=latex}`LuaLaTeX`{=html} のみの対応を想定している. `\pLaTeX`{=latex}`pLaTeX`{=html} や `\upLaTeX`{=latex}`upLaTeX`{=html} には対応していない.

これまでも R Markdown を使用してきたユーザにとっては, YAML フロントマターに数十行に渡っていた書いていた日本語表示のための設定の多くがフォーマットのデフォルト値になったため, かなり楽になると思われる.

たとえば,

```yaml
bookdown::pdf_book:
  toc_depth: 3
  toc_appendix: true
  toc_bib: true
  latex_engine: xelatex
  keep_tex: true
  keep_md: true
  citation_package: natbib
  pandoc_args:
    - '--top-level-division=chapter'
    - '--extract-media'
    - '.'
  template: XXXXX.tex.template'
  dev: "cairo_pdf"
  out_width: "100%"
  out_height: "100%"
  quote_footer: ["\\VA{", "}{}"]
  extra_dependencies: gentombow
```

のように書いていたものがこうなる.

```yaml
rmdja::pdf_book_ja:
  keep_tex: true
  keep_md: true
  tombow: true
```

さらにチャンクオプションを書いたり場合によっては .tex ファイルのテンプレートすら調整する必要もあった. それらも `rmdja` 内で調整している.

さらに, 作成した文書は PDF 形式で出力することはもちろん, HTML 形式で様々なサイトで掲載でき[^blogdown]たり, 電子書籍ファイルとしても出力可能である. このような多様な出力形式への対応しているソフトウェアはあまり例を見ない.


## R使用経験のないユーザへ {-}

Rを使わない, あるいはそもそもプログラミングに詳しくない, という人間にもある使用機会がある. たとえばR を普段使わない人間でも `bookdown` で同人技術書を執筆したという事例がある[^bookdown-example]. この事例は主に数式と画像の貼付けのみだから, 数式出力に必要な `\LaTeX`{=latex}`LaTeX`{=html} の知識があればほとんどのことはできてしまう. そして `rmdja` ではこの事例で言及されている `\LaTeX`{=latex}`LaTeX`{=html} の設定の多くは自動で制御される. また, 小説などはほぼテキストであり, 最低限のレイアウトさえ用意すれば数式も, あるいは画像の挿入すらいらないことが多い. `rmdja` では縦書き文書をPDFで出力する方法も用意している.

<div class="rmdimportant">
<p>印刷用フォーマットおよび縦書き文書フォーマットは現在実験的な導入段階であり, 表示の一部に不具合が存在する.</p>
</div>

[^word-out-of-date]: ただし筆者は数年来 Word を使っていないため, これらのいくつかは既に改善されているかもしれない.
[^blogdown]: `bookdown` 同様に R Markdown で作成した文書をブログ風のフォーマットで出力する `blogdown` パッケージというものも存在する.
[^rmd-cookbook-publish]: 2020/10/19 に書籍としても発売されるらしい.
[^bookdown-example]: https://teastat.blogspot.com/2019/01/bookdown.html

<!--chapter:end:chapters/introduction.Rmd-->

# (PART) 最低限のチュートリアル {-}

# クイックスタート {#quick-start}

`rmdja` パッケージをインストールする. 依存している `rmarkdown`, `bookdown`, `knitr` なども同時にインストールされる.


```{.r .numberLines .lineAnchors}
install.packages("remotes")
remotes::install_github("Gedevan-Aleksizde/my_latex_template", repos = NULL)
```

まだ RStudio を使っていないのなら, RStudio 上で作業することを強く推奨する. さらに, もしもRの操作自体にあまり慣れていないのなら, 森知晴 『[卒業論文のためのR入門](https://tomoecon.github.io/R_for_graduate_thesis/)』などを読むことを薦める. 

加えて, 以下のパッケージが役に立つので気に入ったらインストールしていただきたい.


```{.r .numberLines .lineAnchors}
install.packages(c("tidyverse", "ggthemes", "citr", "clipr", "kableExtra"))
```

RStudio を起動し, 左上から新規作成を選び, "R Markdown" を選ぶ (図 \@ref(fig:new-file)).

<div class="figure" style="text-align: center">
<img src="img//new-file.png" alt="新規作成" width="198" height="30%" />
<p class="caption">(\#fig:new-file)新規作成</p>
</div>

"From Template" からテンプレートを選択する (\@ref(fig:rmdja-templates)).

<div class="figure" style="text-align: center">
<img src="img//rmd-templates.png" alt="R Markdown のテンプレート" width="532" />
<p class="caption">(\#fig:rmdja-templates)R Markdown のテンプレート</p>
</div>

現在 (Ver. 0.4) 用意されているのは以下の4つである.

* プレゼンテーション用スライド形式のテンプレート - `Beamer in Japanese`
* 論文形式のテンプレート - `pdf article in Japanese`
* 書籍形式のテンプレート - `pdf book in Japanese`
* 縦書き文書のテンプレート - `pdf vertical writing in Japanese`

動作確認として, 今回はシンプルな論文形式を選ぶ. ファイルを開いたら, 適当な名称で保存し, "knit" ボタンを押すと PDF が作成される.

# 下準備

以降は順を追って細かい解説をする.

## より丁寧なインストール解説

文書を生成するのに必要なものをインストールする.

このドキュメントは `rmdja` パッケージに含まれている. よってまずはこれをダウンロードしてほしい.



ただし, `bookdown` ver. 0.2 時点ではソースファイルのフォルダ配置指定に不具合があるため[^bookdown-subdir-error], もし0.2以前のバージョンを使用しているなら, 更新するか, github から開発版をインストールする. 同様に, `rmarkdown` も CRAN ではなく開発版をインストールしたほうがよい.


```{.r .numberLines .lineAnchors}
remotes::install_github("rstudio/rmarkdown")
remotes::install_github("rstudio/bookdown")
```


3種類のテンプレートのうち, `pdf book in Japanese` のみ, 文書のビルドのための下準備が追加で必要になるため, その方法を解説する. それ以外は第 \@ref(#quick-start) 節で書いたように "knit" ボタンを押すだけで良い.

最低限のファイルやパッケージで動くほうのデモ用ディレクトリをコピーする. ただし, `tidyverse` と `kableExtra` のインストールも必要である.


```{.r .numberLines .lineAnchors}
file.copy(system.file("resources/examples/bookdown-minimal", package = "rmdja"), "./", recursive = T)
```

## 書籍形式のビルド操作

bookdown の文書生成は従来の R Markdown と違い, RStudio の `knit` ボタンでは**できない**. 代わりに, 以下の2通りの方法がある.

1. `bookdown::render_book('index.Rmd', format = "bookdown::gitbook")` などを呼び出す
2. RStudio の Build ペーンを使う

前者は, 以下のように実行する. 順にHTML, PDF, epub を出力している


```{.r .numberLines .lineAnchors}
bookdown::render_book("index.Rmd", "rmdja::gitbook_ja")
bookdown::render_book("index.Rmd", "rmdja::pdf_book_ja")
bookdown::render_book("index.Rmd", "bookdown::epub_book")
```

コピーしたディレクトリ `bookdown-minimal` を設定する (図 \@ref(fig:build-pane1-1), \@ref(fig:build-pane1-2)).

Build ペーンの "Build Book" の三角形を押すと, 使用できるフォーマット一覧が表示される. これはスライド, 縦書き文書, 書籍などといった文書の種類と1対1で対応しているわけではなく, フォーマット関数に対応している.

* HTML形式 - `rmdja::gitbook_ja`
* PDF形式 - `rmdja::pdf_book_ja`
* 電子書籍 (EPUB) 形式 - `bookdown::epub_book`

デフォルトでは "All Formats" にチェックが入っているため, これら3種類のファイル形式を一度に生成する. 

<div class="figure" style="text-align: center">
<img src="img//build-pane.png" alt="Build ペーンの手動設定" width="549" />
<p class="caption">(\#fig:build-pane1-1)Build ペーンの手動設定</p>
</div><div class="figure" style="text-align: center">
<img src="img//build-pane-build.png" alt="Build ペーンの手動設定" width="757" />
<p class="caption">(\#fig:build-pane1-2)Build ペーンの手動設定</p>
</div>

これで `_book` フォルダに出力がされる.


<!--chapter:end:chapters/minimal.Rmd-->

# (PART) R Markdown と Bookdown の基本機能 {-}

# このパートの概要 {-}

ここではまず, R Markdown の基本的な機能を紹介する. つまり `bookdown` 特有のものではなく, R Markdown 全般で使用できる機能も含めて紹介する. これ以降は自己言及的な説明が多いため, この文書を生成しているソースコードと比較しながら確認することをおすすめする. ここで紹介する機能は BKD, RDG, RCB での記述に基づく.
これら3つのドキュメントを読めば, ほとんどのことは可能になる --- `rmdja` を作る理由になった LaTeX テンプレートの修正以外は --- のだが, 本稿の重要な目的の1つは**複数のファイル形式を両立すること**であるので, それができない書き方には触れないし, 技術文書の作成にあまり使わないような機能の動作確認はおこなわず, 技術文書作成で頻繁に使われ, 便利と思える機能のみ紹介する.

どちらにしろそのうちこれらを翻訳してくれる人が現れることだろう...たぶん.

# 静的なコンテンツの作成

日本語で書かれた資料でごく基本的なことについて, 『[R Markdown入門](https://kazutan.github.io/kazutanR/Rmd_intro.html)』で一通り紹介されている. やや応用的なことも 『R Markdown ユーザーののための Pandoc's Markdown』に書かれている.

また, 既に作成している beamer の用例ファイルもどのようなことができるかの参考になるだろう. ただしこちらは PDF のみの出力を前提としているため, 一部の機能は HTML で使うことができない. 

まずは, 単なるマークアップ, つまりプログラミングの複雑な処理を考えなくても良いタイプの構文を紹介する. それらの多くは単なる Markdown のものと同じである.

## Markdown の基本構文

一応基本の Markdown の構文も挙げておく. 詳細は(ref:BKDB)"[Ch. 2.2 Markdown Syntax](https://bookdown.org/yihui/bookdown/markdown-syntax.html)" を参照.

### インラインでの書式変更

テキストの一部のみ書式を変える

アンダースコアで強調 (イタリック)

```markdown
_underscore_
```

_underscore_

`**` 2つで太字強調

```markdown
**太字強調**
```

**太字強調**

等幅フォント

```markdown
`bookdown` と `rmdja`
```

`bookdown` と `rmdja`

本文中に入力した URL は自動判別され, ハイパーリンクが付けられる. また, `[テキスト](URL)` という書式で, テキストに対してハイパーリンクを付けることができる.   

```markdown

URL は自動判別される: https://github.com/Gedevan-Aleksizde/my_latex_templates/tree/master/rmdja

[`rmdja` の github リポジトリ](https://github.com/Gedevan-Aleksizde/my_latex_templates/tree/master/rmdja)
```

URL は自動判別される: https://github.com/Gedevan-Aleksizde/my_latex_templates/tree/master/rmdja

[`rmdja` の github リポジトリ](https://github.com/Gedevan-Aleksizde/my_latex_templates/tree/master/rmdja)


### ブロック要素

以降は行内では使えず, **適切に表示するには前後に改行を挟む必要**のあるタイプの構文である.

まず, 引用ブロックを使えばかっこいいエピグラフを書き放題である.

```markdown
> Нужны новые формы. Новые формы нужны, а если их нет, то лучше ничего не нужно.
>
> 新しいフォーマットが必要なんですよ. 新しいフォーマットが. それがないというなら, いっそ何もないほうがいい. 
>
> `\r tufte::quote_footer('--- A. チェーホフ『かもめ』')`
```

> Нужны новые формы. Новые формы нужны, а если их нет, то лучше ничего не нужно.
>
> 新しいフォーマットが必要なんですよ. 新しいフォーマットが. それがないというなら, いっそ何もないほうがいい. 
>
> <footer>--- A. チェーホフ『かもめ』</footer>

`rmdja` では, HTML と PDF 両方で同様のデザインの枠で表示するようにしている.

Markdown では `#` は見出しを意味するが, `bookdown` にはさらにオプションが用意されている.

`# 見出し名 {-}` で, セクション番号のつかない見出しを用意できる. 序文, 章末の参考文献, 付録のセクションに使えるだろう. さらに, `bookdown` では `# (PART) 見出し名` で「部」の見出しを作ることができる. この見出しは セクションの合間に挟まるが, 選択することはできない. 文書が長くなったときに, より大きな区切りを付けるのに役に立つだろう. さらに, `# (APPENDIX) 見出し名 {-}` で, 以降の見出しの頭に 「補遺 A, B, C, ...」と付番できる.

箇条書きは以下のように書ける.

```markdown
* iris setosa
* iris versicolor
* iris virginica
```

* iris setosa
* iris versicolor
* iris virginica

```markdown
1. iris setosa
2. iris versicolor
3. iris virginica
```

1. iris setosa
2. iris versicolor
3. iris virginica

インデントを使えばネストできる.

* 課長
  + 課長補佐
    - 課長補佐代理
      + 課長補佐代理心得

## Markdown を使った図表の挿入

markdown は表を記入することもできる.

```markdown
Table: Markdown 記法の表

 Sepal.Length   Sepal.Width   Petal.Length   Petal.Width
-------------  ------------  -------------  ------------
          5.1           3.5            1.4           0.2
          4.9           3.0            1.4           0.2
          4.7           3.2            1.3           0.2
          4.6           3.1            1.5           0.2
          5.0           3.6            1.4           0.2
          5.4           3.9            1.7           0.4
```


Table:Markdown 記法の表

 Sepal.Length   Sepal.Width   Petal.Length   Petal.Width
-------------  ------------  -------------  ------------
          5.1           3.5            1.4           0.2
          4.9           3.0            1.4           0.2
          4.7           3.2            1.3           0.2
          4.6           3.1            1.5           0.2
          5.0           3.6            1.4           0.2
          5.4           3.9            1.7           0.4

画像ファイルも貼り付けられる.

![Johannes Gutenberg](img/Johannes_Gutenberg.jpg){ width=50% }


しかし, キャプションを付けたり, 表示位置やサイズを細かく調整したりするためには, 後述するように**Rプログラムを経由して出力**したほうが良い.

TODO: md 記法で画像貼り付けたときのサイズ統一

### コメントアウト

HTML 式の `<!-- -->` でコメントアウトできる. コメントアウトされた箇所は生成ファイルでもコメントアウトされるのではなく, そもそも出力されなくなる.

## 数式

LaTeX 記法で数式を記述できる. HTML ならば Mathjax によってレンダリングされる. 数式の記述ルールは少々ややこしい. これは現在の `pandoc` の仕様で HTML および LaTeX の規格で矛盾なく出力するためやむをえない措置である.

1. 改行をしない**行内数式**は `$` で囲む, または `\(`, `\)` で囲む.
2. 改行を伴う**数式ブロック**は `$$` で囲む, または `\[`, `\]` で囲む.
3. `align`, `equation` 環境等を使う場合は, 上記の記号を**使わず**, 直接 LaTeX コマンド `\begin{align}...` を打ち込む.

```markdown
\@ref(eq:binom) は二項分布の確率関数である
\begin{align}
f(k) &= {n \choose k} p^{k} (1-p)^{n-k} (\#eq:binom)
\end{align}
```

その出力は, 以下のようになる.

\@ref(eq:binom) は二項分布の確率関数である

\begin{align}
f(k) &= {n \choose k} p^{k} (1-p)^{n-k} (\#eq:binom)
\end{align}


Bookdown では**従来の R Markdown でできなかった数式への付番と, 本文中での参照アンカーリンクの自動作成が可能**となっている (詳細は \@ref(crossref) 章で). LaTeX にすでに慣れている読者に注意が必要だが, Bookdown 特有の制約として,  付番したい場合は `\label{ID}` ではなく `(\#eq:ID)` を使う. また,  PDF (LaTeX) と HTML (Mathjax) の仕様には

1. PDF では `align` は常に数式が付番され, `align*` 等はどうやっても付番されない
2. HTML では `align` でも `align*` であってもラベルを書かなければ付番されず, 書けば付番される.

という違いがある. 両者で同じ表示にこだわるのなら, 付番を取り消す `\notag` を多用することになるだろう.

さらに, bookdown の機能として, LaTeX の「定理」「定義」「証明」などの環境に対応するものが提供されている (参考: BKD [Ch. 2.2 Markdown extensions by bookdown](https://bookdown.org/yihui/bookdown/markdown-extensions-by-bookdown.html)). これらの相互参照も可能である.

例: 以下に補題 \@ref(lem:borelcantelli), 定理 \@ref(thm:theorem1) を示す.

\BeginKnitrBlock{lemma}\iffalse{-91-12508-12524-12523-45-12459-12531-12486-12522-12398-35036-38988-93-}\fi{}<div class="lemma"><span class="lemma" id="lem:borelcantelli"><strong>(\#lem:borelcantelli)  \iffalse (ボレル-カンテリの補題) \fi{} </strong></span>${E_1,E_2,\cdots}$をある確率空間の事象とする. これらの事象の確率の和が有限であるなら, それらが無限に多く起こる確率はゼロである. つまり,

\begin{align*}
& \sum_{n=1}^\infty \mathrm{P}(X_n) <\infty \Rightarrow \mathrm{P}\left(\lim_{n\to\infty}\sup X_n\right) = 0,\\
& \lim_{n\to\infty}\sup X_n = \bigcap_{n=1}^\infty\bigcup_{k\leq n}^\infty E_k
\end{align*}

である.</div>\EndKnitrBlock{lemma}

\BeginKnitrBlock{proof}<div class="proof">\iffalse{} <span class="proof"><em>証明. </em></span>  \fi{}証明は読者の課題とする.</div>\EndKnitrBlock{proof}


\BeginKnitrBlock{theorem}\iffalse{-91-28961-38480-12398-29503-23450-29702-93-}\fi{}<div class="theorem"><span class="theorem" id="thm:theorem1"><strong>(\#thm:theorem1)  \iffalse (無限の猿定理) \fi{} </strong></span>猿がほとんど確実にタイプライタの全てのキーを無限回叩くならば, ほとんど確実にテキストには任意の作品が含まれる.</div>\EndKnitrBlock{theorem}

\BeginKnitrBlock{proof}<div class="proof">\iffalse{} <span class="proof"><em>証明. </em></span>  \fi{}補題 \@ref(lem:borelcantelli) より自明.</div>\EndKnitrBlock{proof}

## カスタムブロック

数式のセクションの定理ブロックの応用で, 独自のブロックセクションを定義することができる. `rmdja` では BKD [Ch. 2.7 Custom blocks](https://bookdown.org/yihui/bookdown/custom-blocks.html) で紹介されている例を予め使えるようにしている. それらは `type="..."` で指定できて, 以下の5種類がある.

* `rmdcaution`
* `rmdimportant`
* `rmdnote`
* `rmdtip`
* `rmdwarning`


である.

<div class="rmdcaution">
<p>技術書によくある注意を喚起するブロック (<code>rmdcaution</code>).</p>
</div>

<div class="rmdimportant">
<p>技術書によくある注意を喚起するブロック (<code>rmdimportant</code>).</p>
</div>

<div class="rmdnote">
<p>技術書によくある注意を喚起するブロック (<code>rmdcnote</code>).</p>
</div>

<div class="rmdtip">
<p>技術書によくある注意を喚起するブロック (<code>rmdtip</code>).</p>
</div>

<div class="rmdwarning">
<p>技術書によくある注意を喚起するブロック (<code>rmdwarning</code>).</p>
</div>

このブロック内では Markdown の基本構文しか使えず, 引用や相互参照などは使えない. これらをブロック内で使いたい場合は `block` の代わりに `block2`  と書く. ただしこちらは pandoc の機能のハックであるため, 将来使えなくなる可能性もある.


## 脚注

脚注はインラインと, 巻末に書く2通りがある.

```markdown
ここにインラインで脚注^[脚注の本文]
```

ここにインラインで脚注^[脚注の本文]

```markdown
本文は巻末に書く[^example-1][^example-2].

[^example-1]: 脚注の本文その2
[^example-2]: 脚注の本文その2
```

本文は巻末に書く[^example-1][^example-2].


ここにインラインで脚注[^脚注の本文]

インラインで書くほうがシンプルに見えるが, この記法では間を空けずに連続して脚注を書くことができない.

```markdown
このように書くと^[脚注その1]^[脚注その2]上付きとして認識される
```

[^example-1]: 脚注の本文その2
[^example-2]: 脚注の本文その2


# 動的なコンテンツの作成

## プログラムチャンク

プログラムチャンクは, R Markdown 最大の特徴であり, R のソースコードや, その実行結果を Markdown に挿入できる. さらには **R 以外の言語の動作も可能**である. 順番が前後してしまったが, 定理などのカスタムブロックは本来はプログラムを入力するためのチャンクブロックであり, それを静的なテキストコンテンツの挿入に流用しているだけである.

以降は R で多くのユーザが頻繁に使うパッケージと, いくつかの技術文書作成に役に立つパッケージをインポートしている前提の説明とする. なお, `rmarkdown`, `bookdown` はチャンク内で特に読み込む必要がない.


```{.r .numberLines .lineAnchors}
pkgs <- installed.packages()
for (p in c("tidyverse", "ggthemes", "equatiomatic", "tufte", "kableExtra")) {
  if (!p %in% pkgs) install.packages(p)
}
if (!"rmarkdown" %in% pkgs) remotes::install_github("rstudio/rmarkdown")
if (!"bookdown" %in% pkgs) remotes::install_github("rstudio/bookdown")
require(tidyverse)
```

```
 要求されたパッケージ tidyverse をロード中です 
```

```
─ Attaching packages ──────────────────── tidyverse 1.3.0 ─
```

```
✓ ggplot2 3.3.2     ✓ purrr   0.3.4
✓ tibble  3.0.3     ✓ dplyr   1.0.2
✓ tidyr   1.1.2     ✓ stringr 1.4.0
✓ readr   1.3.1     ✓ forcats 0.5.0
```

```
─ Conflicts ───────────────────── tidyverse_conflicts() ─
x dplyr::filter()     masks stats::filter()
x dplyr::group_rows() masks kableExtra::group_rows()
x dplyr::lag()        masks stats::lag()
```

```{.r .numberLines .lineAnchors}
require(ggthemes)
```

```
 要求されたパッケージ ggthemes をロード中です 
```

```{.r .numberLines .lineAnchors}
require(equatiomatic)
```

```
 要求されたパッケージ equatiomatic をロード中です 
```

```{.r .numberLines .lineAnchors}
require(kableExtra)
```

このように, ログを掲載することもできる. これは再現性を重視する際に重宝するが, 一方で単に画像などの出力だけを掲載したい場合もあるだろう. あるいは, プログラムを解説するために**プログラムは掲載するが実行しない**, ということも必要になるかもしれない. **プログラムと結果の表示/非表示はどちらも簡単に切り替え可能**である. そのためには, チャンクオプションを指定する.

* `echo`: プログラムを掲載するかどうか
* `message`: プログラム実行結果の標準出力を掲載するかどうか
* `warning`: プログラム実行結果の警告を掲載するかどうか
* `error`: プログラム実行結果のエラーを掲載するかどうか
* `eval`: 文書作成時にプログラムを実行するかどうか
* `include`: 文書作成時にプログラムを実行し, **かつ掲載しない**かどうか
* `results`: 出力をいつもの R の出力風にするか (`markup`), 隠すか (`"hide"`), 出力を区切らずまとめるか (`"hold"`), テキストをそのまま出力するか (`"asis"`). 最後はソースコードを動的に生成したい場合などに使う (後述).

R の論理値は `TRUE`/`FALSE` または `T`/`F` と書く.

チャンクごとに個別に設定することも, デフォルト値を一括設定することもできる. 前者の場合, チャンクオプションは `{}` 内部にカンマ `,` で区切って書く. `r` は R で実行するという意味である.

````
```{r [<name>], [<options>]}
data(cars)
summary(cars)
```
````

一括設定の場合, 以下のようなプログラムでデフォルト値を上書きできる.


```{.r .numberLines .lineAnchors}
knitr::opts_chunk$set(
  echo = F,
  message = T,
  warnings = F,
  error = F
)
```

なおこのチャンクは `eval=F` を設定することで, 実行されることなくプログラムのみ掲載している. ただし, プログラムのみを掲載するなら, 以下のように Markdown の機能でも可能である. こちらの記法は `{}` がなくなっていることに注意する.

````
```sh
echo Hello, Bookdown
```
````

`{}` ブロック内の値にはさらに R プログラムで与えることができる. この使い方は後の章で解説する.

これらのオプションがあるおかげでプログラムとその結果の再現を説明したい場合はソースコードも表示させたり, 回帰分析やシミュレーションの結果だけを掲載したい時は結果のみ表示したりできる. これが R Markdown のチャンクの強みである. 例えば Jupyter notebook/lab などは従来, コードセルと出力セルを自由に隠すことができなかった.

チャンクに使用できる言語は R だけではない. **つまり Python なども使用できる**. 以下で対応しているエンジンの一覧を表示できる.


```{.r .numberLines .lineAnchors}
names(knitr::knit_engines$get())
```

```
 [1] "awk"         "bash"        "coffee"      "gawk"        "groovy"     
 [6] "haskell"     "lein"        "mysql"       "node"        "octave"     
[11] "perl"        "psql"        "Rscript"     "ruby"        "sas"        
[16] "scala"       "sed"         "sh"          "stata"       "zsh"        
[21] "highlight"   "Rcpp"        "tikz"        "dot"         "c"          
[26] "cc"          "fortran"     "fortran95"   "asy"         "cat"        
[31] "asis"        "stan"        "block"       "block2"      "js"         
[36] "css"         "sql"         "go"          "python"      "julia"      
[41] "sass"        "scss"        "theorem"     "lemma"       "corollary"  
[46] "proposition" "conjecture"  "definition"  "example"     "exercise"   
[51] "proof"       "remark"      "solution"   
```

また, 新たにプログラムを追加することもできる. 詳細は RDG [Ch. 2.7 Other language engines](https://bookdown.org/yihui/rmarkdown/language-engines.html) を参考に.

TODO: 他の言語のプログラムを実行する際の注意点

## プログラムで数式を生成する

プログラムチャンクは, 単にプログラムの計算結果を埋め込むだけでなく, 静的なコンテンツを臨機応変に変更して出力させたり, あるいは手作業でやるには煩雑な加工処理を挟んでから表示させるのに役に立つ.

R のプログラムと組み合わせることで**回帰分析の結果の数値をコピペすることなく数式で表示することができる**. そのためには [`equatiomatic`](https://github.com/datalorax/equatiomatic) パッケージの `extract_eq()` を使う.

まずは, 回帰係数を記号で表現するタイプ. LaTeX 数式をそのまま出力するため, チャンクオプションに `results="asis"` を付ける必要があることに注意する.


```{.r .numberLines .lineAnchors}
data(iris)
fit <- lm(Sepal.Length ~ ., data = iris)
extract_eq(fit, wrap = T, ital_vars = T, align_env = "aligned")
```

$$
\begin{aligned}
Sepal.Length &= \alpha + \beta_{1}(Sepal.Width) + \beta_{2}(Petal.Length) + \beta_{3}(Petal.Width)\ + \\
&\quad \beta_{4}(Species_{versicolor}) + \beta_{5}(Species_{virginica}) + \epsilon
\end{aligned}
$$

さらに `use_coef = T` で係数を推定結果の数値に置き換えた.


```{.r .numberLines .lineAnchors}
extract_eq(fit, wrap = T, ital_vars = T, use_coef = T, align_env = "aligned")
```

$$
\begin{aligned}
Sepal.Length &= 2.17 + 0.5(Sepal.Width) + 0.83(Petal.Length) - 0.32(Petal.Width)\ - \\
&\quad 0.72(Species_{versicolor}) - 1.02(Species_{virginica}) + \epsilon
\end{aligned}
$$

`equatiomatic` パッケージは現時点では `lm` `glm` に対応しており, `lmer` への対応も進めているようだ.

TODO: この書き方だと PDF で付番できない

## プログラムを使った図の挿入

既に Markdown 記法による図表の挿入方法を紹介したが, プログラムチャンクを介して画像を読み込み表示させることもできる. まずは, R のプログラムで既存の画像ファイルを表示させる方法.


```{.r .numberLines .lineAnchors}
knitr::include_graphics(file.path(img_dir, "Johannes_Gutenberg.jpg"))
```

<div class="figure" style="text-align: center">
<img src="img//Johannes_Gutenberg.jpg" alt="Johannes Gutenberg" width="50%" height="50%" />
<p class="caption">(\#fig:includegraphic-example)Johannes Gutenberg</p>
</div>


もちろんのこと既存の画像だけでなく, データを読み込んでヒストグラムや散布図などを描いた結果を画像として掲載することもできる.

技術文書や学術論文では, 画像の上か下に「図1: XXXXX」のような**キャプション**を付けることが多い. 紙の書籍では絵本のように本文と図の順序を厳密に守るより, 余白を作らないよう図の掲載位置を調整する必要があるからだ.

プログラムチャンクにはこのキャプションを入力するオプション `fig.cap` があるため, **`plot()` 側でタイトルを付けないほうが良い**. 例えば `ggplot2` パッケージの関数を使い以下のようなチャンクを書く[^standard-graphics].

````
```{r plot-sample, echo=T, fig.cap="`ggplot2` によるグラフ"}
data("diamonds")
diamonds <- diamonds[sample(1:NROW(diamonds), size =), ]
ggplot(diamonds, aes(x=carat, y=price, color=clarity)) +
  geom_point() +
  labs( x = "カラット数", y = "価格") + scale_color_pander(name = "クラリティ") +
  theme_classic(base_family = "Noto Sans CJK JP") + theme(legend.position = "bottom")
```
````


実際の表示は図 \@ref(fig:plot-sample) のようになる.

<div class="figure" style="text-align: center">
<img src="rmdja_files/figure-html/plot-sample-1.png" alt="`ggplot2` によるグラフ"  />
<p class="caption">(\#fig:plot-sample)`ggplot2` によるグラフ</p>
</div>

`ggplot2` 以外のパッケージや言語, たとえば `tikz` や `asymptote`, DOT言語も使用できる. これらは \@ref(advanced-graph) 章で紹介する.

## TODO: 図のレイアウト設定

PDF ならばフロート設定のため, 図が離れた位置に配置されることがある. そのため, 「図 \@ref(fig:plot-sample)」 のような相互参照を使うと良いだろう. フロートを使うかどうかは, 後のセクションで解説する TODO

Rのグラフィックデバイスを使っている限り, 通常のRのコンソールと同じコードをチャンク内に書くだけで表示できる.

R のグラフィックデバイスではないとは, RGL や `plotly` など外部ライブラリに頼ったグラフ作成ツールのことである. 判断できない人は, RStudio 上で実行して, "Plots" ペーンに表示されたら R のグラフィックデバイス, "Viewer" ペーンに表示されたらそうでない, で覚えていただきたい. 後者を表示する方法は \@ref(webapp) 章で後述する. R をこれまで使ったことがなく, それすらも何を言っているのか分からない, という場合は `ggplot2` を使ってもらう.

最後の `fig.cap=""` がキャプションである. ただし, どうも日本語キャプションを書いたあとに他のチャンクオプションを指定するとエラーになるようだ. よって **`fig.cap=` はオプションの末尾に書くべきである**. また, `fig.cap=""` に数式や一部の特殊なテキストを直接入力することができない. この問題は相互参照について解説するセクション \@ref(crossref) で詳細を述べる. 

`fig.cap` 以外のオプションはおそらく頻繁には変えないため, 冒頭でまとめて設定したほうが楽だろう.


```{.r .numberLines .lineAnchors}
knitr::opts_chunk$set(
  fig.align = "center",
  fig.width = 6.5,
  fig.height = 4.5,
  out.width = "100%",
  out.height = "100%"
)
```

なお, これらは `rmdja` でのデフォルト値であるため, 実際にこの値をあえて記述する必要はない.

ここで, `fig.width` と `out.width` の違いも述べておく. `out.width`/`out.height` は表示する画像サイズの違いで, `fig.width`/`fig.height` はプログラムが出力した画像の保存サイズである. よって `ggplot2` などを使わず画像ファイルを貼り付けるだけの場合は `fig.*` は意味をなさない.

[^standard-graphics]: なお, Rユーザーならば標準グラフィック関数である `plot()` 関数をご存知だろうが, 本稿では**標準グラフィック関数の使用を推奨しない**. 標準グラフィック関数のデバイスはもともと日本語フォントを想定しておらず, OSごとに使用できるフォントも異なるためで, 品質維持のためには使用させない方針とした. 工夫すれば標準グラフィック関数でも日本語を適切に出力できるが, `ggplot2` を使用したほうが簡単であることが多いため, 標準グラフィック関数の解説書を作る以外では使うべきでない.

## R プログラムを使った表の装飾

Markdown 記法を使った表記は既に紹介した. しかしこれは表の数値を全て手動で書かなければならない. もちろんこれも R 内のデータを手書きなどせずとも表示できるし, テーブルのデザインもある程度自由に設定できる.
 
R Markdown のデフォルトでは R のコンソールと同様にテキストとして出力されるが, bookdown では異なるデザインで表示されている. これは `knitr`, `kableExtra` パッケージなどで事後処理をかけることで見やすいデザインの表に変換しているからである.

この方法はシンプルで使いやすいが, R はテーブル状のデータ処理に長けているため, 手動で数値を書くよりも簡単な方法がある.


```{.r .numberLines .lineAnchors}
data(iris)
kable(
  head(iris, n = 10),
  caption = "`knitr::kable()` で出力された (PDFではあまりかっこよくない) 表"
)
```

<table>
<caption>(\#tab:display-dataframe-kable)`knitr::kable()` で出力された (PDFではあまりかっこよくない) 表</caption>
 <thead>
  <tr>
   <th style="text-align:right;"> Sepal.Length </th>
   <th style="text-align:right;"> Sepal.Width </th>
   <th style="text-align:right;"> Petal.Length </th>
   <th style="text-align:right;"> Petal.Width </th>
   <th style="text-align:left;"> Species </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:right;"> 5.1 </td>
   <td style="text-align:right;"> 3.5 </td>
   <td style="text-align:right;"> 1.4 </td>
   <td style="text-align:right;"> 0.2 </td>
   <td style="text-align:left;"> setosa </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 4.9 </td>
   <td style="text-align:right;"> 3.0 </td>
   <td style="text-align:right;"> 1.4 </td>
   <td style="text-align:right;"> 0.2 </td>
   <td style="text-align:left;"> setosa </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 4.7 </td>
   <td style="text-align:right;"> 3.2 </td>
   <td style="text-align:right;"> 1.3 </td>
   <td style="text-align:right;"> 0.2 </td>
   <td style="text-align:left;"> setosa </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 4.6 </td>
   <td style="text-align:right;"> 3.1 </td>
   <td style="text-align:right;"> 1.5 </td>
   <td style="text-align:right;"> 0.2 </td>
   <td style="text-align:left;"> setosa </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 5.0 </td>
   <td style="text-align:right;"> 3.6 </td>
   <td style="text-align:right;"> 1.4 </td>
   <td style="text-align:right;"> 0.2 </td>
   <td style="text-align:left;"> setosa </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 5.4 </td>
   <td style="text-align:right;"> 3.9 </td>
   <td style="text-align:right;"> 1.7 </td>
   <td style="text-align:right;"> 0.4 </td>
   <td style="text-align:left;"> setosa </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 4.6 </td>
   <td style="text-align:right;"> 3.4 </td>
   <td style="text-align:right;"> 1.4 </td>
   <td style="text-align:right;"> 0.3 </td>
   <td style="text-align:left;"> setosa </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 5.0 </td>
   <td style="text-align:right;"> 3.4 </td>
   <td style="text-align:right;"> 1.5 </td>
   <td style="text-align:right;"> 0.2 </td>
   <td style="text-align:left;"> setosa </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 4.4 </td>
   <td style="text-align:right;"> 2.9 </td>
   <td style="text-align:right;"> 1.4 </td>
   <td style="text-align:right;"> 0.2 </td>
   <td style="text-align:left;"> setosa </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 4.9 </td>
   <td style="text-align:right;"> 3.1 </td>
   <td style="text-align:right;"> 1.5 </td>
   <td style="text-align:right;"> 0.1 </td>
   <td style="text-align:left;"> setosa </td>
  </tr>
</tbody>
</table>

こちらは関数内にキャプションを書く必要があり, チャンクオプションに指定する方法はない (表\@ref(tab:display-dataframe-kable)).


```{.r .numberLines .lineAnchors}
data(iris)
kable(
  head(iris, n = 10),
  booktabs = T,
  caption = "奇数行を強調し, PDF では booktabs を利用"
) %>% row_spec(seq(1, 10, by = 2), background = "gray")
```

<table>
<caption>(\#tab:display-dataframe-kable-2)奇数行を強調し, PDF では booktabs を利用</caption>
 <thead>
  <tr>
   <th style="text-align:right;"> Sepal.Length </th>
   <th style="text-align:right;"> Sepal.Width </th>
   <th style="text-align:right;"> Petal.Length </th>
   <th style="text-align:right;"> Petal.Width </th>
   <th style="text-align:left;"> Species </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:right;background-color: gray !important;"> 5.1 </td>
   <td style="text-align:right;background-color: gray !important;"> 3.5 </td>
   <td style="text-align:right;background-color: gray !important;"> 1.4 </td>
   <td style="text-align:right;background-color: gray !important;"> 0.2 </td>
   <td style="text-align:left;background-color: gray !important;"> setosa </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 4.9 </td>
   <td style="text-align:right;"> 3.0 </td>
   <td style="text-align:right;"> 1.4 </td>
   <td style="text-align:right;"> 0.2 </td>
   <td style="text-align:left;"> setosa </td>
  </tr>
  <tr>
   <td style="text-align:right;background-color: gray !important;"> 4.7 </td>
   <td style="text-align:right;background-color: gray !important;"> 3.2 </td>
   <td style="text-align:right;background-color: gray !important;"> 1.3 </td>
   <td style="text-align:right;background-color: gray !important;"> 0.2 </td>
   <td style="text-align:left;background-color: gray !important;"> setosa </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 4.6 </td>
   <td style="text-align:right;"> 3.1 </td>
   <td style="text-align:right;"> 1.5 </td>
   <td style="text-align:right;"> 0.2 </td>
   <td style="text-align:left;"> setosa </td>
  </tr>
  <tr>
   <td style="text-align:right;background-color: gray !important;"> 5.0 </td>
   <td style="text-align:right;background-color: gray !important;"> 3.6 </td>
   <td style="text-align:right;background-color: gray !important;"> 1.4 </td>
   <td style="text-align:right;background-color: gray !important;"> 0.2 </td>
   <td style="text-align:left;background-color: gray !important;"> setosa </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 5.4 </td>
   <td style="text-align:right;"> 3.9 </td>
   <td style="text-align:right;"> 1.7 </td>
   <td style="text-align:right;"> 0.4 </td>
   <td style="text-align:left;"> setosa </td>
  </tr>
  <tr>
   <td style="text-align:right;background-color: gray !important;"> 4.6 </td>
   <td style="text-align:right;background-color: gray !important;"> 3.4 </td>
   <td style="text-align:right;background-color: gray !important;"> 1.4 </td>
   <td style="text-align:right;background-color: gray !important;"> 0.3 </td>
   <td style="text-align:left;background-color: gray !important;"> setosa </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 5.0 </td>
   <td style="text-align:right;"> 3.4 </td>
   <td style="text-align:right;"> 1.5 </td>
   <td style="text-align:right;"> 0.2 </td>
   <td style="text-align:left;"> setosa </td>
  </tr>
  <tr>
   <td style="text-align:right;background-color: gray !important;"> 4.4 </td>
   <td style="text-align:right;background-color: gray !important;"> 2.9 </td>
   <td style="text-align:right;background-color: gray !important;"> 1.4 </td>
   <td style="text-align:right;background-color: gray !important;"> 0.2 </td>
   <td style="text-align:left;background-color: gray !important;"> setosa </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 4.9 </td>
   <td style="text-align:right;"> 3.1 </td>
   <td style="text-align:right;"> 1.5 </td>
   <td style="text-align:right;"> 0.1 </td>
   <td style="text-align:left;"> setosa </td>
  </tr>
</tbody>
</table>

さらに, RCB の [Ch. 10.1 The function `knitr::kable()`](https://bookdown.org/yihui/rmarkdown-cookbook/kable.html) ではその他いろいろな書式設定を紹介している.

# 相互参照と引用

## 相互参照 {#crossref}

### 図表や式へのアンカーリンク

図, 表, 式などに番号を自動で割り当て, さらにハイパーリンクを付加できる. `\@ref(ID)` を使う. 現状では `refstyle` や `prettyref` のように接頭語を自動で付けてくれないが, そのうちなんとかなるかもしれない.

bookdown の相互参照は, LaTeX の `prettyref.sty` のように, `接頭語:参照ID` という記法になる. 参照IDは通常, チャンクIDと同じである. 既に紹介したように, 数式参照の接頭語は `eq` で, 定理は `thm` である. 図表は `fig`, `tab`. その他の接頭語は BKD [Ch. 2.2 Markdown extensions by bookdown](https://bookdown.org/yihui/bookdown/markdown-extensions-by-bookdown.html#equations) を参考に.

### 表への相互参照

Markdown 記法で表を書く場合, 以下のように `Table: ` の直後にラベルを記入する (表 \@ref(tab:tab-md)).

```markdown
Table: (\#tab:tab-md) Markdown 記法の表

 Sepal.Length   Sepal.Width   Petal.Length   Petal.Width
-------------  ------------  -------------  ------------
          5.1           3.5            1.4           0.2
          4.9           3.0            1.4           0.2
          4.7           3.2            1.3           0.2
          4.6           3.1            1.5           0.2
          5.0           3.6            1.4           0.2
          5.4           3.9            1.7           0.4
```


Table: (\#tab:tab-md) Markdown 記法の表

 Sepal.Length   Sepal.Width   Petal.Length   Petal.Width
-------------  ------------  -------------  ------------
          5.1           3.5            1.4           0.2
          4.9           3.0            1.4           0.2
          4.7           3.2            1.3           0.2
          4.6           3.1            1.5           0.2
          5.0           3.6            1.4           0.2
          5.4           3.9            1.7           0.4

### 章への相互参照

章見出しへの相互参照も可能である. これはPandocの機能を利用しているため, 接頭辞は不要である. Pandocの仕様により欧文であればタイトルがそのまま参照IDとなるが, 非欧文の文字に対して適用されないため, 参照したい章の見出しにの後にスペースを入れて `{#参照ID}` と書く必要がある.

### 特殊な相互参照

チャンクオプションの `fig.cap` などに TeX 数式を書いても正しく表示できない. そのような場合は `ref` 参照を使う. `(ref:figcap1) \coloremoji{🌸} $\sum \oint \mathfrak{A} \mathscr{B} \mathbb{C}$ \coloremoji{🌸}` と書くと, 図 \@ref(fig:caption) のキャプションにも特殊な記号が使える.

(ref:figcap1) \coloremoji{🌸} $\sum \oint \mathfrak{A} \mathscr{B} \mathbb{C}$ \coloremoji{🌸}

なお, 複数指定する場合は連続させず, 改行で1行空けて宣言する必要がある.


<div class="figure" style="text-align: center">
<img src="rmdja_files/figure-html/caption-1.png" alt="🌸(ref:figcap1)🌸" width="30%" />
<p class="caption">(\#fig:caption)🌸(ref:figcap1)🌸</p>
</div>

この参照は**一度しか使えない**.
 
PDF での表示では, 図 \@ref(fig:caption) のキャプションの外側が文字化けしていることだろう. これは絵文字出力に関する問題で, 別のセクションで解説する.

これはかなり強力で,

1. 定義される前の行にも適用される
2. チャンクオプションだけでなく出力結果にも適用される

という仕様である.

TODO: 自己言及的な文章は書かないならこれくらいの認識でいいだろうが, より正確な話はどうするか

## 文献引用 {#bibliography}

YAMLフロントマターの `biblography:` に文献管理ファイル (`.bib`, `.json` 等) を指定することで, ファイルに含まれる文献への参照が可能になる. `@引用ID` で本文に引用を与えられ, 文書に引用した文献の一覧が自動で生成される. また, `citr` パッケージにより, RStudio Addins に文献に対応する引用IDを取り出して挿入する機能が追加される. 

(ref:citr-caption) `citr` パッケージの例


```{.r .numberLines .lineAnchors}
knitr::include_graphics(file.path(img_dir, "citr.png"))
```

<div class="figure" style="text-align: center">
<img src="img//citr.png" alt="(ref:citr-caption)" width="622" height="70%" />
<p class="caption">(\#fig:citr-image)(ref:citr-caption)</p>
</div>


一方で, この記述がどう反映されるかは文献引用を処理するプログラムによって変化する. さらに厄介なことに, それぞれ全く違うプログラムであるがゆえに, 設定に書き方も変わってくる.


R Markdown の文献引用は pandoc を経由して処理され, pandoc は現時点では `pandoc-citeproc`. `bibtex`, `biblatex` の選択をサポートしている. `pandoc-citeproc` 以外はもともと `\LaTeX`{=latex}`LaTeX`{=html} 用に作られたため, HTML では常に `pandoc-citeproc` で処理される. これはフォーマット引数の `citation_package` で指定できる.

* `default`: `pandoc-citeproc` を使用する
* `biblatex`: biblatex を使用する
* `natbib`: `\BibTeX`{=latex}`BibTeX`{=html} を使用し, 本文中の参照には `natbib.sty` を使う. ただし本来の `natbib` の引用子オプションは使えない
  + `natbiboptions:` で `number`, `authoryear` などの `natbib.sty` のオプションを指定できる.


### 文献引用のフォーマット設定

これがややこしい. まず, `pandoc-citeproc`, `bibtex`, `biblatex` はそれぞれ引用文献リストの書式を記述するフォーマットがありそれぞれ拡張子は `.csl`, `.bst`, `.bbx`, である. 前者は MS Word のスタイルと同じもので, XMLで記述されている[^CSL-editor]. 一方で `.bst` は逆ポーランド記法の構文だったりかなりアレである. そして  `biblatex` はこのような専用の書式ファイルを使わず, 細かい書式設定はすべて `\LaTeX`{=latex}`LaTeX`{=html} のマクロで調整する想定で作られている. また, スタイルファイルを用意しなくとも指定できるスタイルがいくつか存在する.

bibtex および biblatex に関する設定は biblio-style だが, CSLファイルの設定は `csl` を使う.

さらに日本語文献引用が必要な場合の特有の事情として, (1)対応文字コードの問題 (2) 和文と欧文のスタイルが異なるという問題がある. まず前者について, `bibtex` は日本語など非ASCII文字に対応していない. よって従来 `\pBibTeX`{=latex}`pBibTeX`{=html} または `\JBibTeX`{=latex}`JBibTeX`{=html} が使用されていた. しかしこれもJIS規格の範囲までしか対応していないため, 一部の珍しい人名漢字などの表示ができなかった[^pbibtex-unicode]. そのためさらに `\upBibTeX`{=latex}`upBibTeX`{=html} というUnicode対応版プログラムが作成されている. しかし R Markdown (および pandoc) はそのような日本語特有の事情などしらないため, これらを使用することができない. よって**オプション選択の範囲では, `biblatex` か `pandoc-citeproc` でしか日本語文献を表示できない**. これはR Markdownで日本語技術文書を作る際の特にアレな障害の1つである.

[^pbibtex-unicode]: `\pBibTeX`{=latex}`pBibTeX`{=html} のUNICODEモードは内部でSJISに変換しているだけなので, 全てのUnicodeに対応しているわけではない.

<table>
<caption>(\#tab:biblio-comparison)引用プログラムごとの違い</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> item </th>
   <th style="text-align:left;"> HTML対応 </th>
   <th style="text-align:left;"> PDF対応 </th>
   <th style="text-align:left;"> 日本語表示 </th>
   <th style="text-align:left;"> 指定名 </th>
   <th style="text-align:left;"> 文献ファイル </th>
   <th style="text-align:left;"> 文献スタイル </th>
   <th style="text-align:left;"> スタイル指定方法 </th>
   <th style="text-align:left;"> スタイルのオプション </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> `pandoc-citeproc` (default) </td>
   <td style="text-align:left;"> TRUE </td>
   <td style="text-align:left;"> TRUE </td>
   <td style="text-align:left;"> TRUE </td>
   <td style="text-align:left;"> default </td>
   <td style="text-align:left;"> .json </td>
   <td style="text-align:left;"> .csl </td>
   <td style="text-align:left;"> csl: </td>
   <td style="text-align:left;">  </td>
  </tr>
  <tr>
   <td style="text-align:left;"> `biblatex` </td>
   <td style="text-align:left;"> FALSE </td>
   <td style="text-align:left;"> TRUE </td>
   <td style="text-align:left;"> TRUE </td>
   <td style="text-align:left;"> biblatex </td>
   <td style="text-align:left;"> .bib/.bibtex </td>
   <td style="text-align:left;"> なし </td>
   <td style="text-align:left;"> biblio-style: </td>
   <td style="text-align:left;">  </td>
  </tr>
  <tr>
   <td style="text-align:left;"> `bibtex` </td>
   <td style="text-align:left;"> FALSE </td>
   <td style="text-align:left;"> TRUE </td>
   <td style="text-align:left;"> FALSE </td>
   <td style="text-align:left;"> natbib </td>
   <td style="text-align:left;"> .bib </td>
   <td style="text-align:left;"> .bst </td>
   <td style="text-align:left;"> biblio-style </td>
   <td style="text-align:left;"> natbiboptions </td>
  </tr>
</tbody>
</table>



### (TODO) `pandoc-citeproc` と CSL

### (WIP) BibLaTeX

BibLaTeX の全てのオプションに対応しているわけではないので詳しいことは [BibLaTeX のドキュメント](https://www.ctan.org/pkg/biblatex)を読んでいただきたい. 残念ながら, 日本語の情報は非常に乏しい. ここではよく使う `style` のことだけ言及する.

フロントマターの `biblio-style:` で指定できるのは, インクルード時の `style=` に指定できるものに対応する(表 \@ref(tab:biblatex-styles)). つまり, 引用文献の見出しをどうするかである. これは引用リストと本文中の引用子のスタイル両方に影響する.

<table>
<caption>(\#tab:biblatex-styles)biblatex の `bilio-style` で指定できるもの一覧</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> 名称 </th>
   <th style="text-align:left;"> 概要 </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> `numeric` </td>
   <td style="text-align:left;"> '[1]' のような番号 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> `alphabetic` </td>
   <td style="text-align:left;"> 著者名の略称+出版年2桁 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> `authoryear` </td>
   <td style="text-align:left;"> 著者-出版年形式, natbib の標準と同じ </td>
  </tr>
  <tr>
   <td style="text-align:left;"> `authortitle` </td>
   <td style="text-align:left;"> 著者名のみ, リストでは出版年は後置され, 引用子では脚注になる </td>
  </tr>
  <tr>
   <td style="text-align:left;"> `verbose` </td>
   <td style="text-align:left;"> authortitle と同じだが, 引用子にリスト同様の内容を出力する </td>
  </tr>
  <tr>
   <td style="text-align:left;"> `reading` </td>
   <td style="text-align:left;"> 個人的なリーディングリスト向け. ファイルやメモ欄も出力する </td>
  </tr>
  <tr>
   <td style="text-align:left;"> `draft` </td>
   <td style="text-align:left;"> .bib ファイルのIDで表示. 名前通り下書き </td>
  </tr>
  <tr>
   <td style="text-align:left;"> `debug` </td>
   <td style="text-align:left;"> `.bib` の全フィールドを表示 </td>
  </tr>
</tbody>
</table>

その他 `apa`, `ieee` など特定の学会が使用するスタイルも用意されているが, これらは基本欧文しか想定していないし, アカデミックの事情に詳しい人しかこれらの使用にこだわらないだろうから詳しくは解説しない. これらを含めたそれぞれの出力例は https://www.overleaf.com/learn/latex/biblatex_bibliography_styles に一覧があるのでそちらを参考に.

なお, もちろん引用リストのスタイルと引用子のスタイルを個別にすることはできるが, R Markdown および Pandoc にそのオプションを通す機能はない. (bibstyle/citestyleで分けられる,bbx/cbx)

現時点では各分野の学会で日本語文献に対応した BibLaTeX フォーマットを配布しているという情報は見つけられなかった.  参考として私のブログで対応のヒントについて書いた[^biblatex-note].

[^biblatex-note]: https://ill-identified.hatenablog.com/entry/2020/09/20/231335

TODO: その他の非ラテン文字, キリル文字, アラビア文字 ヘブライ文字等は?

TODO: upBibTeX や `bibtex` で動作しない `.bst` ファイルの扱い.

なお, 普段文献管理ソフトを使っていないが, 数本程度の文献を引用リストに載せたい利用者は, `biblatex` の構文を利用して書くのがよいかもしれない. 例えばここに書いてあるように. その場合, デフォルトでは本文の引用は [1], [2] のような番号形式となる. `biblio-style: authoryear` とすることで, `natbib` のような 「著者 (出版年)」 スタイルとなる.

https://teastat.blogspot.com/2019/01/bookdown.html

[^CSL-editor]: 簡単なカスタマイズなら CSL editor というWebサービスでできる. しかしあくまでXMLなので, あまり複雑な処理はできないことに注意する.

# (WIP) 簡単なレイアウト変更

## HTML

### フォント変更

HTML は文字通りHTMLで出力しているため, CSS の使い方次第でいくらでもデザインを変えることができる.

## PDF

### フォント変更

PDF を生成する場合, ver 0.3 時点ではデフォルトのフォントを OS に応じて変えている. もし変更したい場合はYAMLフロントマターの以下の項目を変更する

* `mainfont`: 欧文セリフフォント
* `sansfont`: 欧文サンセリフフォント
* `monofont`: 等幅フォント (コードの表示などに使用)
* `jfontpreset`: 和文フォントのプリセット
* `jmainfont`: 和文メインフォント (一般に明朝体を指定)
* `jsansfont`: 和文セリフフォント (一般にゴシック体を指定)
* `jmonofont`: 和文等幅フォント (コードの表示などに使用)

`jfontpreset` は `zxjafont` または `luatex-ja` によるプリセットで, 3種類のフォントを一括指定できる. 個別指定したフォントはこれを上書きする. 特にこだわりがないなら一括指定で良いが, ソースコードを多く掲載する場合は `M+` や `Ricty` などのフォントを用意すると良いだろう.

さらに, それぞれの項目には `options` と接尾辞のついた項目が用意されている. フォントの相対サイズが合わず不格好な場合は

```yaml
mainfont: Palatinno
mainfontoptions:
  - Scale=0.9
```

などと書いて調整できる.

インラインのフォント変更は TODO

# (WIP) `rmdja` による文書作成支援機能

### クリエイティブ・コモンズの表記

Web公開する文書ならばクリエイティブ・コモンズの表記をつけたいところだ. 公式サイトで毎回発行するのは面倒なので表示する関数を用意にした. ハイパーリンクも付けるようにしている. チャンクでは `results="asis"` オプションが必要になる. また, 通常は `echo=F` を設定すべきだろう. 冒頭の表記もこれで作成している. もちろんそれぞれの媒体に対応している. 

文言の生成は未対応

### ルビ表記

ルビはおそらくCJK言語など一部の言語でしか使われていない (アラビア語とかヘブライ語とかの補助記号は詳しく知らないが多分グリフとしてサポートされてるっぽいので無視) ため, ルビ表記も R Markdown ではサポートされていない. そこで簡単にルビを表示できる関数 `rmdja::ruby()` を用意した. インライン実行で使う. PDF での配置は `pxrubrica.sty` を利用したグループルビである. よって, 1字ごとに配置 (モノルビ) にしたいとか, 突出指定とか, 細かいことはHTMLタグやCSSやLaTeXコマンドを自分で書く. 妥協案として, 1字ごとに呼び出す手もある.

グループルビの例: とある科学の`<ruby>超電磁砲<rp>(</rp><rt>レールガン</rt><rp>)</rp></ruby>`{=html}, `<ruby>皇帝<rp>(</rp><rt>カイザー</rt><rp>)</rp></ruby>`{=html}ラインハルト, `<ruby>柊館<rp>(</rp><rt>シュテッヒパルムシュロス</rt><rp>)</rp></ruby>`{=html}, `<ruby>黒色槍騎兵<rp>(</rp><rt>シュワルツ・ランツェンレイター</rt><rp>)</rp></ruby>`{=html}, `<ruby>喜連瓜破<rp>(</rp><rt>きれうりわり</rt><rp>)</rp></ruby>`{=html},  , `<ruby>MEXICO<rp>(</rp><rt>メキシコ</rt><rp>)</rp></ruby>`{=html}

分割して出力した例: `<ruby>喜<rp>(</rp><rt>き</rt><rp>)</rp></ruby>`{=html}`<ruby>連<rp>(</rp><rt>れ</rt><rp>)</rp></ruby>`{=html}`<ruby>瓜<rp>(</rp><rt>うり</rt><rp>)</rp></ruby>`{=html}`<ruby>破<rp>(</rp><rt>わり</rt><rp>)</rp></ruby>`{=html}, `<ruby>黒色<rp>(</rp><rt>シュワルツ</rt><rp>)</rp></ruby>`{=html}`<ruby>槍騎兵<rp>(</rp><rt>ランツェンレイター</rt><rp>)</rp></ruby>`{=html} ,

TODO: それ以外にも便利機能を少しづつ増やしていく予定

<!--chapter:end:chapters/elemental.Rmd-->

# (PART) 応用編 {-}

# このパートについて {-}

このパートでは, ここまでで紹介した基本機能の応用で,  さまざまな R パッケージやその他の外部プログラムの出力を埋め込む方法を紹介する

# 様々なグラフィックプログラムの埋め込み {#advanced-graph}

## `tikz` を使う

`\LaTeX`{=latex}`LaTeX`{=html} で使われる `tikzdevice` を利用して, 直接  `tikz` の記述による画像を埋め込むことができる. チャンクのエンジンを `tikz` とすることで使用でき, 相互参照やキャプション, 画像サイズの指定といったチャンクオプションも使える. 図 \@ref(fig:tikz-venn) は `tikz` で生成した図である. これはHTMLでも表示できる. TODO: しかし現状ではpdflatex以外のエンジンに変更できないため, 日本語表示が難しい.

<div class="figure" style="text-align: center">
<img src="rmdja_files/figure-html/tikz-venn-1.png" alt="tikzを利用した図の表示"  />
<p class="caption">(\#fig:tikz-venn)tikzを利用した図の表示</p>
</div>

## Asymptote を使う

同様に, Asymptote のプログラムを埋め込むこともできる. 私は Asymptote が分からないので RCB [Ch. 15.9 Create graphics with Asymptote](https://bookdown.org/yihui/rmarkdown-cookbook/eng-asy.html) と同様のプログラムを書いておく. (図 \@ref(fig:asymptote-graph)).

<div class="figure" style="text-align: center">
<img src="rmdja_files/figure-html/asymptote-graph-1.png" alt="Asymptote による画像" height="50%" />
<p class="caption">(\#fig:asymptote-graph)Asymptote による画像</p>
</div>

## (TODO) その他のプログラム

D3.js なども使える

## (TODO) その他の R プログラム

なお, DOT言語は `DiagrammeR` パッケージを経由して使うこともできる[^rcb-diagrammer](図: \@ref(fig:diagrammer-graph)). グラフィカルモデルの記述などはこちらのほうが簡単かもしれない.

(ref:diagrammer-cap) `DiagrammeR` によるグラフィカルモデル (RCB, Ch. 4.15 より)


```{.r .numberLines .lineAnchors}
DiagrammeR::grViz("digraph {
  graph [layout = dot, rankdir = TB]
  
  node [shape = rectangle]        
  rec1 [label = 'Step 1. 起床する']
  rec2 [label = 'Step 2. コードを書く']
  rec3 [label =  'Step 3. ???']
  rec4 [label = 'Step 4. 給料をもらう']
  
  # edge definitions with the node IDs
  rec1 -> rec2 -> rec3 -> rec4
  }",
  height = 500
)
```

<div class="figure" style="text-align: center">
<!--html_preserve--><div id="htmlwidget-126443040a9c324c98aa" style="width:672px;height:500px;" class="grViz html-widget"></div>
<script type="application/json" data-for="htmlwidget-126443040a9c324c98aa">{"x":{"diagram":"digraph {\n  graph [layout = dot, rankdir = TB]\n  \n  node [shape = rectangle]        \n  rec1 [label = \"Step 1. 起床する\"]\n  rec2 [label = \"Step 2. コードを書く\"]\n  rec3 [label =  \"Step 3. ???\"]\n  rec4 [label = \"Step 4. 給料をもらう\"]\n  \n  # edge definitions with the node IDs\n  rec1 -> rec2 -> rec3 -> rec4\n  }","config":{"engine":"dot","options":null}},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->
<p class="caption">(\#fig:diagrammer-graph)(ref:diagrammer-cap)</p>
</div>

[^rcb-diagrammer]: https://bookdown.org/yihui/rmarkdown-cookbook/diagrams.html


# 表のデザイン

## TeX/HTML を出力する関数

`stargazer` や `xtable` のように, HTML や `\LaTeX`{=latex}`LaTeX`{=html} 形式で表を出力してくれるパッケージがある. これらは `results='asis'` のチャンクオプションを指定することで関数の出力するテキストをそのまま埋め込むことができる. よって, あとは HTMLか`\LaTeX`{=latex}`LaTeX`{=html} かといった出力形式の違いに気をつければ表示できる.

(ref:stargazer-title) `stargazer` による表の出力


```{.r .numberLines .lineAnchors}
require(stargazer)
```

```
 要求されたパッケージ stargazer をロード中です 
```

```

Please cite as: 
```

```
 Hlavac, Marek (2018). stargazer: Well-Formatted Regression and Summary Statistics Tables.
```

```
 R package version 5.2.2. https://CRAN.R-project.org/package=stargazer 
```

```{.r .numberLines .lineAnchors}
stargazer(mtcars, type = if (knitr::is_latex_output()) "latex" else "html", header = F)
```


<table style="text-align:center"><tr><td colspan="8" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left">Statistic</td><td>N</td><td>Mean</td><td>St. Dev.</td><td>Min</td><td>Pctl(25)</td><td>Pctl(75)</td><td>Max</td></tr>
<tr><td colspan="8" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left">mpg</td><td>32</td><td>20.091</td><td>6.027</td><td>10</td><td>15.4</td><td>22.8</td><td>34</td></tr>
<tr><td style="text-align:left">cyl</td><td>32</td><td>6.188</td><td>1.786</td><td>4</td><td>4</td><td>8</td><td>8</td></tr>
<tr><td style="text-align:left">disp</td><td>32</td><td>230.722</td><td>123.939</td><td>71</td><td>120.8</td><td>326</td><td>472</td></tr>
<tr><td style="text-align:left">hp</td><td>32</td><td>146.688</td><td>68.563</td><td>52</td><td>96.5</td><td>180</td><td>335</td></tr>
<tr><td style="text-align:left">drat</td><td>32</td><td>3.597</td><td>0.535</td><td>2.760</td><td>3.080</td><td>3.920</td><td>4.930</td></tr>
<tr><td style="text-align:left">wt</td><td>32</td><td>3.217</td><td>0.978</td><td>1.513</td><td>2.581</td><td>3.610</td><td>5.424</td></tr>
<tr><td style="text-align:left">qsec</td><td>32</td><td>17.849</td><td>1.787</td><td>14.500</td><td>16.892</td><td>18.900</td><td>22.900</td></tr>
<tr><td style="text-align:left">vs</td><td>32</td><td>0.438</td><td>0.504</td><td>0</td><td>0</td><td>1</td><td>1</td></tr>
<tr><td style="text-align:left">am</td><td>32</td><td>0.406</td><td>0.499</td><td>0</td><td>0</td><td>1</td><td>1</td></tr>
<tr><td style="text-align:left">gear</td><td>32</td><td>3.688</td><td>0.738</td><td>3</td><td>3</td><td>4</td><td>5</td></tr>
<tr><td style="text-align:left">carb</td><td>32</td><td>2.812</td><td>1.615</td><td>1</td><td>2</td><td>4</td><td>8</td></tr>
<tr><td colspan="8" style="border-bottom: 1px solid black"></td></tr></table>

##  (TODO) `gt` パッケージの対応

TODO


# 文献引用 

## `(u)p\BibTeX`{=latex}`(u)pBibTeX`{=html} を使う

日本語対応 `.bst` ファイルを使いたい場合は少しトリッキーな操作が必要になる. `rmarkdown` は `tinytex` というパッケージでインストールされたスタンドアローンな処理系で PDF を生成している. 冒頭のチャンクで `options(tinytex.latexmk.emulation = F)` を指定することで, 自分のマシンにインストールされている普段使っている処理系に処理させることができる. さらに `rmdja` では `natbib` を指定した場合に自動でカレントディレクトリに `.latexmkrc` をコピーするようにしている. しかしログが残らないなどデバッグしづらいところがあるため, このやり方はやや使いづらい.

# (TODO) Web アプレットの挿入 {#webapp}

### TODO: plotly

### TODO: shiny

# Python スクリプトの埋め込み {#python}

Python スクリプトを埋め込むこともできる. 方法は2通りあり, 都度システムコマンドから呼び出す方法と, `reticulate` パッケージを使うものがある. `reticulate` 登場以前はチャンクごとに呼び出していたため複数のチャンクに分割して記述するのが難しかったが, 現在は `reticulate` パッケージを利用することでRと同じような感覚で, あるいは Jupyter のコードセルと同じような感覚で書ける.

`pyenv` を使用する場合, 共有ライブラリのインストールが必要なことに注意[^pyenv-lib].

[^pyenv-lib]: 詳しくはこちらを参考に https://ill-identified.hatenablog.com/entry/2019/11/15/010746

初めて使う場合は先に `reticulate` 単体でPythonが実行できるか検証してからの方が良い.


```{.r .numberLines .lineAnchors}
require(reticulate)
# Python エンジンを認識しているか確認
py_discover_config()
repl_python()

# 以下, Python コマンド実行, `exit` で抜ける
```

現在 (`knitr` 1.18以降) は R Markdown はデフォルトで `reticulate` を使う. システムコマンド経由にしたい場合はチャンクオプション `python.reticulate=F` を設定する, あるいは `reticulate::eng_python` に変わるエンジンを自作する[^reticulate-knitr].

[^reticulate-knitr]: 参考: https://rstudio.github.io/reticulate/articles/r_markdown.html

あとはチャンクのエンジンに `r` ではなく `python` を指定することでPythonコードを埋め込める.

`matplotlib` エンジンで描いたグラフに日本語フォントを埋め込む場合, `matplotlib-japreset` を使えば必要な設定を一括で行う.

<div class="rmdwarning">
<p><code>matplotlib-japreset</code> は現在, Linux 以外での動作保証をしていない</p>
</div>

```sh
pip install -U git+https://github.com/Gedevan-Aleksizde/matplotlib-japreset.git@master
```


```{.python .numberLines .lineAnchors}
from matplotlib_japreset import mplj_cairo
```

```
Noto Sans CJK JP not found
matplotlib-japreset Cairo mode
font: Noto Sans CJK JP
```

```{.python .numberLines .lineAnchors}
from matplotlib import rcParams
from plotnine import *
from plotnine.data import mtcars
rcParams['font.family']
```

```
['Noto Sans CJK JP']
```

`matplotlib-japreset` によって主要OSで標準インストールされている日本語フォントが自動的に選ばれる. 気に入らない場合は `rcParams['font.family']` に好きなフォント名を上書きする.

(ref:py-plotnine-cap) Python の `plotnine` によるグラフ表示例


```{.python .numberLines .lineAnchors}
ggplot(mtcars, aes('wt', 'mpg', color='factor(gear)')
) + geom_point() + stat_smooth(method='lm') + facet_wrap('~gear')
```

<div class="figure" style="text-align: center">
<img src="rmdja_files/figure-html/py-plotnine-cap-1.png" alt="(ref:py-plotnine-cap)" width="614" />
<p class="caption">(\#fig:py-plotnine-cap)(ref:py-plotnine-cap)</p>
</div>

現状ではmatplotlibの標準出力や警告も表示されてしまうため, チャンクオプション `results='hide', warning=F, message=F` で隠すと良い.

`plotly`, `bokeh` などの `matplotlib` に依存しないモジュールはPDFには対応していないため直接表示できない. 一旦画像を保存して, あらためて画像ファイルを埋め込む必要がある.

<!--chapter:end:chapters/advanced.Rmd-->

# (PART) 製本と多様な形式への対応 {-}

# プレゼンテーション資料の作成

`beamer_presentation_ja` は `rmdja` の最初期からあったフォーマットで, そもそも当初はこれを作るのが目的だった. このフォーマットは Beamer を使用してプレゼンテーション用スライドをPDFファイルで作成する. Beamer は `rmdja::texlogo("LaTeX")` の文書クラスの1つで, `rmarkdown::beamer_presentation` はこれを利用しているが, 例によって日本語表示は想定されていないため, そのためのもろもろの調整込みのラッパーフォーマットである. ただしスライド資料なので組版の禁則処理のような細かい調整は用意していない. `rmdja`ではスライドはPDF以外の出力は不可能である[^slide-html].

通常の文書と違い, デザインを決めるのは主に `theme` である. デフォルトでは [`metropolis`](https://github.com/matze/mtheme)[^metropolis-warn] である. 日本語表示のために調整してあるものの, 日本語表示と直接関係ない部分はカスタマイズの余地としていじっていないが, テンプレートには私の好みが反映された調整 (プログレスバーの位置調整) がYAMLフロントマターに直接書き込まれている.

また, 日本語表示と直接関係ないアレンジとして, 文献引用を行った場合の参考文献リストの表示が

1. 「参考文献」というセクションタイトルのみのスライドが冒頭に自動で挿入される
2. 引用された文献の数に応じてフレームが自動分割される
3. これらの参考文献フレームでは上部のタイトルが表示されない
4. 文字サイズが脚注サイズに縮小

という設定になっている. 通常のプレゼンテーションでは大量の参考文献を読み上げることは少ないという想定で, 紙面の限られたスライドに参考文献のみ羅列したスライドでページ数が増えないように考慮したためこうした.

実際の表示例は `examples` にある.

[^slide-html]: HTML形式のスライドはサポート対象外である. 日本語文書特有の処理はあまりないということ, 普段と違う環境で表示することの多いであろうスライド資料はなるべく環境に依存しない方法で表示すべきと考えているのが理由である. HTMLでスライドを作成したい場合, 次のページが参考になる: https://kazutan.github.io/SappoRoR6/rmd_slide.html#/ 
[^metropolis-warn]: なお `metropolis` テーマ開発者は Fira Sans フォントの使用を想定しており, ビルド時にフォントがないという警告が出ることがあるが無視して良い. (参考: https://github.com/matze/mtheme/issues/280)

# PDF の文書クラス

HTMLは利用者側が見え方をある程度カスタマイズできる. かつて存在した Evernote Clearly やカスタム CSS を使って. そのぶんPDFは作成者側がよりレイアウトに注意を払うことになるだろう. 本稿では文章の区切りを章立てにしている. しかし PDF 数十ページしかない文書を大きな文字サイズの見出しで区切るのは少しものものしい感じがする. YAML フロントマターを変更すれば, トップレベルの見出しを変更できる.

`pdf book in Japanese` は "book" ということで書籍の組版をデフォルト設定にしている. もう少し小規模な文書ならば, **レポート**や**論文記事**形式のほうが良いかもしれない. 例えば, 以下のように指定する.

```yaml
documentclass: bxjsreport
```

`documentclass` には LaTeX の文書クラスファイル (`.cls`) ならなんでも与えることができるが, \XeLaTeX または \LuaLaTeX で日本語文書を作成することを想定しているため, 以下2種類の BXjscls の文書クラス[^bxjscls]の中から選ぶとよい. デフォルトは `bxjsbook` なので, これは明示的に指定する必要はない.

* `bxjsbook`
* `bxjsreport`

このうち, `bxjsbook` が `pdf book in Japanese` のデフォルト設定となっている. `rmdja::texlogo("LaTeX")` の文書クラスは, 行間や見出しのレイアウトなどを日本語文書に準じたものにするが, それ以外の細かい調整は `_output.yml` や `_bookdown.yml` の設定を書き換えて調整する. それでも不十分な場合は, .tex ファイルやpandocテンプレートを直接編集したり, 追加のスタイルファイルを読み込んだりするしかない.


[^bxjscls]: 詳細はここにあるドキュメント参照: https://www.ctan.org/pkg/bxjscls 但し, スライド用クラスである `bxjsslide` の使用は想定していない. また, `bxjsarticle` を使う場合は後述の `pdf article in Japanese` テンプレートから作成したほうがよい. さらに `rmdja::texlogo("LuaLaTeX")` を使用するならば `luatex-ja` で提供される日本語文書クラスも指定することができるが, あまりつかったことがないためレイアウトに不備があるかもしれない.

# (WIP) 卒業論文の作成

卒業論文...というか学術論文での体裁でPDFファイルを作成することも可能である. `pdf article in Japanese` として論文形式のPDFファイルを用意している --- HTML 形式で論文提出を要求するという話は聞いたことがないのでPDFのみ対応している.

書籍形式との違いは,

* 文書の見出しが 「X章」ではなく「1. YYYY」のようになる (したがって, `Rmd` ファイルで `#` で記述した見出しは, PDFではセクションタイトルとなる)
* 余白が見開きを想定したものでなくなる

など些細である. 実際のところ, 文書テンプレートの設定を少しいじっている程度のことしかしていない. テンプレートを開いて確認すればわかるように,

```yaml
output:
  rmdja::pdf_book_ja:
    toc: false
    pandoc_args:
      - '--top-level-division=section'
documentclass: bxjsarticle
```

という設定を追加しているだけである[^ltjsarticle].

大学によっては論文の体裁が細かく指定されている場合もあるかもしれない. 例えば1ページあたりの行数や, 1行あたりの文字数とか. 例えば1ページあたり50行, 1行あたり40字とする場合, 以下のような設定を追加する. ただし, 行数は図表の挿入などで変動するし, プロポーショナルフォントや字幅の異なる欧文を多用すれば1行あたりの文字数は多くなりうる.

```yaml
classoptions:
  - 'number-of-lines=50'
  - 'textwidth=40zw'
```

さらに, カラー印刷が許容されない場合もある. `ggplot2` は `scale_*_grey()` などでカラーパレットを簡単に変更できる (図 \@ref(fig:plot-grey-scale)).


```{.r .numberLines .lineAnchors}
ggplot(
  mutate(mtcars, cyl = factor(cyl)),
  aes(x = mpg, y = wt, color = cyl)
) +
  geom_point() +
  labs(x = "マイル毎米ガロン", y = "重量 (1000ポンド)") +
  theme_bw() +
  scale_color_grey() +
  scale_fill_grey()
```

<div class="figure" style="text-align: center">
<img src="rmdja_files/figure-html/plot-grey-scale-1.png" alt="グレースケールでのプロット"  />
<p class="caption">(\#fig:plot-grey-scale)グレースケールでのプロット</p>
</div>

[^ltjsarticle]: このテンプレートでは論文形式のフォーマットとして `bxjsarticle` を使用している. `\LuaLaTeX`{=latex}`LuaLaTeX`{=html} を使用するならば代わりに `ltjsarticle` クラスも使用可能なはずだが, 私は使ったことがないので説明を省く.

# (WIP) 小説の執筆

作家の京極夏彦は自分の作品を1ページごとに切り取っても作品として成立するようなレイアウトにこだわっているらしい. すでに説明したように技術文書や学術論文では図表の配置や改行などにあまりこだわりがない. しかし, 不可能ではない. HTML では難しいが (不可能ではないがHTMLでやるメリットが感じられないので対応する気がない), PDF ではある程度のレイアウトの制御が可能である. ただし, 本当に厳格なJIS準拠の組版にこだわるなら, LaTeX を直接編集しなければならない.

`rmdja` で用意されている縦書き文書テンプレート `pdf vertical writing in Japanese` は, `jlreq` を利用して[^luatex-ja-tate]縦書き文書のPDFを作成する(図: \@ref(fig:tategaki)). **HTML には未対応である**.

<div class="figure" style="text-align: center">
<img src="img//tategaki.png" alt="縦書き文書の出力例" width="780" />
<p class="caption">(\#fig:tategaki)縦書き文書の出力例</p>
</div>

<div class="rmdwarning">
<p>現在, 縦書き文書では図のようにゴシック体になってしまうことがある.</p>
</div>

<div class="rmdtip">
<p>エディタは横書きのままである. また, 段落改行も Markdown のルールに則して1行空けによってなされる.</p>
</div>

小説家になろうとかに自動投稿する機能もいまのところない.

[^luatex-ja-tate]: `luatex-ja` にも縦書き文書クラス `ltjt` シリーズが存在するが, 公式ドキュメントにすら詳しい解説がなかったため採用しなかった.

# 製本方法の詳細

冒頭のチュートリアルで行った製本 (ビルド) の仕組みをもう少し詳しく解説する.

bookdown-demo を念頭に置いた解説. `rmdja` も基本的に同じ.

* `index.Rmd`: デフォルトで最初に読み込まれる`Rmd` ファイル (名前を変える機能もあるが, 現時点では不具合が起こりやすいのでおすすめしない)
* それ以外の `Rmd` ファイル: 連結して読み込むことが可能
* `_output.yml`: マルチメディア展開のための設定. PDF, HTML, EPUB それぞれの設定を書く
* `_bookdown.yml`: bookdown のレイアウト設定
* その他の設定ファイル: その他製本に必要なもの, 画像ファイル, `.css` ファイル, `.bib` 等

`_output.yaml`, `_bookdown.yml` は `index.Rmd` のヘッダに書くこともできるが, 長くなりすぎるので分割できる. `bookdown::render_book()` 関数は, ルートディレクトリのこれらを自動で読み込んでくれる.

## ファイル構成

これらのファイルの中身を解説する.

### `_output.yml`

本来の YAML の `output:` 以下の記述をこの `_output.yml` ファイルに書くことができる.
`output:` を複数書くと`rmarkdown::render_site()` やビルドツールでそれぞれの形式に一括作成してくれる.

```yaml
output:
  bookdown::gitbook:
    lib_dir: assets
    split_by: section
    config:
      toolbar:
        position: static
  bookdown::pdf_book:
    keep_tex: yes
  bookdown::html_book:
    css: toc.css
documentclass: book
```

詳しくは BKD "[Ch. 3 Output Formats](https://bookdown.org/yihui/bookdown/output-formats.html)" の章を.

### `_bookdown.yml`

`_bookdown.yml` も `index.Rmd` の YAML ヘッダの `bookdown:` 以下に対応する内容を書くことができる. 例えばどの Rmd ファイルを読み込むかとか, LaTeX のときだけ, HTML のときだけ読み込むような設定も可能.


https://ill-identified.hatenablog.com/entry/2020/09/05/202403

詳しくは, BKD [Ch. 4.4 Configuration](https://bookdown.org/yihui/bookdown/configuration.html)


Build ペーンから文書をビルドするには,  `index.Rmd` のYAML ヘッダに `site: bookdown::bookdown_site` を書く必要がある. さらに,  `index.Rmd` をプロジェクトディレクトリのルートに置いていない場合は, ツールバーの `Build` -> `Configure Build Tools...` から `index.Rmd` を置いているディレクトリを site ディレクトリとする設定が必要になる(図  \@ref(fig:build-pane2-1), \@ref(fig:build-pane2-2)).

<div class="figure" style="text-align: center">
<img src="img//build-pane.png" alt="Build ペーンの手動設定" width="549" />
<p class="caption">(\#fig:build-pane2-1)Build ペーンの手動設定</p>
</div><div class="figure" style="text-align: center">
<img src="img//build-pane-build.png" alt="Build ペーンの手動設定" width="757" />
<p class="caption">(\#fig:build-pane2-2)Build ペーンの手動設定</p>
</div>

または, `bookdown::render_book("index.Rmd", "rmdja::pdf_book_ja")` などでも実行できるから, コマンドラインからも実行できる. 同時製本は `rmarkdown::render_site()`.

# 出力形式による表現の限界

## HTMLとPDFで処理を場合分けする

出力方法で言えば, HTML と PDF に大別できる. Rmdは HTMLタグも LaTeX コマンドも受け付けるが, それぞれ HTML と PDF に変換する際にしか反映できない. よって, 例えば複雑な図表を LaTeX コマンドでじかに Rmd ファイルに書いてしまった場合, HTML では表示されない.

紙媒体と電子媒体では表現できることに差がある. 例えば紙はあらゆる環境で同じような見た目になるが, ハイパーリンクは付けられないし, 一度出版してしまうと修正は容易ではない. PDF の見た目も読者の環境に依存しにくいが, やはり更新が容易ではない.

`bookdown` には既に印刷された本の中身を書き換えるする機能はないが, 出力ごとに内容を変えることで, PDF にのみ更新履歴を表示することはできる.

`knitr::is_latex_output()`, `knitr::is_html_output()` などは, knit 時にどの媒体への変換処理なのかを判定するのに使える. `rmdja::ruby()` もこの機能を利用しているし, 本文中の `\LaTeX`{=latex}`LaTeX`{=html} のロゴも HTML と PDF で使い分けている.

また,  `_bookdown.yml` の設定, `rmd_files` は, 媒体別に設定することができる.

```yaml
rmd_files:
  html:
    - index.Rmd
    - html-only.Rmd
  latex:
    - index.Rmd
    - latex-only.Rmd
```


## 絵文字の出力

絵文字をHTMLでもPDFでも出力したい場合, `\coloremoji{⛄}`  のように絵文字を囲む. ただし, RStudio のエディタは一部のマルチバイト文字の表示に対応していないので予期せぬ不具合に注意する.

現在の主要Webブラウザでは, 特に設定せずとも Unicode 絵文字をカラー画像に置き換えて表示できるものが多い. しかし PDF 生成時には明示的にフォントを指定するか, 画像に置き換える記述が必要である. その実現のため `bxcoloremoji` という LaTeX パッケージ[^bxcoloremoji]を利用する. このパッケージは CTAN に登録されていないため, 別途インストールする必要がある.


## 画像の保存形式

技術文書での画像の多くはプロットなど単純な図形なので, 写真などを掲載するのでない限り, PDF で出力する場合はプロット画像も PDF にするのが望ましい. JPG や PNG などのラスタ画像では拡大すると粗くなるが, PDF などのベクタ画像ならば拡大しても粗くならず, かつ単純な図形ならばはファイルサイズも小さく済むことが多い. 一方で HTML は通常 Webブラウザで閲覧するため, PDF に対応していないことが多い.  HTML でベクタ画像を掲載したい場合は **SVG 形式** で出力する.

R による SVG への出力は, 従来組み込みの `SVG()` で行うことが多かったが, 近年は新たなパッケージが出ている. 有力なのは `svglite` と `rsvg` である.

https://oku.edu.mie-u.ac.jp/~okumura/stat/svg.html

`rsvg` のほうが高性能だが,  `knitr` で対応しているのは `svglite` なので簡単に使いたいならこちらを推奨する.

## デフォルトの保存形式

デフォルトでは, PDF は `cairo_pdf`, HTML では解像度を高めに設定した `PNG` を使用している. これは, 件数の多い散布図など, ベクタ形式ではファイルサイズが大きくなりすぎる場合もありうるための判断である.

画像形式を変更したい場合は, チャンクオプションの `dev`  で, オプションは `dev.args=list(...)` で変更できる.

https://bookdown.org/yihui/rmarkdown-cookbook/graphical-device.html

# 製本した文書を配布する

## Wepページのホスティング

HTML ファイルは様々な配布方法がある. もちろん自分でサーバを立てても良い. 特に簡単なのは以下の2点である.

1. github pages を利用する
2. bookdown.org に投稿する

(1) の詳細は github.com の[公式ドキュメント](https://docs.github.com/ja/github/working-with-github-pages/about-github-pages)を見るのが一番良いだろう.

既にbookdownで作成した文書を公開している例は多数ある. 例えば既に何度も言及した公式解説サイトはそれじたいが `bookdown` で作られているし, "R for Data Science" [@wickham2016Data] [^r4ds-source]は, 内容の良さも含め一見に値する. また, "Hands-On Data Visualization: Interactive Storytelling from Spreadsheets to Code" [@doughertyforthcomingHandsOn] という本[^handon-source]が来年出るらしい. そして面白いことにこれは R Google スプレッドシートとか R 以外のWeb上のサービスの利用法を紹介する文書である.

これらはいずれもソースコードまで公開されている. もちろんここでいうソースコードとは, 本文中のプログラムだけでなく文書を生成する `Rmd` ファイルなども含める.

それ以外にも有名無名の多くのドキュメントが公開されているが, 一方で日本語はまだまだ少ない. 内容が豊富で, かつソースコードまで公開されている例として以下が見つかった.

* 『[Rで計量政治学入門](https://shohei-doi.github.io/quant_polisci/)[^poli-source]』
* 『[AIレベルの倫理学](https://mtoyokura.github.io/Ethics-for-A-Level-Japanese/)[^ethics-source]』

bookdown の機能や見た目を確認することができる. さらに以下2つは私が作成したものである.

* 『[三國志で学ぶデータ分析 (Japan.R 2019)](https://gedevan-aleksizde.github.io/Japan.R2019/)』[^sangokushi-source] (Japan.R 2019 の資料)
* 『[経済学と反事実分析 接触篇 Economics and Counterfactual Analysis: A Contact](https://gedevan-aleksizde.github.io/20190125_tokyor/)』[^structural-source] (Tokyo.R 第83回の資料)

特に私の2作品は PDF のレイアウトにも注意を払っているが,  当時は kazutan 氏作の [`bookdown_ja_template`](https://github.com/kazutan/bookdown_ja_template) をさらに改良した [kenjimyzk 氏のテンプレート](https://github.com/kenjimyzk/bookdown_ja_template) を元にワンオフで作成したフォーマットを使用し, `rmdja` を使用していないため, あまりスマートでない書き方が見られる.


また, HTML 形式の文書には PDF など他のファイル形式のダウンロードリンクを設置することができる. これは `_bookdown.yml` で表示を指定できる.

## TODO: 入稿するには

国内の印刷所で PDF 入稿する際のスタンダードは何だろうか? 紙媒体でやったことがないので全くわからない. ver. 0.3 時点での対応を紹介する. 

### トンボの表示

`_output.yml` で

```yaml
rmdja::pdf_book_ja:
  tombow:true
```

とするとPDFにトンボ (trimming mark) を表示する. これは `gentombow.sty` によるものである. しかし私はこの出力が適切なのか判断することができない.


### フォントの埋め込み

少なくとも PDF ではフォントを埋め込みそこなったり, Type 3 フォントが設定されないようにしている. ただし Python 等を利用して描いたPDFは個別に設定が必要な場合があり, 保証できない.

TODO: https://teastat.blogspot.com/2019/01/bookdown.html の記述のうち, まだ対応してないものがある.

# (PART) デバッグ {-}

# このパートで説明すること {-}

残念ながら, 現状 `bookdown` は完全にプログラミング知識のないエンドユーザでも縦横無尽に使用できるかと言うと, まだまだ不安定でそのレベルには達していない. さらに悪いことに, `rmarkdown` および `bookdown` は `knitr`, `pandoc`, LaTeX といった様々なプログラムを継ぎ接ぎして実装されているため, R の知識だけではエラーが起こった場合や, 意図したとおりの出力が得られないときに原因が分かりにくいことがある. そこで, ここではエラーが出た際にどう対処するかのヒントを書いておく.

# 製本時のエラーへの対処

## エラーがどのタイミングで発生したかを特定する

R Markdown はさまざまな外部プログラムを利用して, 数段階のプロセスを経てソースファイルを変換して文書を作成する複雑なプログラムである. 逆に言えば, `Rmd` ファイルを `md` ファイルに変換 (`knitr`による処理) するときにエラーが出たのか, `md` を各ファイルに変換 `pandoc` する際に起こったのかをまず特定するのが重要である. そのためには

1. `keep_md: true` を設定する
2. うまくいかないときはキャッシュを削除してから再実行する


という対処法がある. (1) は文字通り中間出力ファイルである `.md` を残すことを意味する. これが生成されないなら `knitr` でのエラーだと分かるし, 中身を見て不自然な内容になっているのなら Rmd の書き方が `knitr` に正しく評価されていないことがわかる.

キャッシュも私の経験上よくエラーの原因となっている. 以前に実行していたチャンクの結果が更新されていないせいで, `knitr` の処理の不整合を起こすことがある. `*_files` には出力に必要な画像ファイルが, `*_cache` にはチャンク実行結果のキャッシュが残っている. 後者は `knitr::opts_chunk$set(cache = T)` などでキャッシュを残す設定にできるので, `F` に設定した上でこれらのファイルを削除する.

処理に時間がかかるチャンクがあってキャッシュを作りたい場合は, 別途 `rds` や `RData` ファイルに結果を保存するという方法もある. しかしもしプログラムの再現性を重視する場合, この方法は望ましくないだろう. しかし残念ながら現状はこうするか, ひたすら長い時間を待つしかない.

TODO: https://bookdown.org/yihui/rmarkdown-cookbook/cache.html

## YAML フロントマターを確認する

以前『[[R] R Markdown の YAML ヘッダでハマったおまえのための記事](https://ill-identified.hatenablog.com/entry/2020/09/05/202403)』というブログ記事にも書いたように, YAML フロントマターは慣れないと書き間違えやすいのが現状である. もし自分で変更したのなら, 改めて確認すべきだろう. 特に, 製本直後にすぐに, 心当たりのないRプログラム関係のエラーが出る場合, **チャンクではなく YAML フロントマターの読み取りに失敗している可能性**がある.

以下の**4原則**を覚えておこう. 以前は `bookdown` の話を想定してなかったので, さらに条文を1つ加えた.

1. `output:` 以下はフォーマット関数への引数
2. トップレベルのオプションは `pandoc` のオプション
3. タイプミスや位置間違えでも**動いたり, 動かなかったりする**
4. `_output.yml` および `_bookdown.yml` を見る.

`output:` には bookdown::gitbook など, `bookdown` で提供されているフォーマット関数を指定しており, その配下に記入するのはフォーマット関数に与える引数である. よって, 関数ヘルプを確認すれば有効な引数を知ることができる. しかし一方で, `...` が引数になっていることがあるので, タイプミスしてもエラーが出ないことがある.

また, YAMLの構文でサポートされている配列は誤評価を引き起こすことがある.

```yaml
output:
  bookdown::gitbook:
    toc_depth: 3
    toc: true
```

```yaml
output:
  bookdown::gitbook:
    - toc_depth: 3
    - toc: true
```

上の例は正しい記法である. 一方でハイフン `-` は YAML では配列を記述するために用意されている. 下記の場合, キーワード引数ではなく位置引数のような扱いになるため, `toc` に対して `3` を代入することになり, エラーが発生する. 逆に言えば, `-` を使う場合, キーワードを書かずに値だけを正しい順番で書けば機能する.

インデントしないトップレベルの引数は, 基本的に `pandoc` に与える引数である. これ意味のない引数を与えてもエラーを返さないことが多いので, タイプミスに注意する.

しかし, フォーマット関数に `pandoc_args` という構文をサポートしていることや, フォーマット関数で `pandoc` の同名の引数を上書きする仕様のフォーマットもあるため, 上記は絶対ではない. これが原因で, 「`output:` 以下に書くべきものを間違えてトップレベルに書いたが, 意図したとおりに機能した」あるいはその逆が発生することがある. また, **`pandoc` の構文ではキーワードにハイフンを使うことができる**が, フォーマットはRの関数でもあるため, ハイフンを使えず, アンダースコアで置き換えられる. この違いも書き間違えの原因になる.


## PDF 生成時のエラーを確認する

それでもエラーが出る場合, 私の経験上ほとんどが生成した `.tex` ファイルをタイプセットする際にエラーが発生している. `html` との両立を考えると, どうしても `pandoc` が解釈できる構文に限界がくるためである. 

```
! LaTeX Error: XXXXX
```

とか

```
Error: LaTeX failed to XXXX
```

といったメッセージが表示されるのですぐ分かる. さらに丁寧なことに, `tinytex` のデバッグ方法への[リンク](https://yihui.org/tinytex/r/#debugging)まで表示される


この場合最も重要なのは, 以下に尽きる.

1. `options(tinytex.verbose = TRUE)` を設定する
2. `keep_tex: true` を設定する

これは `keep_md` と同様に, 中間ファイルである `.tex` を残すことを意味する.

それでも解決しない場合, 改めてこのファイルを手動でタイプセットするのも1つの方法だ. もしうまくいったり, 異なるエラーが出るのなら, 環境の違いが問題かもしれない. そして `\upBibTeX`{=latex}`upBibTeX`{=html} を使うのなら, 後者が唯一のデバッグ方法だ.


[^r4ds-source]: https://github.com/hadley/r4ds
[^handon-source]: ソース: https://github.com/handsondataviz/book
[^poli-source]: ソース: https://github.com/shohei-doi/quant_polisci
[^ethics-source]: ソース: https://github.com/MToyokura/Ethics-for-A-Level-Japanese
[^sangokushi-source]: ソース: https://github.com/Gedevan-Aleksizde/Japan.R2019
[^structural-source]: ソース: https://github.com/Gedevan-Aleksizde/20190125_tokyor
[^bxcoloremoji]: https://github.com/zr-tex8r/BXcoloremoji

<!--chapter:end:chapters/multi-media.Rmd-->

# (APPENDIX) 補遺 {-}

ここでは `rmdja` の内部処理を解説する. `knitr` や `rmarkdown` の仕様に精通している, 自分で細かい設定をしたいユーザ向けの解説である.

# デフォルト値の自動調整

R Markdown で日本語文書を作成する上での大きな障害の1つである, YAML フロントマターの設定を改善している. `rmdja` の文書フォーマットはYAMLフロントマターのデフォルト値などを日本語文書に適したものに変更している. さらに, ユーザーをOSごとのフォントの違いや煩雑で重複だらけの設定から解放するため, 内部処理でも動的に設定変更している. もちろんこれらは ユーザーによる YAML フロントマターやチャンクオプションの変更で上書きできる.

## デフォルトのフォント

PDF 出力時のデフォルトフォントは, 生成時に OS を判定して設定している. その設定は表 \@ref(tab:font-default) のようなルールである.

<table>
<caption>(\#tab:font-default)OS/エンジン別のデフォルトフォント</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> engine </th>
   <th style="text-align:left;"> Linux </th>
   <th style="text-align:left;"> Mac </th>
   <th style="text-align:left;"> Windows (&gt;= 8) </th>
   <th style="text-align:left;"> Windows (それ以前) </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;background-color: gray !important;"> XeLaTeX </td>
   <td style="text-align:left;"> Noto </td>
   <td style="text-align:left;"> 游書体 </td>
   <td style="text-align:left;"> 游書体 </td>
   <td style="text-align:left;"> MSフォント </td>
  </tr>
  <tr>
   <td style="text-align:left;background-color: gray !important;"> LuaLaTeX </td>
   <td style="text-align:left;"> Noto </td>
   <td style="text-align:left;"> ヒラギノ </td>
   <td style="text-align:left;"> 游書体 </td>
   <td style="text-align:left;"> MSフォント </td>
  </tr>
</tbody>
</table>

これらは `\XeLaTeX`{=latex}`XeLaTeX`{=html} ならば `zxjafont`, `\LuaLaTeX`{=latex}`LuaLaTeX`{=html} ならば `luatex-ja` で用意されているプリセットを使って設定している. 使用 OS の判定は R の基本関数による. なお, Noto フォントを選んだのは Ubuntu 18以降の日本語用フォントだからである. Ubuntu から派生したOSにはプリインストールされていることが多いようだが, Debian, Cent OS, Fedora 等にはおそらくプリインストールされていないので注意. 現時点ではフォントが**実際にインストールされているかを確認する機能はない**.

フォントのプリセットを指定した場合, 個別設定は無効になる. さらに, 3種類の和文フォントを全て設定していない場合もデフォルトのプリセットから選ばれる.


## チャンクのデフォルト設定

デフォルトのグラフィックデバイスは, HTML では `PNG`, PDF では `cairo_pdf` としている. R でよく描画するような単純な図形はベクタ画像が適しているが, 件数のとても多いデータの散布図などはベクタ画像にするとファイルサイズが大きくなるため, そのような画像を適度に「劣化」させてファイルサイズを軽減してくれる `cairo_pdf` を標準としている. HTML に関しては, そもそもデフォルトの設定でPDFが表示できないWebブラウザが多いことから, PNG をデフォルトにした.

また, `block`, `block2`, `asis` などのブロックを `echo=F` や `include=F` にするメリットはほぼないため, `knitr::opts_chunk$set(echo = F, include = F)` と一括設定してもこれらは `echo=T, include=T` のままである. 変更したい場合は, チャンクごとに設定することで有効になる.

# PDF の組版に関する細かい話

ここではpandocテンプレート等の設定を解説する.

3種類の和文フォントを個別設定をした場合, `\XeLaTeX`{=latex}`XeLaTeX`{=html} はフォールバックフォントを有効にしている. `j****fontoptions` 以下に, `FallBack=...` というオプションでフォールバックフォントを指定すれば有効になる.

用紙サイズは, デフォルトは `a4paper`, B5がよいなら `b5paper` オプションを `classoptions:` に指定する.

PDF を印刷所に持ち込んだことがないため詳しいことはわからないが, 『[Bookdownによる技術系同人誌執筆](https://teastat.blogspot.com/2019/01/bookdown.html)』で指摘されているようなトンボやノンブルは出力されるように作ってある (そしてここで紹介されているようなLaTeXのコマンドの多くは `rmdja` では書く必要がなくなった).

TODO: PART の扉ページにはまだノンブルが表示されない

## 画像の配置

現在, PDFで画像の配置を固定する方法について何も特別なものを用意していない. 単純に自分は必要だとおもったことがないため. 固定したい場合は R Markdown や Bookdown のドキュメントを参考にしてほしい. ただし, 通常は章や部をまたいで表示されることはない (はず).

## 取り消し線

LaTeX の各パッケージのバージョンによっては, 和文に取り消し線 (`\sout`) を与えるとタイプセット時にエラーが出ることがある. もともと`ulem.sty`は欧文を前提にしたものなので適当に妥協してほしい.


## TODO: しかし英文で書きたい場合

`rmdja` の機能を使いたいが, 執筆は英語でしたいと言う場合は最低限以下のような設定変更が必要である. デフォルトは日本語用文書クラスのため,

`documentclass: book / report / article`

など欧文用文書クラスを指定する.

`rmdja` では和文フォントを参照するので, 和文フォントの設定も手動で解除する必要がある.

を指定する. そして各種見出しも英文用に調整する.

TODO

# jecon.bst の紹介

和文と欧文を使い分けたスタイルファイルとして, `jecon.bst` がある. `jecon.bst` の公式ではなく, 私がカスタマイズしたバージョンでも良い. こちらは本来よりも電子媒体としての利用を重視して,

* 参照URLを表示せず, ハイパーリンクのみにする
* ArXiv ID の表示とハイパーリンク追加

といった変更をしている. 後者は, BibTeX エントリに以下のように `archivePrefix` に `arxiv` と言う値が入っていると, `eprint` の値が ArXiv ID として表示される. これは ArXiv から直接 `.bib` ファイルを取得したり, Zotero などでインポートすれば必ず入力される項目である.

```bibtex
archivePrefix = {arXiv},
eprint = {XXXX.YYYYY},
...
```

TODO: 現在 jecon.bst の表示も少しおかしいので確認中.

# `fontregisterer` でグラフ用フォントを自動登録

Rで描いたグラフに日本語を表示する場合, Linux 系 OS ならばフォント名を適切に設定するだけで表示されるが, Windows や Mac ではフォントをグラフィックデバイスに登録する必要がある. しかし手動登録は面倒なので, インストールされているシステムフォントを全て自動登録するパッケージ, [`fontregisterer`](https://github.com/Gedevan-Aleksizde/fontregisterer) を用意している.


```{.r .numberLines .lineAnchors}
remotes::install_github("Gedevan-Aleksizde/fontregisterer", repos = NULL, type = "source")
```

もちろんこれは R Markdown 以外でも使用できる. このパッケージは読み込まれた時点で登録処理を行うため,


```{.r .numberLines .lineAnchors}
require(fontregisterer)
```

を最初に実行するだけで良い. 詳しい仕組みの解説は『[おまえはもうRのグラフの日本語表示に悩まない (各OS対応)](https://ill-identified.hatenablog.com/entry/2020/10/03/200618)』に書いている.

<!--chapter:end:chapters/appendix.Rmd-->

# (PART) 参考文献 {-}

# 参考文献 {-}

<!--chapter:end:chapters/reference-title.Rmd-->

