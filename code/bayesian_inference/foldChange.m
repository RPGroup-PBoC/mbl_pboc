function fc = foldChange(R, epsilonR)
% Computes the fold-change in gene expression as a function of the repressor
% copy number R and the binding energy epsilonR
% Parameters
% ----------
% R : array-like.
%     Array containing the repressor copy numbers to evaluate.
% epsilonR : array-like.
%     Array containing the binding energies to evaluate.
% Return
% ------
%fold-change : array-like.
%   theoretical fold-change for a simple repression architecture.

    fc = (1 + 2 * R ./ 4.6E6 .* exp(-epsilonR)).^-1;
end