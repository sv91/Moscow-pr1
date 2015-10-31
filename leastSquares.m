function beta = leastSquares(y,tX)
    % Apply function from the slides.
    beta = (tX'*tX)\(tX'*y);
end