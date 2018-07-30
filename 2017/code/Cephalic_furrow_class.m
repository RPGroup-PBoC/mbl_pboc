% a=10
% b=2
% c=a+b

Embryo = imread('1xBcd.tif'); %open an image
imshow(Embryo); %show the image

%Clicks = ginput; %ginput asks the user to pick points in the image

NCF = 5; %which click corresponds to the cephalic furrow

hold on %don't close the previous figure

xClicks = Clicks(:,1); %first dimension is rows, second is columns. semicolon is to get all
yClicks = Clicks(:,2);

%plot(xClicks,yClicks)

hold off

DeltaX = diff(xClicks); %diff gets the difference between to consecutive values in a vector
DeltaY = diff(yClicks);

%now, take the power 2 of each value
DeltaX2 = DeltaX.^2;
DeltaY2 = DeltaY.^2;

Length = DeltaX2 + DeltaY2;
Lengths = sqrt(Length);

%get the total length
APLength = sum(Lengths);
CFLength = sum(Lengths(1:NCF-1));

xNew = CFLength/APLength;

ave1X = mean([0.304 0.32 0.3224, 0.3276, 0.3196]);
ave05X = mean([0.284, 0.248, 0.29, 0.256, 0.2584]);
ave2X = mean([0.356, 0.346, 0.3586, 0.3432, 0.3389]);

% define a range of D values
D = linspace(0.3,3);
Xcf = 0.32;
lambda = 0.19;

Xnew = Xcf + lambda*log(D);

semilogx(D,Xnew)

hold on
D2 = [ 1 0.5 2];
Xnew = [0.319 0.267 0.349];

semilogx(D2, Xnew, 'o') %plot experimental results

xlabel('Bcd Dosage')
ylabel('Xnew')
title('French Flag')
legend('Prediction','Experimental Results')
hold off





