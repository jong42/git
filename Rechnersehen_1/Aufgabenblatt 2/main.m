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
%% Aufgabe 3

A = (1/9) *ones(3,3,'double');
img_filtered = apply_faltung(img,A);


figure('Name','original image');
imshow(img);
figure('Name','filtered image');
imshow(img_filtered);

%% Aufgabe 4
A_Gauss_3 = create_gauss_matrix(3,3);
img_filtered_3 = apply_faltung(img,A_Gauss_3);

figure('Name','original image');
imshow(img);
figure('Name','Gauss filtered image m=3');
imshow(img_filtered_3);

A_Gauss_5 = create_gauss_matrix(5,5);
img_filtered_5 = apply_faltung(img,A_Gauss_5);
figure('Name','Gauss filtered image m=5');
imshow(img_filtered_5);

A_Gauss_7 = create_gauss_matrix(7,7);
img_filtered_7 = apply_faltung(img,A_Gauss_7);
figure('Name','Gauss filtered image m=7');
imshow(img_filtered_7);

%% Aufgabe 5

D_Gauss_1 = create_gauss_matrix(3,1);
D_Gauss_2 = create_gauss_matrix(1,3);

img_filtered = apply_faltung(img,D_Gauss_1);
img_filtered = apply_faltung(img_filtered,D_Gauss_2);
figure('Name','Gauss filtered image separiert');
imshow(img_filtered);

%% Aufgabe 6