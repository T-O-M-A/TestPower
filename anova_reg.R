#---------------------------------------------------
#                     calcul du n 
#---------------------------------------------------


calcul_n<-function(puissance,puissances,tailles){
  if (is.null(puissance)){
    return (-1)
  } else {
    i = 0
    p_cour = 0
    while((i < 16) && (p_cour < puissance)){
      i = i+1
      p_cour = puissances[i]
    }
    if(i == 16){
      return (0)
    } else {
      n2 = tailles[i]
      p2 = puissances[i]
      if (i==1){
        n1 = 0  
        p1 = 0
      } else {
        n1 = tailles[i-1]
        p1 = puissances[i-1]
      }
      pente = (p2-p1)/(n2-n1)
      if (pente == 0){
        n_calc = (n2-n1)/2
      } else {
        n_calc = (puissance-p1)/pente + n1
      }
      n_calc = ceiling(n_calc)
      return (n_calc)
    }
  }
}

## ANOVA


#---------------------------------------------------
# Fonctions intermédiaires
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
F<-function(means,sample_sizes,y,k){
  num = between_group_variance(sample_sizes,means,y)
  denom = within_group_variance(sample_sizes,means,y)
  f = (num/denom)*(N(sample_sizes) -k)/(k - 1)
  return(f)
}



#---------------------------------------------------
# Fisher-Snedecor test simulations (Monte-Carlo)
#---------------------------------------------------


pilote_anova<-function(k, fact, npilote, sd, runs_bs_pilote, dest_pilote)
{
  alpha = 0.05
  # Table of population means
  means = c(rep(1,k))
  sample_sizes = numeric(k)
  for(i in 1:k){
    # Moyennes entre  0 et 1
    means[i] = 1/i
    sample_sizes[i] = npilote
  }
  
  means = fact*means
  means_empirique_pilote = numeric(k)
  echantillon = matrix(nrow = sample_sizes[i],ncol = k)
  # CI
  conf_mean = matrix(nrow = 2, ncol = k)
  conf_sd = matrix(nrow = 2, ncol = k)
  table_sd_i = numeric(runs_bs_pilote)
  table_sd_i_sorted = numeric(runs_bs_pilote)
  for (i in 1:k){
    echantillon[,i] = rnorm(n = sample_sizes[i], mean = means[i], sd = sd)
    means_empirique_pilote[i] = mean(echantillon[,i])
    conf_mean[,i] = t.test(echantillon[,i],conf.level = alpha)$conf.int
    for(j in 1:runs_bs_pilote)
    {
      # On choisit pour le boostrap des sous-ensembles de taille 80% de la taille de l'échantillon 
      n_bs = ceiling(0.8*sample_sizes[i])
      table_sd_i[j] = sd((sample(echantillon[,i],n_bs,replace=T)))
    }
    table_sd_i_sorted = sort(table_sd_i)
    conf_sd[,i] = c(table_sd_i_sorted[floor(runs_bs_pilote*alpha)],table_sd_i_sorted[floor(runs_bs_pilote*(1-alpha))])
  }
  # Tracé des points
  numero_echantillon = matrix(nrow = sample_sizes[i],ncol = k)
  for (i in 1:k){
    numero_echantillon[,i] = rep(i,sample_sizes[i])
  }
  jpeg(dest_pilote)
  mp <- matplot(numero_echantillon,echantillon)
  lines(1:k,means_empirique_pilote, pch = 21,col = "red")
  lines(1:k,means, pch = 21,col = "blue")
  legend('topleft',c('Moyennes empiriques','Moyennes réelles'),
         fill = c("red", "blue"), bty = 'n',
         border = NA)
  
  #plot(1:k,randommeans,add=TRUE,xlim = xlim, ylim = ylim,pch = 21,col = "blue")
  dev.off()
  ecart_type = sd
  # On retourne l'approximation de l'étude pilote
  return (list(ecart_type=ecart_type, empiricmeans = means_empirique_pilote, realmeans = means, sizes = sample_sizes, conf_mean=conf_mean, conf_sd=conf_sd))
}




#---------------------------------------------------
# Monte-Carlo pour ANOVA 
#---------------------------------------------------

