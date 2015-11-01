function beta = logisticRegression(y,tX,alpha)
% Initial values
    [~,N] = size(tX);
    beta = zeros(N,1);
    maxIters = 1000;
    lastBeta = beta;
    convergence= 0.00001;

    for k = 1:maxIters
        beta
    	g = computeGradient(y, tX,beta);
        H = computeHessian(tX, beta);
        beta = beta -  alpha .* (H \ g);
        if abs(lastBeta - beta)<= beta*convergence 
            break % If the difference between two step is too small, we stop
        end
        lastBeta = beta;
    end
end

function g = computeGradient(y,tX,beta)
    e = logFun(tX*beta) - y;    %compute error
    g = tX'*e;   
end

function H = computeHessian(tx, beta)
    [N,~] = size(tx);
    S = zeros(N);
    for i = 1:N
        l = logFun(tx(i,:)*beta);
        S(i,i) = l*(1-l);
    end
    H = tx'* S * tx;
end

function o = logFun(x)
    o2 = 1/(1+exp(-x));
    o = o2(:,1);
end