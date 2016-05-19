# Objectif de l'étape 0: 
# Estimer la puissance d'un test à 2 modalités

# On fixe le risque de 1ère espèce, la taille de l'effet
# connue a priori, et le nombre d'individus,
# pour obtenir la puissance du test.


# Calcul analytique de la puissance
# pour 2 gaussiennes données, sans échantillon.
# (permet de vérifier la cohérence des résultats)
PuissanceAnalytique <- function(mean1, mean2, var, alpha)
{
  taille_effet = (mean2 - mean1)/sqrt(var)
  
  u = qnorm(1 - alpha) + mean1
  
  return(pnorm(mean2 - u))
}


# Estimation de la puissance
# à partir d'un échantillon de taille n 
# de taille d'effet fixée 
# (ie de moyennes et variances fixées)
PuissanceEstimee <- function(mean1, mean2, var, alpha, n)
{
  norm1 = rnorm(n, mean1, var)
  norm2 = rnorm(n, mean2, var)
  
  
  u = qnorm(1 - alpha) + mean(norm1)
  
  return(pnorm(mean(norm2) - u))
}

# Tests : gaussiennes de moyenne 1 et 2 et de variance 1.
# alpha = 0.05, n = 20.
PA <- PuissanceAnalytique(1,2,1,0.05)
PE <- PuissanceEstimee(1,2,1,0.05,20)
PA
PE
