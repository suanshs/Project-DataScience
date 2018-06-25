##Labwork 3##

##Generating a multivariate dataset with 2 dimensions
x1 <- runif(200,-10,10)
x2 <- runif(200,-12,12)
x3 <- rep(100,200)
x4 <- rep(100,200)
x5 <- rep(100,200)
index <- seq(1,200)

x <- rbind(index,x1,x2,x3,x4,x5)

#calculating Eucladian distance
euc_dist <- function(x,m)
{
  d <- sqrt((x[1]-m[1])^2 + (x[2]-m[2])^2)
  return(d)
}

##Initializing the centres
centreInitialization <- function(k)
{
  m_x <- c()
  m_y <- c()
  m_d <- rep(100000,k)
  for(i in seq(1,k))
  {
    m_x[i] <- runif(1,-5,5)
    m_y[i] <- runif(1,-6,6)
  }
  m <- cbind(m_x,m_y,m_d)
  return(m)
}

##The below below calculates the minimum distance with the centres

k_means <- function(x,m,n)
{
  #Finding distance with each centre
  for(i in seq(1,nrow(m)))
  {
    m[i,3] <- euc_dist(x,m[i,])
  }
  #Finding the minimum distance
  m[which.min(m[,3]),1] <-  m[which.min(m[,3]),1] + n * (x[1] - m[which.min(m[,3]),1])
  m[which.min(m[,3]),2] <-  m[which.min(m[,3]),2] + n * (x[2] - m[which.min(m[,3]),2])
  return(m)
}

#Implementing online k-means

o_kmeans <- function(x,k,n)
{
  m <- centreInitialization(k)
  #Updating the centres with every incoming point
  for(i in seq(1,ncol(x)))
  {
    m <- k_means(x[c(2,3),i],m,n)
  }
  d <- c()
  ##Alotting the centres to the points
  for(i in seq(1,ncol(x)))
  {
    for(j in seq(1,k))
    {
      d[j] <- euc_dist(x[c(2,3),i],m[j,c(1,2)])
    }
    x[4,i] <- which.min(d)
    x[4,i] <- which.min(d)
    x[5,i] <- m[which.min(d),1]
    x[6,i] <- m[which.min(d),2]
  }
  
  plot(x[2,],x[3,], col = x[4,], pch = 19, main = "Online K-Means", xlab = "X1", ylab = "X2")
  return(x)
}


##Implementing Adaptive resonance theory

art <- function(x,rho,n)
{
  #Randomly initializing a centre
  m <- centreInitialization(1)
  
  #Calculating eucledean distance with this centre
  for(i in seq(1, ncol(x)))
  {
    #Finding distance with each centre
    for(j in seq(1,nrow(m)))
    {
      m[j,3] <- euc_dist(x[c(2,3),i],m[j,c(1,2)])
    }
  
   
    if(min(m[,3]) <= rho)
    {
      m[which.min(m[,3]),1] <-  m[which.min(m[,3]),1] + n * (x[2,i] - m[which.min(m[,3]),1])
      m[which.min(m[,3]),2] <-  m[which.min(m[,3]),2] + n * (x[3,i] - m[which.min(m[,3]),2])
    }
    else
    {
      m <- rbind(m,c(x[2,i],x[3,i],100000))
    }
  }
  d <- c()
  #Alotting the centres
  for(i in seq(1,ncol(x)))
  {
    for(j in seq(1,nrow(m)))
    {
      d[j] <- euc_dist(x[c(2,3),i],m[j,c(1,2)])
    }
    if(min(d) <= rho)
    x[4,i] <- which.min(d)
    x[4,i] <- which.min(d)
    x[5,i] <- m[which.min(d),1]
    x[6,i] <- m[which.min(d),2]
  }
  
  plot(x[2,],x[3,], col = x[4,], pch = 19, main = "Adaptive Resonance Theory", xlab = "X1", ylab = "X2")
  return(x)
}



#Implementing self-organizing maps

#Creating a function to calculate the neighborhood function
e <- function(l,i)
{
  e <- (1/(sqrt(2 * pi) * 0.398)) * exp(-1 * (((l-i)^2)/(2 * 0.398 *0.398)))
  return(e)
}

som <- function(x,k,n,nb = 2)
{
  m <- centreInitialization(k)
  for(i in seq(1,ncol(x)))
  {
    #Finding distance with each centre
    for(j in seq(1,nrow(m)))
    {
      m[j,3] <- euc_dist(x[c(2,3),i],m[j,c(1,2)])
    }
    #Updating the centres
    #Updating the closest centre 
    m[which.min(m[,3]),1] <-  m[which.min(m[,3]),1] + n * (x[2,i] - m[which.min(m[,3]),1]) * e(1,1)
    m[which.min(m[,3]),2] <-  m[which.min(m[,3]),2] + n * (x[3,i] - m[which.min(m[,3]),2]) * e(1,1)
    for(j in seq(1,nrow(m)))
    {
      m[j,3] <- euc_dist(m[which.min(m[,3]),c(1,2)],m[j,c(1,2)])
    }
    d <- sort(m[,3])
  
    #Updating the neighborhood
    for(o in seq(1,nb))
    {
      m[m[,3]==d[o],1] <- m[m[,3]==d[o],1] + n * (x[2,i] - m[m[,3]==d[o],1]) * e(1,(o+1))
      m[m[,3]==d[o],2] <- m[m[,3]==d[o],2] + n * (x[3,i] - m[m[,3]==d[o],2]) * e(1,(o+1))
    }
  }
  d <- c()
  #Alotting the centres
  for(i in seq(1,ncol(x)))
  {
    for(j in seq(1,nrow(m)))
    {
      d[j] <- euc_dist(x[c(2,3),i],m[j,c(1,2)])
    }
    x[4,i] <- which.min(d)
    x[5,i] <- m[which.min(d),1]
    x[6,i] <- m[which.min(d),2]
  }
  
  plot(x[2,],x[3,], col = x[4,], pch = 19, main = "Self-Organizing Maps", xlab = "X1", ylab = "X2")
  return(x)
  
}



#Function for calculating reconstruction error
error_cal <- function(x) 
{
  error <- 0
  k <- max(x[3,])
  
    for(t in seq(1:ncol(x)))
    {
      {
        error <- euc_dist(x[c(1,2),t],x[c(4,5),t])+ error
      }
    }
  
  return(error)
}


r1 <- o_kmeans(x,5,0.1)
e1 <- error_cal(r1)

r2 <- art(x,10,0.1)
e2 <- error_cal(r2)

r3 <- som(x,5,0.1,3)
e3 <- error_cal(r3)
