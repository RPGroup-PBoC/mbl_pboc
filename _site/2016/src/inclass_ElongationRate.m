%We want to count spots as a function of time for the 5' and 3' constructs.
%Let's begin by looking at one frame

%Load frame 70 from the 5' set
Image=imread('5Loops070.tif');
imshow(Image)
%The reason this image is black is because the image is in 16bits (65k
%levels of gray) and Matlab only knows how to display 256 levels of gray.
%As a result, we need to tell Matlab how to normalize our image
figure(1)
imshow(Image,[])
%The "[]" option tells Matlab to normalize the image such that the dimmest
%pixel is 0 and the brightest one is 256.


%We want to threshold the image to determine which pixels correspond to
%spots and which ones don't. First, we examine the pixel values using
%imtool
%imtool(Image,[])                   %I'm commenting this out so that it
                                    %doesn't open a new imtool window every
                                    %time I run the code
%Determine the threshold
Threshold=1000;
%Take the threshold
ImThresh=Image>Threshold;
figure(2)
imshow(ImThresh)

%Label all contiguous ones with unique identities using bwlabel
ImLabel=bwlabel(ImThresh);
figure(3)
imshow(label2rgb(ImLabel))
%Note that we used "label2rgb" to convert the labeled regions to colors
%Look at it in grayscale again
figure(4)
imshow(ImLabel,[])

%We have as many spots as labeled regions. If we find the maximum index in
%the image, then we just counted the total number of spots
NSpots=max(max(ImLabel))

%Now do this for each movie
%Get the file list
Files5=dir('5*.tif');
%Go through each frame
for i=1:length(Files5)
    Image=imread(Files5(i).name);
    ImThresh=Image>Threshold;
    ImLabel=bwlabel(ImThresh);
    NSpots5(i)=max(max(ImLabel));
    Time5(i)=i*10;         %in seconds
end

%Get the file list
Files3=dir('3*.tif');
%Go through each frame
for i=1:length(Files3)
    Image=imread(Files3(i).name);
    ImThresh=Image>Threshold;
    ImLabel=bwlabel(ImThresh);
    NSpots3(i)=max(max(ImLabel));
    Time3(i)=i*10;         %in seconds
end

figure(5)
plot(Time5/60,NSpots5,'-r')
hold on
plot(Time3/60,NSpots3,'-b')
hold off
xlabel('Time (min)')
ylabel('Number of spots')
legend('5 prime','3 prime')





    
    
    
    






































