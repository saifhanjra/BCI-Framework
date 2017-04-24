classdef ModelGUIBCIFW2 < handle
    properties(SetObservable)
        %--Data
        neuralSpikesData %NeuuralSpikesData
        behavioralData %BehavioralData
        
        neuralSpikesDataTestOffline %NeuraSpikesData(for evalution trained network)
        behavioralDataTestOffline %BehavioralData (corresponding behavioral data)
        %Why  specefic event & offset are required?
        %The answer to this question is, we have observed the data and find
        %out the trends it is highly probable the 'trends in data' exist
        %in this part of trial in every possible condition. 
        startingOffset %Starting Offset(for starting region of itnterst of trial)   
        endingOffset %Ending Offset (Ending region of interest)
        
        startingEvent 
        endingEvent
        %--FeaturesExtraction&Reduction
        selectedFeatExtAlgo      
        selectedFeatRedAlgo
        
        extractedFeatures
        correspondingLabels
        
        trainingData
        validationData
        testData
        
        selectedFeatExtParamSettingMode
        selectedFeatRedParamSettingMode
        selectedTrainDecoParamSettingMode
        
        %--DecoderModule
        selectedDecoMod
        selectedDecoAlgo
        
       %--TrainedModel(Decoders)
       trainedNNObject
       recordTrainedNNObject

        
        
    end
    methods 
        function hSelf= ModelGUIBCIFW2()
        end
        %------------------------------------------------------------------
        %---------------------DataTab--------------------------------------
        %------------------------------------------------------------------
        function setNeuralSpikesBehavioralData(hSelf)
            %First Extract Neural Data
            try
            [fileNameNeuralSpikes,pathNameNeuralSPikes]=uigetfile({'*.mat'},'Neural SPikes Data');
            nsd=strcat(pathNameNeuralSPikes,fileNameNeuralSpikes);
            nsd=load(nsd);
            hSelf.neuralSpikesData=nsd;
            
            %get corresponding behavioral data
            [fileNameBehav,pathNameBehav]=uigetfile({'*.mat'},'Behavioral data');
            bd=strcat(pathNameBehav,fileNameBehav);
            bd=load(bd);
            hSelf.behavioralData=bd;
            catch
                addcause('Select appropriate Neural File and  corresponding Behavioral File')
            end
        end
        function setStartingOffset(hSelf,startingOffset)
            hSelf.startingOffset = startingOffset;   
        end
        function setEndingOffset(hSelf,endingOffset)
            hSelf.endingOffset = endingOffset;
        end
        function setStartingEvent(hSelf,startingEvent)
            hSelf.startingEvent = startingEvent;
        end
        
        function setEndingEvent(hSelf,endingEvent)
            hSelf.endingEvent = endingEvent;
        end
        
        %------------------------------------------------------------------
        %---------------FeaturesExtraction&Reduction-----------------------
        %------------------------------------------------------------------
        
        %FeatureExtraction-------------------------------------------------
        
        function getFeaturesExtAlgo(hSelf,selectedFeatExtAlgo)
            hSelf.selectedFeatExtAlgo = selectedFeatExtAlgo;     
        end
        
        function getFeatExtParamSettingMod(hSelf,selectedSettingName)
            hSelf.selectedFeatExtParamSettingMode=selectedSettingName;
        end
        function featExtSortedSpikes(hSelf,classLabels)
            startingEventOffset=[hSelf.startingEvent,hSelf.startingOffset];
            endingEventOffset = [hSelf.endingEvent,hSelf.endingOffset];
            data=Data(startingEventOffset,endingEventOffset,hSelf.behavioralData,hSelf.neuralSpikesData);
      
            switch nargin
                case 1
                    [hSelf.extractedFeatures,hSelf.correspondingLabels]=data.featuresVectorsAndLabelsSorted();
                case 2
                    [hSelf.extractedFeatures,hSelf.correspondingLabels]=data.featuresVectorsAndLabelsSorted(classLabels);
            end            
        end %end:featExtSortedSpikes
        
        function featExtUnsortedSpikes(hSelf,classLabels)
            startingEventOffset=[hSelf.startingEvent,hSelf.startingOffset];
            endingEventOffset = [hSelf.endingEvent,hSelf.endingOffset];
            data=Data(startingEventOffset,endingEventOffset,hSelf.behavioralData,hSelf.neuralSpikesData);
            switch nargin
                case 1
                    [hSelf.extractedFeatures,hSelf.correspondingLabels]=data.featuresVectorsAndLabelsUnsorted();
                case 2
                    [hSelf.extractedFeatures,hSelf.correspondingLabels]=data.featuresVectorsAndLabelsUnsorted(classLabels);
            end            
        end
            
        %FeaturesReduction-------------------------------------------------
              
        
        function getFeaturesRedAlgo(hSelf,selectedFeatRedAlgo)
            hSelf.selectedFeatRedAlgo = selectedFeatRedAlgo;
        end
        
        function getFeatRedParamSettingMod(hSelf,selectedSettingName)
            hSelf.selectedFeatRedParamSettingMode = selectedSettingName;
        end
        
        function featRedPCA(hSelf,varargin)
            featuresMatrix = hSelf.extractedFeatures;%features matrix
            labels = hSelf.correspondingLabels; % labels
            featRedPCA = DimesionalityReduction(featuresMatrix,labels);%object for Dimensionality reduction class
           
            switch nargin
                case 1 %default setting for parameters
                    [hSelf.trainingData,hSelf.validationData]=featRedPCA.PCADimRed();
                case 3 %customize setting for algorithm
                    var=varargin{1};
                    trainRatio= varargin{2};
                    [hSelf.trainingData,hSelf.validationData]=featRedPCA.PCADimRed('variability',var,'trainingratio',trainRatio);
            end      
        end
        
        function plotReducedFeaturesPCA(hSelf,plotingDimension)
            featuresMatrix = hSelf.extractedFeatures;%features matrix
            labels = hSelf.correspondingLabels; % labels
            featRedPCA = DimesionalityReduction(featuresMatrix,labels);%object for Dimensionality reduction class
            PCAVisTrainData(featRedPCA,plotingDimension);                            
        end
        
      %--------------------------------------------------------------------
       %------------------------Decoder------------------------------------
       %-------------------------------------------------------------------
       
       % Here, the role of controller would be, for example, check the selected
       % features extraction algo (using switch, case) and call the appropriate 
       % function from model class that will then extract features according to 
       % the technique asked by controller appropriate function
       
       %--For View(Listeners)
       function getDecoMod (hSelf,selectedDecoMod)
           hSelf.selectedDecoMod=selectedDecoMod;
       end
       %--For View (Listener)
       function getDecoAlgo(hSelf,selectedDecoAlgo)
           hSelf.selectedDecoAlgo = selectedDecoAlgo ;
       end
       %--For View(Listener)
       function getTrainDecoParamSettingMod(hSelf,selectedTrainDecoParamSettingMod)
           hSelf.selectedTrainDecoParamSettingMode=selectedTrainDecoParamSettingMod;
       end
       
      
       
       %------TrainDecoder-------------------------------------------------
       
       function trainNeuralNetworksC(hSelf,varargin)
           switch nargin
               case 1
                   nnDec=Decoder.NeuralNetworks();
                   [hSelf.trainedNNObject,hSelf.recordTrainedNNObject]=nnDec.train(hSelf.trainingData,hSelf.validationData);
               case 2
                   layers=varargin{1};
                   nnDec=Decoder.NeuralNetworks('layers',layers);
                   [hSelf.trainedNNObject,hSelf.recordTrainedNNObject]=nnDec.train(hSelf.trainingData,hSelf.validationData);

           end   
       end
       
       function plotNeuralNetwroksC(hSelf,selectedMetricName)
           switch selectedMetricName
               case 'Accuracy(Train,Val,Test)'
                   figure
                   plotperf(hSelf.recordTrainedNNObject)
                   
                   
               case 'ConfusionMatrix(Train,Val,Test)'
                   Decoder.NeuralNetworks.plotConfusionMatrix(hSelf.trainedNNObject,hSelf.recordTrainedNNObject,hSelf.trainingData)
                   
                   
                   
           end
       end
       
       
       
       %-------------------------------------------------------------------
       %------------------------TestDecoder-Offline------------------------
       %-------------------------------------------------------------------
       
       function setNeuralBehavDataTest(hSelf)
            %First Extract Neural Data
            [fileNameNeuralSpikes,pathNameNeuralSPikes]=uigetfile({'*.mat'},'Neural SPikes Data');
            nsd=strcat(pathNameNeuralSPikes,fileNameNeuralSpikes);
            nsd=load(nsd);
            hSelf.neuralSpikesDataTestOffline=nsd; 
            %get corresponding behavioral data
            [fileNameBehav,pathNameBehav]=uigetfile({'*.mat'},'Behavioral data');
            bd=strcat(pathNameBehav,fileNameBehav);
            bd=load(bd);
            hSelf.behavioralDataTestOffline=bd; 

       end
    end
end