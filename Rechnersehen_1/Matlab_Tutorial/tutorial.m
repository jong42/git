%  Enter vector and matrix and multiply them
v = [1; 2; 3];
A = [1 0 0; 2 1 1; 0 0 1];
b = A * v;
b

% If there is no colon (;) at the end of the line, the result will be displayed
v = [1; 2; 3]
A = [1 0 0; 0 1 1; 0 0 1]
b = A * v

% line vector times matrix
w = [3 2 1]
w * A

% concatenation
C = [A; [9 8 7]]
C * v

% "everything" is a matrix (except for cell arrays)
size(A)
size(v)
a=5
size(a)

% transpose
v
v'
size(v')

% access elements
v(2)
w(2)
A(2,1)
a(1,1)
a(1)
a

% getting help
% help size
% help fourier
% lookfor fourier

% load and display an image
lena = imread('Aerial.jpg'); % NOTE you may have to replace that file name
figure('Name', 'lena original');
imshow(lena);

% color to gray image
lenaGray = rgb2gray(lena);
figure('Name', 'lena gray');
imshow(lenaGray);

% fourier transform
lenaFourier = fftshift(fft2(im2double(lenaGray)));
figure('Name', 'lena gray fourier transformed');
imshow(lenaFourier, [min(min(real(lenaFourier))) max(max(real(lenaFourier)))]);
figure('Name', 'lena gray fourier transformed and log-ed');
lenaFourierLog = log(abs(lenaFourier));
imshow(lenaFourierLog, [min(min(real(lenaFourierLog))) max(max(real(lenaFourierLog)))]);
figure('Name', 'lena inverse fourier transformed');
imshow(ifft2(fftshift(lenaFourier)));

% functions: you can make and call your own functions
imshow(foo(lenaGray));
imshow(mysmooth(lenaGray, 50.0));