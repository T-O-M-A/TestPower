# Objectif step2 : 
# Estimer la taille d'échantillonage en fixant:
# la puissance et la taille d'effet
# (ainsi que l'erreur de 1ère espèce).
# Les lois sont supposées normales.

# Résolution Analytique.
TailleEchantillonAnalytique <- function(alpha, puissance, taille_effet)
{
  return (floor(((qnorm(puissance,1) + qnorm(alpha,1))/(taille_effet))^2))
}

# Résolution numérique
TailleEchantillonNumerique <- function(alpha, puissance, taille_effet)
{
  pwr.norm.test(sig.level=alpha,power=puissance,d=taille_effet,alternative="one.sided")
}
# Test 
TailleEchantillonAnalytique(0.05, 0.80, 0.01)
#TailleEchantillonNumerique(0.05, 0.80, 0.01) #package pwr non trouvé

