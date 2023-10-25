function [thisD thisAlpha]=MSDfit;

load('MSD.mat');
x=MSDout(3:end,1);
y=MSDout(3:end,2);
%% Fit: 'untitled fit 1'.
[xData, yData] = prepareCurveData( x, y );

% Set up fittype and options.
ft = fittype( 'D*x^alpha', 'independent', 'x', 'dependent', 'y' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.StartPoint = [0.970592781760616 0.8002804688888];

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );
thisD=fitresult.D;
thisAlpha=fitresult.alpha;
