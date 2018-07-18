%Testing the French Flag model

%Plot the predictions

%Parameters (measured previously and independently)
lambda=16.5;        % Bicoid gradient decay length
                    %(percentage of embryo length
xCF=34.2;           % Original position of the CF


%Create a range of D values for my prediction
D=linspace(0.1,10);
%Plot the prediction
semilogx(D,xCF+lambda*log(D),'-k')
xlabel('dosage')
ylabel('cephalic furrow position')

%Load the data from Liu2013. This is provided as a Comma Separated Values
%document (CSV)
Data=csvread('Liu2013CFMeasurements.csv');
%Data is a matrix with two columns. The first column corresponds to the
%dosage of the fly line. The secound column corresponds to the CF position.
hold on
plot(Data(:,1),Data(:,2),'.r')
hold off
xlim([0.3,4])







