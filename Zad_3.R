library(corrplot)
library(ggplot2)
# Wczytanie danych
data <- read.delim("C:/Users/lyzwi/OneDrive/Dokumenty/R_programing/savings1.txt", header = TRUE, sep = ",", dec = ".")

# Statystyczna analiza
dane<-summary(data)
print(dane)

# Dane liczbowe
variable <- data[, c("sr", "dpi", "ddpi", "pop15", "pop75")]

# Oblicz macierz korelacji
macierz_korelacji <- cor(variable)

# Wyświetl macierz korelacji
print(macierz_korelacji)

# Wygeneruj graficzną reprezentację macierzy korelacji
corrplot(macierz_korelacji, method = "circle")

# Dopasowanie modelu liniowego
model <- lm(sr ~ dpi + ddpi + pop15 + pop75, data = data)

# Wyświetlenie podsumowania modelu
summary(model)

# Wykres reszt
plot(model, which = 1)

# Znalezienie krajów z najmniejszą i największą wartością reszt
min_reszta <- which.min(residuals(model))
max_reszta <- which.max(residuals(model))

cat("Kraj z najmniejszą wartością reszt:", data[min_reszta, "Country"], "\n")
cat("Kraj z największą wartością reszt :", data[max_reszta, "Country"], "\n")

leverage <- hatvalues(model)
# Narysowanie wartości dźwigni
plot(leverage)

# Wyświetlenie krajów z dużymi wartościami dźwigni
high_leverage <- which(leverage > 2 * (ncol(variable) + 1) / nrow(variable))
cat("Kraje z dużymi wartościami dźwigni:", data[high_leverage, "Country"],sep = ", ", "\n")

# Wyznaczenie reszt studentyzowanych
stud_resid <- rstudent(model)
print(stud_resid)
plot(stud_resid)

# Wyświetlenie krajów z dużymi wartościami reszt studentyzowanych
high_resid <- which(abs(stud_resid) > 2 )
cat("Kraje z dużymi wartościami reszt studentyzowanych:", data[high_resid, "Country"],sep = ", ", "\n")

# Wartości miar DFFITS
dffits <- dffits(model)

# Wartości miar DFBETAS
dfbetas <- dfbetas(model)

# Odległości Cooka
cooks_distance <- cooks.distance(model)

# Znalezienie wpływowych wartości DFFITS, DFBETAS i odległości Cooka
high_dffits <- which(abs(dffits) > 2*sqrt((ncol(data) + 1) / nrow(data)))
high_dfbetas <- which(abs(dfbetas) > 2/sqrt(nrow(data)))
high_cooks_distance <- which(cooks_distance > 4 / nrow(data))

# Wyświetlenie krajów z dużymi wartościami miar DFFITS, DFBETAS i odległości Cooka
cat("Obserwacje wpływowe DFFITS:", data[high_dffits, "Country"],sep = ", ", "\n")
cat("Obserwacje wpływowe DFBETAS:", data[high_dfbetas, "Country"],sep = ", ", "\n")
cat("Duże odległości Cooka dla krajów:", data[high_cooks_distance, "Country"],sep = ", ", "\n")

# Znalezienie indeksu obserwacji o największej odległości Cooka
max_cook <- which.max(cooks_distance)

# Nowy model bez tej obserwacji
new_model <- lm(sr ~ dpi + ddpi + pop15 + pop75, data = data[-max_cook,])

# Porównanie modeli
summary(new_model)
summary(model)

# Wykres
plot1 <- ggplot(data, aes(x = dpi + ddpi + pop15 + pop75, y = sr)) +
  geom_point() +
  geom_smooth(method = "lm", se = TRUE) +
  labs(title = "",
       x = "dpi + ddpi + pop15 + pop75",
       y = "Savings")
plot1

data_without_cook <- data[-max_cook,]

# Wykres
plot2 <- ggplot(data_without_cook, aes(x = dpi + ddpi + pop15 + pop75, y = sr)) +
  geom_point() +
  geom_smooth(method = "lm", se = TRUE) +
  labs(title = "",
       x = "dpi + ddpi + pop15 + pop75",
       y = "Savings")
plot2

# Narysowanie wykresu zmian wartości współczynników przy zmiennych pop15 oraz pop75
# (f) Wykres zmian wartości współczynników
coef_pop15 <- coef(model)["pop15"]
coef_pop75 <- coef(model)["pop75"]
coef_pop15_bez_max_cooks <- coef(new_model)["pop15"]
coef_pop75_bez_max_cooks <- coef(new_model)["pop75"]
barplot(c(coef_pop15, coef_pop15_bez_max_cooks), names.arg = c("pop15", "pop15 bez max Cooks"), main = "Zmiana współczynnika pop15")
barplot(c(coef_pop75, coef_pop75_bez_max_cooks), names.arg = c("pop75", "pop75 bez max Cooks"), main = "Zmiana współczynnika pop75")

# Obliczenie statystyki wpływu
influence_stats <- influence.measures(new_model)

influence <- (influence_stats$infmat)

# Wyświetl statystyki wpływu
max_inf_15 <- which.max(influence[, "dfb.pp15"])
max_inf_75 <- which.max(influence[, "dfb.pp75"])
cat("Największy wpływ (pop15):", data[max_inf_15, "Country"], "\n")
cat("Największy wpływ (pop75):", data[max_inf_75, "Country"], "\n")



