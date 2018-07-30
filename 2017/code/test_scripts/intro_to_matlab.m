% Intro to MATLAB

% Of course, this can be used as a calculator.
2 + 2  % This will evaluate to 4
2 + 2; % This will suppres output. 


% We can assign values to variables. 
a = 2;
b = 4;
a * b % This should print 8.

% WE can set up lists and matrices. 
test_list = [1, 2, 3, 5, 7];
auto_list = [0:5:20];  % Range from 0 to 20 taking steps of 5
auto_list = 0:5:20; % Brackets are not needed. 

% We can set up multidimensional arrays. 
twoDimensions = [1, 2, 3; 4, 5, 6;7, 8 9;];  % Generates 2d matrix

% We can query individual positions in all of these arrays and
% lists.
test_list(3) % Should be 3 -- Matlab indexes at 1
auto_list(2:5) % Take values starting at 2 ending at 5
twoDimensions(3, 1)  % Gives value at row 3, column 1


%%
% Now do a numerical integration

% start with one cell at the first time point. 
n0 = 1; 

% Set the rate constant for cell growth in units of inverse min. 
r = 1/30;

% Set the time step in units of min. 
dt = 5; 

% Set the maxiumum number of time points to examine. 
totalTime = 600 / dt;

% Set up an empty list with our initial condition. 
n_t = [];
n_t(1) = n0;

% Loop through the second time point up to our maximum and perform the
% integration. 
for t = 2:totalTime
    n_t(t) = n_t(t-1) + n_t(t-1) * r * dt;
end

% plot the result. 
time = 1:1:totalTime;
semilogy(time, n_t, 'o-')
xlabel('time (min)')
ylabel('number of cells')



% Loop o