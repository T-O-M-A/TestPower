

tailledeffet<-function(mean1, mean2, var, alpha)
{
  norm1 <- rnorm(1000, mean1, var)
  norm2 <- rnorm(1000, mean2, var)

  meannorm1 <- 1:3000
  meannorm2 <- 1:3000
  for (i in 1:3000) {
    rand <- sample(1:1000, 800)
    rnormboot1 <- norm1[rand]
    rnormboot2 <- norm2[rand]
    meanboot1 <- mean(rnormboot1)
    meanboot2 <- mean(rnormboot2)
    meannorm1[i] <- meanboot1
    meannorm2[i] <- meanboot2
  }
  mean1 <- mean(meannorm1)
  mean2 <- mean(meannorm2)
  
  hist((meannorm2 - meannorm1)/sqrt(var),main="Histogramme de Taille d'Effet",ylab="Densité",ylim=c(0,20/sqrt(var)),proba=T)
  
  return((mean2-mean1)/sqrt(var))
}

te<-tailledeffet(10,11.3,0.1,0.05)
te
