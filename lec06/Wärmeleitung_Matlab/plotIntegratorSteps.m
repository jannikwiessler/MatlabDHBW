function FigH = plotIntegratorSteps(solutionStruct)
%PLOTRESULTSHEATCONDUCTION2D function to visualize the stepsize of
%integrator
FigH  = figure('Name','Timegird of Integrator');
semilogx([0,diff(solutionStruct.x)],solutionStruct.x,'b-o');
grid on;
xlabel('Stepsize')
ylabel('Time')
title([solutionStruct.solver,': Integration time over stepsize']);
end