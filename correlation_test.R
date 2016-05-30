# Test de corrélation unilatéral - r test simulation (Monte Carlo)
# Objectif: Estimation de puissance du test de corrélation

# Clear environment
rm(list=ls())

#-----------------------------------------------------------------------
# Paramètres de la simulation
#-----------------------------------------------------------------------

# Taille des échantillons pilotes
npilote = 20


# Taille des tirages pour Monte-Carlo.
n = 50
# Number of runs for MC
runs = 1000


# correlation factor
# close to null to check type 1 error
cf = 0.01
# not null to check power
cf = 0.3

# Erreur de 1ère espèce
alpha = 0.05


#---------------------------------------------------
#                     pilote 
#---------------------------------------------------



pilote_ttest_paired<-function(npilote, cf)
{
  # On simule 2 échantillons "réels" dont le facteur de corrélation est cf.
  congruent = rnorm(npilote,mean = 0,sd = 1)
  s2 = 1/(cf)
  sd_eps = sqrt(s2^2-1)  
  eps = rnorm(npilote,mean = 0,sd = sd_eps)
  incongruent = congruent + eps
  # On estime les paramètres du pilote
  mean1 = mean(congruent)
  mean2 = mean(incongruent)
  ecart_type_congruent = sd(congruent)
  ecart_type_incongruent = sd(incongruent)
  cf_estime = cov(congruent,incongruent)/(sd(congruent)*sd(incongruent))
  # On retourne l'approximation de l'étude pilote
  return (c(mean1, mean2, ecart_type_congruent, cf_estime))
}





#---------------------------------------------------
# r-test simulations (Monte-Carlo)
#---------------------------------------------------

ttest_normal<-function(runs, n, pilote, alpha){
  
  # On récupère les paramètres du pilote
  mean1 = pilote[1]
  mean2 = pilote[2]
  s1 = pilote[3]
  cfpilote = pilote[4]
  
  # Independent variable (predictor)
  x = c(
    rep(1,n),	# group 1
    rep(2,n) # group 2
  )
  x = factor(x)
  
  # Perform runs (with stochastic sampling)
  tval_hand = numeric(runs) # to store resulting t statistics (computed by hand)
  s2 = 1/(cf)
  sd_eps = sqrt(s2^2-1)  
  
  for (r in 1:runs) {
    # Generate random independent samples with normal distributions
    # for the dependent variable (predicted)
    congruent = rnorm(n,mean = mean1,sd = s1)
    eps = rnorm(n,mean = 0,sd = sd_eps)
    incongruent = congruent + eps
    y = c(
      congruent,
      incongruent
    )
    

    # Hand-made equivalent to compute the t statistic
    # (will produce the same value as model$statistic)
    # DV for group
    y1 = y[x==1]
    y2 = y[x==2]
    
    co = cor(y1,y2,method = "pearson")
    tval_hand[r] = sqrt(n-2)*(co/sqrt(1-co^2))
  }
  
  # Display the resulting statistics
  res = data.frame(
    t_statistic_hand=tval_hand
  )
  head(res,10)
  
  # Histograms for the observed t statistic on independent samples
  hist(tval_hand,freq=FALSE,breaks=100)
  # Curve for the theoretical distribution for independent samples
  # (if mean = 0)
  s_range = seq(min(tval_hand),max(tval_hand),length.out=100)
  lines(s_range,dt(s_range,n+n-2))
  # if the histogram and curve match,
  # this means we cannot differentiate the results at chance level)

  
  # Compute the ratio of type I errors (should be <0.5)
  # equivalent to what precedes (to help you understand the computations)
  # (using the t statistic table/function)
  thr_low = qt(1-alpha/2, n -2, lower.tail=F)
  thr_upp = qt(1-alpha/2, n-2, lower.tail=T)
  nb = sum(tval_hand<thr_low | tval_hand>thr_upp)
  p5_hand = nb/runs
  
  # p5_package = power.r.test(r = cfpilote, sig.level = alpha, alternative = "one.sided")$power
  
  # Add these results to the global table
  results = data.frame(
    n=n,
    correlation = cfpilote,
    s1=s1,
    s2 = s2,
    runs=runs,
    p5_hand=p5_hand
    # p5_package=p5_package 
  )
  results
}
pilote = pilote_ttest_paired(npilote, cf)
cf
pilote[4]
ttest_normal(runs, n, pilote, alpha)
# If meand=0, we expect the proportion of p-values<0.05 to be roughly at 0.05 (type I error rate)
# If meand!=0, we expect the proportion of p-values<0.05 to be the highest possible (power)

