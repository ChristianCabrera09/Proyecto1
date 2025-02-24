# Datos climáticos
# Cargar los paquetes 
library(dplyr)
library(ggplot2)
library(hrbrthemes)
library(grid)
library(gridExtra)

# Se carga el archivo csv con el que se va a trabajar y se fija el directorio para tener los datos disponibles todo el tiempo
datos <- read.csv("liberia_datos_climaticos.csv", na.strings = "", sep = ",", dec = ",")

# Ahora bien, con el comando head y dim se van ver los datos generales de el archivo 
head(datos)
dim(datos)

# El siguiente comando mediante permite indagar mejor dentro del archivo csv ya que este posee NA
datos[!complete.cases(datos),]

# Se limpia el archivo de NA
datos <- na.omit(datos)

# Para un mejor manejo de la informacion y del trabajo se van a nombrar los encabezados de las columnas
names(datos) <- c("Fecha","Temperatura", "Humedad", "Vel.Viento", "Lluvia", "Irradiacion", "EvapoTranspiracion")

# A continuacion, se generaran los histogramas de cada columna.
hist1 <- ggplot(datos, aes(x = Temperatura)) +
  geom_histogram(binwidth = 0.2,
                 col = 'black',
                 fill = 'orange') +
  ggtitle('Temperatura') +
  xlab('Grados Celcius') +
  ylab('Frecuencia') +
  theme_ipsum()

hist2 <- ggplot(datos, aes(x = Humedad)) +
  geom_histogram(binwidth = 2,
                 col = 'black',
                 fill = 'blue') +
  ggtitle('Humedad relativa') +
  xlab('% de humedad relativa') +
  ylab('Frecuencia') +
  theme_ipsum()

hist3 <- ggplot(datos, aes(x = Vel.Viento)) +
  geom_histogram(binwidth = 1,
                 col = 'black',
                 fill = 'gray') +
  ggtitle('Velocidad del viento') +
  xlab('Velocidad en m/s') +
  ylab('Frecuencia') +
  theme_ipsum()

hist4 <- ggplot(datos, aes(x = Lluvia)) +
  geom_histogram(binwidth = 5,
                 col = 'black',
                 fill = '#339999') +
  ggtitle('Cantidad de lluvia') +
  xlab('Cant. de lluvia en mm') +
  ylab('Frecuencia') +
  theme_ipsum()

hist5 <- ggplot(datos, aes(x = Irradiacion)) +
  geom_histogram(binwidth = 7,
                 col = 'black',
                 fill = 'yellow') +
  ggtitle('Niveles de irradiacion') +
  xlab('Irradiacion en W/m2') +
  ylab('Frecuencia') +
  theme_ipsum()

hist6 <- ggplot(datos, aes(x = EvapoTranspiracion)) +
  geom_histogram(binwidth = 1,
                 col = 'black',
                 fill = 'green') +
  ggtitle('Cantidad de EvapoTranspiracion') +
  xlab('Cant. de EvapoTranspiracion en mm') +
  ylab('Frecuencia') +
  theme_ipsum()

# Una vez graficados los histogramas uno a uno se unifican en un solo grafico con el comando grind.arrange
grid.arrange(hist1, hist2, hist3, hist4, hist5, hist6)

# Seguidamente mediante los comandos select(), mutate(), group_by() y summarise() se promedia mensualmente cada variable, y la sumatoria de la lluvia y la EvapoTranspiracion, cabe recalcar que estas ultimas dos se encuentran en mm, todo esto se realiza con un data.frame 
Temperatura_mensual <-
  datos %>%
  select(Fecha, Temperatura) %>%
  mutate(Fecha = as.Date(Fecha, format = "%d/%m/%Y")) %>%
  group_by(mes = format(Fecha, "%m")) %>%
  summarise(prom_temp = mean(Temperatura))

Humedad_mensual <-
  datos %>%
  select(Fecha, Humedad) %>%
  mutate(Fecha = as.Date(Fecha, format = "%d/%m/%Y")) %>%
  group_by(mes = format(Fecha, "%m")) %>%
  summarise(prom_hum = mean(Humedad))

Vel.Viento_mensual <-
  datos %>%
  select(Fecha, Vel.Viento) %>%
  mutate(Fecha = as.Date(Fecha, format = "%d/%m/%Y")) %>%
  group_by(mes = format(Fecha, "%m")) %>%
  summarise(prom_viento = mean(Vel.Viento))

Irradiacion_mensual <-
  datos %>%
  select(Fecha, Irradiacion) %>%
  mutate(Fecha = as.Date(Fecha, format = "%d/%m/%Y")) %>%
  group_by(mes = format(Fecha, "%m")) %>%
  summarise(prom_irrad = mean(Irradiacion))

Lluvia_mensual <-
  datos %>%
  select(Fecha, Lluvia) %>%
  mutate(Fecha = as.Date(Fecha, format = "%d/%m/%Y")) %>%
  group_by(mes = format(Fecha, "%m")) %>%
  summarise(sum_lluvia = sum(Lluvia))

EvapoTranspiracion_mensual <-
  datos %>%
  select(Fecha, EvapoTranspiracion) %>%
  mutate(Fecha = as.Date(Fecha, format = "%d/%m/%Y")) %>%
  group_by(mes = format(Fecha, "%m")) %>%
  summarise(sum_evapo = sum(EvapoTranspiracion))

# Luego de haberse promediado por mes cada variable por medio del data.frame anterior, se crean los gráficos de estos
grafico1 <- ggplot(Temperatura_mensual, aes(x = mes, y = prom_temp, group = 1)) +
  ggtitle('Promedio de temperatura mensual en Liberia 2015-2019') +
  xlab('Meses') +
  ylab('Grados Celsius') +
  geom_point(colour = "yellow", size = 2) + 
  geom_line(colour = "yellow", size  = 1)

