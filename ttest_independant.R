# Test de moyenne bilatéral - T test simulation (Monte Carlo)
# Objectif: Estimation de puissance 
# dans le cas: 2 échantillons indépendants de même variance.

# Clear environment
rm(list=ls())
library(gplots)

#-----------------------------------------------------------------------
# Paramètres de la simulation
#-----------------------------------------------------------------------


## Pilote

# Taille des échantillons pilotes
# Non nécessairement égaux (dépend des ressources disponibles)
npilote_congruent = 20
npilote_incongruent = 20
# Nombre de runs pour le Bootstrap du pilote,
# servant à estimer un intervalle de confiance pour l'écart-type du pilote
runs_bs_pilote = 1000
# Difference between the means
# no difference to test the alpha level (type I errors)
meand = 0
# non null to test how often the existing effect is found (power)
meand = 0.1

# Standard deviation of both samples
sd = 0.7

# Erreur de 1ère espèce
alpha = 0.05

## Monte Carlo


# Intervalle des tirages pour Monte-Carlo.
# On prend les mêmes tailles de tirage pour les 2 échantillons
tailles = 10*(2:10)
# Number of runs for MC
runs_MC = 1000




#---------------------------------------------------
#                     pilote 
#---------------------------------------------------


pilote_ttest_independants<-function(npilote_congruent, npilote_incongruent, meand, s, runs_bs_pilote, dest_pilote)
{
  alpha = 0.05
  # On simule 2 échantillons "réels"
  congruent = rnorm(npilote_congruent,mean = 0,sd = s)
  incongruent = rnorm(npilote_incongruent,mean = meand,sd = s)
  # On estime la différence de moyenne et l'écart-type
  mean1 = mean(congruent)
  mean2 = mean(incongruent)
  meand2 = mean2 - mean1
  # On suppose leur écart-type égal.
  # On l'estime donc par une moyenne de leur écart-type empirique.
  ecart_type = (sd(congruent)+sd(incongruent))/2
  # On détermine l'intervalle de confiance pour la moyenne du ttest
  conf_mean = t.test(incongruent,congruent,conf.level = alpha)$conf.int
  # On détermine l'intervalle de confiance de l'écart-type avec un Bootstrap
  table_sd = numeric(runs_bs_pilote)
  for(i in 1:runs_bs_pilote)
  {
    # On choisit pour le boostrap des sous-ensembles de taille 80% de la taille de l'échantillon 
    #(On estime toujours sd par une moyenne des sd des 2 échantillon)
    n_bs_congruent = ceiling(0.8*npilote_congruent)
    n_bs_incongruent = ceiling(0.8*npilote_incongruent)
    table_sd[i] = (sd((sample(congruent,n_bs_congruent,replace=T))) + sd((sample(incongruent,n_bs_incongruent,replace=T))))/2
  }
  table_sd_sorted = sort(table_sd)
  conf_sd = c(table_sd_sorted[floor(runs_bs_pilote*alpha)],table_sd_sorted[floor(runs_bs_pilote*(1-alpha))])
  # On trace le pilote
  jpeg(dest_pilote)
  densCongruent <- density(congruent)
  densIncongruent <- density(incongruent)
  histCongruent <-hist(congruent, breaks=10, plot = FALSE)
  histIncongruent <- hist(incongruent, breaks=10, plot = FALSE)
  xlim <- range(histIncongruent$breaks,histCongruent$breaks)
  ylim <- range(0,histIncongruent$density,histCongruent$density)
  #ylim <- c(0,max(histCongruent$density,max(histIncongruent$density)))
  plot(histCongruent,xlim = xlim, ylim = ylim,
       col = rgb(1,0,0,0.4),xlab = 'congruent',
       freq = FALSE, ## relative, not absolute frequency
       main = 'Distribution')
  opar <- par(new = FALSE)
  plot(histIncongruent,xlim = xlim, ylim = ylim,
       xaxt = 'n', yaxt = 'n', ## don't add axes
       col = rgb(0,0,1,0.4), add = TRUE,
       freq = FALSE) ## relative, not absolute frequency
  ## add a legend in the corner
  legend('topleft',c('Congruent','Incongruent'),
         fill = rgb(1:0,0,0:1,0.4), bty = 'n',
         border = NA)
  par(opar)
  ## plot first density
  xfit1<-seq(min(congruent),max(congruent),length=40)
  yfit1<-dnorm(xfit1,mean=mean1,sd=ecart_type)
  yfit1 <- yfit1*diff(histCongruent$mids[1:2])*length(congruent)
  lines(xfit1, yfit1, col=rgb(1,0,0,0.4), lwd=2) 
  ## plot second density
  xfit2<-seq(min(incongruent),max(incongruent),length=40)
  yfit2<-dnorm(xfit2,mean=mean2,sd=ecart_type)
  yfit2 <- yfit2*diff(histIncongruent$mids[1:2])*length(incongruent)
  lines(xfit2, yfit2, col=rgb(0,0,1,0.4), lwd=2) 
  

  dev.off()
  # On retourne l'approximation de l'étude pilote
  return (list(ecart_type=ecart_type, mean = meand2, conf_mean=conf_mean, conf_sd=conf_sd))
}



