library(terra)
getwd() #asegurar que en la ruta estan los archivos exportados de GEE (2 o 3 archivos por cada año analizado) y el shapefile del area de estudio

# Importar a R los raster generados por GEE para el 2018. Estos productos intermedio no se proporcionan. Si los requiere por favor solicitarlos.
r2018_a <- rast("2019a.tif")  
r2018_b <- rast("2019b.tif")
r2018_c <- rast("2019c.tif")

# Importar a R los raster generados por GEE para el 2023.Estos productos intermedio no se proporcionan. Si los requiere por favor solicitarlos.
r2023_a <- rast("2023a.tif")  
r2023_b <- rast("2023b.tif") 
r2023_c <- rast("2023c.tif")  

# Importar area de estudio en formato vector corregido
aoi <- vect("./Cartografia_metadatos/aoi.shp") #

map2018 <- mosaic(r2019_a,r2019_b,r2019_c)
map2023 <- mosaic(r2023_a,r2023_b,r2023_c)

cm2018 <- crop(map2018, aoi, mask=TRUE) 
cm2023 <- crop(map2023, aoi, mask=TRUE)

plot(cm2019)
plot(cm2023)

#Guardar como INT1U (0-255)
writeRaster(cm2018, filename = "./2019_Class_utm.tif", datatype = "INT1U")
writeRaster(cm2023, filename = "./2023_Class_utm.tif", datatype = "INT1U")
