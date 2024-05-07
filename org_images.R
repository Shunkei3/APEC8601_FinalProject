library(here)
library(tidyverse)
# === read images === #
library(gridExtra)
library(png)
library(grid)
library(magick)
library(cowplot)
library(terra)


# httpgd::hgd()
# httpgd::hgd_browse()


base_dir <- here()
lulc_png_path <- file.path(base_dir, "seals/projects/project_slv/intermediate/visualization/lulc_pngs")
# dir.exists(lulc_png_path)
tg_image_dir_path <- file.path(base_dir, "apec_8601/apec_8601_2024/final_assignment/images")
# dir.exists(tg_image_dir_path)

# /*===========================================*/
#'=  Component 1 =
# /*===========================================*/
copy_images <- function(out_dir_name){
  # out_dir_name = "1c"
  out_dir = file.path(tg_image_dir_path, out_dir_name)

  if(!dir.exists(out_dir)) dir.create(out_dir)

  # --- copy png files --- #
  ls_pngs <- 
      list.files(
        path = lulc_png_path,
        full.name = TRUE
        )
  
  ls_png_files <- 
    file.copy(
      from = ls_pngs,
      to = out_dir, 
      overwrite = TRUE,
      recursive = TRUE
    )
}

gen_map <- function(in_dir_name, out_dir_name){
  # in_dir_name <- "1b"
  # out_dir_name <- "1b_out"

  out_dir <- file.path(tg_image_dir_path, out_dir_name)
  if(!dir.exists(out_dir)) dir.create(out_dir)

  # --- base image --- #
  base_image <- 
   image_read(file.path(tg_image_dir_path ,in_dir_name, "lulc_esa_seals7_luh2-message_2017.png")) %>%
   image_trim(.)

  image_ggplot(base_image, interpolate = FALSE)
  ggsave(file.path(out_dir, "out_base.png"))

   # --- ssp images --- #
  ls_ssp_images <- 
    list.files(
      path = file.path(tg_image_dir_path, in_dir_name),
      pattern = "_rcp",
      full.name = TRUE
      ) %>%
    lapply(., image_read) %>%
    lapply(., image_trim) %>%
    lapply(., rasterGrob)

  plot_grid(
    ls_ssp_images[[1]], ls_ssp_images[[2]], ls_ssp_images[[3]],
    ncol = 1, align = "v"
  )
  ggsave(file.path(out_dir, "out_ssp1.png"))


  plot_grid(
    ls_ssp_images[[4]], ls_ssp_images[[5]], ls_ssp_images[[6]],
    ncol = 1, align = "v"
  )
   ggsave(file.path(out_dir, "out_ssp3.png"))
}


# === Part (b) === #
# copy_images(out_dir_name = "1b")
# gen_map(
#   in_dir_name = "1b",
#   out_dir_name = "1b_out"
#   )
# DONE


# === Part (c) === #
copy_images(out_dir_name = "1c")

gen_map(
  in_dir_name = "1c",
  out_dir_name = "1c_out"
  )




