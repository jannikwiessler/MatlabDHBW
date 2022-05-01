classdef Automobilfederung < handle
    properties
        c1 {mustBeNumeric}
        c2 {mustBeNumeric}
        d2 {mustBeNumeric}
        m1 {mustBeNumeric}
        m2 {mustBeNumeric}
        u
        A {mustBeNumeric}
        B {mustBeNumeric}
        tsimout {mustBeNumeric}
        ysimout {mustBeNumeric}
    end
    methods (Access = public)
        function obj = Automobilfederung(varargin)
            for i = 1:2:nargin
                if strcmp(varargin{i},'c1')
                    obj.c1 = varargin{i+1};
                elseif strcmp(varargin{i},'c2')
                    obj.c2 = varargin{i+1};
                elseif strcmp(varargin{i},'d2')
                    obj.d2 = varargin{i+1};
                elseif strcmp(varargin{i},'m1')
                    obj.m1 = varargin{i+1};
                elseif strcmp(varargin{i},'m2')
                    obj.m2 = varargin{i+1};
                elseif strcmp(varargin{i},'u')
                    if isa(varargin{i+1},'function_handle')
                        obj.u = varargin{i+1};
                    else
                        error("u seems not to be a function handle");
                    end
                else
                    warning("Invalid property: "+varargin{i});
                end
            end
            obj.calcSystemMartixA();
            obj.calcInputMatixB();
        end
        function sim(obj, varargin)
            t = 0;
            tfinal = 10;
            h = 0.01;
            y = [0; 0; 0; 0];
            for i = 1:2:nargin-1
                % ========= YOUR CODE HERE =========
                % perform the varargin: overwrite the defaults
            end
            tout = zeros(ceil((tfinal-t)/h)+1,1);
            yout = zeros(ceil((tfinal-t)/h)+1,length(y));
            tout(1) = t;
            yout(1,:) = y';
            step = 1;
            while (t < tfinal)
                step = step + 1;
                if t + h > tfinal
                    % ========= YOUR CODE HERE =========
                    % h = 
                end
                % ========= YOUR CODE HERE =========
                % calculate the slopes
                % calculate the ynew
                t = t + h;
                y = ynew;
                tout(step) = t;
                yout(step,:) = y';
                obj.tsimout = tout;
                obj.ysimout = yout;
            end
        end
        function fig = visualizeResults(obj)
            fig = figure('Name','Ergebnisse der Simulation');
            subplot(2,1,1);
            plot(obj.tsimout,obj.ysimout(:,1),'s-',...
                 obj.tsimout,obj.ysimout(:,3),'x-')
            grid on;
            ylabel('Höhe in m');
            legend('Karosserie','Rad');
            title("Position der Zustände | stepsize = "+num2str(obj.tsimout(2)-obj.tsimout(1)))
            subplot(2,1,2);
            plot(obj.tsimout,obj.ysimout(:,2),'s-',...
                 obj.tsimout,obj.ysimout(:,4),'x-')
            grid on;
            ylabel('Geschwindigkeit in m/s');
            xlabel('Simulationszeit in s');
            legend('Karosserie','Rad');
            title("Geschwindigkeit der Zustände | stepsize = "+num2str(obj.tsimout(2)-obj.tsimout(1)))
        end
    end
    methods (Access = private)
        function calcInputMatixB(obj)
            % ========= YOUR CODE HERE =========
            % obj.B = 
        end
        function calcSystemMartixA(obj)
            % ========= YOUR CODE HERE =========
            % obj.A = 
        end
        function xdot = rhs(obj, t, x)
            x = x(:);
            xdot = obj.A*x + obj.B*obj.u(t);
        end
    end
end