MC_an<-function(n, runs, means_empirique_pilote, s, k){
  
  
  alpha = 0.05
  # Taille des échantillons pour le MC
  sample_sizes = numeric(k)
  for (i in 1:k){
    sample_sizes[i] = n
  }
  # Independent variable (predictor)
  x = c(
    rep(1,N(sample_sizes))	# group 
  )
  x = factor(x)
  
  # Perform runs (with stochastic sampling)
  fval_hand = numeric(runs)
  fval= numeric(runs) # to store resulting t statistics (computed by hand)
  means_empirique = c(rep(1,k))
  for (r in 1:runs) {
    # Generate random independent samples with normal distributions
    # for the dependent variable (predicted)
    y = 1:N(sample_sizes)
    indice = 0
    for(i in 1:k){
      y[(indice+1):(indice + sample_sizes[i])] = c(rnorm(sample_sizes[i],mean = means_empirique_pilote[i],sd =s))
      indice = indice + sample_sizes[i]
    }
    # Hand-made equivalent to compute the t statistic
    # (will produce the same value as model$statistic)
    # DV for group
    y1 = y[x==1]
    # Pooled standard deviation
    #  s12 = sd(y1)

    indice = 0
    for(i in 1:k){
      intervalle = y1[(indice+1) : (indice + sample_sizes[i])]
      means_empirique[i] = mean(intervalle)
      indice = indice + sample_sizes[i]
    }
    fval_hand[r] = F(means_empirique,sample_sizes,y1,k)
    #  model = fisher.test(y)
    #fval[r] = model$statistic
  }
  ncp = (N(sample_sizes))*(sigma_m(means_empirique,sample_sizes)/s)^2
  thr = qf(1- alpha,df1 = k-1,df2 = N(sample_sizes) - k)
  #thr_upp = qt(alpha/2,n+n-2,lower.tail=F)
  nb = sum(fval_hand > thr)
  p5_hand = nb/runs
  
  #p5_package = power.anova.test(groups = k,n = n1,between.var = between_group_variance(sample_sizes,means_empirique,y),within.var = within_group_variance(sample_sizes,means_empirique,y1) ,sig.level = alpha)$power
  p5_package = pwr.anova.test(f = sigma_m(means_empirique,sample_sizes)/s, k = k, n = n)$power
  
  return(list(sd = s, p5_hand = p5_hand, p5_package = p5_package ))
}


#---------------------------------------------------
# t-test simulations (Monte-Carlo)
#---------------------------------------------------

ttest_anova<-function(n,runs, pilote){
  
  # On récupère les informations du pilote
  sizes = pilote$sizes
  k = length(sizes)
  # Pour la moyenne
  empiricmeans = pilote$empiricmeans # moyenne empirique du pilote
  conf_mean = pilote$conf_mean # intervalle de confiance pour la moyenne du pilote au seuil alpha = 0.05
  means = pilote$realmeans
  # Bornes de l'intervalle de confiance de la moyenne
  empiricmeansinf = conf_mean[1,]
  empiricmeanssup = conf_mean[2,]
  # On calcule les valeurs de l'intervalle qui donneront des valeurs extrêmes pour la puissance
  ICmeaninf_sorted = numeric(k)
  ICmeansup_sorted = numeric(k)
  INF = numeric(k)
  SUP = numeric(k)
  conf_mean_sorted = conf_mean[,order(conf_mean[2,])]
  ICmeaninf_sorted = conf_mean_sorted[1,]
  ICmeansup_sorted = conf_mean_sorted[2,]
  p1 = ICmeaninf_sorted[1]
  pk = ICmeansup_sorted[k]
  SUP[1] = p1
  SUP[k] = pk
  l = pk - p1
  pas = l/(k-1)
  pcour = p1
  for (i in 2:(k-1)){
    opti = pcour + pas
    infcour = ICmeaninf_sorted[i]
    supcour = ICmeansup_sorted[i]
    if(opti < infcour){
      SUP[i] = infcour
    } else {
      if (opti > supcour) {
        SUP[i] = supcour
      } else {
        SUP[i] = opti
      }
    }
  }
  p1 = ICmeansup_sorted[1]
  pk = ICmeaninf_sorted[k]
  if (p1 > pk){
    SUP = rep(p1,k)
  } else {
    INF[1] = p1
    INF[k] = pk
    l = pk - p1
    pas = l/(k-1)
    pcour = p1
    for (i in 2:(k-1)){
      opti = pcour + pas
      infcour = ICmeaninf_sorted[i]
      supcour = ICmeansup_sorted[i]
      if(opti < infcour){
        INF[i] = infcour
      } else {
        if (opti > supcour) {
          INF[i] = supcour
        } else {
          INF[i] = opti
        }
      }
    }
  }
  # Pour les écarts-type
  sd = pilote$ecart_type
  conf_sd = pilote$conf_sd
  # Bornes des intervalles de confiance des écarts-type
  sdinf = mean(conf_sd[1,])
  sdsup = mean(conf_sd[2,])
  # On calcule la puissance grâce à la fonction power du package pwr
  MC_inf = MC_an(n,runs,INF,sdsup,k)
  MC_sup = MC_an(n,runs,SUP,sdinf,k)
  MC_moy = MC_an(n,runs,empiricmeans,sd,k)
  
  
  # On présente les résultats sur la puissance:
  # La puissance à partir des paramètres empiriques du pilote, 
  # Puis les intervalles de confiance de la puissance calculés
  # à partir des intervalles de confiance des paramètres.
  # NB : 
  
  results = data.frame(
    runs = runs,
    Puissance_moy_hand = MC_moy$p5_hand,
    IC_Puissance_hand_inf = MC_inf$p5_hand,
    IC_Puissance_hand_sup = MC_sup$p5_hand,
    Puissance_moy_package = MC_moy$p5_package,
    IC_Puissance_package_inf = MC_inf$p5_package,
    IC_Puissance_package_sup = MC_sup$p5_package
  )
  return (results)
}


