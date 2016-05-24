#A utiliser en deux temps avec modèle
#Observations génère les observations x de la régression multilinéaire
observations<-function(n_obs, mu, s){
  n_param <- length(mu)
  x <- 1:(n_param*n_obs)
  for (i in 1:n_param) {
    x[((i-1)*n_obs+1):(i*n_obs)] <- rnorm(n_obs, mean = mu[i], sd = s[i])
  }
  return (list(x=x))
}

#A utiliser avec observations
#Modèle génère les Y en partant des observations x
modele<-function(alpha, beta, obs){
  n_param <- length(beta)
  n_obs <- length(obs$x)/n_param
  e <- rnorm(n_obs, mean = 0, sd = 1)
  Y <- 1:n_obs
  for (i in 1:n_obs) {
    Y[i] <- alpha + e[i]
    for (j in 1:n_param) {
      Y[i] <- Y[i] + beta[j]*obs$x[((j-1)*n_obs)+i]
    }
  }
  return(list(Y=Y,e=e))
}

#Combinaison de Observations et Modèle
#Donne immédiatement les observations x et Y
regression<-function(alpha, beta, n_obs, mu, s){
  n_param <- length(beta)
  x <- 1:(n_param*n_obs)
  for (i in 1:n_param) {
    x[((i-1)*n_obs+1):(i*n_obs)] <- rnorm(n_obs, mean = mu[i], sd = s[i])
  }
  e <- rnorm(n_obs, mean = 0, sd = 1)
  Y <- 1:n_obs
  for (i in 1:n_obs) {
    Y[i] <- alpha + e[i]
    for (j in 1:n_param) {
      Y[i] <- Y[i] + beta[j]*x[((j-1)*n_obs)+i]
    }
  }
  return(list(x=x,Y=Y,e=e))
}

#Identique à Regression, sauf qu'ici les constantes de la régression et les propriétés
#des normales sont déterminées aléatoirement plutôt que fournies.
# alpha \in [-10;10]
# beta \in [-5;5]
# mean \in [-5;5]
# sd \in [0;3]
regression_blind<-function(n_param, n_obs){
  alpha <- 10 - sample(1:2000, 1)/100
  beta <- 1:n_param
  mu <- 1:n_param
  s <- 1:n_param
  for (i in 1:n_param){
    beta[i] = 5 - sample(1:1000, 1)/100
    mu[i] = 5 - sample(1:1000, 1)/100
    s[i] = 3 - sample(1:300, 1)/100
  }
  x <- 1:(n_param*n_obs)
  for (i in 1:n_param) {
    x[((i-1)*n_obs+1):(i*n_obs)] <- rnorm(n_obs, mean = mu[i], sd = s[i])
  }
  e <- rnorm(n_obs, mean = 0, sd = 1)
  Y <- 1:n_obs
  for (i in 1:n_obs) {
    Y[i] <- alpha + e[i]
    for (j in 1:n_param) {
      Y[i] <- Y[i] + beta[j]*x[((j-1)*n_obs)+i]
    }
  }
  return(list(Y=Y,x=x,alpha=alpha,beta=beta,mean=mu,sd=s,e=e))
}