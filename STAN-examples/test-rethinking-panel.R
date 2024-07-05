set.seed(987123)
N_groups <- 30
N_id <- 200
a0 <- (-2)
bZY <- (-0.5)
g <- sample(1:N_groups, size=N_id, replace=TRUE) # sample into groups
Ug <- rnorm(N_groups, 1.5) # group confounds
X <- rnorm(N_id, Ug[g] ) # individual varying trait
Z <- rnorm(N_groups) # group varying trait (observed)
Y <- rbern(N_id, p = inv_logit( a0 + X + Ug[g] + bZY * Z[g] ) )


dat <- list(Y = Y, X = X, g = g, Ng = N_groups, Z = Z)
# fixed effects
mf <- ulam(
  alist(
    Y ~ bernoulli(p),
    logit(p) <- a[g] + bxy * X + bzy * Z[g],
    a[g] ~ dnorm(0,10),
    c(bxy,bzy) ~ dnorm(0,1)
  ) , data=dat , chains=4 , cores=4 )

precis(mf)


# varying effects (non-centered - next week!)
mr <- ulam(
  alist(
    Y ~ bernoulli(p),
    logit(p) <- a[g] + bxy*X + bzy*Z[g],
    transpars> vector[Ng]:a <<- abar + z*tau,
    z[g] ~ dnorm(0,1),
    c(bxy,bzy) ~ dnorm(0,1),
    abar ~ dnorm(0,1),
    tau ~ dexp(1)
 ) , data=dat , chains=4 , cores=4 , sample=TRUE )

precis(mr)
