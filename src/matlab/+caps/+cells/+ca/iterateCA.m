function [automaton, partMat] = iterateCA(automaton, virusFlags, partMat, timeStep, infection)
%ITERATECA Do one iteration of CA cycle

import caps.particles.pse.*;
import caps.cells.ca.*;


% Cell die.
if virusFlags.isCellDeathEnabled
    automaton = caps.cells.ca.killCells(automaton, timeStep);
end

% Cell lyse.
[automaton partMat] = caps.cells.ca.lyseCells(automaton, virusFlags, partMat);

% Infection spreads.
[automaton partMat] = caps.cells.ca.infectCells(automaton, virusFlags, partMat, infection);


end

