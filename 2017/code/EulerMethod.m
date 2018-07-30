% using Matlab

% what is matlab
2+2

% define a variable
b = 6
c = 8;

% can look at vectors and matrices of numbers
d = [1 2 5 7]
d2 = [0:4:20]

% look at a specific value
d2(4)

% use the Euler method to predict the number of cells
% over time

% define some constants and initial values
N1 = 1; % start with 1 cells at t0
r = 1/30; % rate constant of cell growth in 1/min

dN_dt = N1 * r;
dt = 30; %time in min

% calculate the number of cells after 30 minutes
N2 = N1 + dN_dt * dt

% how to write a loop
% write a loop

% add up the square of the numbers 1 to 5
1^2 + 2^2 + 3^2 + 4^2 + 5^2

% is there a faster way to do the same calculation over and over?
squared = [];
for n = 1:5
    squared(n) = n^2;
end

squared
sum(squared)

% write a loop that keeps calculating the new number
% of cells
dt = 1; % 1 min

% define a vector N to keep track of how many cells
N = [];
N(1) = 1;

for t = 2:500
    N(t) = N(t-1) + N(t-1)*r * dt;
end

% define a vector of time
time = [1:1:500];

% make a plot
plot(time,N)
xlabel('time (min)')
ylabel('number of cells')



