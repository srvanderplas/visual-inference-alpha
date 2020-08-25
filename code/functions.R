mvbeta <- function(alpha, log = F) {
  z <- sum(lgamma(alpha)) - lgamma(sum(alpha))
  if (!log) return(exp(z)) else return(z)
}

bf <- function(a1, a2, m = 20, c, k = sum(c)) {
  stopifnot(a1 > 0, a2 > 0, c <= k, m > 1)

  beta(a2, (m - 1)*a2) * beta(c + a1, k - c + (m - 1)*a1) /
    (beta(a1, (m - 1)*a1) * beta(c + a2, k - c + (m - 1)*a2))
}
bf_vec <- function(a1, a2, m = 20, c, k = sum(c)) {
  stopifnot(a1 > 0, a2 > 0, c <= k, m > 1)

  exp(mvbeta(rep(a2, length(c)), log = T) + mvbeta(a1 + c, log = T) -
        mvbeta(rep(a1, length(c)), log = T) - mvbeta(a2 + c, log = T))
}
vis_p_value <- function(C, K, alpha = 1, m = 20){
  single_p <- function(cc, kk, aa, mm) {
    x <- cc:kk
    sum(exp(lchoose(kk, x) - lbeta(aa, (mm - 1) * aa) + lbeta(x + aa, kk - x + (mm - 1) * aa)))
  }

  df <- tibble(cc = C,
               kk = K,
               aa = alpha,
               mm = m) %>%
    unnest(everything()) %>%
    mutate(p = purrr::pmap_dbl(., single_p))
  df$p
}

vis_p_value_orig <- function(C, K, m = 20){
  single_p <- function(cc, kk, aa, mm) {
    x <- cc:kk
    sum(exp(lchoose(kk, x) - x*log(mm) + (kk-x)*log(1-1/mm)))
  }
  
  df <- tibble(cc = C,
               kk = K,
               mm = m) %>%
    unnest() %>%
    mutate(p = purrr::pmap_dbl(., single_p))
  df$p
}


sim_lineup_model <- function(alpha, m = 19, K = 22, N = 50) {
  theta <- gtools::rdirichlet(1, rep(alpha, m))
  sels <- rmultinom(N, size = K, prob = theta)
  sels
}
