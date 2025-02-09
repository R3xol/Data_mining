# Wczytanie danych
data <- read.delim("C:/Users/lyzwi/OneDrive/Dokumenty/R_programing/airpollution.txt", header = TRUE, sep = "\t", dec = ".")

# Statystyczna analiza
summary<-summary(data[, c("Mortality","Education", "income","JanTemp", "NOx" , "X.NonWhite")])
print(summary)

zmienne <- data[, c("Mortality","Education", "income","JanTemp", "NOx" , "X.NonWhite")]

# Oblicz macierz korelacji
macierz_korelacji <- cor(zmienne, use = "complete.obs")

# Wyświetl macierz korelacji
print(macierz_korelacji)

# Wygeneruj graficzną reprezentację macierzy korelacji
corrplot(macierz_korelacji, method = "circle")


# (b) Dopasowanie modelu liniowego: Mortality ~ NOx
model1 <- lm(Mortality ~ NOx, data = data)

# Współczynnik nachylenia
coef1 <- coef(model1)[2]
# Błąd standardowy współczynnika nachylenia
stderr1 <- summary(model1)$coefficients["NOx", "Std. Error"]

# Sprawdzenie dopasowania modelu
summary(model1)

# (c) Dopasowanie modelu liniowego: Mortality ~ log(NOx)
model2 <- lm(Mortality ~ log(NOx), data = data)

# Współczynnik nachylenia
coef2 <- coef(model2)[2]
# Błąd standardowy współczynnika nachylenia
stderr2 <- summary(model2)$coefficients["log(NOx)", "Std. Error"]

# Sprawdzenie dopasowania modelu
summary(model2)

# (d) Znalezienie obserwacji o dużych residuach studentyzowanych
outliers <- which(abs(rstudent(model2)) > 2)

# Nowy model pomijający obserwacje odstające
new_data <- data[-outliers, ]
new_model2 <- lm(Mortality ~ log(NOx), data = new_data)

# Współczynnik nachylenia
coef3 <- coef(new_model2)[2]
# Błąd standardowy współczynnika nachylenia
stderr3 <- summary(new_model2)$coefficients["log(NOx)", "Std. Error"]

# Sprawdzenie dopasowania modelu
summary(new_model2)

# Porównanie wartości współczynnika R^2 dla obu modeli
r_squared_old <- summary(model2)$r.squared
r_squared_new <- summary(new_model2)$r.squared

# Wykonanie wykresów
library(ggplot2)

# Wykres dla modelu 1: Mortality ~ NOx
plot1 <- ggplot(data, aes(x = NOx, y = Mortality)) +
  geom_point() +
  geom_smooth(method = "lm", se = TRUE) +
  labs(title = "",
       x = "NOx",
       y = "Mortality")
  scale_fill_manual(values = "blue", name = NULL)

# Wykres dla modelu 2: Mortality ~ log(NOx)
plot2 <- ggplot(data, aes(x = log(NOx), y = Mortality)) +
  geom_point() +
  geom_smooth(method = "lm", se = TRUE) +
  labs(title = "",
       x = "log(NOx)",
       y = "Mortality")
  scale_fill_manual(values = "blue", name = NULL)

plot3 <- ggplot(new_data, aes(x = log(NOx), y = Mortality)) +
  geom_point() +
  geom_smooth(method = "lm", se = TRUE) +
  labs(title = "",
       x = "log(NOx)",
       y = "Mortality") +
  scale_fill_manual(values = "blue", name = NULL)

print(plot3)

plot1
plot2
plot3

