pilote_est1<-function(mean1, mean2, var, n_observation){
  norm1 <- rnorm(n_observation, mean1, sqrt(var))
  norm2 <- rnorm(n_observation, mean2, sqrt(var))
 
  return(c((max(mean(norm1),mean(norm2))-min(mean(norm1),mean(norm2))),
           mean(sqrt(var(norm1)),sqrt(var(norm2)))))
}

pilote_est2<-function(mean1, mean2, var, n_observation, n_iteration){
  norm1 <- rnorm(n_observation, mean1, sqrt(var))
  norm2 <- rnorm(n_observation, mean2, sqrt(var))
  
  norm1emp <- rnorm(n_observation, mean(norm1), sqrt(var(norm1)))
  norm2emp <- rnorm(n_observation, mean(norm2), sqrt(var(norm2)))
  
  return(c((max(mean(norm1),mean(norm2))-min(mean(norm1),mean(norm2))),
           mean(sqrt(var(norm1)),sqrt(var(norm2)))))
}

independent_t_test<-function(mean1, mean2, var, alpha, puissance, n_observation_pilote){
  
  return(T)
}

rand <- sample(1:5000, 1)/1000
mean1 <- rand
rand <- sample(1:2000, 1)/1000
mean2 <- rand*mean1
rand <- sample(1:3000, 1)/1000
var <- rand

c(mean1, mean2, var)

alpha <- 0.05
puissance <- 0.90

n_observation <- 200
n_observation_pilote <- 20
n_monte_carlo <- 1000

abs(mean1-mean2)
sqrt(var)

pilote <- pilote_est1(mean1, mean2, var, n_observation_pilote)
meand_pilote <- pilote[1]
s_pilote <- pilote[2]

meand_pilote
s_pilote
