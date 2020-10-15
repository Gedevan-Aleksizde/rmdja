#' PDF/HTML でロゴを出す
#' @description PDF は `BXtexlogo.sty` でロゴを出す.
#' @param logoname: character. BXtexlogo に対応したロゴを出す. 大文字小文字問わずマッチする.
#' @details うろ覚えでもいいように大文字小文字問わない. https://github.com/zr-tex8r/BXtexlogo を参考に

#' @export
texlogo <- function(logoname, isrichtext = FALSE){
  base <- switch(tolower(logoname),
    "tex"      = "TeX",
    "amslatex" = "AmSLaTeX",
    "amstex"   = "AmSTeX",
    "bibtex"   = "BibTeX",
    "context"  = "ConTeXt",
    "etex"     = "eTeX",
    "latex"    = "LaTeX",
    "latexe"   = "LaTeXe",
    "lualatex" = "LuaLaTeX",
    "luatex"   = "LuaTeX",
    "lyx"      = "LyX",
    "metafont" = "METAFONT",
    "meapost"  =  "METAPOST",
    "pdftex"   = "pdfTeX",
    "pdflatex" = "pdfLaTeX",
    "xelatex"  = "XeLaTeX",
    "xetex"    = "XeTeX",
    "epTeX"    = "e-PTeX",
    "euptex"   = "eupTeX",
    "jbibtex"  = "JBibTeX",
    "pbibtex"  = "pBibTeX",
    "platexe"  = "pLaTeXe",
    "platex"   = "pLaTeX",
    "ptex"     = "pTeX",
    "tikz"     = "TikZ",
    "upbibtex"  = "upBibTeX",
    "uplatex"  = "upLaTeX",
    "uplatexe" = "upLaTeXe",
    "uptex"    = "upTeX",
    "hanthethanh" =  "HanTheThanh",
    "komascript" = "KOMAScript",
    "latextex"  =  "LaTeXTeX",
    "nts"      = "NTS",
    "pictex"  = "PiCTeX",
    "sagetex" =  "SageTeX",
    "slitex" =  "SLiTeX",
    "tetex" = "teTeX",
     "tth" = "TTH",
    "aptex" =  "ApTeX",
    "hevea" =  "HeVeA",
    "jbibtex" = "JBibTeX",
    "jlatex" =  "JLaTeX",
    "jtex" = "JTeX",
    "katex" = "KaTeX",
    "ket" = "KET",
    "ketpic" = "KETpic",
    "latexit" = "LaTeXiT",
    "latexml" = "LaTeXML",
    "logoaleph" = "logoAleph",
    "logolambda" = "logoLambda",
    "logolamed" =  "logoLamed",
    "logoomega" = "logoOmega",
    "ptexst" = "pTeXsT",
    "xym" = "XyM",
    "xymtex" = "XyMTeX",
    ""
    )
  if(nchar(base) == 0){
    r <- logoname
  } else{
    r <- paste0("`\\", base, "`{=latex}`", base, "`{=html}")
  }
  return(r)
}