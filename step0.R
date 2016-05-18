tailledeffet<-function(mean1, mean2, var, alpha)
{
  norm1 = rnorm(20, mean1, var)
  norm2 = rnorm(20, mean2, var)
  taille_effet = (mean2 - mean1)/sqrt(var)
  
  u = qnorm(1-alpha) + mean1
  
  return(pnorm(mean2 - u))
}

p<-tailledeffet(0,2,1,0.05)
p