data {
  int<lower=0> N; // number of trials
  int Y; // successes
  int<lower=1> K; // number of priors to combine
  vector[K] means; // mean hyperparameters for the alphas prior 
  vector<lower=0>[K] sds; // standard deviation hyperparameters for the alphas prior 
  real<lower=0> a[K]; // parameters of the K priors
  real<lower=0> b[K];
}
parameters {
real<lower=0,upper=1> theta;
vector[K] m;
}
model {
  vector[K] alpha;
  real astaraux[K];
  real bstaraux[K];
  real astar;
  real bstar; 
    for (k in 1:K){
       alpha[k] <- exp(m[k])/sum(exp(m)); 
       astaraux[k] <- alpha[k]*a[k];
       bstaraux[k] <- alpha[k]*b[k];
    }
  astar <- sum(astaraux);
  bstar <- sum(bstaraux);
  for (k in 1:K){
       m[k] ~ normal(means[k], sds[k]);
  }
  theta ~ beta(astar, bstar);
  Y ~ binomial(N, theta);
}