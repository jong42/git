cd ('C:/users/xi86xev/desktop/git/Rechnersehen_1/Aufgabenblatt 1')

%% Aufgabe 2

img = imread('towercam.jpg');
figure('Name','towercam original');
imshow(img);

%% Aufgabe 3

[min_1,max_1] = minmax('Bilder/Aerial.jpg');
[min_2,max_2] = minmax('Bilder/Mars.jpg');
[min_3,max_3] = minmax('Bilder/Moon.jpg');
[min_4,max_4] = minmax('Bilder/Pollen1.jpg');
[min_5,max_5] = minmax('Bilder/Pollen2.jpg');
[min_6,max_6] = minmax('Bilder/Pollen3.jpg');
[min_7,max_7] = minmax('Bilder/Pollen4.jpg');
[min_8,max_8] = minmax('Bilder/SEM.jpg');
[min_9,max_9] = minmax('Bilder/Spine.jpg');


% Alternative: max(max(img))

%%  Aufgabe 4

show_invert('Bilder/Aerial.jpg');
show_invert('Bilder/Mars.jpg')
show_invert('Bilder/Moon.jpg')
show_invert('Bilder/Pollen1.jpg')
show_invert('Bilder/Pollen2.jpg')
show_invert('Bilder/Pollen3.jpg')
show_invert('Bilder/Pollen4.jpg')
show_invert('Bilder/SEM.jpg')
show_invert('Bilder/Spine.jpg')

%% Aufgabe 5

img_5_1 = gamma_correction('Bilder/Aerial.jpg',2.5);
figure('Name','gammacorrection 2.5');
imshow(img_5_1);
img_5_1 = gamma_correction('Bilder/Aerial.jpg',0.5);
figure('Name','gammacorrection 0.5');
imshow(img_5_1);