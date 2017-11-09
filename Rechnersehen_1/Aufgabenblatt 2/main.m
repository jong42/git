%cd ('git/git/Rechnersehen_1/Aufgabenblatt 2')

%% Aufgabe 1

img = imread('Bilder/Aerial.jpg');
figure('Name','histogram of image');
imhist(img);

%% Aufgabe 2

imshow(img);
img_linearized = histogram_linearization(img);
figure('Name','histogram of linearized image');
imhist(img_linearized);
imshow(img_linearized);

%%
img = imread('Bilder/Mars.jpg');
figure('Name','histogram of image');
imhist(img);
img_linearized = histogram_linearization(img);
figure('Name','histogram of linearized image');
imhist(img_linearized);
figure('Name','original image');
imshow(img);
figure('Name','linearized image');
imshow(img_linearized);

%%
img = imread('Bilder/SEM.jpg');
figure('Name','histogram of image');
imhist(img);
img_linearized = histogram_linearization(img);
figure('Name','histogram of linearized image');
imhist(img_linearized);
figure('Name','original image');
imshow(img);
figure('Name','linearized image');
imshow(img_linearized);