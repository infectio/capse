%%
% Flags convention: every variable of form '.*Flag' has to be boolean.

initCATimeStep = 1;

advectionflag = false; % advection: true - apply flow, flase - don't
CellLysDistFlag = 'unif';% cell lysis distribution flag: unif, norm, exp.
Sensors = true; % save all workspace variable at certain hpi during the simulation

% what kinf od output do you want?
OutputMedia = 'Images'; %'RDF'; RDF or Images (intesities are normalized for the images)
                        % Alternatively - empty string means no output.
%OutputMedia = 'RDF';    % RDF is DataPoints - recording produced measurement

ImagesOutputWithParts = true; % Should the images be displayed with or without PSE particles
CellDeathFlag = false; % False==OFF or true==ON - determines whether 
                       % uninfected cells will die as well (we keep it off 
                       % for VACV, since we don't observe any major cell 
                       % death).

% DEPRECATED: Always extrapolate.
ExtrapolationFlag = true;     %true = linear extrapolation for intensity increase rates above the maximum virus concentration measured
                              %false = use the values measured for the maxiumum virus concentration measured
                              % See also interpolateIntensityRate() 
                              
OutputPrefix = fullfile(dataFolder, 'simulations'); %set the prefix for the output folder
SavePrticlesPlotFlag = false; % Plotting of PSE particles to debug
pseDebugDir = fullfile(dataFolder, 'simulations', 'pse', 'AdvSpd1');
if SavePrticlesPlotFlag, mkdir(pseDebugDir);end %save the partMat to plot it later for the debug purposes

%%
% Modelling properties of viral infection (each virustype has a different 
% set of properties).

% Does virus replicate?
VirusReplicationFlag =  true;
if strcmp(virusType, 'HAdV-E1B')
     % Virus replication is off only for E1B virus
     VirusReplicationFlag =  false;
end

PrimaryLysisFlag = true;
if strcmp(virusType, 'VACV-IHD-J') || strcmp(virusType, 'VACV-WR')
     PrimaryLysisFlag = false;
end

% Does virus uses cell-to-cell spread mechanism?
VirusCell2CellSpreadFlag = false;
VirusCell2CellSuperinfectionFlag = false;
if strcmp(virusType, 'VACV-IHD-J') || strcmp(virusType, 'VACV-WR')
     VirusCell2CellSpreadFlag = true;
end

% Does virus uses cell-free spread mechanism?
VirusCellFreeSpreadFlag = true;


% Are cells producing and releasing virus before lysis
prelyticVirusProductionFlag = false;

isSpreadCell2CellLimitedByTime = false;
isSpreadCell2CellLimitedByVirusAmount = true;

if strcmp(virusType, 'VACV-IHD-J') || strcmp(virusType, 'VACV-WR')
    prelyticVirusProductionFlag = true;
end
%%

if VirusReplicationFlag
  % in days
  lyseStart = 2; lyseEnd = 5;
else
  lyseStart = 2000; lyseEnd = 5000;    % values too big to reach
end


% Pack every flag into a struct
virusFlags = struct( ...
   'isCell2CellSpreadEnabled', VirusCell2CellSpreadFlag, ...
   'isCellFreeSpreadEnabled', VirusCellFreeSpreadFlag, ...
   'isReplicaitonEnabled', VirusReplicationFlag, ...
   'isPrimaryLysisEnabled', PrimaryLysisFlag, ...
   'isExtrapolationEnabled', ExtrapolationFlag, ...
   'saveParticles', SavePrticlesPlotFlag, ...
   'lysisDist', CellLysDistFlag, ...
   'isAdvectionEnabled', advectionflag, ...
   'isCellDeathEnabled', CellDeathFlag, ...   
   'plotImagesWithParts', ImagesOutputWithParts, ...
   'isPrelyticVirusProductionEnabled', prelyticVirusProductionFlag, ...
   'isSpreadCell2CellLimitedByTime', isSpreadCell2CellLimitedByTime, ...
   'isSpreadCell2CellLimitedByVirusAmount', isSpreadCell2CellLimitedByVirusAmount, ...
   'isVirusCell2CellSuperinfectionFlag', VirusCell2CellSuperinfectionFlag ...
);
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