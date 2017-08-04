% Define variables for simulation

% Initial condition
m0 = 0; %mRNA
m0_2 = 100 %mRNA
% production rate
r = 3; %min^-1

% degradation rate
gamma = 1 / 3; %min^-1

% Time step
deltaT = 0.05; %min

% Initialize array for saving number of mRNA
m(1) = m0;
m_02(1) = m0_2

% Use a for loop to update number of cells
for i=2:1:500
    m(i) = m(i-1) + r * deltaT - gamma * deltaT * m(i-1);
    m_2(i) = m_2(i-1) + r * deltaT - gamma * deltaT * m_2(i-1);
end %for

% Define a time array
time = [0:499] * deltaT;

plot(time, m)

ylabel('number of mRNA')
xlabel('time (min)')