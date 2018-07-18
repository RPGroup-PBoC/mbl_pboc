function fc = inClassFoldChange(c, ea, ei, R, epsilonR, epsilonAI)

pactive = (1 + c .* exp(-ea)).^2 ./ ((1 + c .* exp(-ea)).^2 + ...
                   (1 + c .* exp(-ei)).^2 .* exp(-epsilonAI));

fc = 1 ./ (1 + pactive .* 2 .* R ./ 4.6E6 .* exp(-epsilonR));
end