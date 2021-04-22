classdef (Abstract) HeatConductionPlate
%% HeatConductionPlate
% Abstract Class returning a HeatConductionPlate Object
%
    properties (Abstract, Constant)
        cp % specific heat capacity
        rho % density
        lambda % thermal conductivity
    end
    
    properties (SetAccess = immutable)
        dx % length dimension
        dy % width dimension
        dz % height dimension
        geometry % struct containing geometrie fields: length, width, height
        numberOfCells % struct containing number of cells fields: length, width, height
    end
    
    methods
        function obj = HeatConductionPlate(geometry, numberOfCells)
            obj.geometry.length = geometry.length;
            obj.geometry.width = geometry.width;
            obj.geometry.height = geometry.height;
            obj.numberOfCells.length = numberOfCells.alongLength;
            obj.numberOfCells.width = numberOfCells.alongWidth;
            obj.numberOfCells.height = numberOfCells.alongHeight;            
            obj.dx = obj.geometry.length/obj.numberOfCells.length;
            obj.dy = obj.geometry.width/obj.numberOfCells.width;
            obj.dz = obj.geometry.height/obj.numberOfCells.height;
        end        
    end
end