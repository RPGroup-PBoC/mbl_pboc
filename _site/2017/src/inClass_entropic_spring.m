% Define variables for plotting the free energy
a = 1; % in Rob's favorite arbitrary units
N = 1000; % Number of segments in the chain

% Define array containing all possible length values
nArray = 1:N - 1;

% Choose different values for "mg" == force
force = [1, 2.5, 5]; % in kBT units


%%

% Initialize value to save the free energy values
% NOTE: We use N + 1 because we have to consider zero!
freeEnergy = zeros(length(force), N - 1);

% Loop through energies computing the free energy
for f=1:length(force)
    % Compute the free energy
    freeEnergy(f, :) = - force(f) .* (2 .* nArray - N) .* a...
        - (N .* log(N) - nArray .* log(nArray)...
        - (N - nArray) .* log(N - nArray));
end %for

%%

plot(nArray, freeEnergy, 'LineWidth', 1.5)
xlabel('n_R')
ylabel('free energy')
legend(force)