function p = pact(IPTG, ea, ei, epsilon)
%     Returns the probability of a repressor being in the active state as
%     described by the MWC model.
%     Parameters
%     ----------
%     IPTG : Concentration of inducer
%     ea, ei : inducer binding energies to the repressor in the active and
%     inactive state respectively
%     epsilon : energy difference between active and inactive state
    p = (1 + IPTG .* exp(-ea)).^2 ./ ...
    ((1 + IPTG .* exp(-ea)).^2 + exp(-epsilon) .* ...
    (1 + IPTG .* exp(-ei)).^2);
end %function