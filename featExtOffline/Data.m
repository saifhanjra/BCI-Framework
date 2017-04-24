classdef Data
    
    %Data:
    
    %Explantion:
    
    %Objective: Objective of this class is to extract all kind of
    %features vectors(sortedSPikes,unsortedSPikes,LocalFieldPotential)
    %and labels for one complete session 
    
    %Class methods : This class has following class methods
    %1) featuresVectorsAndLabelsUnsortedSpikes: The function of this class
    %method is to extract unsorted spikes Feature vector and it will also
    %extract labels of corresponding features vector. And then it will distribute the data 
    % into training data and test  data. For more detail and
    %explanation about input parameter see the body of function.
    
    %2)featuresVectorsAndLabelsSortedSpikes: The function of this class
    %method is to extract sorted spikes Feature vector and it will also
    %extract labels of corresponding features vector.And then it will distribute the 
    %data init training data and test data.For more details and
    %explanation about input parameters see the body of function.
    
    %3)later on function for localfield potential will also be included
    
    %Static methods: 
    %1)getFeaturesLabels : Purpose of this method is to exclude all the
    %features vector, corresponding to unsuccessful trials. this function
    %will return will return matrix of succesful trials features vectors
    %and it will also return the corresponding labels of each features in
    %a list of integer. For explanation about input parameters details see
    %the body of function.
    
    %2)getTrainingTestdata: Puupose of this static mrhod is to take
    %feature vectors along with label and data distribution(optional) as an
    %input argument and it will then divide the data into training data and
    %test data.
    
    %Object: self is the object of this class
    
    %properties:
    
    %featExt: 'featExt' corresponds to 'Features Extraction' and this 
    % property is instance(object) of class 'FeaturesExtraction' class
    % so this prooperty is struct and it has following fields
    
    %1)StartingIndexOffset: this is vector of dimension 1*2
        %first element of vector would be strating index and second index 
        %would be starting offset, [startingInd, startingOffset]
     %2)EndingIndexOffset: this is the vector of size 1*2
     %first element of vetor would be ending index and second element of
     %list would be ending offset,[endingInd, Offset]
     %3)behavioralData: is a struct conating all the information regarding
     %trials in different fields. Here'behavioralData.saveData.EventTimes'
     % filed is used to extract features. This field contains timing
     % information of trails and within trials(event) and it is 
     % is matrix of m*n
     % m: total Number of trials 
     % n: total Number of events in one trials
     
     %4)NeuralSpikesData:This is struct it contain the neural information
     %of trials for one complete session and it has two main fields which
     %are structs
     
     %NEV: This field is a struct and it will contain all the necessary
     %inforamtion to extract unsorted spikes features vectors in its
     %different whic are of different data types forexample:
     %'neuralSpikesData.NEV.Data.Spikes.TimeStamp' is field of and it is
     %vector of size n*1, where n repesents the time stamps of spikes.
     % To Extract unsorted spikes features 'nev' struct is used
     
     %sortedSPikes: is a struct and it is used to to extract sorted 
     %features vectors. this struct has a field and this filed consist
     %(n*1) cells where n repesent the number of implanted 
     %electrodes(sensors) and each cell contain the sorted spikes
     %information of each electrode.
    
    
    
    properties(SetAccess=private,GetAccess=public)
          featExt
          labels
          

    end
    
    methods
        function self=Data(startingIndexOffset,endingIndexOffset,behavioralData,neuralSpikesData)
            %Explanation:Construcor
            
            %InputParatemeters:
            %1) behavioralData: path of the .mat file associated with behavioral data of particular session
            %2) neuralSpikesData: Path of .nev(unsortedSpikes) file of
            %corresponding to behavioral data
            %3) startingIndexOffset: is a list cotain two elements [startingIndex, startingOffset]
            % startingIndex: from which event of task, you want to start
            % extract features
            % startingOffset: if there is any offset required mention it in
            % the seconds, which is unit of time
            %endingIndexOffset: is a list contain two elemennt[endingIndex, endingOffset]
            %endingIndex:index of event till which you want to extract
            %features
            %endingOffset: offset if any, in seconds
            %behavioralData=load(behavioralData);
            %neuralSpikesData=load(neuralSpikesData);
            self.featExt = FeaturesExtraction(startingIndexOffset,endingIndexOffset,behavioralData,neuralSpikesData);
            self.labels  = GetLabels(behavioralData);
                        
            
        end
        
        
        function [extractedFeaturesVectorUnsorted,extractedLabels]=featuresVectorsAndLabelsUnsorted(self,varargin)
            %Description: extract features vector for unsorted spikes and 
            %labels first sepertely and then combine them togeteher using 
            %another function
            
            %inputParamters:object of this class 'self'.compelet details 
            %can be seen above
            
            %outputParamters:Type: Matrix,Vector
            
            %extractedfeatures:matrix, each column is featuresvector(observation) 
            %and%each row of that column is one feature
            
            featuresVectors=self.featExt.extractUnsortedFeatures();%This function will extract feature, including unsuccessful trials
            %self.feat is the object(instance) of Feature ectraction and 
            %'extractUnsortedFeatures' is class method that will extract
            %features vector by taking class object as an input argument
            %argument
            %outputargument: 
            %features vectors: is m*n matrix, where m is total
            %number of trials and n is total number of fetaures in one
            %feature vector
            
            
            [labelsInt,chckOutliers]=self.labels.extractLabelsSession(); % This function will extract labels, including unsuccessful trials
            %This function will take self.labels as an input argument and.
            %output arguments:
            %labelsInt:it will return the list of labels(integer) as one of
            %output argument, the dimesion of list is 1*m, m is the total
            %number of trials in one session.
            %chckOutliers: is a list of 1*m, m is the total number of
            %trials in one seesion, each element of list is either 0 or
            %1,0 in case when the trial was unsuccessful and 1 when thr
            %triasl was consoderes to be successful
          
            % Next, Data.getFeaturesLabels is a static fuinction of this
            % class and it will take as input argument follwing parameters 
            %featuresVectors: detail(see above)
            %labelsInt:detail(see above)
            %chckOutliers:deatails(see above)
            % extract fetures vectors and label for only succesfull trial
            % and return them as an output argument
            
            if length(varargin)==1
               speceficClassesIds=varargin{1};
               [extractedFeaturesVectorUnsorted,extractedLabels]=Data.getFeaturesLabels(featuresVectors,labelsInt,chckOutliers,speceficClassesIds);
               extractedFeaturesVectorUnsorted=extractedFeaturesVectorUnsorted';
               extractedLabels=extractedLabels';
           else
                [extractedFeaturesVectorUnsorted,extractedLabels]=Data.getFeaturesLabels(featuresVectors,labelsInt,chckOutliers);
                extractedFeaturesVectorUnsorted=extractedFeaturesVectorUnsorted';
                extractedLabels=extractedLabels';
           end
            

             
        end%end:featuresVectorsAndLabelsUnsorted
        
        function [extractedFeaturesVectorSorted,extractedLabels] =featuresVectorsAndLabelsSorted(self,varargin)
            %self.feat is the object(instance) of Feature ectraction and 
            %'extractSortedFeatures' is class method that will extract
            %features vector by taking class object as an input argument
            %argument
            %outputargument: 
            %features vectors: is m*n matrix, where m is total
            %number of trials and n is total number of fetaures in one
            %feature vector
            
           featuresVectors=self.featExt.extractSortedFeatures();%This function will extract feature, including unsuccessful trials
           %This function will take self.labels as an input argument and.
            %output arguments:
            %labelsInt:it will return the list of labels(integer) as one of
            %output argument, the dimesion of list is 1*m, m is the total
            %number of trials in one session.
            %chckOutliers: is a list of 1*m, m is the total number of
            %trials in one seesion, each element of list is either 0 or
            %1,0 in case when the trial was unsuccessful and 1 when thr
            %triasl was consoderes to be successful
          
            % Next, Data.getFeaturesLabels is a static fuinction of this
            % class and it will take as input argument follwing parameters 
            %featuresVectors: detail(see above)
            %labelsInt:detail(see above)
            %chckOutliers:deatails(see above)
            % extract fetures vectors and label for only succesfull trial
            % and return them as an output argument
           [labelsInt,chckOutliers]=self.labels.extractLabelsSession();% This function will extract labels, including unsuccessful trials
           if length(varargin)==1
               speceficClassesIds=varargin{1};
               [extractedFeaturesVectorSorted,extractedLabels]=Data.getFeaturesLabels(featuresVectors,labelsInt,chckOutliers,speceficClassesIds);
               extractedFeaturesVectorSorted=extractedFeaturesVectorSorted';
               extractedLabels=extractedLabels';
           else
                [extractedFeaturesVectorSorted,extractedLabels]=Data.getFeaturesLabels(featuresVectors,labelsInt,chckOutliers,[1,2,3]);
                extractedFeaturesVectorSorted=extractedFeaturesVectorSorted';
                extractedLabels=extractedLabels';
           end                 
            
        end %feturesVectorsAndLabelsSorted
        
    end % end Class Methods
    
    
    methods(Static,Access=public)
        function [extractedFeaturesVector,extractedLabels]= getFeaturesLabels(featuresVectors,labelsInt,chckOutliers,speceficClassesIds)
            %Explanation: This function is used to get features vectors
            %and labels for sunccessful trials 
            
            %InputParamters:
            %featuresVectors:see 'featuresVectorsAndLabelsUnsorted' class
            %Method
            %labelsInt:see 'featuresVectorsAndLabelsUnsorted' class
            %Methods
            %chckOutliers: 'featuresVectorsAndLabelsUnsorted' class
            %Methods
            
            %output parameters:
            %extractedFeaturesVector: is a m*n matrix, where 'm' is total
            %number of features in each features vector and 'n' is total
            %number of successful trials, so, 'n' is total number of
            %features vectors
            %extractedLabels: is a list of length(1*n)
            %m:n' is total
            %number of successful trials
            
            indicesRequired=find(chckOutliers==1);% will give the index of successful trials 
            extractedLabels=labelsInt(indicesRequired);%will give the labels of succesful trials
            switch  nargin
                case 3
                    extractedFeaturesVector=(featuresVectors(indicesRequired,:))';
                case 4
                    indicesRequiredCustomize=[];
                    totalCustomizeClasses=length(speceficClassesIds);
                    for ii = 1:totalCustomizeClasses
                        indicesClass_ii = find(extractedLabels==speceficClassesIds(ii));
                        indicesRequiredCustomize = [indicesClass_ii,indicesRequiredCustomize]; %here pre-allocation is not possible                        
                    end
                    extractedFeaturesVector=(featuresVectors(indicesRequiredCustomize,:))';
                    extractedLabels=extractedLabels(indicesRequiredCustomize);
                    
            end
            %extractedFeaturesVector=(featuresVectors(indicesRequired,:))';% will giv the feature vectors of succesfull trails  
        
        end %end for getFeaturesLabels

    end%end for static methods
end%end class defination
