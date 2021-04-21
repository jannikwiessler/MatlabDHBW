function FigH = showResults(NOCX,NOCY,ts)
%% create figure and axis
FigH = figure('Name','Simulation results','Position',[100 100 1250 650]);
ax1 = axes('Parent', FigH);
title('Heat Conductionn Simulation 2D');
xlabel('Width in m');
ylabel('Length in m');
zlabel('Temperature in °C')
grid on;
set(ax1,'NextPlot','replacechildren')
zlim([18 40])

%% create meshgrid and perform the plotting
[X,Y] = meshgrid(1:NOCX,1:NOCY);
for i = 1:length(ts.time)
    surfc(X,Y,reshape(ts.Data(i,:),[NOCX,NOCY])');
    title(['Heat Conductionn Simulation 2D | t = ',num2str(ts.time(i))]);
    pause(0.001)
end

end