Puissance_an<-function(runs_bs_pilote = 1000, runs_MC = 1000, fact = 0.5, npilote = 20, sd = 1 , k = 8, taille_max = 100, dest_puissance, dest_pilote,puissance=NULL){
  # Environnement
  library(pwr)
  library(gplots)
  # Création du pilote
  pilote = pilote_anova(k, fact, npilote, sd, runs_bs_pilote, dest_pilote)
  # On regarde la puissance en fonction de la taille d'échantillon
  # (!= npilote, qui est la taille du pilote.
  # ici, la taille de l'échantillon correspond à la taille des tirages pour Monte-Carlo)
  tailles = seq(from = 30, to = taille_max, length.out = 15)
  longueur = length(tailles)
  puissances = numeric(longueur)
  IC_low_width = numeric(longueur)
  IC_up_width = numeric(longueur)
  for (i in 1:longueur){
    results = ttest_anova(tailles[i],runs_MC,pilote)
    puissances[i] = results$Puissance_moy_hand
    IC_low_width[i] =  puissances[i] - results$IC_Puissance_hand_inf
    IC_up_width[i] = results$IC_Puissance_hand_sup - puissances[i]
  }
  jpeg(dest_puissance)
  plotCI(tailles, puissances, uiw = IC_up_width, liw = IC_low_width, type = "o", barcol = "red")
  dev.off()
  results
  return(calcul_n(puissance,puissances,tailles))
}



## Regression univariée


#---------------------------------------------------
#                     pilote 
#---------------------------------------------------

stat_b_0_un<-function(data, indice){
  model = lm(data[indice,2]~data[indice,1])
  return (summary(model)[[4]][[1]])
}

stat_b_1_un<-function(data, indice){
  model = lm(data[indice,2]~data[indice,1])
  return (summary(model)[[4]][[2]])
}

stat_noise_s_un<-function(data, indice){
  model = lm(data[indice,2]~data[indice,1])
  return (summary(model)$sigma)
}

