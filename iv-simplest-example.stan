data {
  int<lower=0> N;
  vector[N] y;
  vector[N] x;
  vector[N] z;
}

transformed data {
  array[N] row_vector[2] yx;
  for(i in 1:N) {
    yx[i] = [y[i], x[i]];
  }
}

parameters {
  real alpha;
  real beta;
  real gamma;
  real delta;
  corr_matrix[2] Rho;
  vector<lower=0>[2] Sigma;
}

transformed parameters {
  cov_matrix[2] V = quad_form_diag(Rho, Sigma);
}

model {
  // intercepts
  alpha ~ normal(0, 0.2);
  gamma ~ normal(0, 0.2);
  
  //slopes
  beta ~ normal(0, 0.5);
  delta ~ normal(0, 0.5);
  
  // Errors std devs and correlations 
  Sigma ~ exponential(1);
  Rho ~ lkj_corr(2);
  
  array[N] row_vector[2] mu_yx;
  for(i in 1:N) {
    mu_yx[i] = [alpha + beta * x[i], gamma + delta * z[i]];
  }
  yx ~ multi_normal(mu_yx, V);
}
