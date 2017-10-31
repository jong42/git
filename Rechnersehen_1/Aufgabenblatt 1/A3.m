%cd ('git/git/Rechnersehen_1/Aufgabenblatt 1')

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