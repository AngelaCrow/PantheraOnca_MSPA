setwd("/Informes/Archivos_informe_2/Cartografia_metadatos_2/3. Análisis de la transformación del hábitat en el paisaje Pacífico Central (2019-2023)")

library(terra)

rf_2019<-terra::rast("/Informes/Archivos_informe_1/Update_informe1/1. Mapas de coberturas/2019_Class_utm.tif")
rf_2019

m <- cbind(c(1,2,3,4), 1)
r2019 <- classify(rf_2019, m, others=2)
r2019 [is.na(r2019 )] <- 0
plot(r2019)
writeRaster(r2019, filename = "Raster/Bosque_2019.tif", datatype = "INT1U", overwrite=TRUE)


##2023#######
rf_2023<-terra::rast("/Informes/Archivos_informe_1/Update_informe1/1. Mapas de coberturas/2023_Class_utm.tif")
rf_2023

m <- cbind(c(1,2,3,4), 1)
r2023 <- classify(rf2023, m, others=2)
r2023 [is.na(r2023 )] <- 0
plot(r2023)
writeRaster(r2023, filename = "Raster/Bosque_2023.tif", datatype = "INT1U", overwrite=TRUE)

