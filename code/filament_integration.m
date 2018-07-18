% Define the parameters. 
r = 9; % in dimensions of inverse time.
gamma = 10; % in dimensions of inverse time.
maxLength = 100;  % in units of monomers. 
totalTime = 50; % in units of time. 
dt = 1/50; % in dimensions of time. 
timeSteps = totalTime / dt; % in units of time steps

% Set up the storage matrix. 
P = zeros(maxLength,timeSteps); %Dimensionless!

%Set the initial condition. 
P(40,1) = 1.0; 

% Loop over all of the time steps. 
for t=2:timeSteps

    % Compute the boundary condition at L = 0. 
    P(1, t) = P(1, t-1) + gamma * dt * P(2, t-1) - r * dt * P(1, t-1);
    
    for L=2:(maxLength - 1)
        P(L, t) = P(L, t-1) + r * dt * P(L-1, t-1) + gamma * dt * P(L+1,t-1)...
            - P(L, t-1) * dt * (r + gamma);
    end 
end

% Plot as a 3D bar plot. 
bar3(P(:, 1:70:timeSteps)); 
xlabel('time steps x 70');
ylabel('length in monomers');
zlabel('P(L, t)');



% Plot the steady state distribution. 
bins = 0:1:maxLength - 1; 
bar(bins, P(:, timeSteps));
xlabel('length');
ylabel('probability');




