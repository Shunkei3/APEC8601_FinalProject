# /*===========================================*/
#'= Objective  =
#' + Convert CRS of SEALS LULC 
# /*===========================================*/

# --- for data wrangling --- #
library(here)
library(data.table)
library(tidyverse)
# --- for spatial operation --- #
library(sf)
library(terra)
# --- visualization --- #
library(tmap)

# httpgd::hgd()
# httpgd::hgd_browse()

# --- path --- #
project_path <- here("seals/projects/project_slv/intermediate")
my_dir <- here("apec_8601/apec_8601_2024/final_assignment")
# dir.exists(my_dir)


# /*===== Load boundary of SLV =====*/
bd_slv <- 
	st_read(
		file.path(project_path, "project_aoi/aoi_SLV.gpkg"),
		quiet = TRUE
	)

#/*--------------------------------*/
#' ## SSP1 and SSP3 scenarios
#/*--------------------------------*/
ls_years <- c(2030, 2035, 2040)
ls_ssps <- c("ssp1_rcp26", "ssp3_rcp70")

for(ssp_name in ls_ssps){
	# ssp_name = ls_ssps[[1]]

	# --- create save folder --- #
	save_folder_dir <- here("base_data", "seals_out_lulc")
	if(!dir.exists(save_folder_dir)) dir.create(save_folder_dir)

	# === Modify CRS of seal LULCs === #
	ls_lulc_names <- 
		paste0("lulc_esa_seals7_", ssp_name,"_luh2-message_bau_", ls_years, "_clipped.tif")

	for(lulc_name in ls_lulc_names){
		# lulc_name = ls_lulc_names[[1]]

		temp_lulc <- 
			rast(here(project_path, "stitched_lulc_simplified_scenarios", lulc_name)) %>%
			# project(., "ESRI:54030", method = "near")
			project(., "epsg:32616", method = "near")

		temp_lulc <- subst(temp_lulc, NA, 0)

		terra::writeRaster(
			temp_lulc,
			here(save_folder_dir, paste0("slv_", lulc_name)),
			datatype = "INT1U",
			# NAflag = NA, 
			overwrite=TRUE
		)+
		theme(
  			legend.position="bottom",
  			legend.box = "vertical",
  			legend.box.just = "left",
  			legend.spacing.y = unit(0.001, "cm"),
  			legend.margin=margin(0,0,0,0),
        	legend.box.margin=margin(-10,-10,-10,-10),
  		)
	}
}


test <- rast(here("base_data/seals_out_lulc", "slv_lulc_esa_seals7_ssp1_rcp26_luh2-message_bau_2030_clipped.tif"))
# any(is.na(values(test)))

