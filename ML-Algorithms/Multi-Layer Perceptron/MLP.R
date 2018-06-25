#Creating the sigmoid function
sigmoid <- function(x)
{
  y <- 1/(1 + exp(-x))
  return(y)
}

#Creating the dataset
x2 <- seq(-0.5,0.5, by = 0.01)
l <- length(x2)
x1 <- rep(1,l)
x <- rbind(x1,x2)
noise <- rnorm(l,0,0.02)
r <-   sin(6 * x2) + noise


##Implementing Multi Layer Perceptron using Back Propagation
nn <- function(iter = 300,x,r)
{
  l <- ncol(x)
  #Setting a step function
  n <- 0.01
  #Initializing the values of w and v
  w <- matrix(c(runif(1,-0.01,0.01),runif(1,-0.01,0.01),runif(1,-0.01,0.01),runif(1,-0.01,0.01)),nrow = 2,ncol = 2)
  v <- c(runif(1,-0.01,0.01),runif(1,-0.01,0.01),runif(1,-0.01,0.01))
  
  #Setting some empty parameters
  z <- c()
  d_v <- c()
  d_w <- matrix(,nrow = 2, ncol = 2)
  for(j in seq(1,iter))
  {
    for(t in seq(1,l))
    {
      for(h in seq(1,2))
      {
        z[h] = sigmoid(w[h,1]+ w[h,2]*x[2,t])
      }
      y <- sum(v * c(1,z))
      for(i in seq(1,3))
      {
        d_v <- n * (r[t] - y)*c(1,z)
      }
      for(h in seq(1,2))
      {
        d_w[h,1] <- n*sum((r[t] - y) * v[h+1])*z[h]*(1-z[h])*x[1,t]
        d_w[h,2] <- n*sum((r[t] - y) * v[h+1])*z[h]*(1-z[h])*x[2,t]
      }
      for(i in seq(1,3))
      {
        v[i] <- v[i] + d_v[i]
      }
      for(h in seq(1,2))
      {
        w[h,1] <- w[h,1] + d_w[h,1]
        w[h,2] <- w[h,2] + d_w[h,2]
      }
    }
  }
  return(c(w[1,1],w[1,2],w[2,1],w[2,2],v))
}

output <- function(p,x)
{
  z <- c()
  l <- ncol(x)
  w <- matrix(p[1:4],nrow = 2,ncol=2)
  v <- p[5:7]
  f <- c()
  for(t in seq(1,l))
  {
    z[1] <- sigmoid(w[1,1] + w[1,2]*x[2,t])
    z[2] <- sigmoid(w[2,1] + w[2,2]*x[2,t])
    temp <- sum(v * c(1,z))
    f <- c(f,temp)
  }
  return(f)
}

plot(range(-0.5,0.5), range(-2,2), type='n')
lines(x2,r)

p1 <- nn(100,x,r)
o1 <- output(p1,x)
lines(x2, o1, type='l', col='green')

p2 <- nn(300,x,r)
o2 <- output(p2,x)
lines(x2, o2, type='l', col='red')

p3 <- nn(500,x,r)
o3 <- output(p3,x)
lines(x2, o3, type='l', col='blue')

legend(-0.4,2, legend=c("Original","100 iterations", "300 iterations", "500 iterations"),
       col=c("black","green","red","blue"), lty=1:2, cex=0.8)
