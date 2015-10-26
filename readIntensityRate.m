function intensityRates = readIntensityRate(filename)
    
    
    fileContents = csvread(filename);
    
    %create cell array for the file contents
    %first element is infection start value
    %second element is the infection rate increase table
    numInfectionStartRates = length(unique(fileContents(:,1)));
    intensityRates = cell(numInfectionStartRates, 2);
    
    j=1;
    for i=1:numInfectionStartRates
        ind = find(fileContents(:,1) == fileContents(j,1));
        intensityRates{i,1} = fileContents(ind(1),1);
        if size(fileContents, 2) == 4
            intensityRates{i,2} = fileContents(ind, 2:4);
        else
            intensityRates{i,2} = fileContents(ind, 2:3);
        end
        j = ind(end) + 1; %start next from the next initial
                          %infection value
        
    end

end

