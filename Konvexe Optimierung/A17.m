clear

% display beale function

upper_bound = 10
lower_bound = -10
stepwidth = 1

[X1,X2] = meshgrid(lower_bound:stepwidth:upper_bound);

n = ((upper_bound-lower_bound)/stepwidth)+1;

for i=1:1:n
    for j=1:1:n
        Y(i,j) = beale(X1(i),X2(i));
    end
end

surf(X1,X2,Y);

% calculate beale gradient
syms x1 x2 
grad_beale = gradient(beale(x1,x2),[x1,x2])

% calculate beale hessian matrix
hessian_beale = hessian (beale(x1,x2),[x1,x2])

% display spellucci function
for i=1:1:n
    for j=1:1:n
        Y(i,j) = spellucci(X1(i),X2(i));
    end
end

surf(X1,X2,Y);

% calculate spellucci gradient
syms x1 x2 
grad_spellucci = gradient(spellucci(x1,x2),[x1,x2])

% calculate spellucci hessian matrix
hessian_spellucci = hessian (spellucci(x1,x2),[x1,x2])