# Fonction qui génère un échantillon pilote et renvoie l'échantillon et
# l'intervalle de confiance des 2 paramètres estimé b_0 et b_1
pilote_univariate_reg<-function(npilote, runs_bs_pilote, b_0, b_1, noise_s, dest_pilote)
{
  # On simule 1 échantillon "réel"
  # Si tous les paramètres ne sont pas rentrés,
  # alors ils seront simulés aléatoirement
  # par la fonction regression_blind
  if (is.null(b_0) | is.null(b_1) | is.null(noise_s)){
    print("Génération d'un pilote aux paramètres aléatoires pour régression univariée")
    reg = regression_blind(1, npilote)
  } else {
    # b0, b1 et noise_s doivent être de taille 1
    try(if(length(b_0) != 1 | length(b_1) != 1 | length(noise_s) != 1) stop("b0,b1 and noise_s doivent être de taille 1"))
    # sinon on simule le pilote avec les paramètres souhaités.
    reg = univariate_regression(npilote, b_0, b_1, noise_s)
  }
  # estimation of parameters
  x = reg$x
  Y = reg$Y
  model = lm(Y~x)
  sum = summary(model)
  b0 = sum[[4]][[1]]
  b1 = sum[[4]][[2]]
  noises = sum$sigma
  # bootstrapping to determine confidence intervals for paramaters 
  data = cbind(x,Y)
  boot_b_0 <- boot(data=data, statistic=stat_b_0_un, R=runs_bs_pilote)
  boot_b_1 <- boot(data=data, statistic=stat_b_1_un, R=runs_bs_pilote)
  boot_noise_s <- boot(data=data, statistic=stat_noise_s_un, R=runs_bs_pilote)
  c_0 = boot.ci(boot_b_0, type="bca")$bca
  c_1 = boot.ci(boot_b_1, type="bca")$bca
  c_s = boot.ci(boot_noise_s, type="bca")$bca
  conf_b_0 = c(c_0[4],c_0[5])
  conf_b_1 = c(c_1[4],c_1[5])
  conf_noise_s = c(c_s[4],c_s[5])
  plot_mod(x,Y, dest_pilote, "Informations relatives au coefficient b1")
  return (list(b_0=b0,b_1=b1,noise_s=noises,conf_b_0=conf_b_0,conf_b_1=conf_b_1,conf_noise_s=conf_noise_s))
}

# Fonction qui permet de tracer l'échantillon pilote, la droite de régression et les intervalles de confiance/prédiction
plot_mod<-function(x,Y,dest_pilote,titre){
  model<-lm(Y~x)
  jpeg(dest_pilote)
  plot(x,Y, main = titre)
  abline(model)
  segments(x,fitted(model),x, Y)
  f = floor(min(x))
  c = ceiling(max(x))
  pred.frame<-data.frame(x=seq(f,c,length.out = 5))
  pc<-predict(model, interval="confidence", newdata=pred.frame)
  pp<-predict(model, interval="prediction", newdata=pred.frame)
  matlines(pred.frame, pc[,2:3], lty=c(2,2), col="blue") 
  matlines(pred.frame, pp[,2:3], lty=c(3,3), col="red")
  legend("topleft",c("confiance","prediction"),lty=c(2,3), col=c("blue","red"))
  dev.off()
}

#---------------------------------------------------
# Monte-Carlo pour régression univariée
#---------------------------------------------------

MC_ru<-function(alpha = 0.05, n, runs, b_0, b_1, noise_s){
  
  # to store resulting p-values from model
  pval0 = numeric(runs) 
  pval1 = numeric(runs) 
  tval_hand = numeric(runs) # to store resulting statisics calculated "by hand"
  for (r in 1:runs) {
    reg = univariate_regression(n, b_0, b_1, noise_s)
    sum = reg$sum
    # Run model : on stocke les p-values
    # du modèle généré par R.
    pval0[r] = sum[[4]][[7]]
    pval1[r] = sum[[4]][[8]]
  }
  # On détermine la puissance empirique du test d'après les p-values trouvées par le modèle de régression
  p5_model_0 = sum(pval0<alpha)/runs
  p5_model_1 = sum(pval1<alpha)/runs
  return(list(p5_model_0 = p5_model_0, p5_model_1 = p5_model_1))
}


#---------------------------------------------------
# test simulation (Monte-Carlo)
#---------------------------------------------------


