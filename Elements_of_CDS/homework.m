d = csvread ('Data3.csv',2,0)

plot (d,':');
xlabel ('weeks');
ylabel ('number of influenca cases');
title ('process of influenca in season 2016/17');
xlim ([0 30])

 tspan = [0 10]
 y0 = [1000,10,0]
 alpha = 0.5
 beta = 0.1
 func = @(t,x)SIRMODEL(t,x,alpha,beta);
 %[t,y] = ode23 (func,tspan,y0)



