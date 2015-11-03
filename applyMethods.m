clear all;

% anonymous functions 
RMSE = @(yReal, yPred) sqrt(sum((yReal - yPred) .^ 2) / length(yReal));

% regression dataset
load('Moscow_regression');
[NTr,DTr] = size(X_train);
[NTe,DTe] = size(X_test);

for i = 1:DTr
    meanX = mean(X_train(:,i));
    X_train(:,i) = X_train(:,i) - meanX;
    stdX = std(X_train(:,i));
    X_train(:,i) = X_train(:,i)./stdX;
end

% variables
yRegTr = y_train;
tXRegTr = [ones(NTr, 1) X_train];%X_train(:,11) X_train(:,56) X_train(:,24) X_train(:,40)]; to be determined
tXRegTe = [ones(NTe, 1) X_test(:,11) X_test(:,56) ];

% tests for methods
%alpha = 0:0.005:1
%leastSquares(yRegTr, tXRegTr)
%leastSquaresGD(yRegTr, tXRegTr, 0.001)
%ridgeRegression(yRegTr, tXRegTr, 0.01)
%logisticRegression(y_reg_train, tX_reg_train, 0.0000005)
%penLogisticRegression(y_reg_train, tX_reg_train, 0.000000001, 50000000000000000000000)

% get alpha_star 
AA = [];
alphas = -1:0.0005:0.97; % 0.96 seems good for that, rmse=1244

for alpha = alphas;
    beta = ridgeRegression(yRegTr, tXRegTr, alpha);
    %beta = leastSquaresGD(yRegTr, tXRegTr, alpha);
    rm = RMSE(yRegTr, tXRegTr * beta);
    AA = [AA ; rm];
end
plot(alphas, AA)
%alphaStar = 0.3;

% get beta_star and predictions
% dimensions: beta= Dx1, tX = NxD, tXxbeta=Nx1
%betaStar = ridgeRegression(yRegTr, tXRegTr, alphaStar);
%yStar = tXRegTe * betaStar;

% rmse, we to on train and test with real
%RMSE(yRegTr, tXRegTr * betaStar)

% % ---Kfold testing
% degrees = [3:10];
% 
% % split data in k-fold
% setSeed(1);
% K = 4;
% N = size(y,1);
% idx = randperm(N);
% Nk = floor(N/K);
% for k = 1:K
% 	idxCV(k,:) = idx(1+(k-1)*Nk:k*Nk);
% end
% 
% % lambda values (INSERT CODE)
% lambda = logspace(-4,2,100);
% allVarMseTr = [];
% allVarMseTe = [];
% 
% for degree = degrees
%     
%     % K-fold cross validation
%     for i = 1:length(lambda)
%         for k = 1:K
%             % get k'th subgroup in test, others in train
%             idxTe = idxCV(k,:);
%             idxTr = idxCV([1:k-1 k+1:end],:);
%             idxTr = idxTr(:);
%             yTe = y(idxTe);
%             XTe = X(idxTe,:);
%             yTr = y(idxTr);
%             XTr = X(idxTr,:);
% 
%             % form tX (INSERT CODE)
%             tXTr = [ones(length(yTr), 1) myPoly(XTr, degree)];
%             tXTe = [ones(length(yTe), 1) myPoly(XTe, degree)];
% 
%             % least squares (INSERT CODE)
%             [beta] = ridgeRegression(yTr, tXTr, lambda(i));
% 
%             % training and test MSE(INSERT CODE)
%             mseTrSub(k) = computeCost(yTr, tXTr, beta);
% 
%             % testing MSE using least squares
%             mseTeSub(k) = computeCost(yTe, tXTe, beta);
% 
%         end
%         mseTr(i) = mean(mseTrSub);
%         mseTe(i) = mean(mseTeSub);
%         varMseTr(i) = var(mseTrSub);
%         varMseTe(i) = var(mseTeSub);
%     end
% 
%     
%     allVarMseTr = [allVarMseTr ; varMseTr];
%     allVarMseTe = [allVarMseTe ; varMseTe];
% 
%     % plot
%     subplot(1, 8, degree-2)
%     semilogx(lambda(1:5:end), mseTr(1:5:end), '-o', 'MarkerFaceColor', 'white', 'LineWidth', 2);
%     hold on;
%     semilogx(lambda(1:5:end), mseTe(1:5:end), '-o', 'MarkerFaceColor', 'white', 'LineWidth', 2);
%     
%     grid on;
%     ylim([0 0.05]);
%     xlim([10^-4 10^2]);
%     legend('mseTr', 'mseTe');
%     
% 
% 
% 
% end
