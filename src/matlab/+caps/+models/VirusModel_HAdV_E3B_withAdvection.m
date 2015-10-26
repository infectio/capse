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
    virusType = 'HAdV-E3B';
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

% Overriding  some parameters & flags here:
pauseOnCAIterations = false; % Wait for key stroke or user input after every iteration
virusFlags.plotImagesWithParts = false; % Should the images be displayed with or without PSE particles
virusFlags.isAdvectionEnabled = true; % advection: true - apply flow, flase - don't
TotalTimeStepsHPI = 120; % Total time steps for the model to run in hours post infection
virionLysed = 200000;% amount of virus egressing by lysis from each infected cell



%% Initialize CA & PSE methods.
caps.initModel;

fprintf('Finished model initialization in %5.4f (sec)\n', toc(startModelInit));


%% Iterate through CA & PSE steps.
figure;
caps.cells.ca.runCA;


%% Save this simulation in case we wish to re-examine it later
save(sprintf('%s_workspace_variables_%s_%dx%dcells_%f', imgsDir, date, cells_x,  cells_y)); %, ...


%quit(); %- needed when the script is run on Brustus cluster
end
