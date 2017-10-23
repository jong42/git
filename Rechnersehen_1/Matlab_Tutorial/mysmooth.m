function result=mysmooth(image, sigma)
  fourier = fftshift(fft2(im2double(image)));
  [m n] = size(fourier);
  for i=1:m
    for j=1:n
      ic = i - m/2;
      jc = j - n/2;
      fourier(i,j) = fourier(i,j) * exp(-(ic * ic + jc * jc) / (sigma * sigma));
    end;
  end;
  result = real(ifft2(ifftshift(fourier)));
end