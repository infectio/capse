function [rdf, intMat] = computationalRDF(grid, inf_list, pixelList, stateDim, ...
                         infListDim, infTimeDim, backgroundIntensity)
                     
    RadialStepsNumber = 360;                 
    intMat = caps.visual.plot.createIntensityMatrix(grid, inf_list, pixelList, stateDim, ...
                         infListDim, infTimeDim, backgroundIntensity);    
    centre = [round(length(intMat)/2)  round(length(intMat)/2)];
    rdf = caps.visual.plot.getRDF(intMat, centre, 1, RadialStepsNumber); %use shell size of 1 - can be
                                     %binned later
    
end
