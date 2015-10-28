% How to print pdf files of figures in Matlab
% to be used inside the latex source.

% load training dat
load train.mat;
X = X_train;
y = y_train;

% visualize
figure(1);
hist(y, 30);
hx = xlabel('y');
hy = ylabel('Frequency');

% the following code makes the plot look nice and increase font size etc.
set(gca,'fontsize',20,'fontname','Helvetica','box','off','tickdir','out','ticklength',[.02 .02],'xcolor',0.5*[1 1 1],'ycolor',0.5*[1 1 1]);
set([hx; hy],'fontsize',18,'fontname','avantgarde','color',[.3 .3 .3]);
grid on;

% print the file
print -dpdf histY.pdf

% Next you should CROP PDF using pdfcrop in linux and mac. Windows - not sure of a solution.
