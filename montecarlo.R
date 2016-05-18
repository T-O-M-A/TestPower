montecarlo<-function(mean1,mean2,var,n){
  
  x1 = rnorm(n,mean1,var)
  x2 = rnorm(n,mean2,var)
  e = 0
  for(i in 1:n){
    e = abs(x1[i] - x2[i])/sqrt(var) 
  }
  
  e = e/n
  return(e)
}

e <- montecarlo(0,0.1,1,20)
e

