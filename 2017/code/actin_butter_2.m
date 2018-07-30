% Define the parameters. 
r = 9; % in units of inverse time
gamma = 10; % in units of inverse time
dt = 1 / 50;  % small time step!
maxLength = 50;
totalTime = 5 / dt;

% Set up the storage matrix and initial condition.
pL = zeros(maxLength, totalTime);
pL(1,1) = 1.0; % Start with no filaments

% Loop through time. 
for t=2:totalTime
    % Compute the case when L=0
    pL(1, t) = pL(1, t-1) + gamma * dt * pL(2, t-1) - r * dt * pL(1, t-1);
    
    % Loop through all of the other boxes. 
    for L=2:(maxLength - 1)  % so we can ignore the end case. 
        pL(L, t) = pL(L, t-1) + r * dt * pL(L-1, t-1) + ...
            gamma * dt * pL(L+1, t-1) - r * dt * pL(L, t-1) -...
            gamma * dt * pL(L, t-1);
    end

end
% Plot it. 
bar3(pL(:,1:5:totalTime))
ylabel('length in monomers', 'FontSize', 14)
xlabel('time in time steps', 'FontSize', 14)
zlabel('$$P(L, t)$$', 'Interpreter', 'Latex', 'FontSize', 14)