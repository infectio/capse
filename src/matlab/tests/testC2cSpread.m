function testC2cSpread
% Test neighbourhood

S = load(fullfile(caps.path.root, 'tests', 'mock_automaton.mat'));
automaton = S.automaton;
S = load(fullfile(caps.path.root, 'tests', 'mock_intrates.mat'));
intensityRates =  S.intensityRates;

% params
x = 10;
y = 12;
backgroundIntensity = 0.1;
cellSize = 22;
initialInfection = 10;

% check n-hood for first infected cell
neighbours = caps.cells.ca.getNeighbours(automaton, x, y);

% infect neighbour
for iNeighbour = 1:size(neighbours, 1);
    [xp yp] = neighbours{iNeighbour, :};
    automaton = infectSingleCell(automaton, {xp, yp}, initialInfection, intensityRates);
end

% test by drawing
hg = caps.visual.plot.visualize( ...
    automaton.grid, ...
    [], ...
    automaton.infectedCells, ...
    cellSize, ...
    automaton.dimension.state, ...
    automaton.dimension.infectionList, ...
    automaton.dimension.infectionTime, ...
    false, ...
    backgroundIntensity);
end
