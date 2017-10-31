function [img] = gamma_correction(filename,gamma)

img = imread(filename);
img= im2double(img);

for row = 1:size(img,1)
    for col = 1:size(img,2)
        img(row,col) =  img(row,col)^gamma;
    end
end


end