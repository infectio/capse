function automaton = infectSingleCell( ...
        automaton, ... 
        position, ...        
        infection, ...
        infectionLevel)

    if ~iscell(position)
        position = num2cell(position);
    end
    [x y] = position{:};
    
    intensityRate = interpolateIntensityRate(infection.intensityRates, infectionLevel, true);
    
    stateDim = automaton.dimension.state;
    infectionList = automaton.dimension.infectionList;
    virusAmountDim = automaton.dimension.virusAmount;
    infectionTime = automaton.dimension.infectionTime;
    infectionClock = automaton.dimension.infectionClock;
    automaton.grid(x, y, stateDim) = automaton.cellStates.INFECTED;
    automaton.grid(x, y, infectionList) = size(automaton.infectedCells,1) + 1;
    automaton.grid(x, y, virusAmountDim) = infectionLevel;
    automaton.grid(x, y, infectionTime) = infection.initialTime;
    automaton.grid(x, y, infectionClock) = infection.initialClock;

    automaton.infectedCells{end + 1}.x = x;
    automaton.infectedCells{end}.y = y;
    automaton.infectedCells{end}.initInfVal = infectionLevel;
    automaton.infectedCells{end}.intRate = intensityRate;
    automaton.infectedCells{end}.valid = true;
end