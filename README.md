# SPEC8601 Final Assignment

This is a repository for the final assignment for APEC8601 2024 Spring. 

Country: El Salvador (ISO code: "SLV").

The final report file is available from [here].

**Objective:**

Below, I explain the steps I took for each question of the final project.

## Component 1

### Part (a):

1. Create a new seals project:
+ Open `run_test_standard.py` file. To create a new project folder,  change this line 24 to `project_name = "project_slv"`. Then run run_test_standard.py using the VS code Debugger. This newly creates `project_slv` folder under `Files/seals/projects`.

2. Generate LULC maps for El Salvador for 2030, 2035 and 2040 using SSP1 and SSP3 scenario.

+ First, download the data for RCP2.6 SSP1 and RCP7.0 SSP3 during the period 2015-2100 from [Hurrt et al. (2020)][https://luh.umd.edu/data.shtml] (or use Johnson/Polasky lab drive in the `Johnson-Polasky Lab Drive/earth_economy_data_internal/base_data/luh2/raw_data`). Save each of those data in `base_data/luh2/raw_data/rcp45_ssp2 and base_data/luh2/raw_data/rcp70_ssp3` folder, respectively.

+ Open `scenario_definitions.csv` file under `project_slv/input` folder. Then, modify the file as follows:
	- Modify `aoi` column to "SLV".
	- Add new rows for SSP1 and SSP3 scenarios. This can be done simply by copying the row for baseline scenario, and modify the columns of: `scenario_label`, `exogenous_label`, `climate_label`, `coarse_projections_input_path`, accordingly.
	- Modify the Years for the rows of SSP2 and SSP3 to 2030 2035 2040.

3. Run `run_test_standard.py` file.

> [!WARNING]
>
> Before you run run_test_standard.py with the modified scenario_defenitions.csv , you need to delete all the files/folders inside each folder directly under the folder of project_slv/intermediate (Do not delete any folder  directly under project_slv/intermediate ).


### Part (b)

See `org_image.Rmd`. This file copies the generated maps in part (a) to the `images` folder, and make the individual maps across years into a single `.png` file by SSP scenario.

### Part (c)

For this question, I modified the calibration parameters file so that cropland cannot expand into forest.

1. Modify `default_global_coefficients.csv`.
+ Open `base_data/seals/default_inputs/default_global_coefficients.csv`, and change the value in cell E5 to zero.
2.  Then, run `run_test_standard.py` file.
3. `org_image.Rmd` create a single `.png` files for each scenario.


## Component 2

### Preparation: Directory Organization
1. Create folder called `slv_InVEST_out` under the `Files/base_data` folder.
2. Under the  `slv_InVEST_out` folder, create two folder: `ssp1_rcp26` and `ssp3_rcp70`:
	+ `slv_InVEST_out/ssp1_rcp26` folder stores InVEST outputs based on SEALs output based on RCP2.6-SSP1 scenario.
	+ `slv_InVEST_out/ssp3_rcp70` folder stores InVEST outputs based on SEALs output based on RCP7.0-SSP3 scenario.
3. Then, under `slv_InVEST_out/ssp1_rcp26`, create the following folders: `AnnualWaterYield`, `CarbonStorage`, `CropPollination`, `SedimentRetention`, `e.	NutrientRetention`. Repeat this for `slv_InVEST_out/ssp1_rcp26` folder.


### Work Flow
1. Depending on which InVEST model to be run, the required data is different. See below for the source of input data I used to run each InVEST model. I processed all input data for InVEST models in `prep_InVEST_inputs.R`. CRSs of all spatial input data were transformed into WGS 84 / UTM zone 16N (EPSG:32616). 
2. Having prepared all the required data, I used InVEST software to generate python code to run a model. Then, use that python code to run the model iteratively across different SEALs' LULC data.
	+ See python codes named *Run[InVESTmodel].ipynb* in `Run_InVEST_code` folder. Each file contains python code that I used to run each InVEST model.
3. Finally, I visualized the InVEST outputs with `plot.R`. 


### Input data for InVEST models

Data source is shown inside [ ]. `*` indicates the path to the `base_data` folder in the Johnson/Polasky lab drive. `^` indicates my `base_data` folder. These data sources are processed for SLV with `prep_InVEST_inputs.R`, and the produced data is used for each InVEST model. Most of the data was obtained from the Johnson/Polasky lab drive. I downloaded the data into my local `Files/base_data` with the same structure as the Johnson/Polasky lab drive. For example, `base_data/mesh/isric/depth_to_root_restricting_layer.tif` in Johnson/Polasky lab drive was download in `Files/base_data/mesh/isric/depth_to_root_restricting_layer.tif` in my local drive.


**Annual Water Yield (AWY)**

- [x] Precipitation (average annual precipitation) [`*/mesh/worldclim/baseline/5min/baseline_bio12_Annual_Precipitation.tif`]
- [x] Evapotranspiration [`*/mesh/cgiar_csi/pet.tif`]
- [x] Root Restricting Layer Depth [`*/mesh/isric/depth_to_root_restricting_layer.tif`]
- [x] Plant Available Water Content [`*/mesh/soil/pawc_30s.tif`]
- [x] Land Use/Land Cover [SEALs' ouput in part (b) in component 1 with different scenarios]
- [x] Biophysical Table [`^/mesh/biophysical_table.csv`]
- [x] Z Parameter (The seasonality factor): 20
- [x] Watersheds [`*/mesh/hydrosheds/hydrobasins/hybas_na_lev01-06_v1c/hybas_na_lev06_v1c.shp`]

>[!NOTE] :
>
>(1) You need to modify some column names in `hybas_na_lev06_v1c.shp` to make it compatible with InVEST. Specifically, you need to change ` HYBAS_ID` to `ws_id`.
>(2) For the biophysical table, I combined `*/mesh/esa_and_modis_biophysical_table.csv` and `^/seals/default_inputs/esa_seals7_correspondence.csv` to create `^/mesh/biophysical_table.csv`. Specifically, I merged the two `.csv` files using lulc code, and aggregated the values in  `esa_and_modis_biophysical_table.csv` of by SEALs LULC category. The code to create `biophysical_table.csv` is included in `prep_InVEST_inputs.R`. 
> (3) In `esa_seals7_correspondence.csv`, `lulc_veg` is missing for `esa` column, so you need to define `lulc_veg` by yourself. Follow the description of `lulc_veg` in [InVEST website](https://esws.unige.ch/tut_data.html#data-needs).

>[!WARNING]:
> In `esa_and_modis_biophysical_table.csv`, there are two `Kc` columns with different value. `Kc` is a crop coefficient, and this is one of the required inputs to run Annual Water Yield InVEST model. I picked one of the `Kc` columns.
>Also, I found duplicated names in the `src_lable` column in `esa_seals7_correspondence.csv`. `tree_needleleaved_deciduous_closed_to_open_15` can be found in row 13 and 16 although `src_lable` in each row should be unique. I simply disregarded one of those duplicated rows.


**Carbon Storage (CS) model**

- [x] Current LULC: [SEALs' ouput in part (b) in component 1 with different scenarios]
- [x] Carbon Pools: [`^/mesh/biophysical_table.csv`]

<!-- Current LULC: [SEALs' ouput in part (b) in component 1 under base model] -->
<!-- Future LULC [SEALs' ouput in part (b) in component 1 with different scenarios] -->

**Crop Pollination (CP) model**

- [x] Land Use/Land Cover [SEALs' ouput in part (b) in component 1 with different scenarios]
- [x] Biophysical Table [`^/mesh/biophysical_table.csv`]
- [x] Guide Table [default table]

>[!NOTE] :
>
>For guide table, I used the table attached to the sample data of the InVEST Crop Pollination model. For the biophysical table for the pollination model, I refereed [Koh et al. (2016)](https://www.pnas.org/doi/10.1073/pnas.1517685113) and incorporated their table into my  `^/mesh/biophysical_table.csv`.
>

**Sediment Delivery Ratio model**

- [x] Digital Elevation Model: [`*/base_data/static_regressors/alt_m.tif`]
- [x] Erosivity: [Downloaded from Inter-American Development Bank - SLV ([here](https://github.com/Open-IEEM/IEEM-ES-SLV/))]
- [x] Soil Erodibility [Downloaded from Inter-American Development Bank - SLV ([here](https://github.com/Open-IEEM/IEEM-ES-SLV/))]
- [x] Land Use/Land Cover [SEALs' ouput in part (b) in component 1 with different scenarios]
- [x] Biophysical Table [`^/mesh/biophysical_table.csv`]
- [x] Watersheds: Watersheds [`*/mesh/hydrosheds/hydrobasins/hybas_na_lev01-06_v1c/hybas_na_lev06_v1c.shp`]
- [x] Threshold Flow Accumulation: 1000
- [x] Borselli K Parameter: 2
- [x] Maximum SDR Value: 0.8
- [x] Borselli IC0 Parameter: 0.5
- [x] Maximum L Value: 122

**Nutrient Delivery Ratio**

- [x] Digital Elevation Model: [`*/base_data/seals/static_regressors/alt_m.tif`]
- [x] Land Use/Land Cover [SEALs' ouput in part (b) in component 1 with different scenarios]
- [ ] Nutrient Runoff Proxy [`*/mesh/worldclim/baseline/5min/baseline_bio12_Annual_Precipitation.tif`]
- [x] Watersheds [`*/mesh/hydrosheds/hydrobasins/hybas_na_lev01-06_v1c/hybas_na_lev06_v1c.shp`]
- [x] Biophysical Table [`^/mesh/biophysical_table.csv`]
- [ ] Threshold Flow Accumulation (number of pixels): 1000
- [ ] Borselli K Parameter:2 

>[!NOTE]:
>
>For nutrient runoff proxy, I used annual precipitation data for SLV.


# Outputs:
+ WY model: Get estimated water yield per pixel
+ CS model: The map shows the amount of carbon stored in each pixel (Units are metric tons per pixel)
+ CP model: Per-pixel total pollinator abundance across all species during spring season.
+ SDR model: avoided_export.tif  The contribution of vegetation to keeping erosion from entering a stream (units: tons/pixel/year)
+ NDR model: p_surface_export.tif, Total phosphorus loads (sources) in the watershed, i.e. the sum of the nutrient contribution from all surface LULC without filtering by the landscape. [units kg/year]




