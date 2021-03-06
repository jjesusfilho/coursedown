#' Process the slides folder to knit the xaringan slides (using drake) and create the web front-end
#'
#' @param pdf Shold PDF versions of the slides be compiled
#'
#' @export
#'
process_slides <- function(pdf = FALSE){
  requireNamespace("tidyverse")
  final_output_dir <- fs::path(here::here('docs/slides'))
  if(!fs::dir_exists(final_output_dir)) fs::dir_create(final_output_dir, recursive = TRUE)
  yml <- yaml::read_yaml(fs::path(here::here('slides'),'_site.yml'))
  if(yml$output_dir != fs::path_abs(fs::path(here::here('slides'), yml$output_dir))){
    output_dir <- fs::path_abs(fs::path(here::here('slides'), yml$output_dir))
  } else {
    output_dir <- yml$output_dir
  }
  yml$output_dir <- fs::path_rel(output_dir, start = here::here('slides'))
  yaml::write_yaml(yml, fs::path(here::here('slides'), '_site.yml'))
  if(!fs::dir_exists(output_dir)) fs::dir_create(output_dir, recursive = TRUE)
  rmarkdown::render_site('slides')
  source('slides/lectures/drake.R')
  make(plan)
  if(pdf){
    make(plan_pdf)
  }
  if (output_dir != final_output_dir){
    fs::file_copy(fs::dir_ls(output_dir), final_output_dir, overwrite = TRUE)
  }
}
