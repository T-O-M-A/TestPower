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

#Code fourni par Jean-Charles Quinton
univariate_regression<-function(n, b_0, b_1, noise_s){
  # IVs data generation
  x = runif(n)
  # Model parameters
  b0 = b_0
  b1 = b_1
  noise_sd = noise_s
  # DV generation
  y = b0 + b1*x + rnorm(n,0,noise_sd)
  
  # Test if parameters are correctly estimated
  mod = lm(y~x)
  return(list(Y=y, x=x, sum=summary(mod)))
}

multiple_regression<-function(n, b_0, b_1, b_2, noise_s){
  # IVs data generation
  x = cbind(rep(1,n),runif(n),runif(n))
  # Model parameters
  b = c(b_0, b_1, b_2)
  noise_sd = noise_s
  # DV generation (matrix based)
  y = x%*%b + rnorm(n,0,noise_sd)
  
  # Test if parameters are correctly estimated
  # (remove first column in x, which corresponds to the constant)
  mod = lm(y~x[,-1])
  return(list(Y=y, x=x, sum=summary(mod)))
}

interaction_regression<-function(n, b_0, b_1, b_2, b_3, noise_s){
  # IVs data generation
  x = cbind(rep(1,n),runif(n),runif(n))
  # Add interaction term
  x = cbind(x,x[,3]*x[,2])
  # Model parameters
  b = c(b_0, b_1, b_2, b_3)
  noise_sd = noise_s
  # DV generation (matrix based)
  y = x%*%b + rnorm(n,0,noise_sd)
  
  # Test if parameters are correctly estimated
  # (retrieve first column in x, which corresponds to the constant)
  mod = lm(y~x[,-1])
  return(list(Y=y, x=x, sum=summary(mod)))
}

mixed_effect_regression<-function(n, b_0, b_1_f, b_2, noise_s){
  # Grouping factor
  npart = 10
  part = sort(rep(c(1:npart),length.out=n))
  # Other IV generation
  x = runif(n)
  # Model parameters
  b0 = b_0
  b1_f = b_1_f
  b1 = b1_f + b_2*rnorm(npart)
  noise_sd = noise_s
  # DV generation (matrix based)
  y = b0 + b1[part]*x + rnorm(n,0,noise_sd)
  
  # Test if parameters are correctly estimated
  # (retrieve first column in x, which corresponds to the constant)
  library(lme4)
  mod = lmer(y~x+(0+x|part))
  
  # Comparison of the fixed effects with the parameters
  df1 = data.frame(
    Estimate = fixef(mod),
    Parameter = rbind(b0,b1_f)
  )
  
  # Comparison of the estimation and parameter values (random component)
  # fixed effect for x + random effects for each participant for x
  df2 = data.frame(
    Estimate = fixef(mod)["x"] + ranef(mod)$part$x,
    Parameter = b1
  )
  return(list(Y=y, x=x, sum=summary(mod), df1 = df1, df2 = df2))
}