function [avgInfCells avgLysedCells avgVirParts] = averageEndInfo(conditionFolderPath)
    
    d = dir(conditionFolderPath);
    
    numSims = 0;
    
    
    avgInfCells = 0;
    avgLysedCells = 0;
    avgVirParts = 0;
    
    %for each simulation
    for f = 1:length(d)
        numSims = numSims + 1;
        %as long as its a real file
        if(~strcmp(d(f).name,'.') && ~strcmp(d(f).name,'..') && ...
           ~strcmp(d(f).name, '.DS_Store'))
            
            
            %now load the resulting workspace file
            endFile = dir(fullfile(sprintf('%s%s', conditionFolderPath, d(f).name), 'CA_PSE*.mat'));
                
            load(sprintf('%s%s/%s', conditionFolderPath, d(f).name, endFile.name))
            
            %currently infected cells
            avgInfCells = avgInfCells + sum(sum(CAGrid(:,:,1)==2));
            %cells that were infected, now lysed
            avgInfCells = avgInfCells + sum(sum(CAGrid(:,:,1)==3));
            
            avgLysedCells = avgLysedCells + sum(sum(CAGrid(:,:,1)==3));
           
            avgVirParts = avgVirParts + sum(partMat(:,3));
        end
        
    end
    
    %now divide by the number of simulations to get the total
    avgInfCells = avgInfCells/numSims;
    avgLysedCells = avgLysedCells/numSims;
    avgVirParts = avgVirParts/numSims;
 
    
    
end
