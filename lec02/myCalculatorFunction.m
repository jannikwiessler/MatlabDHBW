function returnValue = myCalculatorFunction(varargin)

for i = 1:nargin
    if ischar(varargin{i}) && strcmp(varargin{i},'operator')
        Operator = varargin{i+1}; 
    elseif ischar(varargin{i}) && strcmp(varargin{i},'value1')
        Value1 = varargin{i+1};
    elseif ischar(varargin{i}) && strcmp(varargin{i},'value2')
        Value2 = varargin{i+1};
    end
end

switch Operator
    case '+'
        returnValue = Value1 + Value2;
    case '-'
        returnValue = Value1 - Value2;
    case '*'
        returnValue = Value1 * Value2;
    case '/'
        returnValue = Value1 / Value2;
    otherwise 
        error('invalid operator');
end

end

