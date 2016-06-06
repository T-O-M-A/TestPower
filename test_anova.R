# Test d'analyse de variance
# Objectif: Estimation de puissance 
# dans le cas: k populations, comparaison à une moyenne de référence
# même écart type

library(pwr)
# Clear environment
rm(list=ls())
#m = c(rep(1,k))
#-----------------------------------------------------------------------
# Paramètres de la simulation
#-----------------------------------------------------------------------

# Number of runs
runs = 100
# Number k of populations
k = 20;
n = c(rep(1,k))
for (i in 1:k){
  n[i] = 20
}

# Sample sizes
sample_sizes = c(rep(1,k));
for(i in 1:k){
sample_sizes[i] = n[i];
}
# Table of population means
means = c(rep(1,k))
# reference mean
means[1] = 0
# no difference to test the alpha level (type I errors)

# non null to test how often the existing effect is found (power)
means[2] = means[1] + 0.1


for(i in 1:k){
  means[i] =0.1 - 0.1/(i)
}


# Standard deviation of sample
s = 0.1

# Erreur de 1ère espèce
alpha = 0.05

#---------------------------------------------------
# Fisher-Snedecor test simulations (Monte-Carlo)
#---------------------------------------------------
sigma_m<-function(means,sample_sizes){
  res = 0
  for(i in 1:length(sample_sizes)){
    res = res + sample_sizes[i]*(means[i]-mean(means))^2 #à changer si les ni sont différents
  }
  res = sqrt(res/N(sample_sizes))
  return(res)
}

N<-function(sample_sizes){
  n = 0
  for (i in 1:length(sample_sizes)){
    n = n + sample_sizes[i];
  }
  return(n)
}


between_group_variance<-function(sample_sizes,means,y){
  bgv  = 0
  for(j in 1:length(sample_sizes)){
    bgv = bgv + sample_sizes[j]*(means[j]- mean(y))^2
  }
  return(bgv)
}




within_group_variance<-function(sample_sizes,means,y){
  wgv = 0
  indice = 0
  for(i in 1:length(sample_sizes)){
    for(j in 1:sample_sizes[i]){
      wgv = wgv + (y[indice + j] - means[i])^2 #mean(means)
    }
    indice = indice + sample_sizes[i]
  }
  return(wgv)
}
F<-function(means,sample_sizes,y){
  num = between_group_variance(sample_sizes,means,y)
  denom = within_group_variance(sample_sizes,means,y)
  f = (num/denom)*(N(sample_sizes) -k)/(k - 1)
  return(f)
}

pilote_ttest_normal<-function(npilote, means, sd, runs_bs_pilote)
{
  # On simule un échantillon "réel" de loi N(meand,s)
  echantillon = rnorm(npilote,mean = meand,sd = sd)
  # On détermine les paramètres empiriques du pilote
  meand2 = mean(echantillon)
  ecart_type = sd(echantillon)
  # On détermine l'intervalle de confiance de la moyenne avec la fonction confint de R
  conf_mean = t.test(echantillon,conf.level = alpha)$conf.int
  # On détermine l'intervalle de confiance de l'écart-type avec un Bootstrap
  table_sd = numeric(runs_bs_pilote)
  for(i in 1:runs_bs_pilote)
  {
    # On choisit pour le boostrap des sous-ensembles de taille 80% de la taille de l'échantillon 
    n_bs = ceiling(0.8*npilote)
    table_sd[i] = sd((sample(echantillon,n_bs,replace=T)))
  }
  table_sd_sorted = sort(table_sd)
  conf_sd = c(table_sd_sorted[floor(runs_bs_pilote*alpha)],table_sd_sorted[floor(runs_bs_pilote*(1-alpha))])
  # On retourne l'approximation de l'étude pilote
  return (list(ecart_type=ecart_type, mean = meand2, conf_mean=conf_mean, conf_sd=conf_sd))
}


test_anova<-function(runs, means, sample_sizes, s, alpha){
  
  # Independent variable (predictor)
  x = c(
    rep(1,N(sample_sizes))	# group 
  )
  x = factor(x)
  
  # Perform runs (with stochastic sampling)
  fval_hand = numeric(runs)
  fval= numeric(runs) # to store resulting t statistics (computed by hand)
  for (r in 1:runs) {
    # Generate random independent samples with normal distributions
    # for the dependent variable (predicted)
    y = 1:N(sample_sizes)
    indice = 0
    for(i in 1:k){
      y[(indice+1):(indice + sample_sizes[i])] = c(rnorm(sample_sizes[i],mean = means[i],sd =s))
      indice = indice + sample_sizes[i]
    }
    # Hand-made equivalent to compute the t statistic
    # (will produce the same value as model$statistic)
    # DV for group
    y1 = y[x==1]
    # Pooled standard deviation
  #  s12 = sd(y1)
    means_empirique = c(rep(1,k))
    indice = 0
    for(i in 1:k){
      intervalle = y1[(indice+1) : (indice + sample_sizes[i])]
      means_empirique[i] = mean(intervalle)
      indice = indice + sample_sizes[i]
    }
    fval_hand[r] = F(means_empirique,sample_sizes,y1)
	 #  model = fisher.test(y)
    #fval[r] = model$statistic
}
ncp = (N(sample_sizes))*(sigma_m(means,sample_sizes)/s)^2
thr = qf(p =  1 -alpha,df1 = k-1,df2 = N(sample_sizes) - k)
#thr_upp = qt(alpha/2,n+n-2,lower.tail=F)
nb = sum(fval_hand > thr)
p5_hand = nb/runs

#p5_package = power.anova.test(groups = k,n = n1,between.var = between_group_variance(sample_sizes,means_empirique,y),within.var = within_group_variance(sample_sizes,means_empirique,y1) ,sig.level = alpha)$power
p5_package = pwr.anova.test(f = sigma_m(means,sample_sizes)/s, k = k, n =n[1],sig.level = alpha)$power
# Add these results to the global table
results = data.frame(
  n=N(sample_sizes),
  mean_diff=mean(means),
  sd=s,
  runs=runs,
  p5_hand=p5_hand,
  p5_package=p5_package, 
  fval_mean = mean(fval_hand),
  thr = thr
)
results
                
}
test_anova(runs, means, sample_sizes,s, alpha)

# If meand=0, we expect the proportion of p-values<0.05 to be roughly at 0.05 (type I error rate)
# If meand!=0, we expect the proportion of p-values<0.05 to be the highest possible (power)
