%% runScript: 
% runs the Automobilfederung model and visulaize the reults
%
% Author: Jannik Wiessler
% DHBW Stuttgart
% email: jannik.wiessler@daimler.com
% data: Q2 2022

%% mandatory
clear; clc; close all;

%% create input function
u = @(t) [(t <= 1) (t > 1)]*[0; 0.3];

%% create model
model = Automobilfederung('m1', 25,...
    'm2', 250,...
    'c1', 9e+4,...
    'c2', 3e+4,...
    'd2', 750,...
    'u', u);

%% simulate model
stepsizeStart = 0.005;
stepsizeEnd = 0.05;
stepsizeDelta = 0.005;
for stepsize = stepsizeStart:stepsizeDelta:stepsizeEnd
    model.sim('t0', 0,...
        'tfinal', 3,...
        'y0', [0 0 0 0],...
        'stepsize', stepsize);
    model.visualizeResults();
end
