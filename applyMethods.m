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
tXRegTr = [ones(NTr, 1) X_train(:,11) X_train(:,56) ]; %to be determined
tXRegTe = [ones(NTe, 1) X_test(:,11) X_test(:,56) ];

% tests for methods
%alpha = 0:0.005:1
%leastSquares(yRegTr, tXRegTr)
%leastSquaresGD(yRegTr, tXRegTr, 0.001)
%ridgeRegression(yRegTr, tXRegTr, 0.01)
%logisticRegression(y_reg_train, tX_reg_train, 0.0000005)
%penLogisticRegression(y_reg_train, tX_reg_train, 0.000000001, 50000000000000000000000)

% get alpha_star 
% AA = [];
% alphas = -1:0.0005:0.97; % 0.96 seems good for that, rmse=1244
% 
% for alpha = alphas;
%     %beta = ridgeRegression(yRegTr, tXRegTr, alpha);
%     %beta = leastSquaresGD(yRegTr, tXRegTr, alpha);
%     rm = RMSE(yRegTr, tXRegTr * beta);
%     AA = [AA ; rm];
% end
% plot(alphas, AA)
alphaStar = 0.96;

% get beta_star and predictions
% dimensions: beta= Dx1, tX = NxD, tXxbeta=Nx1
betaStar = leastSquaresGD(yRegTr, tXRegTr, alphaStar);
yStar = tXRegTe * betaStar;

% rmse, we to on train and test with real
RMSE(yRegTr, tXRegTr * betaStar)
csvwrite('predictions_regression.csv', tXRegTe * betaStar);
csvwrite('test_errors_regression.csv', ['rmse' '1246.25']);% DOESNT WORK DO BY HAND


% ---Kfold testing
%7.77 105 ; 7.74 105
% split data in k-fold
setSeed(1);
K = 5;
idx = randperm(NTr);
NTrk = floor(NTr/K);
for k = 1:K
	idxCV(k,:) = idx(1+(k-1)*NTrk:k*NTrk);
end

% lambda values
lambda = logspace(-2,15,100); %% to be played with
allVarMseTr = [];
allVarMseTe = [];
    
% K-fold cross validation
for i = 1:length(lambda)
    for k = 1:K
        % get k'th subgroup in test, others in train
        XRegTr = tXRegTr(:,2:end);
        idxTe = idxCV(k,:);
        idxTr = idxCV([1:k-1 k+1:end],:);
        idxTr = idxTr(:);
        yTe = yRegTr(idxTe);
        XTe = XRegTr(idxTe,:);
        yTr = yRegTr(idxTr);
        XTr = XRegTr(idxTr,:);

        % form tX (INSERT CODE)
        tXTr = [ones(length(yTr), 1) XTr];
        tXTe = [ones(length(yTe), 1) XTe];

        % least squares (INSERT CODE)
        [beta] = leastSquaresGD(yTr, tXTr, lambda(i));

        % training and test MSE(INSERT CODE)
        mseTrSub(k) = RMSE(yTr, tXTr * beta);

        % testing MSE using least squares
        mseTeSub(k) = RMSE(yTe, tXTe * beta);

    end
    mseTr(i) = mean(mseTrSub);
    mseTe(i) = mean(mseTeSub);
    varMseTr(i) = var(mseTrSub);
    varMseTe(i) = var(mseTeSub);
end


allVarMseTr = [allVarMseTr ; varMseTr];
allVarMseTe = [allVarMseTe ; varMseTe]

% plot
figure;
semilogx(lambda(1:5:end), mseTr(1:5:end), '-o', 'MarkerFaceColor', 'white', 'LineWidth', 2);
hold on;
semilogx(lambda(1:5:end), mseTe(1:5:end), '-o', 'MarkerFaceColor', 'white', 'LineWidth', 2);

grid on;
%ylim([0 0.05]);
%xlim([10^-4 10^2]);
legend('mseTr', 'mseTe');




