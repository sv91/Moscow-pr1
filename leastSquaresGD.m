function beta = leastSquaresGD(y,tX,alpha)
    [N,~] = size(y);
    beta = zeros(N+1,1);
    maxIters = 1000;
    lastBeta = beta;
    convergence= 0.00001;

    for k = 1:maxIters
    	g = computeGradient(y, tX,beta);
        beta = beta - alpha .* g;
        if abs(lastBeta - beta)< beta*convergence
            break
        end
    end
end

function g = computeGradient(y,tX,beta)
    [N,~] = size(y);
    e = y - tX*beta;    %compute error
    g = tX'*e/(-1*N);   %compute MSE
end