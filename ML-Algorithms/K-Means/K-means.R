set.seed(123)

#This function calculates the reconstruction error
error_cal <- function(x) 
{
  error <- 0
  n <- ncol(x)
  k <- n - 3
  for(z in seq(1:k))
  {
    for(t in seq(1:nrow(x)))
    {
      if(x[t,n] == z)
      {
        error <- x[t,(z+2)] + error
      }
    }
  }
  return(error)
}



#function for euclidean distance
euc_dist <- function(xt,x2,y2) 
{
  dist = sqrt((xt[,1]-x2)^2 + (xt[,2] - y2)^2)
  return(dist)
}

#Function for finding centers
#This function recalculates the centres
mean_cent_x <- function(xt,k,t,mx) 
{
  count <- 0
  p<- 0
  for(n in seq(1:nrow(xt)))
  {
    
    if(xt[n,(k+3)] == t)
    {
      p <- p + xt[n,1]
      count <- count + 1
    }
    mx[k] <- p/count
  }
  return(mx[k])
}

#Function for finding centers
#This function recalculates the centres
mean_cent_y <- function(xt,k,t,my) 
{
  count <- 0
  q <- 0
  for(n in seq(1:nrow(xt)))
  {
    
    if(xt[n,(k+3)] == t)
    {
      q <- q + xt[n,2]
      count <- count + 1
    }
    my[k] <- q/count
  }
  return(my[k])
}

kmeans <- function(k)
{
#Generating samples from 3 different distributions
x1 <- rnorm(100,10,25)
x2 <- rnorm(100,15,20)
x3 <- rnorm(100,20,30)
x <- c(x1,x2,x3)
y <- 1:300
xt <- data.frame(x,y) #Generating a univariate sample
mx <- sample(x,k)
my <- sample(y,k)

# Running 10 iterations to find the centers
for(a in seq(1:10)) 
{
#K defines the number of centres we wish to have
for(t in seq(1:k))
{
  l <- t+2
  xt[,l] <- euc_dist(xt,mx[t],my[t])
}
vec <- 3:(k+2)  
for(t in seq(1:k))
{

for(n in seq(1:nrow(xt)))
{
  if(xt[n,(t+2)] == apply(xt[n,vec],1,min))
  {
    xt[n,(k+3)] <- t
  }
}
}
#Finding the mean centers using the function created above  
for(t in seq(1:k))
{
x <- xt
y<- xt
mx[t] <- mean_cent_x(x,k,t,mx)
my[t] <- mean_cent_y(y,k,t,my)
}
}
plot(xt[,2], xt[,1], col=xt[,(k+3)], pch = 19 , main = "K means clustering")
return(xt)
}


x2 <- kmeans(2)
x3 <- kmeans(3)
x4 <- kmeans(4)

e2 <- error_cal(x2)
e3 <- error_cal(x3)
e4 <- error_cal(x4)

e <- c(e2,e3,e4)
plot(c(2,3,4),e, type ="l", xlab = "Value of K",
     ylab = "Reconstruction Error", main = "Reconstruction for different values of K")
