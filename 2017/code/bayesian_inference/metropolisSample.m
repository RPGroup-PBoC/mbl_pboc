function output = metropolisSample(logPost, x0, sigma, nBurn, nSteps)
%     Parameters
%     ----------
%     logPost : function
%         The function to compute the log posterior. It has call
%         signature `logPost(x)`.
%     x0 : array, shape (n_variables)
%         The starting location of a walker in parameter space.
%     sigma : array, shape (n_variables)
%         The standard deviations for the proposal distribution.
%     nBurn : int
%         Number of burn-in steps.
%     nSteps : int
%         Number of steps to take after burn-in.
%     
%     Returns
%     -------
%     output : array
%         The first `n_variables` columns contain the samples.
%         Additionally, column 'lnprob' has the log posterior value
%         at each sample.

% Initialize array to save output
output = zeros(nSteps, 2);

% Initialize walker position
xOut = x0;
% Initialize value of the logPost probability
logpostCurrent = logPost(x0);

% Perform burn-in
for i=1:nBurn
    [xOut, logpostCurrent, accepted] = metropolisStep(xOut, logPost,...
                                                  logpostCurrent, sigma);
end % for

% Perform the real MCMC samples
for j=1:nSteps
    [xOut, logpostCurrent, accepted] = metropolisStep(xOut, logPost,...
                                                  logpostCurrent, sigma);
    % Save walker position at each step
    output(j, :) = [xOut, logpostCurrent];
end % for

end