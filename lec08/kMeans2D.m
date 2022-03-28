function [ clusterIDX, center ] = kMeans2D( numOfCenters, data , maxIter )
% if called via python
if iscell(data)
   data = cell2mat([data{:}]);
   data = reshape(data,2,length(data)/2)';
end

colors = {'m';'c';'r';'g';'b';'y'};

if numOfCenters > length(colors) || numOfCenters < 1
    error('invalid numOfCenters needs to be < 7');
end

numOfDataPoints = size(data,1); % number of points


%% Choose k data points as initial centroids

% choose numOfCenters unique random indices between 1 and size(P,2) (number of points)
randIdx = randperm(numOfDataPoints,numOfCenters);

% initial centroids
center = data(randIdx,:);

%% do the init stuff

% init cluster array
clusterIDX = zeros(numOfDataPoints,1);

% init previous center array clusterPrev (for stopping criterion)
centerPrev = center;

% for reference: count the iterations
iterations = 0;

% init stopping criterion
runFlag = true; % if stopping criterion met, it changes to true

% open figure
h = figure('Name','kMeans');
ax = plot(data(:,1), data(:,2),'ko');
hold on;
for idxCenter = 1:numOfCenters
   
    plot(center(idxCenter,1),center(idxCenter,2),...
        [colors{idxCenter} 's'],'MarkerSize',12,...
        'MarkerFaceColor',colors{idxCenter},...
        'MarkerEdgeColor',[0.1 0.1 0.1]);
    
end
grid on;
xlim([min(data(:,1)) max(data(:,1))]);
ylim([min(data(:,2)) max(data(:,2))]);
pause(1)

%% kmeans: Repeat until stopping criteria

dist = zeros(numOfDataPoints,numOfCenters); % init dist mat

while runFlag
   
    for idxCenter = 1:numOfCenters % calc dist (L2)
        
       temp = data - center(idxCenter,:); % x und y Abstand berechnen
       
       dist(:,idxCenter) = sqrt(sum(temp.^2,2)); % calc dist
       
    end
       
    [~,clusterIDX] = min(dist,[],2);         
    
    for idxCenter = 1:numOfCenters % calc new centers
    
        center(idxCenter,:) = mean(data(clusterIDX == idxCenter,:)); % mean of clusters
        
    end
    
    if all(center == centerPrev,'all') || iterations >= maxIter % abort if center are not moving anymore
       runFlag = false; 
    end
        
    cla; % clear all datapoint in current figure

    hold on;
    
    for idxCenter = 1:numOfCenters % plot new colors wrt clusters
    
        plot(data(clusterIDX==idxCenter,1),data(clusterIDX==idxCenter,2),...
            [colors{idxCenter},'o']);
        
    end
            
    for idxCenter = 1:numOfCenters % plot old and mew centers
            
        plot([centerPrev(idxCenter,1) center(idxCenter,1)],[centerPrev(idxCenter,2) center(idxCenter,2)],...
        ['-',colors{idxCenter},'s'],'MarkerSize',12,...
        'LineWidth',2,...
        'MarkerFaceColor',colors{idxCenter},...
        'MarkerEdgeColor',[0.1 0.1 0.1]);
        
    end
    
    centerPrev = center;
    
    pause(0.5)
    
    iterations = iterations + 1;
    
end

disp("pause: 5 sec");
pause(5);
disp("saving figure to: myNewFigure.fig");
savefig(gcf,'myNewFigure.fig');

% for reference: print number of iterations
fprintf('kMeans used %d iterations of changing centroids.\n',iterations);
end
