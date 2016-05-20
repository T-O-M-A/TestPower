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

tailledeffet<-function(mean, var, alpha, puissance, n_observation, n_iteration, percent_bootstrap)
{
  norm <- rnorm(n_observation, mean, sqrt(var))
  
  meanu <- 1:n_iteration
  for (i in 1:n_iteration) {
    rand <- sample(1:n_observation, percent_bootstrap*n_observation)
    bootstrap <- norm[rand]
    tri <- sort(bootstrap)
    max <- round((1-alpha)*length(bootstrap))
    min <- round((1-puissance)*length(bootstrap))
    umax <- tri[max]
    umin <- tri[min]
    meanu[i] <- (umax - umin)/sqrt((percent_bootstrap*n_observation)*var(norm))
  }

  #hist(meanu,main="Histogramme de Taille d'Effet",xlab="Taille d'effet",ylab="Densité",ylim=c(0,20*sqrt(percent_bootstrap*n_observation/var(norm))),proba=T)
  
  return(mean(meanu))
}

# On répète le processus P précédent un bon nombre de fois pour estimer E[P], qui devrait être très proche
# de la taille d'effet réelle.
mean <- 0
var <- 1
alpha <- 0.05
puissance <- 0.99
n_observations <- 100
n_iteration <- 500
percent_bootstrap <- 0.8

tab <- 1:100
for (i in 1:100) {
te<-tailledeffet(mean,var, alpha, puissance, n_observation, n_iteration, percent_bootstrap)
tab[i] <- te
}

hist(tab,main="Histogramme des Moyennes de Taille d'Effet",xlab="Taille d'effet",ylab="Densité",ylim=c(0,length(tab)),proba=T)

mean(tab)
power.t.test(power=puissance,sig.level=alpha,n=n_observation*percent_bootstrap,type="one.sample",alternative="one.sided")[2]