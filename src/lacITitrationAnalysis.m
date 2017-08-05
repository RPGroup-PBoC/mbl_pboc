% Read images
% mCherry
imCherry = imread('data/lacI_example/mCherry_constitutive.tif');

%YFP
imYFP = imread('data/lacI_example/YFP_regulated.tif');

%%
% Apply a LoG filter to the mCherry image
[imEdge,threshOut] = edge(imCherry, 'log');

imshow(imEdge)
%%

%Fill the holes in the edge image.
imFill = imfill(imEdge, 'holes');
imshow(imFill)

%%
%Remove the small stuff.
imFilt = bwareaopen(imFill, 100, 4);
imshow(imFilt)

%%
%Dilate the objects by 2px.
selem = strel('diamond', 1);
imDil = imdilate(imFilt, selem);
imshow(imDil)

%%
%Remove objects touching the border and label the output image.
imSeg = imclearborder(imDil, 4); %Buffer of 4px.
imSeg = bwlabel(imSeg);
imshow(imSeg)

%%
%Extract the region props of the mask.
props = regionprops(imSeg, 'Area', 'Eccentricity');

%Iterate through each object and apply an area and eccentricity filter.
areas = [props.Area];
eccs = [props.Eccentricity];

%%
hist(areas)
A = [150, 250];

%%
hist(eccs)
E = [.85, 0.95];

%%
approvedAreas = (areas > A(1)) & (areas < A(2));
approvedEccs = (eccs > E(1)) & (eccs < E(2));

%Find the approved labels
approvedLabels = find((approvedAreas .* approvedEccs) > 0);

%Generate the final mask.
segMask = zeros(size(imSeg));
for i=1:length(approvedLabels)
	segMask = segMask + (imSeg==approvedLabels(i));
end

%Relabel the image.
segMask = bwlabel(segMask > 0);

imshow(label2rgb(segMask))

%%

% Once we have the segmentation mask let's extract the fluorecesnce values
% of each of the cells and save it in a table data structure along with the
% area of the cell

% Define the label array for the cell
LabelArray = 1:max(segMask(:));

% Obtain again the areas of the residual cells with region props
props = regionprops(segMask, 'Area');
AreaArray = [props.Area]; % Save areas into an array
totalFluor = zeros(1, length(AreaArray)); % Iinitialize fluorescence array

% Loop through the cells to extract the fluorescence value
for i=1:max(segMask(:))
    % Extract the cell region from the mask
    mask = segMask == i;
    % Multiply by the fluorescence image to obtain the value form the YFP
    % channel
    fluorIm = immultiply(mask, imCherry);
    % Do a sum to extract the total fluorescence read from the image
    totalFluor(i) = sum(fluorIm(:));
end % for

% Generate the table for this image with cell label, area and total
% fluorescence
% First transpose all of the arrays (so stupid)
LabelArray = LabelArray';
AreaArray = AreaArray';
totalFluor = totalFluor';
df = table(LabelArray, AreaArray, totalFluor);
%%
% Now we need to read the data iteratively from this super messy directory
% structyre. This is a super important skill to learn since unfortunately a
% big chunck of the data analysis process is spent arranging the data in a
% reasonable way.

% To begin this example let's find the only the files from the Auto strain
% List all the directories containing the pattern auto
autoDirs = dir('data/lacI_titration_mCherry/Auto*');

% These values for the thresholds were chosen by looking at the histogram
% of these properties
A = [200, 650];
E = [.85, 1];

%%

% Let's now analyze an image using only the functions I defined to automate
% the processing

% Find the TRITC image
directory = strcat(autoDirs(1).folder,'/', autoDirs(1).name);
fileCherry = dir(strcat(directory, '/*TRITC*tif'));
% Read the TRITC image
imCherry = imread(strcat(directory, '/', fileCherry.name));

%Segment the TRITC image
segMask = LogSegmentation(imCherry, A, E);
imshowpair(imCherry, segMask > 0)

% Find the FITC image
directory = strcat(autoDirs(1).folder,'/', autoDirs(1).name);
fileYFP = dir(strcat(directory, '/*FITC*tif'));
% Read FITC image
imYFP = imread(strcat(directory, '/', fileCherry.name));
df = FluorExtraction(segMask,imYFP)

[nrow, ncol] = size(df);
strain = cell(nrow, 1);
strain(:) = {'auto'};
df = [df strain];
df.Properties.VariableNames(end) = {'strain'};

%%

% Now that we show it works let's truly loop through all the images and
% extract the fluorescence from each file

% Let's list the strains
strains = {'Auto', 'Delta', 'WT', 'RBS1147', 'RBS446', 'RBS1027',...
           'RBS1'};
repressors = [-1, 0, 10, 30, 62, 130, 610];
% These values for the thresholds were chosen by looking at the histogram
% of these properties
A = [50, 800];
E = [0, 2];

for i=1:length(strains);
    st = strains{i}
    % List all directories
    Dirs = dir(strcat('data/lacI_titration_mCherry/*', st, '_*'));

    % Loop through sub-directories to segment the cells and obtain the
    % fluorescence value.
    for d=1:length(Dirs)
        % Find the TRITC image
        directory = strcat(Dirs(d).folder,'/', Dirs(d).name);
        fileCherry = dir(strcat(directory, '/*TRITC*tif'));
        % Read the TRITC image
        imCherry = imread(strcat(directory, '/', fileCherry.name));
        %Segment the TRITC image
        segMask = LogSegmentation(imCherry, A, E);

        % Find the FITC image
        directory = strcat(Dirs(d).folder,'/', Dirs(d).name);
        fileYFP = dir(strcat(directory, '/*FITC*tif'));
        % Read FITC image
        imYFP = imread(strcat(directory, '/', fileCherry.name));
        df = FluorExtraction(segMask, imYFP);

        [nrow, ncol] = size(df);
        strain = cell(nrow, 1);
        strain(:) = {st};
        df = [df strain];
        df.Properties.VariableNames(end) = {'strain'};
        df = [df table(repmat(repressors(i), nrow, 1))];
        df.Properties.VariableNames(end) = {'repressors'};

        if i == 1 & d == 1
            dfCells = df;
        else
            dfCells = [dfCells; df];
        end % if
    end % for
end % for

%%

% Now that we have all the single cell fluorecence values, let's compute
% the mean and the standard error of the mean and plot it for all repressor
% copy numbers
totalFluor = zeros(1, length(repressors));
meanFluor = zeros(1, length(repressors));

for r=1:length(repressors)
    rows = dfCells.repressors == repressors(r);
    repData = dfCells(rows, {'Area', 'totalFluor'});
    totalFluor(r) = mean(repData.totalFluor);
    meanFluor(r) = mean(repData.totalFluor ./ repData.Area);
end % for

% Extract the auto fluorescence
meanFluorBgCorr = meanFluor(2:end) - meanFluor(1);

% Compute the fold change
FoldChange = meanFluorBgCorr(2:end) ./ meanFluorBgCorr(1);

%%
rep = logspace(0, 3, 100);
loglog(rep, 1 ./ (1 + 2 * rep / 4.6E6 * exp(13.9)))
hold on
plot(repressors(3:end), FoldChange, '.', 'MarkerSize', 15)

xlabel('repressors')
ylabel('fold-change')

hold off