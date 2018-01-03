# Shelling Example

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

