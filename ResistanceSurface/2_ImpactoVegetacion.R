setwd("/Archivos_informe_2/Cartografia_metadatos_2/3. Análisis de la transformación del hábitat en el paisaje Pacífico Central (2019-2023)")

library(terra)
##2019#######
rf_2019<-terra::rast("/Informes/Archivos_informe_1/Update_informe1/1. Mapas de coberturas/2019_Class_utm.tif")
rf_2019

#########
rclmat <- matrix(c(-Inf, 0, 0,
                   0, 1, 0.3,
                   1, 2, 0.9,
                   2, 3, 0.5,
                   3, 4, 0.7), ncol = 3, byrow = TRUE)

rc <- terra::classify(rf_2019, rclmat, include.lowest = TRUE)
terra::plot(rc)
terra::writeRaster(rc, filename = "Variables/vegImpacto_2019.tif",overwrite = TRUE)
rm(rc,rf_2019)

##2023#######
rf_2023<-terra::rast("/Informes/Archivos_informe_1/Update_informe1/1. Mapas de coberturas/2023_Class_utm.tif")
rf_2023

#
rclmat <- matrix(c(-Inf, 0, 0,
                   0, 1, 0.3,
                   1, 2, 0.9,
                   2, 3, 0.5,
                   3, 4, 0.7), ncol = 3, byrow = TRUE)

rc <- terra::classify(rf_2023, rclmat, include.lowest = TRUE)
terra::plot(rc)
terra::writeRaster(rc, filename = "Variables/vegImpacto_2023.tif",overwrite = TRUE)
