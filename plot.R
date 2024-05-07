library(here)
library(data.table)
library(tidyverse)
library(stringr)
library(tidyterra)
library(terra)
# === read images === #
library(gridExtra)
library(png)
library(grid)
library(tmap)
library(magick)
library(cowplot)

httpgd::hgd()
httpgd::hgd_browse()

path_InVEST_out <- here("base_data/slv_InVEST_out")
path_out_plot_base <- here("apec_8601/apec_8601_2024/final_assignment/images/slv_InVEST_out")

ls_years <- c(2030, 2035, 2040)
ls_ssps <- c("ssp1_rcp26", "ssp3_rcp70")

file_path <- system.file("extdata/cyl_temp.tif", package = "tidyterra")

# /*===========================================*/
#'= Annual Water Yield =
# /*===========================================*/
folder_wy <- "AnnualWaterYield"
inter_path_tif_wy <- "output/per_pixel/wyield.tif"
suffix_image_file <- "wy"

for(ssp_name in ls_ssps){
	# ssp_name = ls_ssps[[1]]
	path_folder <- 
		paste0(here(path_InVEST_out, ssp_name, folder_wy))

	ls_path_out <- paste0(here(path_folder, paste0("y",ls_years), inter_path_tif_wy))

	rasters <- rast(ls_path_out)
	names(rasters) <- ls_years
	rasters[rasters==0] <- NA

	# === make a plot  === #
	map <- 
		tm_shape(rasters) +
    	tm_raster(
    		style = "cont",
    		title = "Water yield per pixel"
    	)+ 
    	tm_layout(
    		main.title = str_replace(ssp_name, "_", "-"),
	 		aes.palette = list(seq = "-RdYlGn"),
	 		main.title.size = 1,
	 		legend.outside = TRUE ,
	 		# legend.outside.position = "bottom",
	 		frame = TRUE
  		)
  	
  	tmap_save(
  		map, 
  		here(path_out_plot_base, paste0(suffix_image_file, "_", ssp_name, ".png"))
  	)
}

# /*===========================================*/
#'= Carbon Storage =
# /*===========================================*/
folder_cs <- "CarbonStorage"
inter_path_tif_cs <- "tot_c_cur.tif"
suffix_image_file <- "cs"

for(ssp_name in ls_ssps){
	# ssp_name = ls_ssps[[1]]
	path_folder <- 
		paste0(here(path_InVEST_out, ssp_name, folder_cs))

	ls_path_out <- paste0(here(path_folder, paste0("y",ls_years), inter_path_tif_cs))

	rasters <- rast(ls_path_out)
	names(rasters) <- ls_years
	rasters[rasters==0] <- NA

	# === make a plot  === #
	map <- 
		tm_shape(rasters) +
    	tm_raster(
    		style = "fisher",
    		title = "Carbon storage per pixel \n metric tons per pixel"
    	)+ 
    	tm_layout(
    		main.title = str_replace(ssp_name, "_", "-"),
    		# main.title.size = 2,
	 		# legend.position = c("right", "top"),
	 		aes.palette = list(seq = "YlOrBr"),
	 		main.title.size = 1,
	 		legend.outside = TRUE ,
	 		# legend.outside.position = "bottom",
	 		frame = TRUE
  		)
  	
  	tmap_save(
  		map, 
  		here(path_out_plot_base, paste0(suffix_image_file, "_", ssp_name, ".png"))
  	)
}

# /*===========================================*/
#'=  CropPollination =
# /*===========================================*/
folder_cp <- "CropPollination"
inter_path_tif_cp <- "total_pollinator_abundance_spring.tif"
suffix_image_file <- "cp"

for(ssp_name in ls_ssps){
	# ssp_name = ls_ssps[[1]]
	path_folder <- 
		paste0(here(path_InVEST_out, ssp_name, folder_cp))

	ls_path_out <- 
		paste0(
			here(path_folder, paste0("y",ls_years), inter_path_tif_cp)
		)

	rasters <- rast(ls_path_out)
	names(rasters) <- ls_years
	rasters[rasters==0] <- NA

	# === make a plot  === #
	map <- 
		tm_shape(rasters) +
    	tm_raster(
    		style = "cont",
    		title = "Per-pixel total \n pollinator abundance"
    	)+ 
    	tm_layout(
    		main.title = str_replace(ssp_name, "_", "-"),
	 		# legend.position = c("right", "top"),
	 		aes.palette = list(seq = "YlOrBr"),
	 		main.title.size = 1,
	 		legend.outside = TRUE ,
	 		# legend.outside.position = "bottom",
	 		frame = TRUE
  		)
  	
  	tmap_save(
  		map, 
  		here(path_out_plot_base, paste0(suffix_image_file, "_", ssp_name, ".png"))
  	)
}

# /*===========================================*/
#'= NutrientRetention (NDR) =
# /*===========================================*/
folder_ndr <- "NutrientRetention"
inter_path_tif_ndr <- "p_surface_export.tif"
suffix_image_file <- "ndr"

for(ssp_name in ls_ssps){
	# ssp_name = ls_ssps[[1]]
	path_folder <- 
		paste0(here(path_InVEST_out, ssp_name, folder_ndr))

	ls_path_out <- 
		paste0(
			here(path_folder, paste0("y",ls_years), inter_path_tif_ndr)
		)

	rasters <- rast(ls_path_out)
	names(rasters) <- ls_years
	rasters[rasters==0] <- NA

	# === make a plot  === #
	map <- 
		tm_shape(rasters) +
    	tm_raster(
    		style = "cont",
    		title = "The amount of phosphorus \n loads in the stream (kg/pixel/year)"
    	)+ 
    	tm_layout(
    		main.title = str_replace(ssp_name, "_", "-"),
	 		# legend.position = c("right", "top"),
	 		aes.palette = list(seq = "YlOrBr"),
	 		main.title.size = 1,
	 		legend.outside = TRUE ,
	 		# legend.outside.position = "bottom",
	 		frame = TRUE
  		)
  	
  	tmap_save(
  		map, 
  		here(path_out_plot_base, paste0(suffix_image_file, "_", ssp_name, ".png"))
  	)
}

# /*===========================================*/
#'= SedimentRetention (SDR model)=
# /*===========================================*/
folder_sdr <- "SedimentRetention"
inter_path_tif_sdr <- "avoided_export.tif"
suffix_image_file <- "sdr"

for(ssp_name in ls_ssps){
	# ssp_name = ls_ssps[[1]]
	path_folder <- 
		paste0(here(path_InVEST_out, ssp_name, folder_sdr))

	ls_path_out <- 
		paste0(
			here(path_folder, paste0("y",ls_years), inter_path_tif_sdr)
		)

	rasters <- rast(ls_path_out)
	names(rasters) <- ls_years
	rasters[rasters==0] <- NA

	# === make a plot  === #
	map <- 
		tm_shape(rasters) +
    	tm_raster(
    		style = "fisher",
    		title = "Per-pixel avoided erosion \n into a stream (tons/pixel/year)"
    	)+ 
    	tm_layout(
    		main.title = str_replace(ssp_name, "_", "-"),
	 		# legend.position = c("right", "top"),
	 		aes.palette = list(seq = "YlOrBr"),
	 		main.title.size = 1,
	 		legend.outside = TRUE ,
	 		# legend.outside.position = "bottom",
	 		frame = TRUE
  		)
  	
  	tmap_save(
  		map, 
  		here(path_out_plot_base, paste0(suffix_image_file, "_", ssp_name, ".png"))
  	)
}
