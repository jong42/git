function [output] = SIRMODEL (timesteps,x,alpha,beta)
% rough implementation of the SIR model (Epidemiologie) 
    S = -alpha*S*I
    I = alpha*S*I- beta*I
    R = beta*I
   
    output = [S,I,R];
end