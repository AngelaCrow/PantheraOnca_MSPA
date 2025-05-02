#'Codigo para estimar resistencia ####
setwd("./Archivos_informe_2/Cartografia_metadatos_2/3. Análisis de la transformación del hábitat en el paisaje Pacífico Central (2017-2023)")

rm(list=ls())
#Librerias----
library(terra)
library(scales)
library(sf)
library(Makurhini)

#Resistencia 2019 ----
Infraestructure <- rast("./Variables/disCarreteras_rcl.tif")
Fragmentation_1 <- rast("./Variables/disPaches_2019rcl.tif")
Fragmentation_2 <- rast("./Variables/PatchSize_impact_2019.tif")
Landuse <- rast("./Variables/vegImpacto_2019.tif")

resist_2019 <- Landuse*Infraestructure*Fragmentation_1*Fragmentation_2
writeRaster(resist_2019, "./Mexbio_2019.tif")

## Scale 1-100----
box_grid <- read_sf("./Vectores/mask_grid.gpkg")

scale_rast <- list()
for(i in 1:nrow(box_grid)){
  print(i)
  x.1 <- crop(resist_2019, box_grid[i,])
  if(class(unique(x.1)) == "data.frame"){
    x.1[] <- rescale(x.1[], to=c(1,100))
    scale_rast[[i]] <- x.1
  } else {
    scale_rast[[i]] <- NULL
  }
}
rsrc <- sprc(purrr::compact(scale_rast))
resist_2019_scale <- mosaic(rsrc, fun = "max")
rm(scale_rast);invisible(gc())

writeRaster(resist_2019_scale, "./Mexbio_2019_1_100.tif")

#Resistencia 2023----
Infraestructure <- rast("./Variables/disCarreteras_rcl.tif")
Fragmentation_1 <- rast("./Variables/disPaches_2023rcl.tif")
Fragmentation_2 <- rast("./Variables/PatchSize_impact_2023.tif")
Landuse <- rast("./Variables/vegImpacto_2023.tif")

resist_2023 <- Landuse*Infraestructure*Fragmentation_1*Fragmentation_2
writeRaster(resist_2023, "./Mexbio_2023.tif")

##Scale 1-100 ----
box_grid <- vect("./Vectores/mask_grid.gpkg")
scale_rast <- list()

for(i in 1:nrow(box_grid)){
  print(i)
  x.1 <- crop(resist_2023, box_grid[i,])
  if(class(unique(x.1)) == "data.frame"){
    x.1[] <- rescale(x.1[], to=c(1,100))
    scale_rast[[i]] <- x.1
  } else {
    scale_rast[[i]] <- NULL
  }
}

rsrc <- sprc(purrr::compact(scale_rast))
resist_2023_scale <- mosaic(rsrc, fun = "max")
rm(scale_rast);invisible(gc())

writeRaster(resist_2023_scale, "./Mexbio_2023_1_100.tif")

