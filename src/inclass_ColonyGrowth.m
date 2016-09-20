%Measure the area taken up by an E. coli colony grown under the microscope

%Let's try the approach for frame 26
%Load the frame
Image=imread('colony_growth_26.tif');
imshow(Image)
%We can inspect the pixel values to decide on a threshold using the
%"data cursor" tool. Alternatively, we can use imtool
%imtool(Image)      %We comment this out so that we don't load imtool again
                    %every time we run the script
%We use the "inspect pixel value tool" within imtool to figure out a good
%threshold
Threshold=100;
%We segment the image by asking if each pixel value is larger than the
%threshold value
ImThresh=Image>Threshold;
imshow(ImThresh)

%To calculate the area occupied by the cells in this frame, I need to sum
%over all pixel values in ImThresh. Remember the function sum first
%operates on rows. This means that we need to run sum twice.
sum(sum(ImThresh))


%Now let's do this for the whole movie

%First, we need to learn how to get a list of file names
FileList=dir('*.tif');      %List all files that have a TIF extension
%FileList is a weird structure called a structure array
%If I want to get the name of file 10
FileList(10).name
%Load this file
Image=imread(FileList(10).name);
imshow(Image)

%Finally, we need to learn how to repeat an operation
%We're going to use a for-loop. In this example we want to calculate i*2
%with i going from 1 to 20.
for i=1:20          %Move the counter i between 1 and 20
    Value(i)=i*2;   %Operation we want to iterate over
end                 %Close the for-loop

%Write a for-loop to display the movie in Matlab
figure(1)       %Bring up figure 1
for i=1:length(FileList)
    Image=imread(FileList(i).name);     %Load the i-th image
    imshow(Image)
    drawnow                             %Force Matlab to show the image
end


%Now, load each image, calculate the area, and save that information into a
%vector
for i=1:length(FileList)
    Image=imread(FileList(i).name);     %Load the image
    ImThresh=Image>Threshold;           %Take the threshold
    Area(i)=sum(sum(ImThresh));         %Calculate the are and save it
                                        %onto a vector
	Time(i)=i*5;                        %Time in minutes (we knew that
                                        %each frame corresponded to
                                        %5 minutes)
end

%Plot Area vs Time
figure(2)
plot(Time,Area,'.')
xlabel('Time (min)')
ylabel('Area (pixels)')


%Fit to an exponential by eye
%First, create a vector of time point for which we will calculate the
%prediction
TimePrediction=0:200;       %This is in minutes
Area0=1000;                 %Starting area in pixels
r=0.0142;                     %In 1/min
AreaPrediction=Area0*exp(r*TimePrediction);

%Plot the prediction on top of the data
hold on             %Tell Matlab not to delete the previous plot
plot(TimePrediction,AreaPrediction,'-r')  %Use a red line
hold off










    
    
    











