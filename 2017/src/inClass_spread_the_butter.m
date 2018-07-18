% Define parameters for spreading the butter
k = 5; % Jump frequency in inverse seconds.
dt = 1 / 50; % Time step sufficiently smaller than the inverse jump freq
numBoxes = 10; % Total number of lattice sites
timeSteps = 100; % total number of steps for the simulation

%%

% Initialize matrix to save the distribution over time
prob = zeros(numBoxes, timeSteps);

% For the first time point let's initialize the distribution
initialPosition = round(numBoxes / 2);
prob(initialPosition, 1) = 1;

% initialize time array
timeArray = 0;

%%

% Loop through time
for t=2:timeSteps
    % Handle the case for the left edge
    prob(1, t) = prob(1, t-1) + k * dt * prob(1 + 1, t-1)...
                 - k * dt * prob(1 , t-1);
             
    % Handle the case for the right edge
    prob(end, t) = prob(end, t-1) + k * dt * prob(end - 1, t-1)...
                    - k * dt * prob(end, t-1);
                
    % Loop through the rest of positions
    for n=2:numBoxes - 1
        prob(n, t) = prob(n, t-1) + k * dt * prob(n-1, t-1)...
                     + k * dt * prob(n+1, t-1)...
                     - 2 * k * dt * prob(n, t-1);
    end %for2
    
    timeArray(t) = (t - 1) * dt;
    
end %for1

%%

% Plot the first time point
bar(1:numBoxes, prob(:, end))

%%

% initialize a figure
figure()

% loop through all the time points
for t=1:timeSteps
    bar(1:numBoxes, prob(:, t))
    xlabel('position')
    ylabel('probability')
    ylim([0, 1])
    pause(0.05)
end %for









