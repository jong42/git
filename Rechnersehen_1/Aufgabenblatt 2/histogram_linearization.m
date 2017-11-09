function img_linearized = histogram_linearization(img)

[counts,colorvals] = imhist(img);

img_linearized = double(img);

% Iterate over each pixel and change its value accordingly
for row = 1:size(img,1)
    for col = 1:size(img,2)
       img_linearized(row,col) = h_cumulated(img(row,col),counts);
    end
end

% Rescale values

img_linearized = uint8((img_linearized/max(img_linearized(:)))*255);

end