#---------------------------------------------------
# Monte-Carlo pour 2 échantillons indépendants 
#---------------------------------------------------

MC_ind<-function(n1, n2, runs, meand, sd){
  
  alpha = 0.05
  # Independent variable (predictor)
  x = c(
    rep(1,n1),	# group 1
    rep(2,n2)	# group 2
  )
  x = factor(x)
  
  # Perform runs (with stochastic sampling)
  tval = numeric(runs) # to store resulting t statistics
  tval_hand = numeric(runs) # to store resulting t statistics (computed by hand)
  pval = numeric(runs) # to store resulting p-values
  for (r in 1:runs) {
    # Generate random independent samples with normal distributions
    # for the dependent variable (predicted)
    y = c(
      rnorm(n1,mean=0,sd=sd),
      rnorm(n2,mean=meand,sd=sd)
    )
    
    # Hand-made equivalent to compute the t statistic
    # (will produce the same value as model$statistic)
    # DV for each group
    y1 = y[x==1]
    y2 = y[x==2]
    # Pooled standard deviation
    s12 = sqrt((sd(y1)^2+sd(y2)^2)/(n1+n2-2))
    tval_hand[r] = (mean(y1)-mean(y2))/(s12*sqrt((1/n1)+(1/n2)))
    
    
    # Run model : on stocke les t-statistics et p-values
    # du modèle généré par R.
    model = t.test(y2, y1, var.equal=TRUE)
    tval[r] = model$statistic
    pval[r] = model$p.value
    
  }
  
  # Display the resulting statistics
  res = data.frame(
    t_statistic=tval,
    t_statistic_hand=tval_hand,
    p_value=pval
  )
  head(res,10)
  

  
  # Directly exploit the pvalues generated by the model
  # to get the power of type I error rate (depending on meand value)
  # p5_model devrait tendre vers 0.05 si meand = 0
  # p5_model nous donne la puissance du test si meand != 0
  nb = sum(pval<alpha)
  # --> signifie que si meand = 0, on conclue à tort un effet à un ratio p5_model
  # si meand != 0, on affirme à raison un effet à un ratio p5_model
  p5_model = nb/runs
  
  # Compute the ratio of type I errors (should be <0.5)
  # equivalent to what precedes (to help you understand the computations)
  # (using the t statistic table/function)
  # p5_hand devrait etre égal à p5_model
  thr_low = qt(alpha/2,n1+n2-2,lower.tail=T)
  thr_upp = qt(alpha/2,n1+n2-2,lower.tail=F)
  nb = sum(tval<thr_low | tval>thr_upp)
  p5_hand = nb/runs
  
  # On calcule la puissance théorique (analytique) du t-test avec le package power:
  # NB: Dans le cas n1 = n2 = n, on devrait avoir p5_package = p5_model = p5_hand.
  p5_package = power.t.test(n=(n1+n2)/2, d = meand/sd, sig.level = alpha, type = "two.sample", alternative = "two.sided")$power
  
  return(list(meand = meand, sd = sd, p5_model = p5_model, p5_hand = p5_hand, p5_package = p5_package ))
}

#---------------------------------------------------
# t-test simulations (Monte-Carlo)
#---------------------------------------------------

