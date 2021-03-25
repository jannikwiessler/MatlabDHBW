classdef myCalculatorClass < matlab.mixin.SetGet
   properties (Access = private)
      result
      value1
      value2
   end
   methods (Access = public)
      function obj = myCalculatorClass(varargin)
         for i = 1:nargin
            if ischar(varargin{i}) && strcmp(varargin{i},'value1')
                obj.value1 = varargin{i+1};
            elseif ischar(varargin{i}) && strcmp(varargin{i},'value2')
                obj.value2 = varargin{i+1};
            end
         end
      end
      function multiply(obj)
         obj.result = obj.value1 * obj.value2;
      end
      function add(obj)
         obj.result = obj.value1 + obj.value2;
      end
      function subtract(obj)
         obj.result = obj.value1 - obj.value2;
      end
      function divide(obj)
         obj.result = obj.value1 / obj.value2;
      end
      function value = getValue1(obj)
          value = obj.value1;
      end
      function value = getValue2(obj)
          value = obj.value2;
      end
      function value = getResult(obj)
          value = obj.result;
      end
   end
end