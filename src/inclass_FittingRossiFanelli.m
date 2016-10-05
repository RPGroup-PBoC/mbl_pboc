%We want to fit the data for O2 binding to myoglobin as a function of O2
%partial pressure from the Rossi-Fanelli paper.

%First, we load the data that was extracted using DigitizeIt. This data is
%saved as a CommaSeparatedValues file (CSV).
Data=csvread('RossiFanelli1958-fig2.csv');
%Note that data is a matrix. The first column corresponds to the O2 partial
%pressure values and the second column corresponds to pbound.
O2Data=Data(:,1);
pData=Data(:,2);

%Now plot the data
figure(1)
plot(O2Data,pData,'ok')
xlabel('O_2 partial pressure (mmHg)')
ylabel('p_{bound}')

%Let's fit the data to our prediction from the simple thermodynamic model:
%pbound=(L/Kd)/(1+L/Kd).
%First, we fit by eye using the fact that at L=Kd, pbound=0.5. By looking
%at the plot we guess a Kd=0.9 mmHg approximatelly.

%Define a set of O2 pressures for my prediction
O2Pred=linspace(0,6);       %Range between 0 and 6 mmHg
Kd=0.6818;                     %in mmHg
pboundPred=(O2Pred/Kd)./(1+(O2Pred/Kd));
hold on
plot(O2Pred,pboundPred,'-r')
hold off

%Second, minimize chi2, which is the sum of the square of the differences
%between the data and the prediction
%Recalculate the prediction not for O2Pred, but for the values from the
%data, O2Data
pboundPred=(O2Data/Kd)./(1+(O2Data/Kd));
%Get the difference between data and prediction for each value of O2Data
Differences2=(pboundPred-pData).^2;
chi2=sum(Differences2)

%Finally, we want to scan through a set of Kd values and find the minimum
%chi2.
%Define a range of Kd values to test
KdTest=linspace(0.5,1);
%Now, do a for-loop, where I calcualte chi2 for each value of Kd
for i=1:length(KdTest)
    %Calculate the predicted pbound values for this Kd
    pboundPred=(O2Data/KdTest(i))./(1+(O2Data/KdTest(i)));
    %Get the differences squared
    Differences2=(pboundPred-pData).^2;
    %Sum the differences to get the Kd
    chi2(i)=sum(Differences2);
end
%Plot chi2 vs Kd
figure(2)
plot(KdTest,chi2)
xlabel('Kd (mmHg)')
ylabel('chi^2')

%Get the Kd for which we got the minimum chi2
%The min function first gives the minimum value in the chi2 vector. The
%second output is the index corresponding to the minimum value in the chi2
%vector.
[MinValue,MinIndex]=min(chi2);  
%We don't care about the actual MinValue. We just care about the Kd
%corresponding to this value.
%MinIndex gives us the position along the chi2 vector where this minimum
%occurred.
KdTest(MinIndex)




    

    
    

    





































