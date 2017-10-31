#### A1

myfunc = function(j){
  
  
  x = 1/j
  y = 1/j^2
  
  #x = 1/j
  #y = 1/(1+1/j) - 1
 

  zaehler = y * sin(x)
  nenner = x**2 + y**2
  res = zaehler/nenner
  return(res)
}

plot(myfunc,xlim=c(0,100000))
myfunc(100000000000000)

#### A2

myfunc2 = function(j){
  
  x = 1/j
  y = 1/j^2
  
  #x = myfunc(j)
  #y = myfunc(j)
  
  #x = 1/j^5
  #y = 1/j
  
  zaehler = y * x
  nenner = sqrt(x**2 + y**2)
  res = zaehler/nenner
  return(res)
}

plot(myfunc2,xlim=c(0,5))
myfunc2(100000000000000)