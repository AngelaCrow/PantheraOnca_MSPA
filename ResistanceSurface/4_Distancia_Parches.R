setwd("/Informes/Archivos_informe_2/Cartografia_metadatos_2/3. Análisis de la transformación del hábitat en el paisaje Pacífico Central (2019-2023)")

library(terra)

# Leer el ráster original para usarlo como mascara
mascara <- terra::rast("Raster/Bosque_2019.tif")
# Definir la matriz de reglas de clasificación y aplicar la clasificación al ráster original
rclmat_M <- matrix(c(0, 1, NA, 1, 5, 1))
mascara <- terra::classify(mascara, rclmat_M)

##2019####
rf_2019<-terra::rast("Raster/Bosque_2019.tif")
rf_2019

m <- cbind(c(2), 1)
r2019 <- terra::classify(rf_2019, m, others=NA)
plot(r2019)

# Caluclar raster de distancia a parches
dis_parches <- terra::distance(r2019) 
terra::plot(dis_parches)

# Recortar el raster con la mascara: m
ddis_parches <- terra::mask(terra::crop(dis_parches, mascara), mascara)

#Guardar raster de distancia a parches
terra::writeRaster(ddis_parches, filename = "Variables/disParches_2019.tif",overwrite = TRUE)
terra::plot(ddis_parches)

#rcl
rm(rclmat,rc)
rclmat <- matrix(c(0, 1500, 0.5,
                   1500, 4500, 0.25,
                   4500, 10000, 0.15,
                   10000, Inf, 0.1), ncol = 3, byrow = TRUE)

rc <- terra::classify(ddis_parches, rclmat, include.lowest = TRUE)
terra::plot(rc)
terra::writeRaster(rc, filename = "Variables/disPaches_2019rcl.tif", overwrite = TRUE)

rm(rc, dis_parches,rf_2019)

##2023####
rf_2023<-terra::rast("Raster/Bosque_2023.tif")
rf_2023

m <- cbind(c(2), 1)
r2023 <- terra::classify(rf_2023, m, others=NA)
terra::plot(r2023)

# Caluclar raster de distancia a parches
dis_parches <- terra::distance(r2023) 
terra::plot(dis_parches)

# Recortar el raster con la mascara: m
dis_parches <- terra::mask(terra::crop(dis_parches, mascara), mascara)

#Guardar raster de distancia a parches
terra::writeRaster(ddis_parches, filename = "Variables/disParches_2023.tif",overwrite = TRUE)
terra::plot(ddis_parches)

#rcl
rm(rclmat,rc)
rclmat <- matrix(c(0, 1500, 0.5,
                   1500, 4500, 0.25,
                   4500, 10000, 0.15,
                   10000, Inf, 0.1), ncol = 3, byrow = TRUE)

rc <- terra::classify(ddis_parches, rclmat, include.lowest = TRUE)
terra::plot(rc)
terra::writeRaster(rc, filename = "Variables/disPaches_2023rcl.tif", overwrite = TRUE)