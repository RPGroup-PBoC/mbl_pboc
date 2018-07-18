%Simulate mRNA birth and death using the Gillespie algorithm

%Model parameters
r=3;        %1/min
gamma=1/3;  %1/min/mRNA
%Simulation parameters
TotalReactions=100; %Total number of events we want to simulate
Time=0;     %This initializes a vector where we will keep track of time
%Initial condition
m(1)=0;

for i=2:TotalReactions  %Repeat the loop TotalReactions times
    %First, get the probabilities per unit time corresponding to
    %this time point
    k1=r;   %Production event
    k2=gamma*m(i-1);    %Degradation event
    k0=k1+k2;
    %Get a random number to decide on the DeltaT to the next
    %reaction
    Coin1=rand;
    %Weight this uniformly distributed random number using an
    %exponential distribution
    DeltaT=1/k0*log(1/Coin1);
    %Add this DeltaT to the time of the previous event to get the
    %time of the current event
    Time(i)=DeltaT+Time(i-1);
    
    %Second, flip a new coin to decide which event will happen
    Coin2=rand;
    if Coin2<k1/k0      %Production event
        m(i)=m(i-1)+1;
    else                %Degradation event
        m(i)=m(i-1)-1;
    end
end

plot(Time,m,'.')
xlabel('Time (min)')
ylabel('mRNA number')










