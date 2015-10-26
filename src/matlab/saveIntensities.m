function saveIntensities(intDir, timeStep, rdf)
    
    fileName = sprintf('%s%d%d', intDir, timeStep, '.rdf');
    save(fileName, 'rdf');

end