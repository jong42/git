function [output] = SIRMODEL (timesteps,x,alpha,beta)
% rough implementation of the SIR model (Epidemiologie) 
    S = -alpha*x(1)*x(2)
    I = alpha*x(1)*x(2)- beta*x(2)
    R = beta*x(2)
   
    output = [S,I,R]';
end