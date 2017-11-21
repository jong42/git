function [A_Gauss] = create_gauss_matrix(m,n)

sigma=m/5;
A_Gauss = zeros(m,n,'double');

for row = 1:size(A_Gauss,1)
    for col = 1:size(A_Gauss,2)
      A_Gauss(row,col) = exp(-(row^2 + col^2)/(2*sigma^2));
    end
end

% Normiere auf Summe=1
A_Gauss = A_Gauss/sum(A_Gauss(:));

end