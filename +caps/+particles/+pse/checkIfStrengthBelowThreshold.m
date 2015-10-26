function done = checkIfStrengthBelowThreshold(partMat, strengthDim, ...
    cellAreaList, cellArea, ...
    infectionThreshold, pseThreshold)
%CHECKIFSTRENGTHBELOWTHRESHOLD is just a little helper method that goes 
% through all the particles to determine if the strength of a particle is 
% less than the lowest infection threshold when it is below this threshold 
% then no additional cells can become infected and then the PSE simulation 
% can stop.

done = false;
nPartsAboveThreshold = 0;
for c=1:length(cellAreaList)
    if(sum(partMat(cellAreaList{c}(:,1),strengthDim))/cellArea > infectionThreshold)
        nPartsAboveThreshold = nPartsAboveThreshold + 1;
    end
end

%fprintf('nPartsAboveThreshold: %d\n', nPartsAboveThreshold);
if(nPartsAboveThreshold == 0)
    done = true;
    return;
end

%else maybe we should check to see if there is much difference
%left in the concentrations
% this is needed bc if threshold is set low and the space isn't
% very big, then it will never reach below infection
% probability threshold
maxStrength = max(partMat(:,strengthDim));
minStrength = min(partMat(:,strengthDim));
if(maxStrength - minStrength <= pseThreshold)
    done = true;
    return;
end


end
