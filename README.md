# What's this?

Customized R Markdown/Bookdown format functions for Japanese users

# なにこれ

* R Markdown で 日本語文書を作るためのフォーマットを梱包したパッケージです
* 現時点では Beamer スライド (`rmarkdown::beamer_presentation`), `bookdown` に対応しています.
* XeLaTeXまたはLuaLaTeXでのタイプセットを前提にしています
  + それぞれ `zxjatype`, `luatex-ja`, を利用して和文表示をしています
* 私的LaTeXテンプレ集である[my_latex_templates](https://github.com/Gedevan-Aleksizde/my_latex_templates/)からパッケージとして独立しました

以下は `rmdja` 自身で作成したドキュメントです. HTML/PDF/EPUB を用意しています.

https://gedevan-aleksizde.github.io/rmdja/

# 最低限必要なもの

* R >= 3.6
* R Studio >= 1.3.1056
* `rmarkdown` (>= 2.4)
* `bookdown` (>= 0.20.6)

# インストールから使用まで

1. 後述の必要なパッケージや外部プログラムをインストールする
2. このパッケージをインストールする (`remotes` パッケージを使うのが簡単です)
```
remotes::install_github('Gedevan-Aleksizde/rmdja', repos = NULL, type = "source")
```
特定のバージョンをインストールする場合は, 以下のようにして指定できます.
```
remotes::install_github('Gedevan-Aleksizde/rmdja', ref="v0.4", repos = NULL, type = "source")
```
または以下のような記法も可能です
```
remotes::install_github('Gedevan-Aleksizde/rmdja@v0.4', repos = NULL, type = "source")
```
リリース一覧からダウンロードしたアーカイブファイルからインストールすることもできます.

3. 新規作成時に [R Markdown] -> [From Template] -> `{rmdja}` のテンプレートのいずれかを選択します  
![select templete](inst/resources/img/readme-selection.png)
  + または最初は [`examples/beamer`](inst/resources/examples/beamer/) の `beamer_blank.Rmd` か `examples/beamer_xelatex_{使用しているOS名}.Rmd` をコピーして使ってみてください
  + (上記どちらでもないなら) `Rmd`ファイルに`output::rmdja::beamer_presentation_ja` を指定
4. フォントの指定 (オプション)
  + OSごとの違いはほぼデフォルトのフォントだけです. もしフォントが表示されない/気に入らない場合は手動で指定してください. 例えば,
  + MS (Win10) なら 
  ```
  jfontpreset: bizud
  ```
  + Ubuntuなら
  ```
  jfontpreset: noto
  ```
  + macなら
  ```
  jfontpreset: hiragino-pro
  ```
  でとりあえずは動くはずです.
  + XeLaTeX をお使いなら `zxjafont`, LuaLaTeX をお使いなら `luatex-ja` のプリセット名で指定できます
  + 混植も可能です
  + 詳しくは [`examples/beamer`](inst/resources/examples/beamer/) 以下の pdf を確認してください.

**NOTE**: `jmainfont`, `jsansfont`, `jmonofont` で書体ごとにフォントを設定できます. `mainfont`/`sansfont`/`monofont` は欧文用です. 特に `monofont`/`jamonofont`はソースコードの掲載に使われます. プログラムの解説をしたい場合は[M+](http://mix-mplus-ipa.osdn.jp/)や[Ricty](https://rictyfonts.github.io/)などのインストールを推奨します

**NOTE**: 現時点での XeLaTeX 版と LuaLaTeX 版の違いは以下のとおりです.

1. 一部のLaTeXコマンドが違う
2. 文字の相対的な大きさ, 字間などのレイアウトが微妙に違う
3. LuaLaTeX のほうがやや処理が遅い
4. 縦書き文書は LuaLaTeX のみ対応

## 初期バージョン (rmdCJK) をお使いの場合

名称を変更したため旧バージョンは不要になります. アンインストールしてください

```
remove.package("rmdCJK")
```

# 用途によっては追加インストールが必要なもの

## (u)pBibTeX を使用したい場合

* upBibTeX を使って参考文献を出力したい (≒ .bst ファイルを指定したい) 場合, TeX Live のインストールが必要になります. BibLaTeX や pandoc-citeproc で良い, 参考文献を一切使わないというのであれば**不要**です
* Mac OS なら MacTeX, Ubuntu なら[公式](https://www.tug.org/texlive/acquire-netinstall.html)から落としてください
  +  Ubuntu は `apt` を**使わず**インストールしたほうが良いです
  + [TeX wiki](https://texwiki.texjp.org/?TeX%20Live)などを参考にしてください
* [`jecon.bst`](https://github.com/ShiroTakeda/jecon-bst) が役に立つかも知れません
  + 日本語文献リスト用のスタイルファイルです
  + TeX Live にも `jplain.bst`, `jipsj.bst` などの日本語対応スタイルがバンドルされていますが, `jecon.bst` は日本語出力用のオプションが充実しています.

## フォントについて

日本語フォントを指定しなかった場合 (`jfontpreset` 未設定, かつ`j~~font`の設定が3つ揃っていない場合), OSを判別して以下のようにデフォルトフォントを決めています. これらは (Linux 以外) OS標準インストールフォントのはずです.

|         | Mac          | Linux | windows (8以降)  | windows(それ以前) |
|:------- | ------------:| -----:| ----------------:| -----------------:|
| XeLaTeX | 游書体       | Noto  | 游書体           | MSフォント        |
| LuaLaTeX| ヒラギノProN | Noto  | 游書体           | MSフォント        |

Linux は Ubuntu 18 以降の設定に準拠して Noto をデフォルトにしています. Debian とか Cent OS とかは手動で変えるか Noto をインストールしてください.

Debian:

```sh
sudo apt install fonts-noto-cjk-extra -t stretch-backports
```

Cent OS とか Fedora とか:

https://www.google.com/get/noto/help/install/

**NOTE**: `monofont`/`jamonofont`はソースコードの掲載に使われます. [M+](http://mix-mplus-ipa.osdn.jp/)や[Ricty](https://rictyfonts.github.io/)などのインストールを推奨します

### 注意事項

* 現時点では実際にフォントがインストールされているか判定していません.
* `XeLaTeX` ではヒラギノフォントのプリセット`hiragino-pro`/`hiragino-pron`は, OS Xにバンドルされていないヒラギノ明朝 W2を必要とします. インストールされていない場合, この設定ではエラーが発生します.
* WindowsかつLuaLaTeXのとき, `\jfontspec` でフォント変更する歳, Noto Serif CJK JP が読み込めないことがあります (原因調査中)
* LuaLaTeX ではフォントが常にゴシック体になります, また, 一部のフォントプリセットが正しく認識されないことがあります (詳細は公式ドキュメントを参照してください)

## サンプルの内容を再現したい場合

[`examples/`](inst/resources/examples/beamer/) 以下に用例がいくつか存在します.

* `beamer_xelate.Rmd`
* `beamer_lualatex.Rmd`

`*.pdf` はそれぞれに対応する出力例です.

各OSでよく使われるフォントを指定している以外は上記は全て同じです. 適当なディレクトリに上記いずれかをコピーしてknitしてみてください.
コピーする際には

```
file.copy(system.file("resources/examples/beamer/beamer_xelatex.Rmd", package = "rmdja"), to = "./")
file.copy(system.file("resources/examples/beamer/beamer_lualatex.Rmd", package = "rmdja"), to = "./")
```

と言うふうにコピーすると楽です.

**NOTE**: 用例の一環として, knit時に同じフォルダに `tab.tex`, `examples.bib`, `.latexmkrc` というファイルが生成されます. 上書きに注意してください.

### examples に必要なRパッケージ

* なくても動きますが, あったほうが使い方がわかりやすいです
* 以下でインストールしてください

```
install.packages(
  c("conflicted", "rmarkdown", "tidyverse", "ggthemes", "ggdag", "DiagrammeR", "xtables", "kableExtra", "stargazer", "tufte"),
  dependencies = T)
```

* MacおよびWindowsはさらに以下が必要です (DOT言語での作図例のため)
  + Windows はさらにRStudioの再起動が必要かもしれません

```
install.packages("webshot")
webshot::install_install_phantomjs()
```

### examples に必要な外部プログラム

* Graphviz

DOT言語で生成した画像を挿入する用例があるため, インストールが必要です

MAC:

```
brew install graphviz
```

Ubuntu:

```
sudo apt install graphiviz
```

* [BXcoloremoji.sty](https://github.com/zr-tex8r/BXcoloremoji)
  + カラー絵文字を出力したい場合に必要です. CTANに登録されてないため手動インストールする必要があります


# 謝辞

* 以下に触発されて作りました
  + https://atusy.github.io/tokyor85-original-rmd-format
  + https://kazutan.github.io/HijiyamaR6/intoTheRmarkdown.html#/
  + https://github.com/atusy/tokyor85down

* r-wakalang で `rmarkdown` の不具合を指摘するや即座にプルリクエストを上げていただいた Atusy 氏
* 奥村晴彦氏の主催する [TeX Forum](https://oku.edu.mie-u.ac.jp/tex/) で質問に答えて頂いた方々

この場を借りて感謝します

# その他

2020/9/19 Tokyo.R で本パッケージの機能を紹介しました.

『[おまえは万物をRSTUDIOで書ける](https://speakerdeck.com/ktgrstsh/you-can-write-everything-on-rstudio)』

# 更新履歴メモ

* v0.4 以降の更新情報は NEWS.md を参照してください
* v0.3.2
  + v0.3の寝起きで作ったおかしいところを修正したバージョン
* v0.3.1
  + ミスしたので微修正版
 以下はリポジトリ分割前のバージョンです.
* v0.3
  + `bookdown` 日本語版に対応
  + フォントを指定しなかった場合, OSに応じて自動設定するように
  + 複数形式に対応したルビ出力関数 `ruby()` を追加
  + クリエイティブコモンズのアイコン表示 `get_CC()` を追加
* v0.2
  + 新規作成時のテンプレートとして選べるように
  + 用例ファイルのフォント選択を自動判別化 (フロントマターにベタ書きしただけ)
* v0.1
  + 最初の公開版
* (0.0.5) LuaLaTeX/XeLaTeX 両方に対応できるように, 再度の名前変更
* (0.1.0) win/ubuntu/macで対応, XeLaTeX/LuaLaTeX で動作確認したのでmasterにマージ.
* (0.1.1) レイアウト微修正
