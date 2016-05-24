alpha <- 10 - sample(0:2000, 1)/100
beta_x <- 10 - sample(0:2000, 1)/100
beta_y <- 10 - sample(0:2000, 1)/100
beta_z <- 10 - sample(0:2000, 1)/100

n = 3

mu_x <- 5 - sample(0:1000, 1)/100
s_x <- sample(0:300, 1)/100
mu_y <- 5 - sample(0:1000, 1)/100
s_y <- sample(0:300, 1)/100
mu_z <- 5 - sample(0:1000, 1)/100
s_z <- sample(0:300, 1)/100

observations<-function(n, mu_x, s_x, mu_y, s_y, mu_z, s_z){
  x <- rnorm(n, mean = mu_x, sd = s_x)
  y <- rnorm(n, mean = mu_y, sd = s_y)
  z <- rnorm(n, mean = mu_z, sd = s_z)
  e <- rnorm(n, mean = 0, sd = 1)
  return (c(x,y,z,e))
}

regression<-function(alpha, beta_x, x, beta_y, y, beta_z, z, e){
  Y <- alpha + beta_x*x + beta_y*y + beta_z*z + e
  return(Y)
}

observations <- observations(n, mu_x, s_x, mu_y, s_y, mu_z, s_z)
observations
x <- observations[1:n]
y <- observations[n+1:2*n]
z <- observations[2*n+1:3*n]
e <- observations[3*n+1:4*n]

Y <- regression(alpha, beta_x, x, beta_y, y, beta_z, z, e)

observations
x
y
z
Y