# Wczytanie danych
dane <- read.csv("http://archive.ics.uci.edu/ml/machine-learning-databases/iris/iris.data", header = FALSE)
colnames(dane) <- c("DlugoscPlatka", "SzerokoscPlatka", "DlugoscLodygi", "SzerokoscLodygi", "Gatunek")

# Podział na zbiór treningowy i testowy
set.seed(111)
indeksy_treningowe <- sample(1:nrow(dane), nrow(dane)*0.7)
dane_treningowe <- dane[indeksy_treningowe, ]
dane_testowe <- dane[-indeksy_treningowe, ]

# Budowanie drzewa decyzyjnego
library(rpart)
drzewo <- rpart(Gatunek ~ ., data = dane_treningowe, method = "class")
print(drzewo)

# Wyświetlanie drzewa graficznie
library(rpart.plot)
rpart.plot(drzewo, extra = 1)

# Wyjaśnienie reguł
cat("Reguły drzewa decyzyjnego:\n")
printcp(drzewo)

rules <- rpart.rules(drzewo)
print(rules)

# Macierz błędów
prognozy <- predict(drzewo, dane_testowe, type = "class")

macierz_bledow <- table(dane_testowe$Gatunek, prognozy)
print(macierz_bledow)

# Ile błędów popełnił algorytm
ile_bledow <- sum(dane_testowe$Gatunek != prognozy)
cat("Ilość błędów: ", ile_bledow, "\n")

# Procent dobrze odgadniętych odpowiedzi
procent_dobrze <- sum(dane_testowe$Gatunek == prognozy) / nrow(dane_testowe) * 100
cat("Procent dobrze rozpoznanych gatunków: ", procent_dobrze, "%\n")