test_univariate<-function(alpha = 0.05, n, runs, pilote){
  
  # On récupère les informations du pilote
  conf_b_0 = pilote$conf_b_0
  conf_b_1 = pilote$conf_b_1
  conf_noise_s = pilote$conf_noise_s
  # Bornes de l'intervalle de confiance des paramètres estimés
  b_0inf = conf_b_0[1]
  b_0sup = conf_b_0[2]
  b_1inf = conf_b_1[1]
  b_1sup = conf_b_1[2]  
  noise_sinf = conf_noise_s[1]
  noise_ssup = conf_noise_s[2]
  # Paramètres estimés
  b_0 = pilote$b_0
  b_1 = pilote$b_1
  noise_s = pilote$noise_s
  MC_inf = MC_ru(n = n,runs = runs,b_0 = b_0,b_1 = b_1inf,noise_s = noise_s)
  MC_moy = MC_ru(n = n,runs = runs,b_0 = b_0,b_1 = b_1,noise_s = noise_s)
  MC_sup = MC_ru(n = n,runs = runs,b_0 = b_0,b_1 = b_1sup,noise_s = noise_s)
  
  
  IC_Puissance_model_0 = c(MC_inf$p5_model_0,MC_sup$p5_model_0)
  IC_Puissance_model_1 = c(MC_inf$p5_model_1,MC_sup$p5_model_1)
  Puissance_moy_model_0 = MC_moy$p5_model_0
  Puissance_moy_model_1 = MC_moy$p5_model_1
  results = data.frame(
    n=n,
    runs = runs,
    Puissance_moy_model_0 = Puissance_moy_model_0,
    Puissance_moy_model_1 = Puissance_moy_model_1,
    IC_Puissance_model_0_inf = IC_Puissance_model_0[1],
    IC_Puissance_model_0_sup = IC_Puissance_model_0[2],
    IC_Puissance_model_1_inf = IC_Puissance_model_1[1],
    IC_Puissance_model_1_sup = IC_Puissance_model_1[2]
  )
  return (results)
}


#---------------------------------------------------
# Test : Puissance en fonction de la taille de l'échantillon.
# (Calcul basé sur l'algorithme de Monte Carlo )
#---------------------------------------------------

Puissance_ur<-function(npilote = 20, runs_bs_pilote = 1000, runs_MC = 1000, taille_max = 70, b_0 = NULL, b_1 = NULL, noise_s = NULL, dest_puissance, dest_pilote, puissance = NULL){
  # Environnement
  library(gplots)
  library(regression)
  library(boot)
  # Création du pilote
  pilote = pilote_univariate_reg(npilote, runs_bs_pilote, b_0, b_1, noise_s, dest_pilote)
  # On regarde la puissance en fonction de la taille d'échantillon
  # (!= npilote, qui est la taille du pilote.
  # ici, la taille de l'échantillon correspond à la taille des tirages pour Monte-Carlo)
  tailles = seq(from = 10, to = taille_max, length.out = 15)
  longueur = length(tailles)
  puissances = rep(0,longueur)
  IC_low_width = numeric(longueur)
  IC_up_width = numeric(longueur)
  for (i in 1:longueur){
    # On prend les mêmes tailles d'échantillonage pour les tirages de Monte-Carlo
    results = test_univariate(n = tailles[i], runs = runs_MC, pilote = pilote)
    puissances[i] = results$Puissance_moy_model_1
    IC_low_width[i] =  puissances[i] - results$IC_Puissance_model_1_inf
    IC_up_width[i] = results$IC_Puissance_model_1_sup - puissances[i]
  }
  jpeg(dest_puissance)
  plotCI(tailles, puissances, uiw = IC_up_width, liw = IC_low_width, type = "o", barcol = "red")
  results # affiche les puissances pour le dernier tirage de Monte Carlo
  dev.off()
  return(calcul_n(puissance,puissances,tailles))
}

## Regression multiple



#---------------------------------------------------
#                     pilote 
#---------------------------------------------------

stat_b_0_mr<-function(data, indice){
  model = lm(data[indice,3]~data[indice,1:2])
  return (summary(model)[[4]][[1]])
}

stat_b_1_mr<-function(data, indice){
  model = lm(data[indice,3]~data[indice,1:2])
  return (summary(model)[[4]][[2]])
}
stat_b_2_mr<-function(data, indice){
  model = lm(data[indice,3]~data[indice,1:2])
  return (summary(model)[[4]][[3]])
}

stat_noise_s_mr<-function(data, indice){
  model = lm(data[indice,3]~data[indice,1:2])
  return (summary(model)$sigma)
}

