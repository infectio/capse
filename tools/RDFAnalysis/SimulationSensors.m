%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%   Simulation Phenotypic data extraction from vars saved in Sensors
%%%                           (c)Artur Yakimovich
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
DataFolder = 'I:\AY-Data2\110402_Simulations\E3B_interp_vir100K\All_RDFs\';
FileCommonName = 'SensorVars113*';

AllFiles = dir(fullfile(DataFolder,FileCommonName));

for i = 1:size(AllFiles,1)
% %%% Provide sensors files
% %30 hpi to calculate propagation speed
% load('D:\AY-Data\110310_simulationResults\E3B\08-Mar-2011-11-41-37.875\Sensors\SensorVars30.mat')           
% % [SProw, SPcol] = find (intMat > backgroundIntensity);
% % Radius30hpi = max(((max(SProw) - min(SProw))/2), ((max(SPcol) - min(SPcol))/2))*umPerPx;
% % find largest radius, method 2
% [SProw, SPcol] = find (intMat > backgroundIntensity);
% CenterRow = numel(intMat(:,1))/2;
% CenterCol = numel(intMat(:,2))/2;
% for i =1:size(SProw,1)
% %     for j =1:size(SPcol,1)
% Radii30hpi(i) = sqrt((CenterRow-SProw(i,1)).^2 + (CenterCol-SPcol(i,1)).^2);
% %     end
% end
% Radius30hpi = max(Radii30hpi)*umPerPx;

%Measure Radius V3
%Measure Radius V3
% imshow(intMat*200);
% [x1, y1] = ginput(1);
% RadiusV3_1 = sqrt((CenterRow-x1)^2 + (CenterCol-y1)^2);
% close all;


%120 hpi
load(fullfile(DataFolder,AllFiles(i).name));

% find largest radius, method 1
% [SProw, SPcol] = find (intMat > backgroundIntensity);
% SPRadius = max(((max(SProw) - min(SProw))/2), ((max(SPcol) - min(SPcol))/2))*umPerPx;
% end of method 1

% find largest radius, method 2
[SProw, SPcol] = find (intMat > backgroundIntensity);
CenterRow = numel(intMat(:,1))/2;
CenterCol = numel(intMat(:,2))/2;
% for i =1:size(SProw,1)
% %     for j =1:size(SPcol,1)
% Radii(i) = sqrt((CenterRow-SProw(i,1))^2 + (CenterCol-SPcol(i,1))^2);
% %     end
% end
% SPRadius = max(Radii)*umPerPx;
% end of method 2

%Measure Radius V3
imshow(intMat*100);
[x2, y2] = ginput(1);
close all;
RadiusV3_2 = sqrt((CenterRow-x2)^2 + (CenterCol-y2)^2)*umPerPx;
CAGridCenterRow = size(CAGrid(:,:,1),1)/2;
CAGridCenterCol = size(CAGrid(:,:,1),2)/2;
uhGridBoundry = CAGridCenterRow + floor(RadiusV3_2/cellSize);
lhGridBoundry = CAGridCenterRow - floor(RadiusV3_2/cellSize);
uvGridBoundry = CAGridCenterCol + floor(RadiusV3_2/(2*cellSize/sqrt(3)));
lvGridBoundry = CAGridCenterCol - floor(RadiusV3_2/(2*cellSize/sqrt(3)));
%  imshow(intMat(floor(lhGridBoundry*cellSize/umPerPx):floor(uhGridBoundry*cellSize/umPerPx),floor(lvGridBoundry*(2*cellSize/sqrt(3))/umPerPx):floor(uvGridBoundry*(2*cellSize/sqrt(3))/umPerPx))*100);
%  close all;

%           [SPCenterRow, SPCenterCol] = find (CAGrid == 3)
%           SPCenterRow = max(SProw) - round((max(SProw) - min(SProw))/2)
%           SPCenterCol = max(SPcol) - round((max(SPcol) - min(SPcol))/2)

%         SPCropped = intMat((SPCenterCol-SPRadius):(SPCenterCol+SPRadius), (SPCenterRow-SPRadius):(SPCenterRow+SPRadius))
NumberofAllCells = numel(CAGrid(:,:,1));
NumberofInfectedCells = size(find(CAGrid(lhGridBoundry:uhGridBoundry,lvGridBoundry:uvGridBoundry,1) == 2),1) + size(find(CAGrid(lhGridBoundry:uhGridBoundry,lvGridBoundry:uvGridBoundry,1) == 3),1);
NumberofCellsInSP = numel(CAGrid(lhGridBoundry:uhGridBoundry,lvGridBoundry:uvGridBoundry,1));
% NumberofCellsInSP = floor((pi*(SPRadius)^2)/(2*sqrt(3)*(cellSize/2)^2));
          
% FrontPropagationSpeed = (SPRadius - Radius30hpi)/(113-30);
 FrontPropagationSpeed = (RadiusV3_2)/(113-25);
% save intesity matricies and other vars
disp ('=========cellSize:');              
disp (cellSize);              
% disp ('SPRadius:');              
% disp (SPRadius);              
disp ('NumberofAllCells:');
disp (NumberofAllCells);
disp ('NumberofInfectedCells:');
disp (NumberofInfectedCells);
disp ('NumberofCellsInSP:');
disp (NumberofCellsInSP);
disp ('FrontPropagationSpeed:');
disp (FrontPropagationSpeed);
disp ('um per pixel:');
disp (umPerPx);
disp ('RadiusV3_2');
disp (RadiusV3_2);
% disp ('FrontPropagationSpeedV3');
% disp (FrontPropagationSpeedV3);
xlswrite(fullfile(DataFolder,'results.xls'), [RadiusV3_2 NumberofAllCells NumberofInfectedCells NumberofCellsInSP FrontPropagationSpeed], ['A', num2str(i),':','E', num2str(i)])
end


