function fc = fold_change(IPTG, ea, ei, R, epsilon_r, epsilon)
%     Returns the fold-change in gene expression for a simple-repression
%     architecture.
%     Parameters
%     ----------
%     IPTG : Concentration of inducer
%     ea, ei : inducer binding energies to the repressor in the active and
%     inactive state respectively
%     epsilon : energy difference between active and inactive state
%     R : repressor copy number
%     epsilon_r : binding energy of the repressor to the DNA
    
    fc = 1 ./ (1 + pact(IPTG, ea, ei, epsilon) .* ...
              (2 .* R) ./ 4.6E6 .* exp(-epsilon_r));
end