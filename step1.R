# Objectif de l'étape 1:
# Déterminer la taille d'effet du cas incongruent sur le cas congruent.
# On part d'un nombre 

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
