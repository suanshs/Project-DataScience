library("parallel")
library("foreach")
library("itertools")
library("doParallel")
library("rbenchmark")

set.seed(123)
#Initializing the Clusters
nc <- detectCores() - 1
cl <- makeCluster(rep("localhost", nc))
#Parallel Matrix Multiplication
#Splitting the rows of Matrix A and distributing it to the clusters

matprod.par <- function(cl, A, B) {
  index <- splitIndices(nrow(A), length(cl))
  Alist <- lapply(index, function(ii) A[ii,,drop=FALSE])
  do.call(rbind, clusterApply(cl, Alist, get('%*%'), B))
}
####Training####

#Calculating regression parameters with original matrix multiplication
regression_org <- function(x,r)
{
  w = solve((t(x)%*%x)) %*% t(x) %*% r
  return(w)
}

#Calculating regression parameters with parallel matrix multiplication
regression_par <- function(cl,x,r)
{
  t <- t(x)
  w = matprod.par(cl,matprod.par(cl,solve(matprod.par(cl,t,x)),t),r)
  return(w)
}


t1 <- benchmark(
  "Original" = {
    X <- matrix(rnorm(500000), 5000, 100)
    R <- matrix(rnorm(5000),5000,1)
    b <- regression_org(X,R)
  },
  "Parallel" = {
    X <- matrix(rnorm(500000), 5000, 100)
    R <- matrix(rnorm(5000),5000,1)
    b <- regression_par(cl,X,R)
  },
  replications = 1,
  columns = c("test", "replications", "elapsed",
              "relative", "user.self", "sys.self"))

t2 <- benchmark(
  "Original" = {
    X <- matrix(rnorm(750000), 5000, 150)
    R <- matrix(rnorm(5000),5000,1)
    b <- regression_org(X,R)
  },
  "Parallel" = {
    X <- matrix(rnorm(750000), 5000, 150)
    R <- matrix(rnorm(5000),5000,1)
    b <- regression_par(cl,X,R)
  },
  replications = 1,
  columns = c("test", "replications", "elapsed",
              "relative", "user.self", "sys.self"))


t3 <- benchmark(
  "Original" = {
    X <- matrix(rnorm(500000), 1000, 500)
    R <- matrix(rnorm(1000),1000,1)
    b <- regression_org(X,R)
  },
  "Parallel" = {
    X <- matrix(rnorm(500000), 1000, 500)
    R <- matrix(rnorm(1000),1000,1)
    b <- regression_par(cl,X,R)
  },
  replications = 1,
  columns = c("test", "replications", "elapsed",
              "relative", "user.self", "sys.self"))


t4 <- benchmark(
  "Original" = {
    X <- matrix(rnorm(1000000), 1000, 1000)
    R <- matrix(rnorm(1000),1000,1)
    b <- regression_org(X,R)
  },
  "Parallel" = {
    X <- matrix(rnorm(1000000), 1000, 1000)
    R <- matrix(rnorm(1000),1000,1)
    b <- regression_par(cl,X,R)
  },
  replications = 1,
  columns = c("test", "replications", "elapsed",
              "relative", "user.self", "sys.self"))



t5 <- benchmark(
  "Original" = {
    X <- matrix(rnorm(10000000), 10000, 1000)
    R <- matrix(rnorm(10000),10000,1)
    b <- regression_org(X,R)
  },
  "Parallel" = {
    X <- matrix(rnorm(10000000), 10000, 1000)
    R <- matrix(rnorm(10000),10000,1)
    b <- regression_par(cl,X,R)
  },
  replications = 1,
  columns = c("test", "replications", "elapsed",
              "relative", "user.self", "sys.self"))

t1$inputdim <- "5000 * 100"
t2$inputdim <- "5000 * 150"
t3$inputdim <- "1000 * 500"
t4$inputdim <- "1000 * 1000"
t5$inputdim <- "10000 * 1000"

t <- rbind(t1,t2,t3,t4,t5)
t
