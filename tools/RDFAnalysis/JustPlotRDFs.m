%RDFs variable has to be loaded before starting this script




            ColorSet = varycolor(7);
            set(gca, 'ColorOrder', ColorSet);
            hold all;
            
            
            

            % How many points to skip while plotting, 1 - plot every point
            PlotingStep = 10;

            % First dimension of the RDF array is the number of image.  The second
            % dimension contains the RDF points 1 to the length of the rdf
            [NumberOfImages,RDFValuesPntsNumber] = size(RDFs);
TimePointsToPlot = [120];
            %microns per pixel vlaue
            umPerPx = 0.645;
            for i = 20:PlotingStep:90  %or to NumberOfImages
            if i == intersect(TimePointsToPlot, i) 
                factorlength = umPerPx*RDFValuesPntsNumber;
            plot(umPerPx:umPerPx:factorlength, RDFs(i, 1:RDFValuesPntsNumber));
            end
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