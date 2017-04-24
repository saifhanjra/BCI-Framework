% [fileNameBehav,pathNameBehav]=uigetfile({'*.mat'},'Behavioral data');
% bd=strcat(pathNameBehav,fileNameBehav);
% 
% 
% [fileNameNeuralSpikes,pathNameNeuralSPikes]=uigetfile({'*.mat'},'Neural SPikes Data');
% nsd=strcat(pathNameNeuralSPikes,fileNameNeuralSpikes);


startingIndexOffset=[2,0.4];
endingIndexOffset=[7,0.6];

% defaultans = {'[     ]','[     ]'};
% x = inputdlg({'Starting index and Offset','ending index and Offset'},...
%               'Decoding Index with Offset', [1 50; 1 50],defaultans);
  
bd='C:\Users\KlaesLab03\Desktop\OneDrive - rub.de\MatlabScripts\PhDStuff\BCIPackages\Data\20131016-115158_rps_01_behav.mat';
nsd='C:\Users\KlaesLab03\Desktop\OneDrive - rub.de\MatlabScripts\PhDStuff\BCIPackages\Data\rps_20131016-115158-NSP1-001.mat';
          
% startingIndexOffset=str2num(x{1, 1});
% endingIndexOffset=str2num(x{2, 1});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data=Data(startingIndexOffset,endingIndexOffset,bd,nsd); %inititaing constructor
[extractedFeaturesSortedVector,extractedSortedLabels]=data.featuresVectorsAndLabelsSorted();

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
cmpFeatLab=CompatibleFeaturesLabels(extractedFeaturesSortedVector,extractedSortedLabels);
[featNN,labNN]=cmpFeatLab.makeComp4NN();


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Online Part:


