function beta = ridgeRegression(y,tX, lambda)
    
beta=((tX'*tX)+lambda)\(tX'*y);

end