ttest_independants<-function(n1, n2, runs, pilote){

  # On récupère les informations du pilote
  # Pour la moyenne
  mean = pilote$mean # moyenne empirique du pilote
  conf_mean = pilote$conf_mean # intervalle de confiance pour la différence moyenne du pilote au seuil alpha = 0.05
  # Bornes de l'intervalle de confiance de la différence de moyenne
  meaninf = conf_mean[1]
  meansup = conf_mean[2]
  # Pour l'écart-type
  ecart_type = pilote$ecart_type  # ecart_type empirique du pilote (le même pour les 2 échantillons)
  conf_sd = pilote$conf_sd # intervalle de confiance pour l'écart-type du pilote au seuil alpha = 0.05
  # Bornes de l'intervalle de confiance de l'écart-type
  sdinf = conf_sd[1]
  sdsup = conf_sd[2]
  
  MC_inf = MC_ind(n1,n2,runs,meaninf,sdsup)
  MC_sup = MC_ind(n1,n2,runs,meansup,sdinf)
  MC_moy = MC_ind(n1,n2,runs,mean,ecart_type)

  
  IC_Puissance_model = c(MC_inf$p5_hand,MC_sup$p5_hand)
  IC_Puissance_hand = c(MC_inf$p5_model,MC_sup$p5_model)
  IC_Puissance_package = c(MC_inf$p5_package,MC_sup$p5_package)
  
  # On présente les résultats sur la puissance:
  # La puissance à partir des paramètres empiriques du pilote, 
  # Puis les intervalles de confiance de la puissance calculés
  # à partir des intervalles de confiance des paramètres.
  # NB : 
  Puissance_moy_hand = MC_moy$p5_hand
  Puissance_moy_model = MC_moy$p5_model
  Puissance_moy_package = MC_moy$p5_package
  results = data.frame(
    n1=n1,
    n2=n2,
    runs = runs,
    Puissance_moy_hand = Puissance_moy_hand,
    IC_Puissance_hand_inf = IC_Puissance_hand[1],
    IC_Puissance_hand_sup = IC_Puissance_hand[2],
    Puissance_moy_model = Puissance_moy_model,
    IC_Puissance_model_inf = IC_Puissance_model[1],
    IC_Puissance_model_sup = IC_Puissance_model[2],
    Puissance_moy_package = MC_moy$p5_package,
    IC_Puissance_package_inf = IC_Puissance_package[1],
    IC_Puissance_package_sup = IC_Puissance_package[2]
  )
  return (results)
}


#---------------------------------------------------
# Test : Puissance en fonction de la taille de l'échantillon.
# (Calcul basé sur l'algorithme de Monte Carlo )
#---------------------------------------------------

Puissance_ind<-function(npilote_congruent = 20, npilote_incongruent = 20, meand = 0.4, sd = 0.3, runs_bs_pilote = 1000, runs_MC = 1000, taille_max = 100, dest_puissance, dest_pilote, puissance = NULL){
  # Environment
  library(gplots)
  # Création du pilote
  pilote = pilote_ttest_independants(npilote_congruent, npilote_incongruent, meand, sd, runs_bs_pilote, dest_pilote)
  # On regarde la puissance en fonction de la taille d'échantillon
  # (!= npilote, qui est la taille du pilote.
  # ici, la taille de l'échantillon correspond à la taille des tirages pour Monte-Carlo)
  tailles = seq(from = 20, to = taille_max, length.out = 15)
  longueur = length(tailles)
  puissances = numeric(longueur)
  IC_low_width = numeric(longueur)
  IC_up_width = numeric(longueur)
  for (i in 1:longueur){
    # On prend les mêmes tailles d'échantillonage pour les tirages de Monte-Carlo
    results = ttest_independants(tailles[i], tailles[i], runs_MC,pilote)
    puissances[i] = results$Puissance_moy_hand
    IC_low_width[i] =  puissances[i] - results$IC_Puissance_hand_inf
    IC_up_width[i] = results$IC_Puissance_hand_sup - puissances[i]
  }
  jpeg(dest_puissance)
  plotCI(tailles, puissances, uiw = IC_up_width, liw = IC_low_width, type = "o", barcol = "red")
  dev.off()
  results # affiche les puissances pour le dernier tirage de Monte Carlo
  return(calcul_n(puissance,puissances,tailles))
}
n_calc = Puissance_ind(dest_puissance =  '/user/6/.base/bonjeang/home/SpeProject/Projet-Specialite-Calcul-de-Puissance/TEST/puissance.jpg',
        dest_pilote = '/user/6/.base/bonjeang/home/SpeProject/Projet-Specialite-Calcul-de-Puissance/TEST/pilote.jpg',puissance = 0.8)
n_calc