grafico2 <- ggplot(Humedad_mensual, aes(x = mes, y = prom_hum, group = 1)) +
  ggtitle('Promedio de porcentaje de humedad mensual en Liberia 2015-2019') +
  xlab('Meses') +
  ylab('Porcentaje de humedad relativa') +
  geom_point(colour = "#009900", size = 2) + 
  geom_line(colour = "#009900", size = 1)

grafico3 <- ggplot(Vel.Viento_mensual, aes(x = mes, y = prom_viento, group = 1)) +
  ggtitle('Promedio de velocidad del viento mensual en Liberia 2015-2019') +
  xlab('Meses') +
  ylab('Velocidad del viento (m/s)') +
  geom_point(colour = "#ff6600", size = 2) + 
  geom_line(colour = "#ff6600", size = 1)

grafico4 <- ggplot(Irradiacion_mensual, aes(x = mes, y = prom_irrad, group = 1)) +
  ggtitle('Niveles de irradiacion mensual en Liberia 2015-2019') +
  xlab('Meses') +
  ylab('Nivel de irradiacion (w/m2)') +
  geom_point(colour = "purple", size = 2) + 
  geom_line(colour = "purple", size = 1)

grafico5 <- ggplot(Lluvia_mensual, aes(x = mes, y = sum_lluvia, group = 1)) +
  ggtitle('Sumatoria mensual de la Lluvia en Liberia 2015-2019') +
  xlab('Meses') +
  ylab('Cantidad de Lluvia (mm)') +
  geom_point(colour = "#339999", size = 2) + 
  geom_line(colour = "#339999", size = 1) 

grafico6 <- ggplot(EvapoTranspiracion_mensual, aes(x = mes, y = sum_evapo, group = 1)) +
  ggtitle('Sumatoria mensual de la EvapoTranspiracion en Liberia 2015-2019') +
  xlab('Meses') +
  ylab('Cantidad de EvapoTranspiracion (mm)') +
  geom_point(colour = "black", size = 2) + 
  geom_line(colour = "black", size = 1) 

# Una vez creados los graficos se unifican en un mismo grafico con el comando grid.arrange
grid.arrange(grafico1, grafico2, grafico3, grafico4, grafico5, grafico6)

#Para finalizar se compara la información de variables entre si, mediante una nube de puntos, para esto primero se crea un data.frame nuevo que contenga la información promediada de cada mes de los cuatro años, es decir, el promedio mensual de 51 meses desde enero 2015 hasta marzo 2019
Data_anual <- 
  datos %>%
  select(Fecha, Temperatura, Humedad, Vel.Viento, Lluvia, Irradiacion, EvapoTranspiracion) %>%
  mutate(Fecha = as.Date(Fecha, format = "%d/%m/%Y")) %>%
  group_by(meses = format(Fecha, "%m/%Y")) %>%
  summarise(temp_anual = mean(Temperatura),
            hume_anual = mean(Humedad),
            viento_anual = mean(Vel.Viento),
            lluv_anual = mean(Lluvia),
            irrad_anual = mean(Irradiacion),
            evapo_anual = mean(EvapoTranspiracion))

#Con este nuevo data.frame se grafican las variables entre si, a cada grafico se le asigna un nombre para poder utilizar el comando grid.arrange
point1 <- ggplot(Data_anual, aes(x = evapo_anual, y = lluv_anual)) +
  geom_point(colour = 'blue') +
  ggtitle('Relación entre la Lluvia y la EvapoTranspiración') +
  xlab('EvapoTranspiración') +
  ylab('Lluvia') +
  theme_ipsum(
    grid = "Y, y"
  )

point2 <- ggplot(Data_anual, aes(x = hume_anual, y = temp_anual)) +
  geom_point(colour = '#009900') +
  ggtitle('Relación entre la Humedad y la Temperatura') +
  xlab('Humedad') +
  ylab('Temperatura') +
  theme_ipsum(
    grid = "Y, y"
  )

point3 <- ggplot(Data_anual, aes(x = evapo_anual, y = hume_anual)) +
  geom_point(colour = '#cc0066') +
  ggtitle('Relación entre la Humedad y la EvapoTranspiración') +
  xlab('EvapoTranspiración') +
  ylab('Humedad') +
  theme_ipsum(
    grid = "Y, y"
  )

point4 <- ggplot(Data_anual, aes(x = temp_anual, y = irrad_anual)) +
  geom_point(colour = '#cc6600') +
  ggtitle('Relación entre la Temperatura y la Irradiación') +
  xlab('Temperatura') +
  ylab('Irradiación') +
  theme_ipsum(
    grid = "Y, y"
  )

point5 <- ggplot(Data_anual, aes(x = hume_anual, y = viento_anual)) +
  geom_point(colour = '#00cccc') +
  ggtitle('Relación entre la Humedad y la Velocidad del Viento') +
  xlab('Humedad') +
  ylab('Velocidad del Viento') +
  theme_ipsum(
    grid = "Y, y"
  )

point6 <- ggplot(Data_anual, aes(x = hume_anual, y = lluv_anual)) +
  geom_point(colour = '#cc00ff') +
  ggtitle('Relación entre la Humedad y la Lluvia') +
  xlab('Humedad') +
  ylab('Lluvia') +
  theme_ipsum(
    grid = "Y, y"
  )

#Como ultimo paso se unifican las nubes de puntos con el comando grid.arrange
grid.arrange(point1, point2, point3, point4, point5, point6,
             top = textGrob(
               gp = gpar(fontface = 2, fontsize = 23),
               "NUBES DE PUNTOS DE LA RELACIÓN DE LAS VARIABLES ENTRE SI LIBERIA 2015-2019"))