function lnP = logPosterior(foldChangeExp, R, epsilonR)
% Parameters
% ----------
% foldChangeExp : array-like.
%     Array containing the experimental gene expression fold-change.
% R : array-like.
%     Array containing the repressor copy numbers to evaluate.
% epsilonR : array-like.
%     Array containing the binding energies to evaluate.
% Return
% ------
%fold-change : array-like.
%   theoretical fold-change for a simple repression architecture.
    
    % Compute theoretical fold-change for given parameter values
    foldChangeTheory = foldChange(R, epsilonR);
    
    % Calculate the residuals of experimental and theoretical predictions
    residuals = foldChangeExp - foldChangeTheory;

    % Compute the non-normalized log posterior probability 
    lnP = -length(foldChangeExp) ./ 2 .* log(sum(residuals.^2));

end