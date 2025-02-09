# Instalacja i załadowanie biblioteki readr
library(readr)

# Wczytanie danych
dane <- read.delim("C:/Users/lyzwi/OneDrive/Dokumenty/R_programing/gala_data.txt", header = TRUE, sep = ",", dec = ".")

# Oblicz macierz korelacji
macierz_korelacji <- cor(dane)

# Wyświetl macierz korelacji
print(macierz_korelacji)

# Wygeneruj graficzną reprezentację macierzy korelacji
corrplot(macierz_korelacji, method = "circle")

# (a) Dopasowanie modelu liniowego
model <- lm(Species ~ Area + Elevation + Nearest + Scruz + Adjacent, data = dane)
summary(model)

# Diagnostyka modelu
par(mfrow = c(2, 2))
plot(model)

# Wykres reszt
plot(model, which = 1)

# (b) Spierwiastkowanie zmiennej objaśnianej
dane$Species_sqrt <- sqrt(dane$Species)
model_sqrt <- lm(Species_sqrt ~ Area + Elevation + Nearest + Scruz + Adjacent, data = dane)
summary(model_sqrt)

# Wykres reszt
plot(model_sqrt, which = 1)

# Diagnostyka nowego modelu
par(mfrow = c(2, 2))
plot(model_sqrt)

# Zmienna o największym p-value
p_values <- summary(model_sqrt)$coefficients[, "Pr(>|t|)"]
max_p_value_var <- names(which.max(p_values[-1]))  # -1 to exclude intercept
cat("Zmienna o największym p-value: ", max_p_value_var, "\n")

# Usunięcie zmiennej z modelu
reduced_model_formula <- as.formula(paste("Species_sqrt ~", paste(names(dane)[!names(dane) %in% c("Endemics","Species", "Species_sqrt", max_p_value_var)], collapse = " + ")))
print(reduced_model_formula)
reduced_model <- lm(reduced_model_formula, data = dane)
summary(reduced_model)

# Diagnostyka modelu
par(mfrow = c(2, 2))
plot(reduced_model)

# Wykres reszt
plot(reduced_model, which = 1)

# Porównanie współczynników determinacji
cat("Współczynnik determinacji modelu pierwotnego: ", summary(model)$r.squared, "\n")
cat("Współczynnik determinacji modelu spierwiastkowanego: ", summary(model_sqrt)$r.squared, "\n")
cat("Współczynnik determinacji modelu zredukowanego: ", summary(reduced_model)$r.squared, "\n")
cat("Zmodyfikowany współczynnik determinacji modelu pierwotnego: ", summary(model)$adj.r.squared, "\n")
cat("Zmodyfikowany współczynnik determinacji modelu spierwiastkowanego: ", summary(model_sqrt)$adj.r.squared, "\n")
cat("Zmodyfikowany współczynnik determinacji modelu zredukowanego: ", summary(reduced_model)$adj.r.squared, "\n")
