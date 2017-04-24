classdef ExtractFeaturesVectorOnline
    % ExtractFeaturesVectorOnline:
    %Explantion: The objective of this class is to extract online features
    %vectors to test the decoders performance online. Different methods of
    %this class are used to extract different kind of features.
    
    %Object: object of this class is self
    
    %Properties:
      
    %behavioralData :
    % behavioralData: is a struct conating all the information regarding
    % trials in different fields. Here'behavioralData.saveData.EventTimes'
    % is field and is used to get to get timing inofrmation of trials to
    % extract features. This field contains timing
    % information of trails and within trials(event). It is
    % is matrix of size m*n
    % m: total Number of trials
    % n: total Number of events in one trials
    
    %trialNumber: trial number you want to decode and this is of data type
    %integer
    
    %1)StartingIndexOffset: this is vector of dimension 1*2
    %first element of vector would be strating index and second index
    %would be starting offset, [startingInd, startingOffset]
    
    %2)EndingIndexOffset: this is the vector of size 1*2
    %first element of vetor would be ending index and second element of
    %list would be ending offset,[endingInd, endingOffset]
    
    %Class Methods:
    % getDecodingTimeInformation: This class method is used to get timing
    % information of NSP for the purpose of decoding. This function wil return 
    % 'startingTimeNeuralSignal' and 'endingTimeNeuralSignal' both time are
    % in second(Real value).
    
    %getFeaturesVectorUnsortedOnline: This class mthod is used extract unsorted 
    %spikes features, this will return a vector of dimension (n*1), where n
    %is total number of features
    
    %getFeaturesVectorSortedOnline: comming soon :)
    
    %getFeaturesVectorsLFPOnline: comming soon :)
    
    
    
    
    
    properties
        behavioralData
        trialNumber
        trialStartingIndexOffset
        trialEndingIndexOffset
        
    end
    methods
        function self = ExtractFeaturesVectorOnline(behavioralData,trialNumber,trialStartingIndexOffset,trialEndingIndexOffset)
            self.behavioralData=behavioralData;
            self.trialNumber=trialNumber;
            self.trialStartingIndexOffset=trialStartingIndexOffset;
            self.trialEndingIndexOffset=trialEndingIndexOffset;
           
        end
        function featuresVector = getFeaturesVectorUnsortedOnline(self)
            %getting trial decoding time in seconds
            %startingTimeNeuralSignal,endingTimeNeuralSignal
            [startingTimeNeuralSignal,endingTimeNeuralSignal]=getDecodingTimeInformation(self);
            %constructing object of class 'ReadingDataNSP'
            neuralData=ReadingDataNSP(startingTimeNeuralSignal,endingTimeNeuralSignal);
            %calling the class method 'gettingSpikesDataNSP'
            [spikingActivityTask,trialTime] = neuralData.gettingSpikesDataNSP();
            featuresVector=zeros(96,1);%preallocation
            for ii=1:length(featuresVector)
                %constructing features vector
                dataElectrode_ii=spikingActivityTask{ii, 2};
                numberSpikes_ii=numel(dataElectrode_ii);
                featuresVector(ii)=numberSpikes_ii;
            end
        end
        function[startingTimeNeuralSignal,endingTimeNeuralSignal]=getDecodingTimeInformation(self)
            % getting ht task detail for complete session
            trialsDetails=self.behavioralData.saveData.EventTimes;
            %Starting time for all tasks
            trialstartingTime = trialsDetails(:,2);
            % Ending times for all task in one seesion
            trialsEndingTime = trialsDetails(:,7);
            total_tasks=size(trialsDetails,1);
            fprintf('There will be %d tasks(trials) in this session.\n',total_tasks);
            trialIndex=self.trialNumber;
            trialStartingIndex=self.trialStartingIndexOffset(1);%trial starting time 
            trialStartingOffset=self.trialStartingIndexOffset(2);% trial offset time
            trialEndingIndex=self.trialEndingIndexOffset(1);% trial ending index
            trialEndingOffset=self.trialEndingIndexOffset(2);%trail ending offset
            
            startingTimeNeuralSignal = (self.behavioralData.saveData.EventTimes(trialIndex,trialStartingIndex) + trialStartingOffset); %Here, enter the index
            endingTimeNeuralSignal=(self.behavioralData.saveData.EventTimes(trialIndex,trialEndingIndex) + trialEndingOffset);
            %holdTime=endingTimeNeuralSignal-startingTimeNeuralSignal;
        end
    end 
    
end
