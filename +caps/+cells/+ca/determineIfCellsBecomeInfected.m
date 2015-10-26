
%Output
% grid:            updated CA Grid which includes the cells that became
%                  infected and their lysis time
% newly_inf_list:  a list of the cells that have just become
%                  infected during this round.
%                  the list contains the (x,y) coordinates of the
%                  grid positions
function [grid newly_inf_list] = determineIfCellsBecomeInfected( ... 
    grid, virusDim, stateDim, infListDim, infectionClockDim, ... 
    infectProbs, neighInfProbs, cellArea, states, latentPeriod, inf_list_length)


    import caps.cells.ca.*;


    newly_inf_list = zeros(0,2);
    
    for i = 1:size(grid,1)
        for j = 1:size(grid,2)
            %interpolate the probability of infection at virus
            %amount
            prob = interp1(infectProbs(:,1), infectProbs(:,2), ...
                           grid(i,j,virusDim)/cellArea);
                   
            %probability to become infected via an infected neighbouring cell
            % TODO: was not implemented - remove?
            %prob_neigh = determineNeighbourInfectionProbability(grid,  [i j], neighInfProbs);
                       
            %now draw a random number to see if the cell will
            %become infected 
            randomProb = rand(1);
            %fprintf(' virusAmt: %d prob: %f randomProb: %f\n', ...
            %        grid(i,j,virusDim), prob, randomProb);
            if(randomProb <= prob && grid(i,j,stateDim) ~= states.LYSED...
                                      && grid(i,j,stateDim) ~= states.INFECTED && grid(i,j,stateDim) ~= states.DEAD)
                grid(i,j, stateDim) = states.INFECTED;
                grid(i,j, infectionClockDim) = randi(latentPeriod.*2, 1)./2; %had to convert half days into integers and then back to half days
                
                insertPos = size(newly_inf_list,1)+1;
                newly_inf_list(insertPos, :) = [i j];
                grid(i,j, infListDim) = insertPos + inf_list_length; %for the overall list
            end
        end
    end
    
    
end