# Fonction qui génère un échantillon pilote et renvoie l'échantillon et
# l'intervalle de confiance des 2 paramètres estimé b_0 et b_1
pilote_multiple_reg<-function(npilote, runs_bs_pilote, b_0, b_1, b_2, noise_s, dest_pilote)
{
  # On simule 1 échantillon "réel"
  # Si tous les paramètres ne sont pas rentrés,
  # alors ils seront simulés aléatoirement
  # par la fonction regression_blind
  if (is.null(b_0) | is.null(b_1) | is.null(b_2) |  is.null(noise_s)){
    print("Génération d'un pilote aux paramètres aléatoires pour régression multiple")
    reg = regression_blind(2, npilote)
    # estimation of parameters
    x = reg$x
    Y = reg$Y
    x = matrix(x,nrow = npilote,ncol = 2)
    model = lm(Y~x)
  } else {
    # b0, b1 et noise_s doivent être de taille 1
    try(if(length(b_0) != 1 | length(b_1) != 1 | length(b_2) != 1 | length(noise_s) != 1) stop("b0,b1,b2 et noise_s doivent être de taille 1"))
    # sinon on simule le pilote avec les paramètres souhaités.
    reg = multiple_regression(npilote, b_0, b_1, b_2, noise_s)
    # estimation of parameters
    x = reg$x
    Y = reg$Y
    x = x[,-1]
    model = lm(Y~x)
  }
  
  sum = summary(model)
  b0 = sum[[4]][[1]]
  b1 = sum[[4]][[2]]
  b2 = sum[[4]][[3]]
  noises = sum$sigma
  data = cbind(x,Y)
  # bootstrapping to determine confidence intervals for paramaters 
  boot_b_0 <- boot(data=data, statistic=stat_b_0_mr, R=runs_bs_pilote)
  boot_b_1 <- boot(data=data, statistic=stat_b_1_mr, R=runs_bs_pilote)
  boot_b_2 <- boot(data=data, statistic=stat_b_2_mr, R=runs_bs_pilote)
  boot_noise_s <- boot(data=data, statistic=stat_noise_s, R=runs_bs_pilote)
  c_0 = boot.ci(boot_b_0, type="bca")$bca
  c_1 = boot.ci(boot_b_1, type="bca")$bca
  c_2 = boot.ci(boot_b_2, type="bca")$bca
  c_s = boot.ci(boot_noise_s, type="bca")$bca
  conf_b_0 = c(c_0[4],c_0[5])
  conf_b_1 = c(c_1[4],c_1[5])
  conf_b_2 = c(c_2[4],c_2[5])
  conf_noise_s = c(c_s[4],c_s[5])
  plot_mod(x[,2], Y, dest_pilote, "Informations relatives au coefficient b2")
  return (list(b_0=b0,b_1=b1,b_2=b2,noise_s=noises,conf_b_0=conf_b_0,conf_b_1=conf_b_1,conf_b_2=conf_b_2,conf_noise_s=conf_noise_s))
}

#---------------------------------------------------
# Monte-Carlo pour régression multiple
#---------------------------------------------------

MC_rm<-function(alpha = 0.05, n, runs, b_0, b_1, b_2, noise_s){
  
  # to store resulting p-values from model
  pval0 = numeric(runs) 
  pval1 = numeric(runs) 
  pval2 = numeric(runs) 
  tval_hand = numeric(runs) # to store resulting statisics calculated "by hand"
  for (r in 1:runs) {
    reg = multiple_regression(n, b_0, b_1, b_2, noise_s)
    sum = reg$sum
    # Run model : on stocke les p-values
    # du modèle généré par R.
    pval0[r] = sum[[4]][[10]]
    pval1[r] = sum[[4]][[11]]
    pval2[r] = sum[[4]][[12]]
  }
  # On détermine la puissance empirique du test d'après les p-values trouvées par le modèle de régression
  p5_model_0 = sum(pval0<alpha)/runs
  p5_model_1 = sum(pval1<alpha)/runs
  p5_model_2 = sum(pval2<alpha)/runs
  return(list(p5_model_0 = p5_model_0, p5_model_1 = p5_model_1, p5_model_2 = p5_model_2))
}


#---------------------------------------------------
# test simulation (Monte-Carlo)
#---------------------------------------------------


