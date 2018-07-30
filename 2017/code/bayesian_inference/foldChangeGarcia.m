function fc = foldChangeGarcia(R, epsilonR)

fc = (1 + R ./ 4.6E6 .* exp(-epsilonR)).^-1;

end