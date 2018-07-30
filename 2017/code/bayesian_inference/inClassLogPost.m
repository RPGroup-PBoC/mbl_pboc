function logPost = inClassLogPost(param, indepVar, foldChangeExp)
% Unpack parameters
ea = param(1);
ei = param(2);

% Unpack independent variables
IPTG = indepVar(:, 1);
R = indepVar(:, 2);
epsilonR = indepVar(:, 3);

% Compute theoretical fold change
foldChangeThry = inClassFoldChange(IPTG, ea, ei, R, epsilonR, 4.5);

% Compute residuals
resid = foldChangeExp - foldChangeThry;

logPost = -length(foldChangeExp) ./ 2 .* log(sum(resid.^2));

end