function [meanVal, semVal] = bootstrapSample(dist)
% Performs 1E6 bootstrap samples over the given distribution
nSamples = 1 * 10^5;
samples = [];
for i=1:nSamples
    samples(i) = mean(randsample(dist, length(dist), true));
end

% Compute the mean and standard error. 
meanVal = mean(samples);
semVal = std(samples) / sqrt(length(samples));
end
