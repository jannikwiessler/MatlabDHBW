%% mandatory
clear; clc; close all;

%% create the heatconduction plate
plate.length = 2;
plate.width = 1.5;
plate.height = 0.05;
discretizationCells.alongLength = 40; % in y direction
discretizationCells.alongWidth = 35; % in x direction
discretizationCells.alongHeight = 1;
HCP_Iron = IronHeatConductionPlate(plate,discretizationCells);

%% create initial temperature field
initialTemperature = 20; %°C
temperatureField = initialTemperature*ones(HCP_Iron.numberOfCells.length,...
                                           HCP_Iron.numberOfCells.width);
temperatureVec = reshape(temperatureField,[HCP_Iron.numberOfCells.length*HCP_Iron.numberOfCells.width,1]);

%% call run simulation
simTimeEnd = 600;
options = odeset('RelTol',1e-6,'AbsTol',1e-6);
sol = ode15s(@(t,temperatureVec)rhsHeatConduction2D(t,temperatureVec,HCP_Iron),[0 simTimeEnd],temperatureVec,options);
t = linspace(0,simTimeEnd,simTimeEnd+1);
y = deval(sol,t);

%% visualize the resulting temp field   
h = plotResultsHeatConduction2D(t,y,HCP_Iron);

%% visualize the integrators stepsize
g = plotIntegratorSteps(sol);
