% Define variables for simulation

% Initial condition
N0 = 1; %cell

% Growth rate
r = 1 / 30; %min^-1

% Time step
deltaT = 15; %min

% Compute the first time point manually
N1 = N0 + r * deltaT * N0;

% Initialize array for saving number of cells
N(1) = N0;
Nlarge(1) = N0;

% Use a for loop to update number of cells
for i=2:1:50
    N(i) = N(i-1) + r * deltaT * N(i-1);
    Nlarge(i) = Nlarge(i-1) + r * 45 * Nlarge(i-1);
end %for

% Define a time array
time = [0:49] * deltaT;
timelarge = [0:49] * 45;

semilogy(time, N)
hold on
semilogy(timelarge, Nlarge, '.')

ylabel('number of cells')
xlabel('time (min)')
legend('N', 'Nlarge')