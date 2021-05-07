testdir <- testthat::test_path()
rmddir <- file.path(testdir, "rmd")
texdir <- file.path(testdir, "tex")
workdir <- file.path(testdir, "working")
delete_aux <- function(name){
  unlink(file.path(testdir, c(
    "jauthoyear.bbx",
    "jauthoryear.cbx",
    "packages.bib",
    ".latexmkrc",
    paste0(name, "_files"),
    xfun::with_ext(name, c("pdf", "log"))
    )),
    recursive = T)
}
test_that("Rmd compling identity test", {
  old <- getOption("knitr.table.format")
  if(packageVersion("rmarkdown") < 2.8){
    options(knitr.table.format = "latex")
  }
  for(name in paste0(c("article", "beamer"), ".Rmd")){
    unlink(file.path(workdir, "*"), recursive = T)
    file.copy(file.path(rmddir, name), to = workdir)
    delete_aux(name)
    expect_equal(rmarkdown::render(file.path(workdir, name), quiet = T),
                 file.path(getwd(), sub(basename(workdir), pattern = "^\\.", replacement = ""), xfun::with_ext(name, "pdf")))
    expect_equal(readLines(file.path(workdir, xfun::with_ext(name, "tex"))),
                 readLines(file.path(texdir, xfun::with_ext(name, "tex"))))
    delete_aux(name)
    unlink(file.path(workdir, "*"), recursive = T)
  }
  options(knitr.table.format = old)
})
