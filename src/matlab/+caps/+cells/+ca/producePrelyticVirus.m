function [cellAssociatedVirusAmount cellFreeVirusAmount] = producePrelyticVirus(virusSpread, cellInfectiontime)
% PRELYTICVIRUSPRODUCTION
%
% prelyticVirusProduction determines  how much virus is produces at the 
% current time step by the virus according to the Sigmoidal Virus Growth 
% model.
% Y=Bottom + (Top-Bottom)/(1+10^((LogEC50-X)*HillSlope))
% The model equation is: Y = Bottom + (Top - Bottom)/...
% (1+ 10^((logEC50-t)*Slope)), where Y is the virus amount, t � is time after
% infection and "Bottom", "Top", "EC50" and "Slope"  are the fitting 
% parameters.
% Input Arguments: virusType, t, Bottom, Top, EC50 and Slope
% 

% Compute model predicted result for delta t
deltaY = (virusSpread.bottom + (virusSpread.top - virusSpread.bottom)/(1+ 10^((log10(virusSpread.EC50)-cellInfectiontime)*virusSpread.slope)));
if cellInfectiontime >= 1
    deltaY = deltaY - (virusSpread.bottom + (virusSpread.top - virusSpread.bottom)/(1+ 10^((log10(virusSpread.EC50)-(cellInfectiontime-1))*virusSpread.slope)));
end
% apply weights
cellAssociatedVirusAmount = virusSpread.cellAssociatedWeight*deltaY;
cellFreeVirusAmount = virusSpread.cellFreeWeight*deltaY;

end

