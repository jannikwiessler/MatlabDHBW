%% runScript: 
% runs the linear regression model and visulaize the reults
%
% See also: LinearRegressionDataFormatter, LinearRegressionModel, GradientDescentOptimizer,
% Author: Jannik Wiessler
% DHBW Stuttgart
% email: jannik.wiessler@daimler.com
% data: Q1 2021

%% mandatory
clear; clc; close all;

%% create data object for linear regression model
dataForLinearRegression = LinearRegressionDataFormatter('Data','TempearatureMeasurement.mat',...
    'Feature','T3','CommandVar','T4');

%% create optimizer object
gradientDescentOptimizer = GradientDescentOptimizer('LearningRate',9e-6,'MaxIterations',1e5);

%% create lineaer regression model object
LRMObject = LinearRegressionModel('Data',dataForLinearRegression,'Optimizer',gradientDescentOptimizer);

%% test cost function
LRMObject.setTheta(9,1)
cost = LRMObject.costFunction();
disp("current costs for theta = " + "[" + num2str(LRMObject.theta(1)) + ";" + num2str(LRMObject.theta(2)) + "]" +...
    ": " + num2str(cost) + ", expected: 3673.2168");

LRMObject.setTheta(0,0)
cost = LRMObject.costFunction();
disp("current costs for theta = " + "[" + num2str(LRMObject.theta(1)) + ";" + num2str(LRMObject.theta(2)) + "]" +...
    ": " + num2str(cost) + ", expected: 79994.0539");

%% show cost function area
costFunctionFigure = LRMObject.showCostFunctionArea();

%% perform the training
tic
LRMObject.optimizer.runTraining(LRMObject);
toc

%% show the resulting model
lrmFigure = LRMObject.showModel();

%% sho optimum in contour plot
optimumFigure = LRMObject.showOptimumInContour();

