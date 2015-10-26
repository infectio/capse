
LoadDir = 'D:\PhDProject\caps\data\simulations\pse\AdvSpd1\';
SvDir = [LoadDir, '\tif'];
mkdir (SvDir);

% find all the .m files
AllUnsorted = dir(fullfile(LoadDir,'*.mat'));
%put them into the natural ordering (ie. s1, s2, ... s10, s11...)
AllCellArry = sort_nat(extractfield(AllUnsorted, 'name'));
Allmat = cell2struct(AllCellArry, 'name', 1);

for iM = 1:length(Allmat)
    load ([LoadDir, Allmat(iM).name]);
    scatter(partMat(:,1), partMat(:,2),5,partMat(:,3));
    print('-dtiff',[SvDir, '\', Allmat(iM).name,'.tif'])
end