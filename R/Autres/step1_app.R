# Test de moyenne bilatéral - T test simulation (Monte Carlo)
# Objectif: Estimation de taille d'effet 
# dans le cas: 2 échantillons appariés
# N(mu_x, s_x) et N(mu_y, s_y)
# NB: les tailles des échantillons seront n
# 
# Clear environment
rm(list=ls())

#-----------------------------------------------------------------------
# Paramètres de la simulation
#-----------------------------------------------------------------------


# Number of runs
runs = 10000

# Sample sizes (for each group)
n = 20

# Means of samples
mu_x = 0
mu_y = 1

# Standard deviation of samples
s_x = 0.1
s_x = 0.2

# Erreur de 1ère espèce
alpha = 0.05

#---------------------------------------------------
# t-test simulations (Monte-Carlo)
#---------------------------------------------------

ttest_MC_app<-function(runs, mu_x, mu_y, n, s_x, s_y, alpha){
  
  # Independent variable (predictor)
  x = c(
    rep(1,n1),	# group 1
    rep(2,n2)	# group 2
  )
  x = factor(x)
  
  # Perform runs (with stochastic sampling)
  t_e_hand = numeric(runs) # to store resulting effect size (computed by hand)
  for (i in 1:runs) {
    # Generate random independent samples with normal distributions
    # for the dependent variable (predicted)
    y = c(
      rnorm(n,mean=mu_x,sd=s_x),
      rnorm(n,mean=mu_y,sd=s_y)
    )
    
    # Hand-made equivalent to compute the t statistic
    # (will produce the same value as model$statistic)
    # DV for each group
    y1 = y[x==1]
    y2 = y[x==2]
    r_emp = cov(y1,y2)/(sd(y1)*sd(y2))
    # Pooled standard deviation
    s_z_emp = sqrt(sd(y1)^2+sd(y2)^2-2*r_emp*sd(y1)*sd(y2))
    t_e_hand[i] = (mean(y1)-mean(y2))/(s12*sqrt((1/n1)+(1/n2)))
  }
  

  # On calcule la puissance théorique (analytique) du t-test avec le package power:
  # NB: Dans le cas n1 = n2 = n, on devrait avoir p5_package = p5_model = p5_hand.
  r = 1 + (mu_x*mu_y)/(s_x*s_y)
  s_z = sqrt(s_x^2+s_y^2-2*r*s_x*s_y)
  t_e = mu_x-mu_y/(s_z)
  
  # Add these results to the global table
  results = data.frame(
    n=n,
    mean_diff=mu_x-mu_y,
    s_x=s_x,
    s_y=s_y,
    runs=runs,
    t_e_hand = t_e_hand,
    t_e = t_e
  )
  results
}
ttest_MC_app(runs, mu_x, mu_y, n, s_x, s_y, alpha)
# If meand=0, we expect the proportion of p-values<0.05 to be roughly at 0.05 (type I error rate)
# If meand!=0, we expect the proportion of p-values<0.05 to be the highest possible (power)