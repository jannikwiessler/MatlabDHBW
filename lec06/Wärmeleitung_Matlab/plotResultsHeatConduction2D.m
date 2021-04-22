function FigH = plotResultsHeatConduction2D(timeStamp,simResults,HCP_Obj)
%PLOTRESULTSHEATCONDUCTION2D function to visualize the simulation results
%of a simple 2D heat conduction problem

%% create figure and axis
FigH = figure('Name','Simulation results','Position',[100 100 1250 650]);
ax1 = axes('Parent', FigH);
title('Heat Conductionn Simulation 2D');
xlabel('Width in m');
ylabel('Length in m');
zlabel('Temperature in °C')
grid on;
set(ax1,'NextPlot','replacechildren')
zlim([-75 max(max(simResults))+10]);
zlim([18 40])

%% create meshgrid and perform the plotting
[X,Y] = meshgrid(1:HCP_Obj.numberOfCells.width,1:HCP_Obj.numberOfCells.length);
for i = 1:length(timeStamp)
    surfc(X,Y,reshape(simResults(:,i),[HCP_Obj.numberOfCells.length,HCP_Obj.numberOfCells.width]));
    title(['Heat Conductionn Simulation 2D | t = ',num2str(timeStamp(i))]);
    pause(0.001)
end
end

