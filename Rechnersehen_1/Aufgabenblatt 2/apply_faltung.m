function [img_res] = apply_faltung(img,A)

img_res = img;

% Iterate over each pixel and apply filter
for row = 1:size(img,1)
   for col = 1:size(img,2)
         % Check for boundary conditions
         if ((row+floor(size(A,1)/2) <= size(img,1)) && (row-floor(size(A,1)/2) >= 1) &&...
             (col+floor(size(A,2)/2) <= size(img,2)) && (col-floor(size(A,2)/2) >= 1))      
                 img_res(row,col) = matrix_filter(img,row,col,A);
         else
             img_res(row,col) = 0;
         end
   end
end

end

