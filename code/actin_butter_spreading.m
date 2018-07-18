% Define the parameters.
r = 9;
gamma = 10;
dt = 1 / 50;
maxLength = 100;
totalTime = 50;
timeSteps = totalTime / dt;

% Set up the storage matrix. 
pL= zeros(timeSteps, maxLength);

% Set the initial condition. 
pL(1, 1) = 1.0;   % Start with no filaments. 

% Loop through each time step. 
for t=2:timeSteps
    % Compute the edge case. 
    pL(t, 1) =  pL(t-1,1) + gamma * dt * pL(t-1, 2) -...
        r * dt * pL(t-1, 1);

    
    % Loop through all the other lengths. 
    for b=2:maxLength - 1
        pL(t, b) = pL(t-1, b) + r * dt * pL(t-1, b-1) +...
            gamma * dt * pL(t-1,b+1) - r * dt * pL(t-1, b) -...
            gamma * dt * pL(t-1, b);
    end
end

% Plot it as a three dimensional bar plot. 
bar3(pL(:, 1:20:maxLength));
xlabel('time (steps)')
ylabel('length (monomers)')


% WE can also just look at the first two time points and the last. 
bins = linspace(0, maxLength, maxLength);
bar(bins, pL(timeSteps, :));
hold on

% Plot the predicted curve
L = linspace(0, maxLength, 1000);
dist = (1 - (r / gamma)) * (r / gamma) .^ L;
plot(L, dist, 'r-')
hold off