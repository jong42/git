
function [img_inv] = show_invert(filename)

img = imread(filename);
img_inv = im2double(img);

for row = 1:size(img_inv,1)
    for col = 1:size(img_inv,2)
        img_inv(row,col) = 1 - img_inv(row,col);
    end
end

figure('Name','inverted image');
imshow(img_inv);

end