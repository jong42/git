myfunc = function(x,y){
  #x = a[1]
  #y = a[2]
  if ((x**2+y**2)>0){
    res = x*y*(x**2-y**2)/(x**2+y**2)
  } else if (x==y && x==0){
    res = 0
  }
  return(res)
}


x <- seq(-3,3,length.out=100)
y <- seq(-3,3,length.out=100)
z <- outer(x,y,myfunc)

persp(x,y,z, col='red',axes=T,ticktype="detailed")


