% Read the data frame containing experimental fold-change measurements
df = readtable('Garcia2011_AbsoluteSinglelacZ_wFC.csv');
df(1:5, {'operator', 'repressors', 'fold_change'})

%%
% Extract the data for O2
O2Rows = strcmp(df.operator, 'O2') & (df.repressors > 0);

% Use boolean array to extract data
dfO2 = df(O2Rows, {'operator', 'repressors', 'fold_change'});
dfO2(1:5, :)

%%
% Plot the raw data for O2
loglog(dfO2.repressors, dfO2.fold_change, 'o', 'Linewidth', 1.5)
xlabel('repressors per cell')
ylabel('fold-change')

%%
% Group by repressor copy number and compute mean and std of fold-change
statsO2 = grpstats(dfO2, 'repressors', {'mean', 'std'},...
    'DataVars', 'fold_change')
%%
% Plot the data with mean and error bars
errorbar(statsO2.repressors, statsO2.mean_fold_change,...
         statsO2.std_fold_change, 'ko', 'Linewidth', 1.5)
set(gca, 'xscale', 'log')
set(gca, 'yscale', 'log')
xlabel('repressors per cell')
ylabel('fold-change')

%%
% Group by two categories: operator and repressor copy numeber
% Then compute mean and std of fold change
statsOperator = grpstats(df, {'operator', 'repressors'}, {'mean', 'std'},...
    'DataVars', 'fold_change')

%%
operators = unique(statsOperator.operator);

figure
hold on
for i=1:length(operators)
    % Extract the rows for the operator
    opRows = strcmp(statsOperator.operator, operators(i));
    % Extract mean and std of fold change for this operator
    opData = statsOperator(opRows, :);
    % Plot repressor copy number vs fold-change
    errorbar(opData.repressors, opData.mean_fold_change,...
         opData.std_fold_change, 'o', 'Linewidth', 1.5)
end %for
set(gca, 'xscale', 'log')
set(gca, 'yscale', 'log')
xlabel('repressors per cell')
ylabel('fold-change')
legend(operators, 'Location', 'southwest')
hold off

%%
% Plot the posterior probability of the binding energy

% Define a grid of binding energies
epsilonR = linspace(-14.2, -13.6, 500);

% Initialize array to save log posterior probability
logP = zeros(size(epsilonR));

% For loop to compute log posterior for each value in the grid
for i=1:length(epsilonR)
    logP(i) = logPosteriorGarcia(dfO2.fold_change,2 * dfO2.repressors,...
                                 epsilonR(i));
end %for

plot(epsilonR, exp(logP))
xlabel('\Delta \epsilon_r')
ylabel('P(\Delta \epsilon_r \mid D)')

%%
% Find the most probable value for the binding energy and evaluate the
% second derivative at this point to compute the error bar.

% Build anonymous function to feed to optimization routine
minFun = @(epsilonR) -logPosteriorGarcia(dfO2.fold_change,...
                                          2 * dfO2.repressors, epsilonR);

p0 = -13.9;                                      
[popt, fval, exitflag, output, lambda, grad, hessian] = fmincon(minFun,p0);