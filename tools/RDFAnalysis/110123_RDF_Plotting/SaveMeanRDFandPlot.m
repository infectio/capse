%=====================================================================
% %  2011 (copyright) Artur Yakimovich, University of Zurich, Switzerland
%                                 ****
%======================================================================
clear all
LoadParentFolder = 'D:\AY-Data\101202-AY-E11Stc_Plate_21\LastTP_RDF\WithAgarose\';
SaveFile = 'D:\AY-Data\101202-AY-E11Stc_Plate_21\LastTP_RDF\WithAgarose.mat';
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
end

save(SaveFile, 'MeanRDFs');

[NumberOfImages,RDFValuesPntsNumber] = size(MeanRDFs);
umPerPx = 0.645;
factorlength = umPerPx*RDFValuesPntsNumber;


plot(umPerPx:umPerPx:factorlength, MeanRDFs(1, 1:RDFValuesPntsNumber));

% hold on
xlabel('um')
ylabel('average intensity')
legend off

