%These are the fluorescence values obtained using
%GeneExpressionMultipleFiles.m
Auto=122.43;    % autofluorescence value
Delta=612.95;   % delta strain fluorescence
Denom=Delta-Auto;
R=[11,30,62,130,610];
R11=229.59;
R30=171.89;
R62=154.18;
R130=135.07;
R610=128.61;
%Calculate the fold change in gene expression
FoldChange=[(R11-Auto)/Denom,(R30-Auto)/Denom,(R62-Auto)/Denom,...
    (R130-Auto)/Denom,(R610-Auto)/Denom];
%Plot it
figure(1)
loglog(R,FoldChange,'.r','MarkerSize',20)
xlabel('Number of repressors')
ylabel('Fold-change')

%Calculate the DeltaE from the RBS446 (R=62) data
DE=-log(5E6/62*(1/FoldChange(3)-1))
%Now use this value of DeltaE to make a prediction for the other data
%points
%Range of R to plot
RPrediction=logspace(1,3);      %Go from 10^1 to 10^3
%Get the fold change based on the DE we calculated  above
FoldChangePrediction=1./(1+RPrediction/5E6*exp(-DE));
%Plot the prediction on top of the data
hold on
loglog(RPrediction,FoldChangePrediction,'-k')
hold off













