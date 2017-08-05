function df = FluorExtraction(segMask, signalIm)
%FluorExtraction extracts the fluorescence values of individual cells given
%a segmentation mask segMask and a fluorescence image fluorIm.
% Parameters
% ----------
% segMask : segmentation mask with labeled objects
% signalIm : Raw fluorescence image from which extract the fluorescence data

% List labels for the cells in the segmentation mask
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
    fluorIm = immultiply(mask, signalIm);
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
df.Properties.VariableNames = {'cellLabel', 'Area', 'totalFluor'};