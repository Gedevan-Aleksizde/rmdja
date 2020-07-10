# What's this?

Customized bearmer presentation format function for Japanese users

# なにこれ

* R Markdown で 日本語Beamerスライドを作るためにフォーマットを梱包したパッケージです
* ~~名称は (Xe)LaTeX の `zxjatype` パッケージから取っていますが, 同パッケージ開発者の八登崇之氏は一切関知していません~~
* ~~一旦 `zxjatype` ではなく `XeCJK` で和文フォントを埋め込むようにしました~~
  + ~~スライドでは`zxjatype`を使えないことによる大きな影響はないですが, そのうち`zxjatype`で表示するようにしたいです~~
* 0.1 から `zxjatype` の使用を再開しました. さらにCJKといいつつ中韓の言語に対応する予定はないため `rmdja` に改名しました.
* LuaLaTeXまたはXeLaTeXでのタイプセットを前提にしています
  + それぞれ `luatex-ja`, `zxjatype` を利用して和文表示をしています
  
## 既知の問題点

* `rmarkdown` 2.3 (現時点でのCRAN最新版) では標準グラフィックデバイスのフォントサイズが自動調整されません
  + 気になる方は[githubリポジトリ](https://github.com/rstudio/rmarkdown) から2.3.2以降をインストールしてください
* `XeLaTeX` ではヒラギノフォントのプリセット`hiragino-pro`/`hiragino-pron`は, OS Xにバンドルされていないヒラギノ明朝 W2を要求します
* WindowsかつLuaLaTeXのとき, `\jfontspec` でフォント変更する歳, Noto Serif CJK JP が読み込めないことがあります (原因調査中)

# 使い方

1. 後述の必要なパッケージや外部プログラムをインストールする
2. このパッケージをインストールする

```
remotes::install_github('Gedevan-Aleksizde/my_latex_templates', subdir = 'rmdja')
```

3. `Rmd` ファイルを新規作成する
  + 最初は `examples/beamer_blank.Rmd` か `examples/beamer_xelatex_{使用しているOS名}.Rmd` をコピーして使ってみてください
  + OSごとの違いはほぼデフォルトのフォントだけです
4. `Rmd`ファイルに`output::rmdja::beamer_presentation_ja` を指定
  + フォントを手動で指定する必要があります
  + MS なら 
  ```
  jfontpreset: ms
  ```
  + Ubuntuなら
  ```
  jfontpreset: noto
  ```
  + macなら
  ```
  jfontpreset: yu-osx
  ```
  でとりあえずは動くはずです.
  + 詳しくは `examples/` 以下の pdf を確認してください.

## 初期バージョン (rmdCJK) をお使いの場合

名称を変更したため旧バージョンは不要になります. アンインストールしてください

```
remove.package("rmdCJK")
```

## 必要なパッケージなど

* 最低限必要なのは `rmarkdown` のみです.

### 外部プログラム

* TeX Live (>= 2020)
もし (u)pBibTeX を一切使わない(BibLaTeX や pandoc-citeproc で良い), 参考文献を一切使わないというのであれば不要です
  + upBibTeX を使う必要があるためです
  + BiBLaTeX または pandoc-citeproc の出力する参考文献で満足している, または参考文献リストを一切使わないのなら不要です
  + Mac OS なら MacTeX, Ubuntu なら[公式](https://www.tug.org/texlive/acquire-netinstall.html)から落としてください
    - Ubuntu は `apt` を使わずインストールしたほうが良いです
  + [TeX wiki](https://texwiki.texjp.org/?TeX%20Live)などを参考にしてください
*. [`jecon.bst`](https://github.com/ShiroTakeda/jecon-bst) 
  + 日本語文献リスト用のスタイルファイルです
  + 他の`bst`ファイルを使っている, 参考文献を表示するつもりがない, なら**不要**です
  + TeX Live にも `jplain.bst`, `jipsj.bst` などの日本語対応スタイルがバンドルされていますが, `jecon.bst` は日本語出力用のオプションが充実しています.

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

# サンプル

`examples/` 以下にサンプルが存在します.


* `beamer_linux.Rmd` (linuxというよりubuntu)
* `beamer_macos.Rmd`
* `beamer_windows.Rmd`

`*.pdf` はそれぞれに対応する出力例です.

各OSでよく使われるフォントを指定している以外は上記は全て同じです. 適当なディレクトリに上記いずれをコピーしてknitしてみてください.
コピーする際には

```
file.copy(file.path(system.file("examples", package = "rmdCJK"), "beamer_*.Rmd"), "HOGEHOGE")
```

でコピーすると楽です.

**NOTE**: 用例の一環として, knit時に同じフォルダに `tab.tex`, `examples.bib`, `.latexmkrc` というファイルが生成されます. 上書きに注意してください.

**NOTE**: `monofont`/`jamonofont`はソースコードの掲載に使われます. [M+](http://mix-mplus-ipa.osdn.jp/)や[Ricty](https://rictyfonts.github.io/)などのインストールを推奨します

**NOTE**: 現時点での XeLaTeX 版と LuaLaTeX 版の違いは以下のとおりです.

1. 一部のLaTeXコマンドが違う
2. 文字の相対的な大きさ, 字間などのレイアウトが微妙に違う
3. LuaLaTeX のほうがやや処理が遅い

# 謝辞

* 以下に触発されて作りました
  + https://atusy.github.io/tokyor85-original-rmd-format
  + https://kazutan.github.io/HijiyamaR6/intoTheRmarkdown.html#/
  + https://github.com/atusy/tokyor85down

* r-wakalang で `rmarkdown` の不具合を指摘するや即座にプルリクエストを上げていただいた Atusy 氏
* 奥村晴彦氏の主催する [TeX Forum](https://oku.edu.mie-u.ac.jp/tex/) で質問に答えて頂いた方々

この場を借りて感謝します

# 更新履歴

* (0.0.5) LuaLaTeX/XeLaTeX 両方に対応できるように, 再度の名前変更
