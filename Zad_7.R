# Wczytanie danych
dane <- read.csv("http://archive.ics.uci.edu/ml/machine-learning-databases/iris/iris.data", header = FALSE)
colnames(dane) <- c("DlugoscPlatka", "SzerokoscPlatka", "DlugoscLodygi", "SzerokoscLodygi", "Gatunek")

library(caret)
# Normalizacja danych liczbowych min-max
process <- preProcess(as.data.frame(dane[, 1:4]), method=c("range"))

dane_norm <- predict(process, as.data.frame(dane[, 1:4]))
dane_norm$Gatunek <- dane$Gatunek

# Podział na zbiór treningowy i testowy
set.seed(111)
indeksy_treningowe <- sample(1:nrow(dane_norm), nrow(dane_norm)*0.7)
dane_treningowe <- dane_norm[indeksy_treningowe, ]
dane_testowe <- dane_norm[-indeksy_treningowe, ]

# Uruchomienie algorytmu k-NN
library(class)
k <- 3
prognozy <- knn(dane_treningowe[, 1:4], dane_testowe[, 1:4], dane_treningowe$Gatunek, k = k)

# Czy zmiana liczby sąsiadów powoduje zmianę klasyfikacji
k2 <- 6
prognozy2 <- knn(dane_treningowe[, 1:4], dane_testowe[, 1:4], dane_treningowe$Gatunek, k = k2)
cat("Czy zmiana liczby sąsiadów powoduje zmianę klasyfikacji? ", any(prognozy != prognozy2), "\n")

# Ewaluacja klasyfikatora i wyświetlenie macierzy błędów
macierz_bledow <- table(dane_testowe$Gatunek, prognozy)
print(macierz_bledow)

# Ile błędów popełnił algorytm
ile_bledow <- sum(dane_testowe$Gatunek != prognozy)
cat("Ilość błędów: ", ile_bledow, "\n")

# Dokładność klasyfikatora
dokladnosc <- sum(diag(macierz_bledow)) / sum(macierz_bledow)
cat("Dokładność klasyfikatora: ", dokladnosc*100, "%\n")

