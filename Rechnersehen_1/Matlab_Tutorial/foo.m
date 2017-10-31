function result=foo(image)
  localCopy = image;
  [m n] = size(localCopy);
  for i=1:m %i=m*3/8:m*5/8
    for j=1:n %j=m*3/8:m*5/8
      ic = i - m/2;
      jc = j - n/2; 
      s = 100.0;
      localCopy(i,j) = localCopy(i,j) * exp(-(ic * ic + jc * jc) / (s * s));
    end;
  end;
  result = localCopy;
end