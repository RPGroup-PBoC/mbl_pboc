%% Load one of the embryo images
Embryo=imread('2xBcd.tif'); %put the name of the image file here
%Display it
imshow(Embryo)


%% Find where you click using ginput. 
%If you do ginput(N), it will allow you
%to click N times. Otherwise, you can click until you press ENTER
ginput %it returns a list of x,y pairs
%IMPORTANT: comment ginput out before continuing with the script

%% Click along the periphery of the embryo. 
% Remember which click corresponded to the CF. Save the information in the matrix Clicks
Clicks=ginput;     %Comments this out once you're satisfied with your
                    %clicks
NCF=10;             %The click corresponding to the CF. This will be
                    %user-dependent

%% Overlay our clicks with the image
hold on         %Tell Matlab to not delete the previous figure
%To make a plot, we need to create a vector out of the matrix Clicks that
%has a list of either the x or y values.
xClicks=Clicks(:,1);
yClicks=Clicks(:,2);
plot(xClicks,yClicks,'r-o')  %Dots connected by lines, in red
plot(xClicks(NCF),yClicks(NCF),'bo','MarkerFaceColor','b','MarkerSize',10) % a big blue circe for the CF position
hold off
%% Length of each segment: Pitagoras
%Next, we want to calculate the length of each one of the segments we
%clicked on
%First, calculate the DeltaX and DeltaY using diff, which takes the
%difference between consecutive elements in a vector
DeltaX=diff(xClicks);
DeltaY=diff(yClicks);

%Second, square each vector. Note that we need to tell Matlab to perform
%the "^" operation in an elementwise fashion by using the command ".^".
DeltaX2=DeltaX.^2;
DeltaY2=DeltaY.^2;
%Third, sum the DeltaX^2 and DeltaY^2 together
Length2=DeltaX2+DeltaY2;
%Finally, take the square root
Lengths=sqrt(Length2);

%Now, let's see the total length of the AP axis in pixels
APLength=sum(Lengths)
%Get the length until the CF
CFLength=sum(Lengths(1:NCF-1))
xNew=CFLength/APLength

%% Plot the prediction
%First, make a vector of dosages with numbers equally spaced between 0.3 and 3
Drange=linspace(0.3,3);     %Create a vector with 100 points equally
                            %spaced between the two bounds
                            
%Parameters, in fraction of AP axis
xCF=0.32;                            
lambda=0.19;
%Plot the prediction equation
semilogx(Drange,xCF+lambda*log(Drange),'-k')

%Create vectors with the data to plot on top of prediction
Ddata=[1,0.5, 0.5, 2];
CFdata = [0.3240,0.25, 0.179, 0.349]; %populate this with students' data

hold on
plot(Ddata,CFdata,'or')
hold off
legend('Prediction','Experimental measurements')

                            

















