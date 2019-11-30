function error=mean_square_error(x,y)
  error=0;
  for i=1:size(x,1)
      for j=1:size(x,2)
          error=error+(x(i,j)-y(i,j))^2;
      end
  end
  error=error/prod(size(x));
end