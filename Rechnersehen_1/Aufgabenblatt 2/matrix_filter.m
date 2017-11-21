function [res] = matrix_filter(img,row,col,A)

res = 0;

%Iterate over each matrix element
for mat_row = 1:size(A,1)
    for mat_col = 1:size(A,2)
      res = res + A(mat_row,mat_col) * double(img(row-floor(size(A,1)/2)+mat_row-1,col-floor(size(A,2)/2)+mat_col-1));
    end
end


end