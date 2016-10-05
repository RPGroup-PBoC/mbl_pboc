%Simulate the dilution experiment to calibrate fluroescent proteins

%Model parameters
alpha=50;       %Calibration factor, in units of intensity per molecule
NCells=100;     %Number of mother cells we will simulate 

for Nmother=1:2000
    %Create a for-loop that goes through each cell repeat for a given value of
    %Nmother
    for j=1:NCells
        %Now, we need to decide where each one of these molecules goes.
        %Create counters N1 and N2 where we will store the number of molecules that
        %went to each cell
        N1=0;
        N2=0;
        %Create a for-loop that goes through each molecule within the mother cell.
        for i=1:Nmother
           RandomNumber=rand;
           if RandomNumber>0.5  %Molecule went to cell number 1
               N1=N1+1;
           else                 %Molecule went to cell number 2
               N2=N2+1;
           end
        end
        %Save the difference in partitioning in a vector that moves over the
        %different cells we simulated (j).
        N1minusN2(j,Nmother)=N1-N2;
    end
end    

%Calculate the intensities
I1minusI2=alpha*N1minusN2;  %Error in partitioning of intensity
Imother=alpha*(1:2000);     %Intensity of the mother cell
%Now, calculate the average intensity error in partitioning given a value
%of Imother. First, get the square of the partitioning error.
I1minusI2Squared=I1minusI2.^2;
%This matrix runs along the different initial values of Nmother on its
%columns. Each row corresponds to a repeat given an Nmother value.
%To get the mean, we can actually use the function "mean". Note that, like
%"sum", this function operates on the rows. As a result, if we take the man
%of our matrix we will average over the different repeats for a give
%Nmother value.
MeanI1minusI2Squared=mean(I1minusI2Squared);
%Make the plot
plot(Imother,MeanI1minusI2Squared,'o')
xlabel('I_{mother}')
ylabel('<(I_1-I_2)^2>')
%Finally, we calculate the value of alpha by fitting our data to a line. We
%use polyfit to fit to a polynomial of degree 1 (a line)
FitResult=polyfit(Imother,MeanI1minusI2Squared,1)
%The first output of polyfit is the slope, the scond output is the
%y-intercept.
%Plot our fit on top of the simulated data
hold on
plot(Imother,Imother*FitResult(1),'-r')
hold off

















    



