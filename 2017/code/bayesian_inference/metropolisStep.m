function [xOut, logpostUpdated, accepted] = metropolisStep(x, logPost,...
                                                       logpostCurrent,...
                                                       sigma)
%     Parameters
%     ----------
%     x : array, shape (n_variables)
%         The present location of the walker in parameter space.
%     logPost : function
%         The function to compute the log posterior.
%     logpostCurrent : float
%         The current value of the log posterior.
%     sigma : array, shape (n_variables)
%         The standard deviations for the proposal distribution.
%     Returns
%     -------
%     xOut : array, shape (n_variables)
%         The position of the walker after the Metropolis-Hastings
%         step. If no step is taken, returns the inputted `x`.
%     logPost_updated : float
%         The log posterior after the step.
%     accepted : bool
%         True is the proposal step was taken, False otherwise.

% Propose a new position for the walker sampling out of a Gaussian
% distribution centered at the current walker position with std sigma.
xNew = normrnd(x, sigma);

% Evaluate the logPosterior at the new proposed step
logpostNew = logPost(xNew);

% Compute log Metropolis ratio
log_r = logpostNew - logpostCurrent;

% Check if we accept step or not
if log_r > 0
    accepted = 1;
    logpostUpdated = logpostNew;
    xOut = xNew;
else
    % flip a coin to decide if accept the step or not based on the
    % value of the Metropolis ratio
    accepted = binornd(1, exp(log_r));
    if accepted == 1
        logpostUpdated = logpostNew;
        xOut = xNew;
    else
        logpostUpdated = logpostCurrent;
        xOut = x;
        
    end % if
    
end % if

end % function