#Impacto tamaño de parche

library(terra)
library(sf)
library(rmapshaper)

#Size of patches
rast_patches <- rast("./Bosque/Bosque_2019.tif")
rast_mask <- vect("./Vectores/mask_study.gpkg")

##
vect_patches <- rast_patches; vect_patches[vect_patches <2] <- NA
vect_patches <- as.polygons(vect_patches, aggregate = FALSE)

vect_patches.2 <- disagg(vect_patches)
vect_patches.2$area <- expanse(vect_patches.2, unit = "km")
vect_patches.2$impact <- 0
vect_patches.2$impact[which(vect_patches.2$area <= 1)] <- 0.55
vect_patches.2$impact[which(vect_patches.2$area > 1 & vect_patches.2$area <= 10)] <- 0.25
vect_patches.2$impact[which(vect_patches.2$area > 10 & vect_patches.2$area <= 100)] <- 0.15
vect_patches.2$impact[which(vect_patches.2$area > 100 & vect_patches.2$area <= 1000)] <- 0.05
invisible(gc())

#Malla
box_vect <- st_bbox(vect_patches.2) %>% st_as_sfc() %>% st_as_sf()
box_grid <- st_make_grid(box_vect, square = T)  %>% st_sf() %>% st_cast("POLYGON")
impact_size <- list()

for(i in 1:nrow(box_grid)){
  print(i)
  x.1 <- crop(vect_patches.2, vect(box_grid[i,]))
  if(nrow(x.1) > 0){
    referencia <- crop(rast_patches, vect(box_grid[i,])) * 0
    x.2 <- rasterize(x.1, referencia, field = "impact")    
  } else {
    x.2 <- NULL
  }
  impact_size[[i]] <- x.2
}

rsrc <- sprc(purrr::compact(impact_size)); invisible(gc())
m <- mosaic(rsrc, fun = "max")
m[is.na(m)] <- 1; m <- mask(m, rast_mask)
writeRaster(m, "/3. Análisis de la transformación del hábitat en el paisaje Pacífico Central (2017-2023)/Variables/PatchSize_impact_2019.tif", overwrite = TRUE)

####Whitebox
library(whitebox)
rast_patches <- rast("./Bosque/Bosque_2023_bosque.tif")
rast_mask <- vect("/Vectores/mask_study.gpkg")

##
rast_patches <- rast_patches; rast_patches[rast_patches <2] <- NA
writeRaster(rast_patches, "./Bosque/Bosque_2023_bosque.tif")

wbt_clump(input = "./Bosque/Bosque_2023_bosque.tif", output = "./Bosque/Bosque_2023_bosque_clump.tif")
wbt_raster_area(input = "./Bosque/Bosque_2023_bosque_clump.tif", output = "./Bosque/Bosque_2023_bosque_clump_area.tif")
area_patches <- rast("./Bosque/Bosque_2023_bosque_clump_area.tif")


#1 ha = 10000m2 / (10*10 de un pixel) = 100
area_patches[area_patches<=100] <- 0.55
#10 ha = 100000m2 / (10*10 de un pixel) = 1000
area_patches[area_patches>100 & area_patches <= 1000] <- 0.25
#100 ha = 1e+6m2 / (10*10 de un pixel) = 10000
area_patches[area_patches>1000 & area_patches <= 10000] <- 0.15
#1000 ha = 1e+7m2 / (10*10 de un pixel) = 1e+05
area_patches[area_patches>10000 & area_patches <= 1e+05] <- 0.05
#>1000 ha
area_patches[area_patches>1e+05] <- 0
#
area_patches <- rast("/3. Análisis de la transformación del hábitat en el paisaje Pacífico Central (2017-2023)/Variables/PatchSize_impact_2023.tif")

area_patches[is.na(area_patches)] <- 1
plot(area_patches)

area_patches.2 <- mask(area_patches, rast_mask)
plot(area_patches.2)

writeRaster(area_patches.2, "/3. Análisis de la transformación del hábitat en el paisaje Pacífico Central (2017-2023)/Variables/PatchSize_impact_2023.tif", overwrite = TRUE)