test_multiple<-function(alpha = 0.05, n, runs, pilote){
  
  # On récupère les informations du pilote
  conf_b_0 = pilote$conf_b_0
  conf_b_1 = pilote$conf_b_1
  conf_b_2 = pilote$conf_b_2
  conf_noise_s = pilote$conf_noise_s
  # Bornes de l'intervalle de confiance des paramètres estimés
  b_0inf = conf_b_0[1]
  b_0sup = conf_b_0[2]
  b_1inf = conf_b_1[1]
  b_1sup = conf_b_1[2] 
  b_2inf = conf_b_2[1]
  b_2sup = conf_b_2[2]
  noise_sinf = conf_noise_s[1]
  noise_ssup = conf_noise_s[2]
  # Paramètres estimés
  b_0 = pilote$b_0
  b_1 = pilote$b_1
  b_2 = pilote$b_2
  noise_s = pilote$noise_s
  MC_inf = MC_rm(n = n,runs = runs,b_0 = b_0inf,b_1 = b_1inf,b_2 = b_2inf,noise_s = noise_ssup)
  MC_moy = MC_rm(n = n,runs = runs,b_0 = b_0,b_1 = b_1,b_2 = b_2,noise_s = noise_s)
  MC_sup = MC_rm(n = n,runs = runs,b_0 = b_0sup,b_1 = b_1sup,b_2 = b_2sup,noise_s = noise_sinf)
  
  
  IC_Puissance_model_0 = c(MC_inf$p5_model_0,MC_sup$p5_model_0)
  IC_Puissance_model_1 = c(MC_inf$p5_model_1,MC_sup$p5_model_1)
  IC_Puissance_model_2 = c(MC_inf$p5_model_2,MC_sup$p5_model_2)
  Puissance_moy_model_0 = MC_moy$p5_model_0
  Puissance_moy_model_1 = MC_moy$p5_model_1
  Puissance_moy_model_2 = MC_moy$p5_model_2
  results = data.frame(
    n=n,
    runs = runs,
    Puissance_moy_model_0 = Puissance_moy_model_0,
    Puissance_moy_model_1 = Puissance_moy_model_1,
    Puissance_moy_model_2 = Puissance_moy_model_2,
    IC_Puissance_model_0_inf = IC_Puissance_model_0[1],
    IC_Puissance_model_0_sup = IC_Puissance_model_0[2],
    IC_Puissance_model_1_inf = IC_Puissance_model_1[1],
    IC_Puissance_model_1_sup = IC_Puissance_model_1[2],
    IC_Puissance_model_2_inf = IC_Puissance_model_2[1],
    IC_Puissance_model_2_sup = IC_Puissance_model_2[2]
  )
  return (results)
}


#---------------------------------------------------
# Test : Puissance en fonction de la taille de l'échantillon.
# (Calcul basé sur l'algorithme de Monte Carlo )
#---------------------------------------------------

Puissance_mr<-function(npilote = 20, runs_bs_pilote = 1000, runs_MC = 1000, taille_max = 100, b_0 = NULL, b_1 = NULL, b_2 = NULL, noise_s = NULL, dest_puissance, dest_pilote, puissance = NULL){
  # Environment
  library(gplots)
  library(regression)
  library(boot)
  # Création du pilote
  pilote = pilote_multiple_reg(npilote, runs_bs_pilote, b_0, b_1, b_2, noise_s, dest_pilote)
  # On regarde la puissance en fonction de la taille d'échantillon
  # (!= npilote, qui est la taille du pilote.
  # ici, la taille de l'échantillon correspond à la taille des tirages pour Monte-Carlo)
  tailles = seq(from = 20, to = taille_max, length.out = 15)
  longueur = length(tailles)
  puissances = rep(0,longueur)
  IC_low_width = numeric(longueur)
  IC_up_width = numeric(longueur)
  for (i in 1:longueur){
    # On prend les mêmes tailles d'échantillonage pour les tirages de Monte-Carlo
    results = test_multiple(n = tailles[i], runs = runs_MC, pilote = pilote)
    puissances[i] = results$Puissance_moy_model_2
    IC_low_width[i] =  puissances[i] - results$IC_Puissance_model_2_inf
    IC_up_width[i] = results$IC_Puissance_model_2_sup - puissances[i]
  }
  jpeg(dest_puissance)
  plotCI(tailles, puissances, uiw = IC_up_width, liw = IC_low_width, type = "o", barcol = "red")
  dev.off()
  results # affiche les puissances pour le dernier tirage de Monte Carlo
}

n_calc = 
  Puissance_ur(dest_puissance =  '/user/6/.base/bonjeang/home/SpeProject/Projet-Specialite-Calcul-de-Puissance/TEST/puissance.jpg',
               dest_pilote = '/user/6/.base/bonjeang/home/SpeProject/Projet-Specialite-Calcul-de-Puissance/TEST/pilote.jpg',puissance = 0.8)

n_calc


