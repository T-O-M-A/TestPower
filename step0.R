puissance<-function(mean1, mean2, var, alpha)
{
  norm1 = rnorm(20, mean1, var)
  norm2 = rnorm(20, mean2, var)
  newmean1 <- mean(norm1)
  newmean2 <- mean(norm2)
  taille_effet = (newmean2 - newmean1)/sqrt(var)
  
  u = qnorm(1-alpha) + newmean1
  
  return(pnorm(newmean2 - u))
}

p<-puissance(0,3,1,0.05)
p