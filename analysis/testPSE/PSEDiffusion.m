function partMat = PSEDiffusion(partMat, V, D, dt, t, verletList, ...
                                epsilon, strengthDim)

    for timeStep = dt:dt:t
    
        
        %apply the diffusion step with PSE
        pseSum = applyPSE(partMat,verletList,epsilon,strengthDim);

        %apply the time step for particle strengths
        partMat(:,strengthDim) = partMat(:,strengthDim) + V(:).*D*dt./epsilon^2 ...
            .* pseSum(:);
    

    
    end
end