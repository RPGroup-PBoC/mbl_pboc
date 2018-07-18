%Measure E. coli size using a graticule as calibration

%Load the image of a graticule
GraticuleImage=imread('Graticule100x.tif');
%Display this image
imshow(GraticuleImage)

%Let's learn a few more things about vectors and matrices
a=[4,6,1,2,3,4,6,7]
%Pull the third element of vector a
a(3)
%Pull elements 4 through 7 of vector a
a(4:7)
%Move to a matrix
b=[3,5,1,3;6,4,3,2;0,7,5,2]
%Pull out the number in row 2, column 3
b(2,3)
%Get elements in columns 2 and 3 on row 1
b(1,2:3)
%Get all elements on row 3
b(3,:)


%Make a line plot along the width of the image
LineValues=GraticuleImage(500,:);    %Get all column values along row 500
%Plot the line values
figure(2)           %Create a new figure with the label 2
plot(LineValues)
xlabel('Position (pixels)')
ylabel('Intensity (au)')

%We use the data cursor to count the number of pixels between eight valleys
%of intensity
umPerPixel=80/(1175-91);    %In um per pixel


%Put a scale bar on top of the E. coli image
%Load the image
EColiImage=imread('Ecoli100x.tif');
figure(3)
imshow(EColiImage)

%We want to plot a scale bar on top of our image by modifying some of the
%image's pixel values
%Let's go back to the example of the b matrix
%Replace the value in row 2, column 3 by 10
b(2,3)=10
%Replace all values along row 3 by 20
b(3,:)=20


%Commit to a scale bar length
BarLengthInUm=5;
BarLengthInPixels=round(BarLengthInUm/umPerPixel) %We use the function round
                                                  %to get an integer number
                                                  %of pixels
BarThicknessInPixels=10;

%Place the scale bar starting at row 1116 and column 920
EColiImage(920:920+BarThicknessInPixels,...
    1116:1116+BarLengthInPixels)=0;
%Show the image again
imshow(EColiImage)













































