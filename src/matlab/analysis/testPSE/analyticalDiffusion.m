function analyticalSoln = analyticalDiffusion(particlePos, D, t, ...
                                    initPosCoords)
    
    
    dim = size(particlePos,2);
    numParticles =size(particlePos,1);
    particleDists = sqrt(sum((particlePos-...
                              repmat(initPosCoords,numParticles, 1)).^2,2));
    analyticalSoln = greensFunc(particleDists, D, t, dim);
end

function analyticalSoln = greensFunc(partDists, D, t, dim)

    analyticalSoln = 1/((4*pi*D*t)^(dim/2))*exp(-(partDists.^2/(4*D*t)));
 
end


