classdef CopperHeatConductionPlate < HeatConductionPlate
%% CopperHeatConductionPlate
% Class returning a HeatConductionPlate Object which is made of copper
    properties (Constant)
        cp = 385; % copper: 385 J/(kgK)
        rho = 8.930e3; % copper: 8.930e3 kg/m3
        lambda = 400; % copper: 400 W/(mK)
    end
    
    methods (Access = public)
        function obj = CopperHeatConductionPlate(geometry, numberOfCells)
            obj = obj@HeatConductionPlate(geometry, numberOfCells);            
        end
    end
end