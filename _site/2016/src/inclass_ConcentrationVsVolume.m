% When we want to write comments, we need to begin the line with a
% percentage sign

1+1         %I can add an inline comment as well

%Save a number in a variable
a=10;           %Note that the ; suppresses the output
%Operate on a
a*2

%Define an array
b=[5,3,8,1,3,2,6]
%Operate on a vector
b*2
b-5


%Make a plot of the number of molecules @ 1nM as a function of the cell
%volume

%To begin, we need to define a set of x values that we will use for the
%plot
Volumes=[0.1,1,10,100,1000,10000,10^5];     %In in um^3
NumberOfMolecules=Volumes;                  %Assuming volume is in um^3

%Generate the graph using the function plot. This function takes as inputs
%vectors for the X and Y values
plot(Volumes,NumberOfMolecules)
%Show us the dots connected by lines
plot(Volumes,NumberOfMolecules,'.-')  %'.-' plots dots connected by lines
%Plot this on log-log axes
loglog(Volumes,NumberOfMolecules,'.-')
%Now, add labels
xlabel('Volume (\mum^3)')     %Note that strings (text) need to be
                            %surrounded by apostrophes
ylabel('Number in 1nM')
































