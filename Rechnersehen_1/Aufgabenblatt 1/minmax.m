
function [min,max] = minmax(filename)

img = imread(filename);

max = 0;
min = 1000;

for row = 1:size(img,1)
    for col = 1:size(img,2)
        if img(row,col) > max
            max = img(row,col);
        end
        if img(row,col) < min
            min = img(row,col);
        end        
    end
end

end

