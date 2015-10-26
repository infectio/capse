%=====================================================================
% %  2011 (copyright) Artur Yakimovich, University of Zurich, Switzerland
%                                 ****
%======================================================================
clear all
LoadParentFolder = 'I:\AY-Data2\110402_Simulations\E3B_exterp_vir50K\AllRDFs\';
SaveFile = 'I:\AY-Data2\110402_Simulations\E3B_exterp_vir50K\IV_E3B_exterp_vir200K_0.5.mat';
% SaveFile1 = 'D:\AY-Data\110310_simulationResults\E3B_200cells_extrapolation\IV_extr_200_E3Bsd.mat';
CommonName = '*.mat';
maxShellSize = 111;
TP = 113;

%Common name mask for the GFP channel imaes
Allmat = dir(fullfile(LoadParentFolder,CommonName));
% Allmat = cell2struct(mat, 'name', 1);
AllRDFs = cell (size(Allmat,1),maxShellSize);
% AllRDFsStr = cell2struct(AllRDFs);
for i = 1:size(Allmat,1)
    
    load([LoadParentFolder, Allmat(i,1).name]);
    for j = 1:size(RDFs(TP, :), 2)
    AllRDFs(i, j) = num2cell(RDFs(TP,j));
    end
end

for i = 1:maxShellSize
MeanRDFs(i) = mean(cell2mat(AllRDFs(:, i)));
sdRDFs(i) = std(cell2mat(AllRDFs(:, i)));
end




[NumberOfImages,RDFValuesPntsNumber] = size(MeanRDFs);
umPerPx = pixelList(2, 2) - pixelList(1,2);
factorlength = umPerPx*RDFValuesPntsNumber;
save(SaveFile, 'MeanRDFs', 'sdRDFs', 'factorlength', 'umPerPx', 'NumberOfImages', 'RDFValuesPntsNumber');

plot(umPerPx:umPerPx:factorlength, MeanRDFs(1, 1:RDFValuesPntsNumber));

 hold on
plot(umPerPx:umPerPx:factorlength, (MeanRDFs(1, 1:RDFValuesPntsNumber)+sdRDFs(1, 1:RDFValuesPntsNumber)), '--b');
plot(umPerPx:umPerPx:factorlength, (MeanRDFs(1, 1:RDFValuesPntsNumber)-sdRDFs(1, 1:RDFValuesPntsNumber)), '--b');
 xlim([0 500])
 ylim([0 0.05])

            xlabel('um')
            ylabel('average intensity')
            legend off

