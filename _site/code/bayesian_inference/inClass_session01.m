% Read data
df = readtable('flow_master.csv');
df(1:5, :)

%%
% extract the data from a single strain
O2Rows = strcmp(df.operator, 'O2');
dfO2 = df(O2Rows, :);

%%
% Extract data from strain with repressor = 130 and operator = O2
O2R130Rows = strcmp(df.operator, 'O2') & df.repressors == 130;
dfFit = df(O2R130Rows, :);
dfFit(1:5, :)

semilogx(dfFit.IPTG_uM, dfFit.fold_change_A, 'o')
xlabel('IPTG (\mu M)')
ylabel('fold-change')

%%
% testing the fold-change function
R = 130; % repressors per cell
epsilonR = -13.9; % kBT
ea = 5; % kBT
ei = -1; % kBT
epsilonAI = 4.5; % kBT

cArray = logspace(-1, 4, 100); % µM

% Compute theoretical fold-change
fcThry = inClassFoldChange(cArray, ea, ei, R, epsilonR, epsilonAI);

% Plot the fold-change
semilogx(cArray, fcThry, 'Linewidth', 1.5)
xlabel('IPTG (\mu M)')
ylabel('fold-change')

%%
% Test the log posterior function
indepVar = table2array(dfFit(:,...
            {'IPTG_uM', 'repressors', 'binding_energy'}));
foldChangeExp = table2array(dfFit(:, 'fold_change_A'));

%%
% Create a grid of values to evaluate posterior
ea = linspace(4, 6, 100); % kBT
ei = linspace(-.3, -.9, 100); % kBT

[ea_grid, ei_grid] = meshgrid(ea, ei);

% compute log posterior with nested for loops

% initialize matrix to save log posterior
logPosterior = zeros(size(ea_grid));

for i=1:length(ea)
    for j=1:length(ei)
        logPosterior(i,j) = inClassLogPost([ea_grid(i,i), ei_grid(i,j)],...
                                            indepVar, foldChangeExp);
    end %for 2
end %for 1

logPosterior = logPosterior - max(logPosterior(:));
%%
% Plot the resulting log posterior
contourf(ea, ei, exp(logPosterior))
xlabel('\Delta \epsilon_A')
ylabel('\Delta \epsilon_I')
title('Posterior probability, O2 - R = 130')



