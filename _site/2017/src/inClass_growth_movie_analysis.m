1+1
% Comments are made by typing "%" at the beginning
% of the comment

% Define a variable
a=10;  % ";" suppresses the output
% Operate on the variable
a*2

% We want to load one of the frames of the movie to learn
% how to segment cells. Then, we'll tell the code to repeat
% the operation for all frames in the movie.

% Images are loaded using the command "imread". Let's load frame 24.
imread('colony_growth_23.tif')
% Note that we get a matrix where each position corresponds to a pixel
% in the image, and the value to the pixel intensity.
% Let's now load the image and save it into a variable. Also, we'll
% suppress the output using ";".
Cells=imread('colony_growth_10.tif');
% Display the image
imshow(Cells)
% We can examine the pixel values using the Data Cursor in the image
% window. We estimate that pixel values above 80 will correspond to cells.

% A nicer way to explore the pixel values is through imtool. Note that
% imtool will open a new window every time you run the script. So, after
% you used it, you might want to comment it out with "%"
%imtool(Cells)
% Upon closer examination we decided to go for a threshold of 100.

% Yet another way to inspect the pixel values is to plot a histogram of the
% image. This is exactly what the function imhist does.
figure(2) %This forces Matlab to plot everything in Figure 2
imhist(Cells)
% Maybe we can show the number of pixels on a log scale
set(gca,'Yscale','log')

%Now we want to draw a threshold. Let's use a simple example
a=[2,3,6,1,2,7,1,2]     %We're defining a column-vector. Numbers are
                        %separated by commas
a>2

% Define the threshold
Threshold=100;
% Take the threshold
ImThresh=Cells>Threshold;
% Show the thresholded image
imshow(ImThresh)

%Overlay the original and segmented images for comparison
imshowpair(Cells,ImThresh)

% We got a pretty good overlay. We now measure the area by summing over
% all pixels. Since pixels with cells have a value of 1, and pixels without
% cells have a value of 0, the sum will just be the colony area in
% pixels^2.
% To sum, we use the function "sum". Let's see how it operates on a small
% matrix
b=[1,2;3,4]
% Note that "sum" only sums over one dimension
sum(b)
% If we want to sum over the whole matrix, we apply "sum" twice
sum(sum(b))

%The area occupied by cells in this frame is
sum(sum(ImThresh))

%I'm going to save this information in the vector Area. Each position in
%this vector will correspond to a frame.
Area(23)=sum(sum(ImThresh))

%Let's define a for loop. We need a counter "i", and a range from 0 to 10
%in this example.
for i=0:10
    i*2   
end

%To determine the range of the for-loop, we first need a list of files.
D=dir('*.tif')
% * is a wildcard. This lists all files with the extension tif.
% The results are saved in the structured array D. Let's see its
% information for the first element.
D(1)
% If I just want the file name of the first image
D(1).name

%Now, we're ready to write the for-loop
for i=1:length(D)  %This asks how long the structured array D is
    %Load the i-th image
    Cells=imread(D(i).name); 
    %Take the threshold
    ImThresh=Cells>Threshold;
    %Find the area and assign it
    Area(i)=sum(sum(ImThresh));
    %Define a time vector
    Time(i)=(i-1)*5;    %in minutes
end

%Now, plot the result
plot(Time,Area)
%If you want to show the data points connected by lines
plot(Time,Area,'.-')
%Let's use a log-axis on y to see if this is exponential growth
semilogy(Time,Area,'.-')
%Axis labels
xlabel('time (min)')
ylabel('cell area')



%Simulate exponential growth

%Model parameters
k=log(2)/35;    %1/min
%Simulation parameters
dt=0.1;         %min
TotalTime=300;  %min
%Initial conditions. Note that we now converted our simulation to area
%rather than number of cells. This is our estimate for the initial
%condition of our movie.
N(1)=5*10^2;        
%Integrate the equation using a for-loop
for i=2:TotalTime/dt
   N(i)=N(i-1)+N(i-1)*k*dt;
   TimeSimulation(i)=(i-1)*dt;
end
%Plot the results on a semilog plot
semilogy(TimeSimulation,N)
xlabel('time (min)')
ylabel('cell area')
%We want to compare our simulation to the data. In order for Matlab not to
%delete the previous plot, we use hold on
hold on
%Plot the data as red dots
semilogy(Time,Area,'.r')
%Stop preserving plots
hold off


% Fit for the best value of k

%First, define a range of search for k
%To define a range we use the ":" operator that defines start:step:end
kRange=0.01:0.0001:0.03;

%Let's calculate the error for a kTest
kTest=0.02;
%Calculate the error. Note that to square each element in the vector I need
%to put a "." in front of the "^2".
Error=sum((log(Area)-(log(N(1))+kTest*Time)).^2)

%Calculate the Error for each value of kRange
for i=1:length(kRange)
   Error(i)=sum((log(Area)-(log(N(1))+kRange(i)*Time)).^2);    
end
plot(kRange,Error,'.-')

%Plot the data on top of our best fit
figure(2)
kFit=0.0192;
plot(Time,log(Area),'.r')
hold on
plot(Time,log(N(1))+kFit*Time)
hold off
xlabel('time (min)')
ylabel('cell area')








































































