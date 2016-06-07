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



test_correlation<-function(runs,mea)
