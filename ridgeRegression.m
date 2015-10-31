function beta = ridgeRegression(y,tX, lambda)
% Applying function from the slides.
    beta=((tX'*tX)+lambda)\(tX'*y);
end