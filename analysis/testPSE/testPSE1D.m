function [L2 Linf] = testPSE1D
    
    %parts = [36, 40, 48, 60, 70, 80, 100, 140, 160, 200, 400, 600, 800, 1000, 2000, 4000, 6000];
    %parts = [36, 200, 400, 800, 1000, 2000, 4000, 6000];
    
    %parts = [25, 50, 100, 140, 160, 200, 400, 800];
    parts = [12, 20, 60, 80, 100, 140, 160, 200, 400, 1000];
    
    parts = parts + 1; % they are 
    L2 = zeros(length(parts), 1);
    Linf = zeros(length(parts), 1);

    lBounds = 0; 
    uBounds = 1000;
    
    %set the time step and number of timesteps done to be the same
    h_s = min((uBounds-lBounds)./(parts-1));
    D = 50; 
    dt = h_s^2/(2*D)*0.5; %2*dimension
    t = dt*1000
    
    startTime = 100;
    t_anal = startTime + t;
    
    
    
    for p = 1:length(parts)

        nParts = parts(p);
        
        h = (uBounds - lBounds)/(nParts-1);
        epsilon = h;
        cutOff = 5*epsilon;
        V = ones(nParts,1)*h;
        
        partPos = createParticles1D(nParts, lBounds, uBounds);
        verletList = createVerletList1D(partPos, cutOff);
  
        partMat = [partPos' zeros(length(partPos), 1)] ;
        strengthDim = size(partMat, 2);
     
        matWidth = length(partMat);
        initPos = ceil(matWidth*0.5);
        
        initialConc = analyticalDiffusion(partMat(:,1), D, startTime, ...
                                             partMat(initPos, 1));
      
                                         
        plot(partMat(:,1), initialConc, '-*');                                         
        partMat(:, strengthDim) = initialConc.*V;
           
        
                                           
        %figure(2);
        %hold on;
        %plot(partMat(:,1), partMat(:,2)./V, 'g')
        
        
        %diffusion via PSE
        partMat = PSEDiffusion1D(partMat, V, D, dt, t, verletList, epsilon, strengthDim);
        
        %determine analytical solution
        analyticalSoln = analyticalDiffusion(partMat(:,1), D, t_anal, ...
                                             partMat(initPos,1));

        % plot
        figure(2);
        hold on;
        
        plot(partMat(:,1), partMat(:,2)./V, 'r');  
        plot(partMat(:,1), initialConc, '-*');
        plot(partMat(:,1), analyticalSoln, 'g');
        
        
        
        
        
        
        %compare L2 and L_inf norms
        errors = partMat(:, strengthDim)./V(:) - analyticalSoln;
        
        errorbar(partMat(:,1), partMat(:,2)./V, errors, 'r')
        
        
        fprintf('Values at ends: %e %e \n', partMat(1,strengthDim)./V(1), partMat(end,strengthDim)./V(end));
        
        N = length(errors);
        %disp(nParts);
        %disp(N);
        
        L2(p) = sqrt(sum(errors.^2)/N);
        Linf(p) = max(abs(errors));
        
        fprintf('Nparts: %d, L2: %e, Linf:%e \n', nParts, L2(p), Linf(p));
        fprintf('            L2: %f, Linf:%f \n', L2(p), Linf(p));

    end
    
    partsSel = 1:length(parts);
    
    figure(3);
    hold on;
    logParts = log10(parts)';
    logL2 = log10(L2);
    pL2 = polyfit(logParts(partsSel), logL2(partsSel), 1)
    
    logLinf = log10(Linf);
    pInf = polyfit(logParts(partsSel), logLinf(partsSel), 1)
    
    plot(logParts, logL2);
    plot(logParts, logLinf, 'r');
    
    
    %plot the lines
    
    f = polyval(pL2,logParts(partsSel));
    plot(logParts(partsSel),f,'--b')
    
    f = polyval(pInf,logParts(partsSel));
    plot(logParts(partsSel),f,'--r')
    
    % labels and legends
    plot(logParts,log10(parts.^-2),'k')
    legend('L2','Linf', 'L2 fit', 'Linf fit', 'Analytical slope for N^{2} convergence');
    title('Convergence Curve of PSE Method in 1D');    
    ylabel('log(E_R_M_S)');
    xlabel('log(N)');
    
    
        figure(4);
    hold on;
    logParts = log10((parts-1)./(uBounds - lBounds))';
    logL2 = log10(L2);
    pL2 = polyfit(logParts(partsSel), logL2(partsSel), 1)
    
    logLinf = log10(Linf);
    pInf = polyfit(logParts(partsSel), logLinf(partsSel), 1)
    
    plot(logParts, logL2);
    plot(logParts, logLinf, 'r');
    
    
    %plot the lines
    
    f = polyval(pL2,logParts(partsSel));
    plot(logParts(partsSel),f,'--b')
    
    f = polyval(pInf,logParts(partsSel));
    plot(logParts(partsSel),f,'--r')
    
    % labels and legends
    plot(logParts,log10(parts.^-2),'k')
    legend('L2','Linf', 'L2 fit', 'Linf fit', 'Analytical slope for N^{2} convergence');
    title('Convergence Curve of PSE Method in 1D');    
    ylabel('log(E_R_M_S)');
    xlabel('log(1/h)');

end

function partPos =  createParticles1D(nParts, uBounds, lBounds)

    cellMid = (1/2)*(uBounds-lBounds)/(nParts);

    partPos = linspace(lBounds+cellMid,uBounds-cellMid,nParts);

end

function verletList = createVerletList1D(partPos, cutOff)

    %since this is just 1D, we can find the "window" size that corresponds
    %to the cutOff value
    
    windowSize = 0;
    for ii = 1:length(partPos)
        if abs(partPos(ii) - partPos(1)) > cutOff
            break;
        end
        windowSize = ii-1;
    end
   
    verletList = cell(length(partPos), 1);
    for ii = 1:length(partPos)
          %lower one
          for jj = windowSize:-1:1
              if ii-jj > 0 
                verletList{ii} = [verletList{ii} ii-jj];
              end
          end
          % upper ones
          for jj = 1:windowSize
              if ii+jj <= length(partPos) 
                verletList{ii} = [verletList{ii} ii+jj];
              end
          end
          
    end
          
    
end
