% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% * Lu X, Rudi A, Borgonovo E, Rosasco L. Faster Kriging: Facing High-Dimensional Simulators. Operations Research. 2020 Jan;68(1):233-49.
% * Author: Xuefei Lu, xuefei.lu@ed.ac.uk
% * Date: Dec, 2020
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Table 3. DACE results
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clearvars;close all; clc

addpath('./dace')
addpath('./AGdata')% additive gaussian
%% import data
clearvars

X=load('x_train.txt');
Y=load('y_train.txt');

N=1000; 
%N=2300; % memory error 4G RAM
X_train = X(1:N,:);
Y_train = Y(1:N);

X_test = load('x_test.txt');
Y_test = load('y_test.txt');

clear X Y
%% 
rng(1234)
% generate random seed
% complete experiments requires long running time, try a small trail
seed = rand(30,1)*100000;
seed = seed(1:5); % comment out for complete experiment

theta0 = 0.1*ones(1,size(X_train,2));
lob = 1e-6*ones(1,size(X_train,2)); upb = 0.2*ones(1,size(X_train,2));


RMSE = zeros(length(seed),1); R2= zeros(length(seed),1);
tr_time = [];tes_time = [];


for i = 1:length(seed)
rng(seed(i))
tic
% requires the MATLAB toolbox DACE (v.2.0)
[dmodel, perf] = dacefit(X_train, Y_train, @regpoly0, @corrgauss, theta0, lob, upb); 
tr_time = [tr_time; toc];

tic
[Ypred, Yvar] = predictor(X_test, dmodel);
tes_time = [tes_time; toc];
RMSE(i) = sqrt(mean((Y_test - Ypred).^2));  % Emperical Root Mean Squared Error
R2(i) =  1-sum((Y_test - Ypred).^2)/sum((Y_test - mean(Y_test)).^2);
end
tes_time = tes_time/length(X_test);


