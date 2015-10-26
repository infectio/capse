%=====================================================================
% %  2011 (copyright) Artur Yakimovich, University of Zurich, Switzerland
%                                 ****
%======================================================================
clear all
LoadParentFolder = 'I:\AY-Data2\110402_Simulations\E3B_exterp_vir100K\AllRDFs\';
SaveFile = 'I:\AY-Data2\110402_Simulations\E3B_exterp_vir100K\IV_E3B_exterp_vir100K.mat';
CommonName = '*.mat';
maxShellSize = 799;
%Common name mask for the GFP channel imaes
Allmat = dir(fullfile(LoadParentFolder,CommonName));
% Allmat = cell2struct(mat, 'name', 1);
AllRDFs = cell (size(Allmat,1),maxShellSize);
% AllRDFsStr = cell2struct(AllRDFs);
for i = 1:size(Allmat,1)
    
    load([LoadParentFolder, Allmat(i,1).name]);
    for j = 1:size(RDFs(:))
    AllRDFs(i, j) = num2cell(RDFs(j));
    end
end

for i = 1:maxShellSize
MeanRDFs(i) = mean(cell2mat(AllRDFs(:, i)));
sdRDFs(i) = std(cell2mat(AllRDFs(:, i)));
end

save(SaveFile, 'MeanRDFs','sdRDFs');


[NumberOfImages,RDFValuesPntsNumber] = size(MeanRDFs);
umPerPx = 0.645;
factorlength = umPerPx*RDFValuesPntsNumber;


plot(umPerPx:umPerPx:factorlength, MeanRDFs(1, 1:RDFValuesPntsNumber)./2^16); %

hold on

plot(umPerPx:umPerPx:factorlength, (MeanRDFs(1, 1:RDFValuesPntsNumber)+sdRDFs(1, 1:RDFValuesPntsNumber))./2^16, '--b'); 
plot(umPerPx:umPerPx:factorlength, (MeanRDFs(1, 1:RDFValuesPntsNumber)-sdRDFs(1, 1:RDFValuesPntsNumber))./2^16, '--b'); %
 xlim([0 500])
 ylim([0 0.05])

            xlabel('um')
            ylabel('average intensity')
            legend off

