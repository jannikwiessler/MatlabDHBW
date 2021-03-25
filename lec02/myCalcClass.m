classdef myCalcClass < matlab.mixin.SetGet 
    properties (Access = private)
        result
        value1
        value2
    end
    
    methods (Access = public)
        function obj = myCalcClass(varargin)
           for i = 1:nargin
              if strcmp(varargin{i},'value1')
                  obj.value1 = varargin{i+1};
              elseif strcmp(varargin{i},'value2')
                  obj.value2 = varargin{i+1};
              end 
           end
        end
        
        function add(obj)
           obj.result = obj.value1 + obj.value2; 
        end
        
        function value = getResult(obj)
             value = obj.result;
        end
    end    
end