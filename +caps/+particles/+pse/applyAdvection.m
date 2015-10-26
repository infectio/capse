function [partMat, cellAreaList, partAreaList] = ...
    applyAdvection(partMat, dt_PSE, advectionspeed, lBounds, uBounds, h, ...
                   cutOff, cellMid, numPerDim, cellSize, CAGrid)
%APPLYADVECTION Advection implementation

% So far we will implement only advection uphill
% (OY axis + direction). This can be reproduced and measured in the
% experiment. Therefore we set the coordinatesc change in OX to 0
dx = 0;  % otherwise it should be dt_PSE * advectionspeed <- some advection speed in OX
dy = dt_PSE * advectionspeed;
%dy = 4;
% in our case we move particles to the + direction of OY, so it's +dy
%move the particles accordingly
newpositions(:,1) = partMat(:,1) + dx;
newpositions(:,2) = partMat(:,2) + dy;
newpositions(:,3) = partMat(:,3);

%Now remesh the particles to the old position using M'(4)
%method. This keeps the particles where they were before and
%effectively moves the strength to the advection direction.
% partMat = remesh(partMat,newpositions);

%implement particles addition and delition. In future this will not
%me needed when the remeshing is working.

% 1. check whether the new positions are within the boundaries. To
% speed up we will check only particles with min and max
% coordinates on the OX(:,1) and OY(:,2) axes. distance between
% particles currently is 2A, A = 3.7130
% cellMid - is the distance between particles



% 2. if particles are outside of the boundaries - delete them

uBviolaterOX = find(newpositions(:,1)>=uBounds);
lBviolaterOX = find(newpositions(:,1)<=lBounds);
uBviolaterOY = find(newpositions(:,2)>=uBounds);
lBviolaterOY = find(newpositions(:,2)<=lBounds);

% 3. now check whether the distance from the max and min particles
% to the is more then h.

% 4. if yes - add more particles at distance h to the nearest
% particle with strength = 0

gridShift = uBounds - lBounds - 2*cellMid;

%OX lower
%if min(newpositions(:,1)) - lBounds >= 2*cellMid
if ~isempty(uBviolaterOX)
    
    %instead of deleting and creating new array elements let's just
    %re-assign coordinates of boundary conditions violaters accordingly and their Strength to 0
    %these way we'll naver change the matrix size. Should be faster
    %as well
    %in a for loop decide how many rows/col of new positions should
    %be added. Important if more than one cols/rows are moved in
    %one iteration
    
    newpositions(uBviolaterOX, 1) = newpositions(uBviolaterOX, 1) - gridShift;
    % TODO make unoin of all violaters and assign 0
    newpositions(uBviolaterOX, 3) = 0;
    %             for iDimFold = numPerDim:numPerDim:uBviolaterOX
    %                 newpositions(uBviolaterOX((iDimFold-numPerDim):iDimFold),1) = min(newpositions(:,1)) - cellMid;
    %                 newpositions(uBviolaterOX((iDimFold-numPerDim):iDimFold),2) = min(newpositions(:,2)):cellMid:cellMid*numPerDim;
    %                 newpositions(uBviolaterOX((iDimFold-numPerDim):iDimFold),3) = 0;
    %             end
    
end
%OX upper
%if uBounds - max(newpositions(:,1)) >= 2*cellMid
if ~isempty(lBviolaterOX)
    
    newpositions(lBviolaterOX, 1) = newpositions(lBviolaterOX, 1) + gridShift;
    newpositions(lBviolaterOX, 3) = 0;
    %              for iDimFold = numPerDim:numPerDim:lBviolaterOX
    %                 newpositions(lBviolaterOX((iDimFold-numPerDim):iDimFold),1) = max(newpositions(:,1)) + cellMid;
    %                 newpositions(lBviolaterOX((iDimFold-numPerDim):iDimFold),2) = min(newpositions(:,2)):cellMid:cellMid*numPerDim;
    %                 newpositions(lBviolaterOX((iDimFold-numPerDim):iDimFold),3) = 0;
    %              end
end

%OY
%OY lower
%if min(newpositions(:,2)) - lBounds >= 2*cellMid
if ~isempty(uBviolaterOY)
    newpositions(uBviolaterOY, 2) = newpositions(uBviolaterOY, 2) - gridShift;
    newpositions(uBviolaterOY, 3) = 0;
    %             for iDimFold = numPerDim:numPerDim:uBviolaterOY
    %                 newpositions(uBviolaterOY((iDimFold-numPerDim):iDimFold),1) = min(newpositions(:,1)):cellMid:cellMid*numPerDim;
    %                 newpositions(uBviolaterOY((iDimFold-numPerDim):iDimFold),2) = min(newpositions(:,2)) - cellMid;
    %                 newpositions(uBviolaterOY((iDimFold-numPerDim):iDimFold),3) = 0;
    %             end
end
%OY upper
%if uBounds - max(newpositions(:,1)) >= 2*cellMid
if ~isempty(lBviolaterOY)
    newpositions(lBviolaterOY, 2) = newpositions(lBviolaterOY, 2) + gridShift;
    newpositions(lBviolaterOY, 3) = 0;
    
    %             for iDimFold = numPerDim:numPerDim:lBviolaterOY
    %                 newpositions(lBviolaterOY((iDimFold-numPerDim):iDimFold),1) = min(newpositions(:,1)):cellMid:cellMid*numPerDim;
    %                 newpositions(lBviolaterOY((iDimFold-numPerDim):iDimFold),2) = max(newpositions(:,2)) + cellMid;
    %                 newpositions(lBviolaterOY((iDimFold-numPerDim):iDimFold),3) = 0;
    %             end
end

% If any of the conditions are met - deletion and addition should be
% performed resulting into the same number of particles
%         display('sizes of partMat and newpositions respectively:');
%         display(size(partMat))
%         display(size(newpositions))

partMat = newpositions;
%         display('sizes of partMat updated:');
%         display(size(partMat));
%         display('PSE time step:');
%         display(timeStep);
%

% Make sure that the particles positions in cellArealList and
% partAreaList are updated we use the createAreaLists function
% again here. Infuture this should fixed in a more efficient way.
[cellAreaList, partAreaList] = createAreaLists([size(CAGrid,1) size(CAGrid,2)], partMat, cellSize, h);

end
