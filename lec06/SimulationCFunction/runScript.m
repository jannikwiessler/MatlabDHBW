clear; close all; clc;

%% create the geometry
plate.length = 2;
plate.width = 1.5;
plate.height = 0.05;
discretizationCells.alongLength = 28; % in y direction
discretizationCells.alongWidth = 30; % in x direction
discretizationCells.alongHeight = 1;
HCP_Iron = IronHeatConductionPlate(plate,discretizationCells);

%% compile the s function
mex heatcond.c

%% create input
simTimeEnd = 1000;
simInputTimeStamp = linspace(0,simTimeEnd,simTimeEnd)';
simInputSignal = zeros(length(simInputTimeStamp),1);
simInputSignal(:,1) = 1500*sin(simInputTimeStamp).*((simTimeEnd-simInputTimeStamp)/simTimeEnd);
simInputSignal(1:20,1) = 2500;
%% run the simulation
simulinkModel = 'Waermeleitung';
open_system(simulinkModel)
out = sim(simulinkModel);

%% show the results
showResults(HCP_Iron.numberOfCells.width,HCP_Iron.numberOfCells.length,out.simout);