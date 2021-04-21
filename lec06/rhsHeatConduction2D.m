function dTdt = rhsHeatConduction2D(t,tempVec,HCP_Obj)
%% rhsHeatConduction2D
% function returning the right hand side of ode for a simpple 2D heat condution problem
T = reshape(tempVec,[HCP_Obj.numberOfCells.length,HCP_Obj.numberOfCells.width]);

%% get constants
cp = HCP_Obj.cp;
rho = HCP_Obj.rho;
lambda = HCP_Obj.lambda;

dx = HCP_Obj.dx;
dy = HCP_Obj.dy;

%% Ströme initialisieren
QdotxZu = zeros(HCP_Obj.numberOfCells.length,HCP_Obj.numberOfCells.width);
QdotxAb = zeros(HCP_Obj.numberOfCells.length,HCP_Obj.numberOfCells.width);
QdotyZu = zeros(HCP_Obj.numberOfCells.length,HCP_Obj.numberOfCells.width);
QdotyAb = zeros(HCP_Obj.numberOfCells.length,HCP_Obj.numberOfCells.width);
Qab = zeros(HCP_Obj.numberOfCells.length,HCP_Obj.numberOfCells.width);
Qzu = zeros(HCP_Obj.numberOfCells.length,HCP_Obj.numberOfCells.width);
if t < 50
    Qzu(floor(HCP_Obj.numberOfCells.length/4),floor(HCP_Obj.numberOfCells.width/2)) = 2500;
    Qzu(floor(3*HCP_Obj.numberOfCells.length/4),floor(HCP_Obj.numberOfCells.width/2)) = 2500;
    Qzu(floor(HCP_Obj.numberOfCells.length/2),floor(HCP_Obj.numberOfCells.width/4)) = 2500;
    Qzu(floor(HCP_Obj.numberOfCells.length/2),floor(3*HCP_Obj.numberOfCells.width/4)) = 2500;
end

%% randbedingung setzten
T(2:end-1,1) = T(2:end-1,2);
T(2:end-1,end) = T(2:end-1,end-1);
T(1,2:end-1) = T(2,2:end-1);
T(end,2:end-1) = T(end-1,2:end-1);

%% Ströme berechnen (RHS)
for i = 2:HCP_Obj.numberOfCells.length-1 % in y direction
    QdotyZu(i,:) = -dx*lambda*HCP_Obj.geometry.height*(T(i,:) - T(i-1,:))/dy;
    QdotyAb(i,:) = -dx*lambda*HCP_Obj.geometry.height*(T(i+1,:) - T(i,:))/dy;
end

for i = 2:HCP_Obj.numberOfCells.width-1 % in x direction
    QdotxZu(:,i) = -dy*lambda*HCP_Obj.geometry.height*(T(:,i) - T(:,i-1))/dx;
    QdotxAb(:,i) = -dy*lambda*HCP_Obj.geometry.height*(T(:,i+1) - T(:,i))/dx;
end

%% LHS berechnen
dTdt1 = zeros(HCP_Obj.numberOfCells.length,HCP_Obj.numberOfCells.width);
dTdt1 = 1/(cp*dx*dy*rho*HCP_Obj.geometry.height)*(QdotxZu - QdotxAb + QdotyZu - QdotyAb + Qzu - Qab);

dTdt = reshape(dTdt1,[HCP_Obj.numberOfCells.length*HCP_Obj.numberOfCells.width,1]);
end