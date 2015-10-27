function [L2 Linf] = testPSE
    
    %parts = [8, 12, 16, 20, 30, 40, 50];
    parts = [4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 70];
    parts = parts + 1;
    parts = parts.*parts;
    %parts = parts.*9;
    L2 = zeros(length(parts), 1);
    Linf = zeros(length(parts), 1);
    minStrengths = zeros(length(parts), 1);
   
    
    
    modelSize = [1000 1000];
 

    lBounds = 0; 
    uBounds = max(modelSize(1), modelSize(2));
    
    
    h_s = min((uBounds-lBounds)./(parts.^(1/2)-1));
    D = 50; 
    dt = h_s^2/(2*D)*0.5 %2*dimension
    t = 10
    
    numiters = 10/dt;
    dt = 10/ceil(numiters)
    
    startTime = 100;
    t_anal = startTime + t;
    
    
    
    for p = 1:length(parts)
        
        nParts = round(sqrt(parts(p)))^2;
        
        h = (uBounds-lBounds)/(nParts^(1/2)-1);
        epsilon = h;
        cutOff = 8*epsilon;
        
        partPos = createParticles(nParts, lBounds, uBounds);
        verletList = createVerletListnlogn(partPos, cutOff, lBounds, uBounds);
        partMat = [partPos zeros(size(partPos, 1), 1)]; 
        strengthDim = 3;
        V = ones(nParts,1)*h^2;
        
        matWidth = sqrt(length(partMat));
        initPos =  floor(0.5*matWidth)*matWidth + ceil(matWidth*0.5);
        
        initialConc = analyticalDiffusion(partMat(:,1:2), D, startTime, ...
                                             partMat(initPos, 1:2));
        partMat(:, strengthDim) = initialConc.*V;
        
        [X, Y] = meshgrid(1:matWidth);
        X = X*epsilon;
        Y = Y*epsilon;
        Z=reshape(partMat(:,strengthDim)./V,matWidth,matWidth);
        %v=[0 modelSize(1) 0 modelSize(2) 0 0.15];

        mesh(X,Y,Z)
        %axis(v);
        pause(0.2);
        
        %diffusion via PSE
        partMat = PSEDiffusion(partMat, V, D, dt, t, verletList, epsilon, strengthDim);
        
        fprintf('min of strengths: %e\n', min(partMat(:,3)./V(:)));
        minStrengths(p) = min(partMat(:,3));
        
        %figure(2);
        
        [X, Y] = meshgrid(1:matWidth);
        X = X*epsilon;
        Y = Y*epsilon;
        Z=reshape(partMat(:,strengthDim)./V,matWidth,matWidth);
        %v=[0 modelSize(1) 0 modelSize(2) 0 0.15];

        mesh(X,Y,Z)
        
        %determine analytical solution via greens function
        analyticalSoln = analyticalDiffusion(partMat(:,1:2), D, t_anal, ...
                                             partMat(initPos, 1:2));
       
        %hold on;
        [X, Y] = meshgrid(1:matWidth);
        X = X*epsilon;
        Y = Y*epsilon;
        Z=reshape(analyticalSoln,matWidth,matWidth);
        %v=[0 modelSize(1) 0 modelSize(2) 0 0.15];

        mesh(X,Y,Z)
        pause(0.1);
        
        %compare L2 and L_inf norms
        errors = partMat(:, strengthDim)./V - analyticalSoln;
         
        indices = find(abs(errors) >= max(abs(errors))*0.90);
        nParts
        partMat(indices, 1:3)
        
        N = length(errors);
        
        L2(p) = sqrt(sum(errors.^2)/N);
        Linf(p) = max(abs(errors));
        
        

    
    end
    
    figure(3);
    hold on;
    logParts = log10(parts)';
    logL2 = log10(L2);
    
    fitSel = 1:3;%1:length(parts);
    polyfit(logParts(fitSel), logL2(fitSel), 1)
    
    plot(logParts, logL2);
    logLinf = log10(Linf);
    plot(logParts, logLinf, 'r');
    
    plot(logParts,log10(parts.^-1),'k')
    legend('L2','Linf', 'Analytical slope of convergence');
    ylabel('log(E_R_M_S)');
    xlabel('log(N)');
    
    
    figure(4);
    hold on;
    logParts = log10(((uBounds-lBounds)./(parts.^(1/2)-1)).^(-1))';
    logL2 = log10(L2);
    
    fitSel = 1:7;%1:length(parts);
    
    pL2 = polyfit(logParts(fitSel), logL2(fitSel), 1)
    
    plot(logParts, logL2);
    logLinf = log10(Linf);
    plot(logParts, logLinf, '-r');
    
    f = polyval(pL2,logParts(fitSel));
    plot(logParts(fitSel),f,'*-b')
    
    plot(logParts,-2*logParts-7,'k')
    legend('L2','Linf', 'L2 fit', 'Analytical slope of convergence');
    ylabel('log(E_R_M_S)');
    xlabel('log(h)');
    
    
    figure(4);
    hold on;
    logParts = log10(((uBounds-lBounds)./(parts.^(1/2)-1)).^(-1))';
    logL2 = log10(L2);
    
    fitSel = 1:9;%1:length(parts);
    
    pL2 = polyfit(logParts(fitSel), logL2(fitSel), 1)
    
    plot(logParts(fitSel), logL2(fitSel));
    logLinf = log10(Linf);
    plot(logParts(fitSel), logLinf(fitSel), '-r');
    
    f = polyval(pL2,logParts(fitSel));
    plot(logParts(fitSel),f,'*-b')
    
    
    pLinf = polyfit(logParts(fitSel), logLinf(fitSel), 1)   
    f = polyval(pLinf,logParts(fitSel));
    plot(logParts(fitSel),f,'*-r')
    
    plot(logParts(fitSel),-2*logParts(fitSel)-10,'k')
    legend('L2','Linf', 'L2 fit', 'Linf fit','Analytical slope of N^{2} convergence');
    ylabel('log(E_R_M_S)');
    xlabel('log(1/h)');
    title('Convergence Curve of PSE Method in 2D');   
    
  
    
    figure(5);
    hold on;
    logParts = log10((uBounds-lBounds)./(parts.^(1/2)-1))';
    logL2 = log10(L2);
    
    fitSel = 1:5;%1:length(parts);
    
    pL2 = polyfit(1./logParts(fitSel), logL2(fitSel), 1)
    
    plot(1./logParts, logL2);
    logLinf = log10(Linf);
    plot(1./logParts, logLinf, '*-r');
    
    f = polyval(pL2,1./logParts(fitSel));
    plot(1./logParts(fitSel),f,'*-b')
    
    plot(1./logParts,log10(parts.^-(1.2)),'k')
    legend('L2','Linf', 'L2 fit', 'Analytical slope of convergence');
    ylabel('log(E_R_M_S)');
    xlabel('log(h)');
    
    
    
end

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