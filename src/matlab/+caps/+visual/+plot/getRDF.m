function RDF = getRDF(intMat, centre, shellStep, StepsNumAroundCenter)
 
    
    intMatSize = size(intMat);
    
    %determine how big the max shell will be before going off one
    %of the four edges
    
    maxShell = min([centre(1)-1, intMatSize(1)-centre(1), centre(2)-1, ...
                    intMatSize(2)-centre(2)]);
    %shellStep = 5;
    
    %now make our 'result' array
    RDF = zeros(maxShell, 1);
    
    numSteps = StepsNumAroundCenter; %take measurements every 2 degrees (initial value 180)
    angleStep = (2*pi)/numSteps;
   
    
    for r = 1:length(RDF)
        clear CircleIntensity;
        CircleIntensity = zeros(2*pi/angleStep, 1);
        for angle = angleStep:angleStep:2*pi %go around circle,no double counting
            x = centre(1) + (r)*cos(angle);
            y = centre(2) + (r)*sin(angle);
            CircleIntensity(round(angle/angleStep)) = intMat(round(x), round(y));
        end
        RDF(r) =  mean(CircleIntensity);
    end
    
%     RDFNew = zeros(floor(maxShell/shellStep)-1, 1);
    
    %average the bins (ie shell step)
%     for s  = 1:length(RDFNew)
%         sum = 0;
%         for bin = 1:shellStep
%             sum = sum + RDF(s*shellStep + bin);
%         end
%         RDFNew(s) = sum./shellStep;
%     end
%     RDF = RDFNew;
    
%     RDF = RDF./numSteps;
    
    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%     Infectio - a virus infection spread simulation platform
%     Copyright (C) 2014-2015  Artur Yakimovich, Yauhen Yakimovich
% 
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.