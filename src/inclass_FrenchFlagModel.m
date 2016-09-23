%Plot the prediction for the CF position (xNew) as a function of Bicoid
%dosage (D)

%Start by defining the range of D values we're going to calculate the
%prediction for
%We could do
D=[0.5,1,2];
%However, let's create a set of numbers between reasonable bounds using
%linspace
D=linspace(0.3,5);  %Create 100 equally spaced points between 0.3 and 5

%Define the model parameters
xCF=0.32;           %Fraction of the embryo at which the WT CF shows up
lambda=0.19;        %Bicoid decay length in units of fraction of embryo length

%Calculate xNew
xNew=xCF+lambda*log(D);
%Plot it
semilogx(D,xNew,'-r')
xlabel('Dosage')
ylabel('xNew')


%Now analyze the data so we can test our model
%Load an image of a 1x embryo
Embryo=imread('1xBcd.tif');
imshow(Embryo)

%Strategy for finding the CF: We're going to click along the ventral side
%in order to measure the total length of the embryo and the length from the
%anterior end to the CF.

%We can record clicks on an image using ginput. By calling ginput, you can
%click as many times as you want on the plot. When you're done, you press
%enter. We'll keep track of the click corresponding to the CF.
%Clicks=ginput;     %Note that we comment this line out after we run the
                    %script for the first time in order to avoid having to
                    %click again
CFClick=10;     %The click corresponding to the CF

%See how good of a job we did at tracing the contour of the embryo by
%overlaying the image with a plot of the clicks
%First, extract the x and y values from Clicks
xClicks=Clicks(:,1);        %All rows in the first column of Clicks
yClicks=Clicks(:,2);        %All rows in the second column of Clicks
%Now, make the plots
hold on
plot(xClicks,yClicks,'.-r')
hold off


%Calculate the length of each segment
%First, create "Delta" vectors that have, for example,
%DeltaX=[x2-x1,x3-x2,...]
%This can be done using the diff function
DeltaX=diff(xClicks);
DeltaY=diff(yClicks);
%Second, calculate the square of each Delta element. Note that we need to
%raise to the power of 2 in an element-wise fashion by using the "."
%operator
DeltaX2=DeltaX.^2;
DeltaY2=DeltaY.^2;
%Third, add DeltaX2 and DeltaY2
SquareLengths=DeltaX2+DeltaY2;
%Finally, take the square root
Lengths=sqrt(SquareLengths);

%Calculate the total axis length by summing over all elements of Lengths
LengthEmbryo=sum(Lengths);
%Calculate the length until the CF by adding Lengths from 1 to CFClick-1
LengthCF=sum(Lengths(1:CFClick-1));
%Get the CF position with respect to the total length of the embryo
LengthCF/LengthEmbryo


%We got the data for the different dosages
DData=[0.5,1,2];
xNewData=[0.25,0.32,0.36];

%Plot the prediction
semilogx(D,xNew,'-r')
xlabel('Dosage')
ylabel('xNew')
hold on
plot(DData,xNewData,'.k','MarkerSize',20)
hold off








































