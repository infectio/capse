function rand_seed()
%RAND_SEED Reseed random stream.
%   Reset the pseudorandom stream (to make simulation results unique).
reset(RandStream.getDefaultStream, sum(100*clock));
end

