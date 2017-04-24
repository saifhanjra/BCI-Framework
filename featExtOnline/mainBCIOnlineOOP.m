behavioralData=load('C:\Users\KlaesLab03\Desktop\OneDrive - rub.de\MatlabScripts\PhDStuff\BCIPackages\Data\20131016-115158_rps_01_behav');
TrialNumber=2;
trialStartingIndexOffset=[2,0.4];
trialEndingIndexOffset=[7,0.6];


featVect=ExtractFeaturesVectorOnline(behavioralData,TrialNumber,trialStartingIndexOffset,trialEndingIndexOffset);
featuresVector = featVect.getFeaturesVectorUnsortedOnline();

%  featuresVector = featVect.getFeaturesVectorUnsortedOnline();
% 
% 
% trainedModelNN=load('C:\Users\KlaesLab03\Desktop\OneDrive - rub.de\MatlabScripts\PhDStuff\BCI-Framework\OnlinePart(UnsortedSpikes)\bestNetwork');
% testInput=featuresVector;
% 
% trainedDecods=TrainedDecoders(trainedModelNN,testInput);
% 
% predictedOutput=trainedDecods.getTrainedModelNN();


