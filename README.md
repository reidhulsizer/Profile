# someofmybestwork

```{r}
library(astsa)
library(knitr)
library(tseries)
x = read.csv("final01.csv", header=TRUE)
y = read.csv("final02.csv", header=TRUE)
plot(ts(y$X.0.1964947))
plot(ts(x$X0.2410655))
x = diff(log(x$X0.2410655))
y = diff(y$X.0.1964947)
a = ts(x)
b = ts(y)
plot(a)
plot(b)
acf(a)
pacf(a)
#a monthly data w/ seasonality looks like MA maybe AR 
acf(b)
pacf(b)
#b looks like MA maybe ARMA
acf(b^2)
acf(a^2)
qqnorm(a)
qqnorm(b)
```
#a
```{r}
(fit01 <- sarima(a, 0, 0, 0,   0, 0, 1,   12, details=FALSE ))
(fit10 <- sarima(a, 0, 0, 1,   0, 0, 0,   12, details=FALSE ))
(fit11 <- sarima(a, 0, 0, 1,   0, 0, 1,   12, details=FALSE ))
(fit00 <- sarima(a, 0, 0, 0,   0, 0, 0,   12, details=FALSE ))
(fit20 <- sarima(a, 0, 0, 2,   0, 0, 0,   12, details=FALSE ))
(fit02 <- sarima(a, 0, 0, 0,   0, 0, 2,   12, details=FALSE ))
mdl = c( "fit01", "fit02", "fit11", "fit00", "fit10", "fit20")
aic = c( fit01$AIC, fit02$AIC, fit11$AIC, fit00$AIC, fit10$AIC, fit20$AIC)
bic = c( fit01$BIC, fit02$BIC, fit11$BIC, fit00$BIC, fit10$BIC, fit20$BIC)
kable( cbind(mdl,aic,bic) )
(fit11a <- sarima(a, 0, 0, 1,   0, 0, 1,   12, details=FALSE ))
(fit11b <- sarima(a, 0, 0, 1,   1, 0, 1,   12, details=FALSE ))
(fit11c <- sarima(a, 0, 0, 1,   0, 1, 1,   12, details=FALSE ))
(fit11d <- sarima(a, 0, 0, 1,   1, 1, 1,   12, details=FALSE ))
nm = c( "fit11a", "fit11b", "fit11c", "fit11d")
aic = c( fit11a$AIC, fit11b$AIC, fit11c$AIC, fit11d$AIC)
bic = c( fit11a$BIC, fit11b$BIC, fit11c$BIC, fit11d$BIC)
kable( cbind(nm,aic,bic) )
(fit11da <- sarima(a, 0, 0, 1,   1, 1, 1,   12, details=FALSE ))
(fit11db <- sarima(a, 0, 0, 1,   1, 2, 1,   12, details=FALSE ))
(fit11dc <- sarima(a, 0, 0, 1,   2, 1, 1,   12, details=FALSE ))
(fit11dd <- sarima(a, 0, 0, 1,   2, 2, 1,   12, details=FALSE ))
nms = c( "fit11da", "fit11db", "fit11dc", "fit11dd")
aic = c( fit11da$AIC, fit11db$AIC, fit11dc$AIC, fit11dd$AIC)
bic = c( fit11da$BIC, fit11db$BIC, fit11dc$BIC, fit11dd$BIC)
kable( cbind(nms,aic,bic) )
(fit11dca <- sarima(a, 0, 0, 1,   2, 1, 1,   12, details=FALSE ))
(fit11dcb <- sarima(a, 0, 0, 1,   3, 1, 1,   12, details=FALSE ))
(fit11dcc <- sarima(a, 0, 1, 1,   2, 1, 1,   12, details=FALSE ))
(fit11dcd <- sarima(a, 1, 0, 1,   2, 1, 1,   12, details=FALSE ))
ns = c( "fit11dca", "fit11dcb", "fit11dcc", "fit11dcd")
aic = c( fit11dca$AIC, fit11dcb$AIC, fit11dcc$AIC, fit11dcd$AIC)
bic = c( fit11dca$BIC, fit11dcb$BIC, fit11dcc$BIC, fit11dcd$BIC)
kable( cbind(ns,aic,bic) )

# Project 4 
#Reid H

# This function calculates the index of dissimilarity by dividing the unit square into 4 quadrants and 
#looking at the proportion of each type in each quadrant.
# Inputs:
# x1: a vector of the x locations of type 1 people (length = number of type 1 people)
# y1: a vector of the y locations of type 1 people (length = number of type 1 people)
# x2: a vector of the x locations of type 2 people (length = number of type 2 people)
# y2: a vector of the y locations of type 2 people (length = number of type 2 people)
#
# Return Value:  the index of dissimilarity, between 0 and 1 (0=perfect integration, 1=perfect segregation)


calcindex <- function(x1,y1,x2,y2){
  
  n1 = length(x1)
  n2 = length(x2)
  
  q1e=sum(as.integer((x1<0.5)&(y1<0.5)))
  q2e=sum(as.integer((x1>=0.5)&(y1<0.5)))
  q3e=sum(as.integer((x1<0.5)&(y1>=0.5)))
  q4e=sum(as.integer((x1>=0.5)&(y1>=0.5)))
  
  q1o=sum(as.integer((x2<0.5)&(y2<0.5)))
  q2o=sum(as.integer((x2>=0.5)&(y2<0.5)))
  q3o=sum(as.integer((x2<0.5)&(y2>=0.5)))
  q4o=sum(as.integer((x2>=0.5)&(y2>=0.5)))
  
  r = 0.5*(abs(q1e/n1-q1o/n2)+abs(q2e/n1-q2o/n2)+abs(q3e/n1-q3o/n2)+abs(q4e/n1-q4o/n2))
  
  return(r)
  
}


#N = # of people
#f = fraction of people of type 1
#t = threshold % of people that must be of same type
#s = # of iterations 

distance = function(x, y) {
  return(dist(t(array(c(x, t(y)), dim=c(ncol(y), 1+nrow(y)))))[1:nrow(y)])
}

Shelling = function (n, f, t, s){
  y1 = c(runif(n))
  x1 = c(runif(n))
  points = cbind(x1,y1)
  apop = n*f
  type = c()
  neighbor = vector(length=10)
  for (j in 1:n){
    if (j <= apop) {(type[j] = 1)}
    else type[j] = 2
  }
  solution = c()
  solution[1] = calcindex(x1[1:apop], y1[1:apop], x1[(apop+1):n], y1[(apop+1):n])
  for (h in 1:s){
    for(i in 1:50){
      new = 1
      while (new==1){
        new = 0 
        points = cbind(x1,y1)
        d = c(distance(points[i,], points))
        d = replace(d, d==0, 1)
        equal = 0
        for(j in 1:10){
          neighbor[j] = which.min(d)
          if (type[neighbor[j]] == type[i]){
            equal = equal + 1 
          }
          d[neighbor[j]] = 1
        }
        if (equal < t*10){
          x1[i] = runif(1)
          y1[i] = runif(1)
          new = 1
        }
      }
    }
  }
  solution[2] = calcindex(x1[1:apop], y1[1:apop], x1[(apop+1):n], y1[(apop+1):n])
  return(solution)
}

Shelling(50, .4, .5,50)

data = data.frame(list(character(), character(), numeric(), character(), numeric(), character()))
names(data) = c("date", "away_team", "away_score", "home_team", "home_score", "location")

y = list()
  for (i in 1960:2010){
    y[[i]] = read.fwf(paste("http://homepages.cae.wisc.edu/~dwilson/rsfc/history/howell/cf",i,"gms.txt",sep=""), width = c(11, 28, 3, 29, 3, 20)) 
  }
data = rbind.data.frame(y[[1960]],y[[1961]],y[[1962]],y[[1963]],y[[1964]],y[[1965]],y[[1966]],y[[1967]],y[[1968]],y[[1969]],y[[1970]],y[[1971]],y[[1972]],y[[1973]],y[[1974]],y[[1975]],y[[1976]],y[[1977]],y[[1978]],y[[1979]],y[[1980]],y[[1981]],y[[1982]],y[[1983]],y[[1984]],y[[1985]],y[[1986]],y[[1987]],y[[1988]],y[[1989]],y[[1990]],y[[1991]],y[[1992]],y[[1993]],y[[1994]],y[[1995]],y[[1996]],y[[1997]],y[[1998]],y[[1999]],y[[2000]],y[[2001]],y[[2002]],y[[2003]],y[[2004]],y[[2005]],y[[2006]],y[[2007]],y[[2008]],y[[2009]],y[[2010]])

#data = rbind.data.frame(for(i in 1960:2010){(paste0(,y[[i]],","))})

names(data) = c("date", "away_team", "away_score", "home_team", "home_score", "location")

data$season = as.numeric(substr(data$date,7,10))
data$month = as.numeric(substr(data$date,1,2))

for(i in 1:length(data$date)){if(data$month[[i]] < 3){data$season[[i]] = data$season[[i]] - 1}}
for(i in 1:length(data$date)){if(data$away_score[[i]] < data$home_score[[i]]){data$winner[[i]] = as.character(paste(data$season[[i]],data$home_team[[i]],sep = ""))}}
for(i in 1:length(data$date)){if(data$away_score[[i]] > data$home_score[[i]]){data$winner[[i]] = as.character(paste(data$season[[i]],data$away_team[[i]],sep = " "))}}
for(i in 1:length(data$date)){if(data$away_score[[i]] == data$home_score[[i]]){data$winner[[i]] = as.character("NULL")}}
for(i in 1:length(data$date)){if(data$away_score[[i]] == data$home_score[[i]]){data$loser[[i]] = as.character("NULL")}}
for(i in 1:length(data$date)){if(data$away_score[[i]] < data$home_score[[i]]){data$loser[[i]] = as.character(paste(data$season[[i]],data$away_team[[i]],sep = " "))}}
for(i in 1:length(data$date)){if(data$away_score[[i]] > data$home_score[[i]]){data$loser[[i]] = as.character(paste(data$season[[i]],data$home_team[[i]],sep = ""))}}
for(i in 1:length(data$date)){data$AWAY[[i]] = as.character(paste(data$season[[i]],data$away_team[[i]],sep = " "))}
for(i in 1:length(data$date)){data$HOME[[i]] = as.character(paste(data$season[[i]],data$home_team[[i]],sep = ""))}
for(i in 1:length(data$date)){if(data$away_score[[i]] == data$home_score[[i]]){data$loser[[i]] = as.character("NULL")}}

df = data.frame(factor(8572),numeric(8572),numeric(8572),numeric(8572))
names(df) = c("Teams", "Wins", "Losses", "Games")

a = as.vector(rbind(data$HOME,data$AWAY))
df$Teams = unique(a)

df$Games = 0
for(i in 1:length(df$Teams)){
  for(j in 1:71906){
    if(df$Teams[[i]] == a[[j]]){
      df$Games[[i]] = df$Games[[i]] +1
    }
  }
}

for(i in 1:6060){
if(df$Games < 6){
    df = df[-i,]
  }
}

df$Wins = 0
df$Losses = 0
for(i in 1:6060){
  for(j in 1:length(data$date)){
    if(df$Teams[[i]] == data$winner[[j]]){
      df$Wins[[i]] = df$Wins[[i]] +1
      df$Opponents[[i]] = c(df$Opponents[[i]] , which(df$Teams == as.factor(data$loser[[j]])))
    }
    if(df$Teams[[i]] == data$loser[[j]]){
      df$Losses[[i]] = df$Losses[[i]] + 1
      df$Opponents[[i]] = c(df$Opponents[[i]] , which(df$Teams == as.factor(data$winner[[j]])))
    }
  }
}


A = matrix(diag(2+(df$Losses+df$Wins)), nrow=6060)
for(i in 1:6060){
  for(j in 1:6060){
    if(j %in% (df$Opponents)[[i]]){
      A[i,j] = -1*length(which(j == df$Opponents[[i]][]))
    }
  }
}


b= matrix(1 + (df$Wins - df$Losses)/2,nrow = 6060)


C = solve(A,b)

solution = data.frame(df$Teams,C)
solution = solution[order(-solution$C),]

year = function(x){
  for(i in 1:length(solution$df.Teams)){
    if(as.factor(" x.*") =! solution$df.teams[[i]]){
      solution = solution[-i,]
    }
    return(solution$df.Teams)
  }
}


