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

pilote_test_correlation<-function(npilote, meand, s1, s2, cf, runs_bs_pilote)
{
  # On simule 2 échantillons "réels"
  # tels que: leur différence de moyenne est meand,
  # les standard error des echantillons sont s1 et s2,
  # et le facteur de corrélation est cf.
  congruent = rnorm(npilote,mean = 0,sd = s1)
  # Dans le cas apparié, on suppose que Y = a + bX + eps,
  # où eps est une normale centrée. On a donc:
  a = meand
  # puis var(Y) = b²var(X) + var(eps), et
  # cf = b/(s1s2)
  b = cf*(s1*s2)
  sd_eps = sqrt(s2^2-b^2*s1^2)  
  eps = rnorm(npilote,mean = 0,sd = sd_eps)
  incongruent = a + b*congruent + eps
  # On estime les paramètres du pilote
  mean1 = mean(congruent)
  mean2 = mean(incongruent)
  meand2 = mean2 - mean1
  ecart_type_congruent = sd(congruent)
  ecart_type_incongruent = sd(incongruent)
  cf_estime = cor(congruent, incongruent)
  # On détermine l'intervalle de confiance pour la moyenne du ttest
  conf_mean = t.test(incongruent,congruent,paired = TRUE)$conf.int
  # On détermine l'intervalle de confiance des écarts-type et du coefficient de corrélation avec un Bootstrap
  table_sd1 = numeric(runs_bs_pilote)
  table_sd2 = numeric(runs_bs_pilote)
  for(i in 1:runs_bs_pilote)
  {
    # On choisit pour le boostrap des sous-ensembles de taille 80% de la taille de l'échantillon 
    n_bs = ceiling(0.8*npilote)
    table_sd1[i] = sd((sample(congruent,n_bs,replace=T)))
    table_sd2[i] = sd((sample(incongruent,n_bs,replace=T)))
  }
  table_sd1_sorted = sort(table_sd1)
  table_sd2_sorted = sort(table_sd2)
  conf_sd1 = c(table_sd1_sorted[floor(runs_bs_pilote*alpha)],table_sd1_sorted[floor(runs_bs_pilote*(1-alpha))])
  conf_sd2 = c(table_sd2_sorted[floor(runs_bs_pilote*alpha)],table_sd2_sorted[floor(runs_bs_pilote*(1-alpha))])
  
  # On retourne l'approximation de l'étude pilote
  return (list(ecart_type_congruent=ecart_type_congruent, ecart_type_incongruent=ecart_type_incongruent, mean=meand2, conf_mean=conf_mean, conf_sd1=conf_sd1,conf_sd2 = conf_sd2))
}


test_correlation<-function(npilote, runs, means, sd1, sd2){
  #Création du pilote
  
  pilote = pilote_test_correlation(npilote, meand, s1, s2, cf, runs_bs_pilote)
  
  
}
