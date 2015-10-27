function VirusModel(virusType)
%COMBINED CA-PSE MODEL - Simulation of viral spread over population of
%cells using particle methods.
%
% Simulation entry point: 
%    - Initializes and runs model of particular virus with different
%      parameters;
%    - Runs Cellular Automata & Particale Strength Exchange methods
%      (CA&PSE);
%    - Saves results.

%% Set virus type
simulationFileName = mfilename;
if nargin == 0
    % Declare Virus strain (type). Possible values are:
    % {'HAdV-E3B','HAdV-E1B', 'VACV-IHD-J', 'VACV-WR'}
    virusType = 'VACV-WR';
    %virusType = 'HAdV-E3B';
end

%% Bootstrap model
startModelInit = tic;

% Add paths for parent folder of +caps package and all the required
% toolboxes (e.g. inside .../lib/* folder).
caps.path.init;
    
% Configure model by setting its parameters and reading the input.
caps.config.init;

% Uncomment this to reset MATLAB's random seed.
% caps.utils.rand_seed();


%% Initialize CA & PSE methods.
caps.initModel;

fprintf('Finished model initialization in %5.4f (sec)\n', toc(startModelInit));


%% Iterate through CA & PSE steps.
h2 = figure();
setappdata(0,'h2',h2);
caps.cells.ca.runCA;

%% Save this simulation in case we wish to re-examine it later
save(sprintf('%s_workspace_variables_%s_%dx%dcells_%f', imgsDir, date, cells_x,  cells_y)); %, ...


%quit(); %- needed when the script is run on Brustus cluster
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