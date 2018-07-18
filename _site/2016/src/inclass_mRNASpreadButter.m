%Simulation for spreading the butter

%Model parameters
r=3;            % 1/min
gamma=1/3;      % 1/min

%Simulation parameters
dt=0.01;        % min
Nmax=40;        % Maximum number of mRNAs we will calculate a probability for
TotalTime=40;    % min
%We create a time vector where each index will represent the a point in
%time using the ":" operator
Time=0:dt:TotalTime;
%Vector for the mRNA bins for the distribution
Bins=0:1:Nmax;

%Initialize my simulation matrix. Rows will correspond to time and columns
%will correspond to mRNA number. We use the function zeros to create this
%initial matrix
p=zeros(length(Time),length(Bins));

%Initial conditions
p(1,1)=1;

%Do the simulation by defining two for-loops. The first one will go over
%time with index i. The second one will go over mRNA number with index n.
for i=2:length(Time)        %For-loop over times
    %Calculate the probability for the zero bin    
    p(i,1)=p(i-1,1)-r*dt*p(i-1,1)+gamma*dt*p(i-1,2);
    
    %Calculate the probability for the 1 through Nmax-1 bins
    for n=2:(length(Bins)-1)
        p(i,n)=p(i-1,n)+r*dt*p(i-1,n-1)-r*dt*p(i-1,n)...
            +gamma*dt*n*p(i-1,n+1)-gamma*dt*(n-1)*p(i-1,n);
    end
    
    %Calculate the probability for the Nmax bin
    p(i,length(Bins))=p(i-1,length(Bins))+r*dt*p(i-1,length(Bins)-1)...
        -gamma*dt*Nmax*p(i-1,length(Bins));    
end

%Plot the distribution at the last time point using a bar graph
bar(Bins,p(length(Time),:))
xlabel('mRNA number')
ylabel('Probability')

%Check the distribution
%Normalization
sum(p(length(Time),:))
%To calculate the mean, we need to weight the number of mRNA by its
%probability
sum(p(length(Time),:).*Bins)


%Plot the distribution for different time points
% figure(2)
% for i=1:length(Time)
%     bar(Bins,p(i,:))
%     title(Time(i))     %Have the time in minutes as a title
%     ylim([0,1])         %Fix the limits of the y-axis
%     xlim([0,Nmax])
%     xlabel('Number of mRNA')
%     ylabel('Probability')
%     drawnow         %Force Matlab to actually display the plot
% end
% 

figure(3)
bar(Bins,p(length(Time),:))
hold on
plot(Bins,exp(-r/gamma)*(r/gamma).^Bins./factorial(Bins),'.-r',...
    'MarkerSize',20)
hold off
legend('Simulation','Poisson')
xlabel('mRNA number')
ylabel('Probability')












