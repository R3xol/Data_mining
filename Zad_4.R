# Instalacja i załadowanie biblioteki readr
library(readr)
library(corrplot)

# Wczytanie danych
dane <- read.delim("C:/Users/lyzwi/OneDrive/Dokumenty/R_programing/realest.txt", header = TRUE, sep = ",", dec = ".")

# (a) Dopasowanie modelu liniowego
model <- lm(Price ~ Bedroom + Space + Room + Lot + Tax + Bathroom + Garage + Condition, data = dane)
summary(model)

# Oblicz macierz korelacji
macierz_korelacji <- cor(dane)

# Wyświetl macierz korelacji
print(macierz_korelacji)

# Wygeneruj graficzną reprezentację macierzy korelacji
corrplot(macierz_korelacji, method = "circle")

# Wpływ zwiększenia liczby sypialni o 1
cat("Wpływ zwiększenia liczby sypialni o 1: ", coef(model)["Bedroom"], "\n")

# Model liniowy opisujący zależność ceny domu jedynie od liczby sypialni
model_bedroom <- lm(Price ~ Bedroom, data = dane)
summary(model_bedroom)

# Wykonanie wykresów
library(ggplot2)

# Wykres
plot <- ggplot(dane, aes(x = Bedroom, y = Price)) +
  geom_smooth(method = "lm", se = TRUE) +
  geom_point() +
  labs(title = "",
       x = "Liczba sypialni",
       y = "Cena")

plot

# Wykres
plot1 <- ggplot(dane, aes(x =  Bedroom + Space + Room + Lot + Tax + Bathroom + Garage + Condition, y = Price)) +
  geom_point() +
  geom_smooth(method = "lm", se = TRUE) +
  labs(title = "",
       x = "Bedroom + Space + Room + Lot + Tax + Bathroom + Garage + Condition",
       y = "Cena")
scale_fill_manual(values = "blue", name = NULL)

plot1


# Obliczenie statystyki wpływu
influence_stats <- influence.measures(model)

influence <- (influence_stats$infmat)

# Wyświetl statystyki wpływu
max_inf_Bedroom <- which.max(influence[, "dfb.Bthr"])

inf <- dane[max_inf_Bedroom,]

# Obserwacja o największym wpływie
print(inf)

high_cooks_distance <- which(influence[ ,"cook.d"]> 4 / nrow(dane))

print(dane[high_cooks_distance,])



# (b) Przewidywanie ceny domu
nowy_dom <- data.frame(Bedroom = 3, Space = 1500, Room = 8, Lot = 40, Tax = 1000, Bathroom = 5, Garage = 1, Condition = 0)
predykcja <- predict(model, newdata = nowy_dom)
cat("Przewidywana cena domu: ", predykcja, "\n")
