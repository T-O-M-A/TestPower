# Objectif de l'étape 1:
# Déterminer la taille d'effet du cas incongruent sur le cas congruent.
# On part d'un nombre fixé d'observations, ici n = 1000, et on les duplique en utilisant du Bootstrap :
#   Un grand nombre de fois (ici 3000), on va sélectionner 800 observations aléatoirement sur ces 1000,
#   et on va calculer la taille d'effet observée sur ce tirage d'observation.
#   Le alpha et la puissance (donc le beta) sont fixés, ce qui permet de calculer la taille d'effet nécessaire
#   pour avoir une telle puissance étant donné ce alpha.
#   Dans les faits, on tri les valeurs des 800 observations considérées, et la taille d'effet correspond à
#   la différence entre la (1-alpha)ième valeurs et la (1-beta)ième.
# Une fois le calcul effectué pour chaque itération du Bootstrap, on estime la taille d'effet désirée par 
# la moyenne des tailles d'effets obtenues précédemments.


tailledeffet<-function(mean, var, alpha, puissance)
{
  norm <- rnorm(1000, mean, var)
  
  meanu <- 1:3000
  for (i in 1:3000) {
    rand <- sample(1:1000, 800)
    rnormboot <- norm[rand]
    tri <- sort(rnormboot)
    max <- round((1-alpha)*length(rnormboot))
    min <- round((1-puissance)*length(rnormboot))
    umax <- tri[max]
    umin <- tri[min+1]
    meanu[i] <- umax - umin
  }

  hist(meanu,main="Histogramme de Taille d'Effet",xlab="Taille d'effet",ylab="Densité",ylim=c(0,20/sqrt(var)),proba=T)
  
  return(mean(meanu))
}

te<-tailledeffet(10,1, 0.05, 0.9)
te