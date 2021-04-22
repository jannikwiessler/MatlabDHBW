classdef IronHeatConductionPlate < HeatConductionPlate
%% IronHeatConductionPlate
% Class returning a HeatConductionPlate Object which is made of Iron

    properties (Constant)
        cp = 439; % iron: 439 J/(kgK)
        rho = 7.874e3; % iron: 7.874e3 kg/m3
        lambda = 80; % iron: 80 W/(mK)
    end
    
    methods (Access = public)
        function obj = IronHeatConductionPlate(geometry, numberOfCells)
            obj = obj@HeatConductionPlate(geometry, numberOfCells);            
        end
    end
end