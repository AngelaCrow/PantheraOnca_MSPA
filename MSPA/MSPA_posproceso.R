
# Establecer el directorio de trabajo
setwd("/MSPA")

# Leer el ráster original para usarlo como mascara
m <- terra::rast("../Bosque/Bosque_2019.tif")

# Definir la matriz de reglas de clasificación y aplicar la clasificación al ráster original
rclmat_M <- matrix(c(0, 1, NA, 1, 5, 1))
m <- terra::classify(m, rclmat_M)

# Definir la matriz de reglas de clasificación
rclmat <- matrix(c(-Inf, 0, 0,
                   0, 1, 7,
                   1, 3, 4,
                   3, 5, 3,
                   5, 9, 2,
                   9, 17, 1,
                   17, 33, 6,
                   33, 35, 6,
                   35, 37, 6,
                   37, 65, 5,
                   65, 67, 5,
                   69, 69, 5,
                   69, 100, 0,
                   100, 101, 7,
                   101, 103, 4,
                   103, 105, 3,
                   105, 109, 2,
                   109, 117, 1,
                   117, 129, NA,
                   129, 133, 6,
                   133, 135, 6,
                   135, 137, 6,
                   137, 165, 5,
                   165, 167, 5,
                   167, 169, 5,
                   169, Inf, 0), ncol = 3, byrow = TRUE)

# Nombres para las clases 
nombres <- data.frame(
  value = c(0, 1, 2, 3, 4, 5, 6, 7),
  nombre = c("Background", "Core", "Islet", "Perforation", "Edge", "Loop", "Bridge", "Branch")
)

# Leer el ráster específico para el año 2019
mspa2019 <- terra::rast("MSPA/output2019/Bosque_2019_8_1_1_1.tif")

# Definir la tabla de clasificación y aplicarla al ráster de 2019
rc2019 <- terra::classify(mspa2019, rclmat, include.lowest = TRUE)
# Recortar el raster con la mascara: m
rc2019 <- terra::mask(terra::crop(rc2019, m), m)

# Mostrar y guardar el resultado de la clasificación para 2019
terra::plot(rc2019)
terra::writeRaster(rc2019, "mspa2019_rcl.tif", overwrite = TRUE)
# Calcular el numero de pixeles por categoria.
table_mspa2019 <- terra::freq(rc2019)
# Unir la tabla de frecuencias con la tabla de nombres
table_mspa2019 <- dplyr::left_join(table_mspa2019, nombres, by = c("value" = "value"))%>% dplyr::mutate("Year" = 2019) %>% dplyr::select(-c("layer"))

table_mspa2019 <- table_mspa2019 %>%
  dplyr::mutate(Percentage = count / sum(count) * 100)

rm(mspa2019)

# Leer el ráster específico para el año 2023
mspa2023 <- terra::rast("MSPA/output2023/Bosque_2023_8_1_1_1.tif")
# Aplicar la clasificación al ráster de 2023
rc2023 <- terra::classify(mspa2023, rclmat)
rc2023 <- terra::mask(terra::crop(rc2023, m), m)

# Mostrar y guardar el resultado de la clasificación para 2023
terra::plot(rc2023)
terra::writeRaster(rc2023, "mspa2023_rcl.tif", overwrite = TRUE)
table_mspa2023 <- terra::freq(rc2023)
table_mspa2023 <- dplyr::left_join(table_mspa2023, nombres, by = c("value" = "value")) %>% dplyr::mutate("Year" = 2023) %>% dplyr::select(-c("layer"))

table_mspa2023 <- table_mspa2023 %>%
  dplyr::mutate(Percentage = count / sum(count) * 100)

rm(mspa2023)

# Crear un gráfico de barras agrupadas
df<-rbind(table_mspa2019,table_mspa2023) 
write.csv(df,"Tabla_cambiosMSPA.csv", row.names = F)

df<-dplyr::filter(df,nombre != "Background")

ggplot(df, aes(x = nombre, y = Percentage, fill = factor(Year))) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Cambio en cada categoría",
       x = "Categoría",
       y = "Porcentaje de área",
       fill = "Año") +
  scale_fill_manual(values = c("2019" = "lightblue", "2023" = "blue")) +  # Colores para cada año
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 0, hjust = 0.5))  # Rotar etiquetas del eje x para mejor legibilidad
