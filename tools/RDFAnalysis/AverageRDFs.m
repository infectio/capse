function avgRDF = AverageRDFs(conditionFolderPath)
    
    d = dir(MainDir);
    
    numSims = 0;
    
    %for each simulation
    for f = 1:length(d)
        numSims = numSims + 1;
        %as long as its a real file
        if(~strcmp(d(f).name,'.') && ~strcmp(d(f).name,'..') && ...
           ~strcmp(d(f).name, '.DS_Store'))
            
            %now go through all the data for each of the sub-folder
            %this is going through the time points of the RDF
            subd = dir(fullfile(sprintf('%s/%s', MainDir, d(f).name), 'int_*rdf.mat'));
            for j = 1:length(subd)
                
                load(sprintf('%s/%s/%s', MainDir, d(f).name, subd(j).name))
            
                %if its the file first of the first folder, then make the matrices to
                %store in
                if(strcmp(d(f).name, '1') && j==1)

                    avgRDF = zeros(length(subd), length(rdf));
                    
                end
                
                avgRDF(j,:) = avgRDF(j,:) + rdf;
                
                
            end
            
        end
        
    end
    
    for timePoint = 1:size(avgRDF, 1)
        avgRDF(timePoint, :) = avgRDF(timePoint, :)./numSims;
    end
    
    
    
end
