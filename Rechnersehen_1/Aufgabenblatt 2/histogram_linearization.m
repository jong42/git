
img = imread('Bilder/Aerial.jpg');
[counts,colorvals] = imhist(img);

img_linearized = double(img);

% Iterate over each pixel and change its value accordingly
for row = 1:size(img,1)
    for col = 1:size(img,2)
       img_linearized(row,col) = h_cumulated(img(row,col),counts);
    end
end

[counts_cumulated,colorvals] = imhist(img_linearized);

% Rescale values