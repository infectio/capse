function automaton = killCells(automaton, timeStep)

automaton.grid = determineIfCellsDie(automaton.grid, timeStep, ...
    automaton.cellDeathFractions, automaton.dimension.state, ...
    automaton.cellStates);

end

