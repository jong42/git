

row_names = c("array size / 1024","Ax CPU","A^Tx CPU","Ax GPU","A^Tx GPU","Ax GPU shared mem","A^Tx GPU shared mem", "Ax GPU shared mem dp","A^Tx GPU shared mem dp")
nr_1 = c(1,2.648388,8.519093,1.381536,0.496960,6.868512,8.026976,3.775520,4.357088)
nr_2 = c(2,10.844859 ,86.301981,2.760736,0.990336,13.728864,16.109024,4.148192,5.189088)
nr_3 = c(4, 43.006201 ,379.152365,5.492832,1.980096,27.623072 ,32.605919,131.763428,132.323929)
nr_4 = c(8, 171.924113 ,1568.620750,21.878529,4.138976 ,57.452255  ,79.533058,448.153351,562.721436)
nr_5 = c(16, 687.508070 ,6585.118184 ,91.003487,10.681856 ,110.084351  ,250.683838,1530.365967,2018.924438)

res_mat = matrix(data=c(nr_1,nr_2,nr_3,nr_4,nr_5),nrow=9,ncol=5)

res = data.frame(nr_1,nr_2,nr_3,nr_4,nr_5)
row.names(res) = row_names

library(gridExtra)
grid.table(res)

## plot full area
plot(res_mat[2,],type="l",xlab="Matrixgröße/1024",ylab="Laufzeit in ms",col=1,ylim = c(0,7000),xaxt="n")
axis(side=1, at=c(1,2,3,4,5), labels=c(1,2,4,8,16)) 
lines(res_mat[3,],col=2)
lines(res_mat[4,],col=3)
lines(res_mat[5,],col=4)
lines(res_mat[6,],col=5)
lines(res_mat[7,],col=6)
lines(res_mat[8,],col=7)
lines(res_mat[9,],col=8)

legend(1,y=7000,legend=c("Ax CPU","A^Tx CPU","Ax GPU","A^Tx GPU","Ax GPU shared mem","A^Tx GPU shared mem", "Ax GPU shared mem dp","A^Tx GPU shared mem dp"),
        fill=c(1,2,3,4,5,6,7,8))

## plot small matrix size
plot(res_mat[2,],type="l",xlab="Matrixgröße/1024",ylab="Laufzeit in ms",col=1,xlim=c(1,2),ylim = c(0,50))
lines(res_mat[3,],col=2)
lines(res_mat[4,],col=3)
lines(res_mat[5,],col=4)
lines(res_mat[6,],col=5)
lines(res_mat[7,],col=6)
lines(res_mat[8,],col=7)
lines(res_mat[9,],col=8)

legend(1,y=50,legend=c("Ax CPU","A^Tx CPU","Ax GPU","A^Tx GPU","Ax GPU shared mem","A^Tx GPU shared mem", "Ax GPU shared mem dp","A^Tx GPU shared mem dp"),
       fill=c(1,2,3,4,5,6,7,8))


## plot small time values
plot(res_mat[2,],type="l",xlab="Matrixgröße/1024",ylab="Laufzeit in ms",col=1,ylim = c(0,400),xaxt="n")
axis(side=1, at=c(1,2,3,4,5), labels=c(1,2,4,8,16)) 
lines(res_mat[3,],col=2)
lines(res_mat[4,],col=3)
lines(res_mat[5,],col=4)
lines(res_mat[6,],col=5)
lines(res_mat[7,],col=6)
lines(res_mat[8,],col=7)
lines(res_mat[9,],col=8)

legend(1,y=400,legend=c("Ax CPU","A^Tx CPU","Ax GPU","A^Tx GPU","Ax GPU shared mem","A^Tx GPU shared mem", "Ax GPU shared mem dp","A^Tx GPU shared mem dp"),
       fill=c(1,2,3,4,5,6,7,8))


