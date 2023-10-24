data {
  int<lower=1> n0; // number of unobserved outcomes
  int<lower=1> n1; // number of observed outcomes
  int<lower=1> p; // # of regressors in outcome model (including intercept)
  int<lower=1> q; // # of regressors in selection model (including intercept) 

  // Outcome model:
  vector[n1] y; // outcome
  matrix[n1, p] X; // regressors for outcome model, first column is intercept 
  
  // Selection Model:
  // Regressor matrix is split into two pieces based on whether we observe y
  // The columns of each matrix match up: same regressors across Z0, Z1
  // First column of each is intercept 
  matrix[n0, q] Z0; // y *unobserved* i.e selection indicator = 0
  matrix[n1, q] Z1; // y *observed* i.e. selection indicator = 1
}

parameters {
  // Outcome model
  vector[p] beta; // coefficient vector
  real<lower=0> sigma; // error variance
  
  // Selection model
  vector[q] gamma; // coefficient vector
  real<lower= -1, upper= 1> rho; // corr. between selection and outcome errors
}

model {
  // Try flat priors for now
  
  // Selection model: Z for which y is unobserved
  vector[n0] w0 = Z0 * gamma;
  for(i in 1:n0) { 
    target += log(Phi_approx(-w0[i])); // Phi_approx() to avoid underflow
  }
  
  // Selection model: Z for which y is observed 
  vector[n1] w1 = Z1 * gamma;
  vector[n1] Xb = X * beta; 
  vector[n1] u = y - Xb;
  for(i in 1:n1) {
    target += log(Phi_approx((w1[i] + rho * u[i] / sigma) / sqrt(1 - rho^2)));
  }
  
  // Outcome model:
  y ~ normal(Xb, sigma);
}
