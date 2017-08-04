%Let's simulate a stochastic process of birth and death of mRNAs

%Model parameters
r=3;        %1/min
gamma=1/3;  %1/min/mRNA
%Simulation parameters
dt=0.005;           %min
TotalTime=40;        %min, we choose to be larger than 1/gamma
Time=0:dt:TotalTime;%min
%Initial condition
m(1)=0;

%Start the simulation
for i=2:length(Time)    %Move through all time points
    Coin=rand;          %Flip our random coin, which we will turn into a
                        %biased, three-sided coin
    %Decide which trajectory to take given the coin flip
    if Coin<r*dt  %Production of one mRNA
        m(i)=m(i-1)+1;
    elseif Coin<(r*dt+m(i-1)*gamma*dt) %Degradation event
                                       %elseif is only invoked if the
                                       %previous if-stament was not true
        m(i)=m(i-1)-1;
    else        %Nothing happened. Note that this else is only executed
                %if the two previous if-statements were not true
        m(i)=m(i-1);
    end
end

%Plot the stochastic simulation
figure(1)
plot(Time,m,'-')
xlabel('Time (min)')
ylabel('mRNA number')

%We want to figure out the progression of events in our
%simulation: when do we have production, degradation,
%or nothing happening.
%If we calculate the difference between contiguous time points in
%our vector m, we will get +1 for production, -1 for degradation,
%and 0 for nothing.
Events=diff(m);
%Plot the events as a function of time
figure(2)
plot(Time(1:end-1),Events,'.-')

%Plot a histogram of the events
hist(Events)





















