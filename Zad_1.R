# Wczytanie biblioteki MASS i załadowanie zbioru danych Cars93
library(MASS)
library(e1071)
library(plotly)
library(corrplot)
data(Cars93)

wybrane_kolumny <- Cars93[, c("Min.Price", "MPG.city", "MPG.highway", "Weight", "Origin", "Type")]
print(wybrane_kolumny)

# Tworzenie nowych zmiennych w tablicy Cars 93: zużycie paliwa w litrach na 100 
# km w mieście i na autostradzie,waga samochodu w kg oraz cena wersji podstawowej 
# w tys. PLN
Cars93$Fuel_usage.city <- 3.8 / Cars93$MPG.city * 100 / 1.6
Cars93$Fuel_usage.highway <- 3.8 / Cars93$MPG.highway * 100 / 1.6
Cars93$Weight.kg <- Cars93$Weight * 0.4536
Cars93$Price.PLN <- Cars93$Price * 3.35

# Podstawowe statystyki próbkowe dla danych opisujących cenę wersji podstawowej samochodu
summary(Cars93$Price.PLN)


wybrane_kolumny_kor <- Cars93[, c("Min.Price", "MPG.city", "MPG.highway", "Weight")]

# Oblicz macierz korelacji
macierz_korelacji <- cor(wybrane_kolumny_kor)

# Wyświetl macierz korelacji
print(macierz_korelacji)

# Wygeneruj graficzną reprezentację macierzy korelacji
corrplot(macierz_korelacji, method = "circle")

# Obliczanie skośności
skosnosc <- skewness(Cars93$Price.PLN)
print(skosnosc)

# Obliczanie kurtozy
kurtoza <- kurtosis(Cars93$Price.PLN)
print(kurtoza)

# Kwantyl rzędu 0.95 dla cen wersji podstawowej samochodów
quantile_95_price <- quantile(Cars93$Price.PLN, 0.95)
print(quantile_95_price)

# Zidentyfikowanie modeli samochodów, których dotyczą te ceny
models <- subset(Cars93, Price.PLN > quantile_95_price, select=c(Manufacturer, Model, Price.PLN))
print(models)

# Narysowanie wykresu słupkowego dla zmiennej Type
barplot(table(Cars93$Type), main="Wykres słupkowy dla zmiennej Type", xlab="Type", ylab="Liczba samochodów")

# Narysowanie wykresu kołowego dla zmiennej Type
pie(table(Cars93$Type), main="Wykres kołowy dla zmiennej Type")

# Obliczenie liczby samochodów z kategorii sportowe
Sporty_cnt <- table(Cars93$Type)["Sporty"]
print(Sporty_cnt)

# Wykresy pudełkowe dla zużycia benzyny w mieście osobno dla samochodów amerykańskich i nieamerykańskich
boxplot(Fuel_usage.city ~ Origin, data=Cars93, main="Zużycie benzyny w mieście", xlab="Pochodzenie", ylab="Zużycie (l/100km)")

usa <- subset(Cars93, Origin == "USA")
non_usa <- subset(Cars93, Origin != "USA")
summary(usa$Fuel_usage.city)
summary(non_usa$Fuel_usage.city)

# Tworzenie wykresu 1: Cena podstawowa vs. Zużycie benzyny w mieście
plot1 <- plot_ly(Cars93, x = ~Fuel_usage.city, y = ~Price.PLN, type = "scatter", mode = "markers", name = "Cena vs. Zużycie w mieście")

# Dodawanie współczynnika korelacji
corr1 <- cor(Cars93$Fuel_usage.city, Cars93$Price.PLN)
text1 <- paste("Współczynnik korelacji:", round(corr1, 2))
plot1 <- plot1 %>% layout(annotations = list(x = 5, y = 180, text = text1))

# Dodawanie opisów osi
plot1 <- plot1 %>% layout(xaxis = list(title = "Zużycie benzyny w mieście"), yaxis = list(title = "Cena podstawowa"))

# Tworzenie wykresu 2: Zużycie w mieście vs. Zużycie na autostradzie
plot2 <- plot_ly(Cars93, x = ~Fuel_usage.highway, y = ~Fuel_usage.city, type = "scatter", mode = "markers", name = "Zużycie w mieście vs. na autostradzie")

# Dodawanie współczynnika korelacji
corr2 <- cor(Cars93$Fuel_usage.highway, Cars93$Fuel_usage.city)
text2 <- paste("Współczynnik korelacji:", round(corr2, 2))
plot2 <- plot2 %>% layout(annotations = list(x = 3, y = 14, text = text2))

# Dodawanie opisów osi
plot2 <- plot2 %>% layout(xaxis = list(title = "Zużycie benzyny na autostradzie"), yaxis = list(title = "Zużycie benzyny w mieście"))

# Tworzenie subplotu
subplot <- subplot(plot1, plot2, nrows = 2)

# Wyświetlenie subplotu
subplot

model <- lm(Fuel_usage.highway ~ Fuel_usage.city, data = Cars93)
summary(model)

# Narysowanie histogramu częstości dla danych dotyczących wagi samochodu
hist(Cars93$Weight.kg, main="Histogram częstości dla wagi samochodu", xlab="Waga samochodu (kg)", ylab="Częstość")

