function beta = logisticRegression(y,tX,alpha)
    % algorithm parametes
    maxIters = 1000;

    % initialize
    [~,D] = size(tX);
    beta = zeros(D, 1);

    % iterate
    fprintf('Starting iterations, press Ctrl+c to break\n');
    fprintf('L  beta0 beta1\n');
    for k = 1:maxIters;
        g = computeGradientNegMLE(y, tX, beta); % gradient
        L = computeCostNegMLE(y, tX, beta); % cost
        beta = beta - alpha .* g; % gradient descent to update beta

        if g'*g < 1e-5; % convergence
           fprintf('CONVERGED: #iter=%i\n', k)
           break; 
        end;

        beta_all(:,k) = beta;
        L_all(k) = L;

        fprintf('%.2f  %.2f %.2f\n', L, beta(1), beta(2));

        % Overlay on the contour plot
        % For this to work you first have to run grid Search
        %subplot(121);
        %plot(beta(1), beta(2), 'o', 'color', 0.7*[1 1 1], 'markersize', 12);
%         pause(.5) % wait half a second
% 
%         % visualize function f on the data
%         subplot(122);
%         x = [1.2:.01:2]; % height from 1m to 2m
%         x_normalized = (x - meanX)./stdX;
%         f = beta(1) + beta(2).*x_normalized;
%         plot(height, weight,'.');
%         hold on;
%         plot(x,f,'r-');
%         hx = xlabel('x');
%         hy = ylabel('y');
%         hold off;
    end
end

function [ g ] = computeGradientNegMLE( y, tX, beta )
% compute gradient corresponding to the log-likelihood
    g = tX' * (logisticSigma(tX*beta) - y);
    %g = g ./ length(y);
end

function [ r ] = logisticSigma(x)
    r = 1 ./ (1 + exp(-x));
end

function [ L ] = computeCostNegMLE(y, tX, beta)
% return negative of the value of log-likelihood
    % this is the log of the likelihood

    L = 0;
    for n = 1:length(y)
        L = L + y(n) * (tX(n,:) * beta) - log(1 + exp(tX(n,:) * beta));
    end
L = -L;
end
