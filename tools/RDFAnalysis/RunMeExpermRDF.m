%=====================================================================
%        RunMe script to get an RDF of an image series and plot it 
%
%                            ****OOOOOO****     
%  2010 (copyright) Artur Yakimovich, University of Zurich, Switzerland
%                                 ****
%======================================================================
clear all
NormalizeTheIntensity = 'Yes';
ImFolder = 'I:\AY-Data2\101102S10E\Stitched\G02\ROI\';
%Common name mask for the GFP channel imaes
RadialStepsNumber = 360;
CommonNameGFP = '*w2.TIF';
CommonNamePI = '*w2.TIF';
% produces RDFs as an output
RDFs = experimentalImagesRDF(ImFolder,CommonNameGFP,CommonNamePI, RadialStepsNumber);
%remove zero elements
RDFs = mat2cell(RDFs,ones(size(RDFs(:,1), 1),1), ones(size(RDFs(1,:), 2),1));
[NumberOfImages,RDFValuesPntsNumber] = size(RDFs);
for i = 1:NumberOfImages
    for j=1:RDFValuesPntsNumber
        if RDFs{i,j} == 0
            RDFs{i,j} = [];
        end
    end
end
RDFs = cell2mat(RDFs);
if strcmp('Yes', NormalizeTheIntensity) == 1;
    RDFs = RDFs - min(RDFs(:));
end    
% How many points to skip while plotting, 1 - plot every point
PlotingStep = 10;

% First dimension of the RDF array is the number of image.  The second
% dimension contains the RDF points 1 to the length of the rdf
[NumberOfImages,RDFValuesPntsNumber] = size(RDFs);
%l = length(rdf);
%l = 430;
%microns per pixel vlaue
umPerPx = 0.645;

factorlength = round(umPerPx*RDFValuesPntsNumber);
%factorlength =
%set(0,'DefaultAxesColorOrder',[0 1 0;0 1 0;0 0 1]);

           ColorSet = varycolor(5);
            set(gca, 'ColorOrder', ColorSet);
            hold all;
            
            
            

            % How many points to skip while plotting, 1 - plot every point
            

            % First dimension of the RDF array is the number of image.  The second
            % dimension contains the RDF points 1 to the length of the rdf
            [NumberOfImages,RDFValuesPntsNumber] = size(RDFs);

            %microns per pixel vlaue
            umPerPx = 0.645;
            for i = 1:PlotingStep:NumberOfImages
            factorlength = umPerPx*RDFValuesPntsNumber;
            plot(umPerPx:umPerPx:factorlength, RDFs(i, 1:RDFValuesPntsNumber)./2^16);
 end
            % hold on
            xlim([0 500])
            ylim([0 0.025])
            xlabel('um')
            ylabel('average intensity')
            legend off


            %plot(1:lengthOfRDF, RDFs(i,:))
           
            set(gcf, 'Colormap', ColorSet);
            colorbar
            hold off



% plot(umPerPx:umPerPx:factorlength, RDFs(1:PlotingStep:NumberOfImages, 1:RDFValuesPntsNumber)./2^16);
% hold on
% xlabel('um')
% ylabel('average intensity')
% h = legend('Location','EastOutside');
% hold off
%plot(1:lengthOfRDF, RDFs(i,:))