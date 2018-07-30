function chiSq = residFunc(epValue)
 % Load the data. 
 data = readtable('data/lacZ_titration_data.csv');
 repressors = data.repressor;
 foldChange = data.fold_change;
 % Set up our counter for the sumSquares. 
 chiSq = 0;
 
 % Loop through each repressor value and compute the prediction. 
 for R=1:length(repressors)
     prediction = (1 + (repressors(R) / 5E6) * exp(-epValue))^-1;
     
     % Compute the difference
     chiSq = chiSq + (prediction - foldChange(R))^2;
 end

 end

