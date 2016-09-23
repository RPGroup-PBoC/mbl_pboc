% Define values for the energies
d_eb = -5; % kBT
d_ei = -2; % kBT

% Define the range of concentrations for the plot
L = logspace(-4, -1, 1000); % Molar

% Compute Z, aka the partition function
Z = 1 + 2 * L .* exp(-d_eb) + L.^2 .* exp(-(2 * d_eb + d_ei));

% Compute the probabilities of each state
p0 = 1 ./ Z; % empty state
p1 = L .* exp(-d_eb) ./ Z; % one ligand bound
p2 = L.^2 .* exp(-(2 * d_eb + d_ei)) ./ Z; % two ligands bound

% Plot the probabilities of each of the states as a function of
% ligand concentration
semilogx(L, p0, 'LineWidth', 1.5);
hold on
semilogx(L, 2 * p1, 'LineWidth', 1.5); % multiplied by 2 to account
                                       % for both states singly bound
semilogx(L, p2, 'LineWidth', 1.5);

% Now let's pimp the plot
xlabel('ligand concentration (M)')
ylabel('probability')
legend('Empty', 'Singly bound', 'Doubly bound', 'Location', 'east')
hold off
 %%
 
 % Let's repeat the plot for higher cooperativity
 % Define values for the energies
d_eb = -5; % kBT
d_ei = -10; % kBT

% Define the range of concentrations for the plot
L = logspace(-7, -1, 1000); % Molar

% Compute Z, aka the partition function
Z = 1 + 2 * L .* exp(-d_eb) + L.^2 .* exp(-(2 * d_eb + d_ei));

% Compute the probabilities of each state
p0 = 1 ./ Z; % empty state
p1 = L .* exp(-d_eb) ./ Z; % one ligand bound
p2 = L.^2 .* exp(-(2 * d_eb + d_ei)) ./ Z; % two ligands bound

% Plot the probabilities of each of the states as a function of
% ligand concentration
semilogx(L, p0, 'LineWidth', 1.5);
hold on
semilogx(L, 2 * p1, 'LineWidth', 1.5); % multiplied by 2 to account
                                       % for both states singly bound
semilogx(L, p2, 'LineWidth', 1.5);

% Now let's pimp the plot
xlabel('ligand concentration (M)')
ylabel('probability')
legend('Empty', 'Singly bound', 'Doubly bound', 'Location', 'east')
hold off

%%