function prob_neigh = determineNeighbourInfectionProbability(grid,  pos, neighInfProbs)

    % so we must define a few things
    
    % if the infection is additive (most simple) based on the infection
    % status of neighbours, or if say it follows some other sort of
    % distribution (like for example... maybe a negative binomial - if the
    % first infected neighbour cell doesn't make it infected, then does the
    % next, and the next...)
    prob_neigh = neighInfProbs;
end

