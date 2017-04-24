classdef NeuralNetworks < handle
    %NeuralNetworks
    %Explantion :
    
    %This class is written for the purpose of classification tasks, later
    %on  the functionality of this class will be enhanced and can then be
    %be used for regression or continuose decoding tasks
    
    % This class is the implemention  of feed forward fully connected 
    % neural network and it is using Matlab built in library for 
    %neural networks, However, it is fully customized
    
    %The regularization is perfomred in slightly differnt way by intialzing 
    % ten diffenrent objects of neural network class(bulit-in). The object
    % then trained and object with higest test accuracy is choosen and can
    % be evaluted on un-seen test input
    %
    
    %object:
    
    %properties:
    %paramters: is a struct and has the following field
    
               % layers: will be vector and it will defined the
               % archictecture of network e.g: [20,15] will define two
               % hidden layer fully connected neural network. first hidden
               % layer will have 20 neurons and second hidden layer will
               % have 15 neuron, However, the number of neuron at input
               % layer and outputlayer will be deterimind automatically
               % when an object of neural network is created
               
    %trainingData: is a struct and it has two fields and each field is
    %matrix,named as data and labels
    
               %data: this field will be matrix having dimension m*n and it
               %contain training data
               %m: defines total number of features in one input
               %n: defines total number of inputs 
               %example: 45*20 matrix will have 20 training inputs and each
               %input is 45 dimensional
               
               %labels:this field will be matrix having dimension m*n and
               %it contains labels of training data
               %m: dimesion depends on total number of classes
               %forexample: if we have three classes then  m will be three
               %the value of each row is either zero or 1. 0 represent this
               %particular row doesnot belong to coressponding class of
               %training input and 1 represent this row belongs to
               %correspnding class of training input
               %n: total number of training inputs
               %example: 3*20 matrix will be represent the labels of 3
               %classes for total 20 training examples
               
    %testData: is a struct and it has two fields and each field is
    %matrix,named as data and labels
    
               %data: this field will be matrix having dimension m*n and it
               %contain test data
               %m: defines total number of features in one input
               %n: defines total number of inputs 
               %example: 45*20 matrix will have 20 test inputs and each
               %input is 45 dimensional
               
               %labels:this field will be matrix having dimension m*n and
               %it contains labels of test data
               %m: dimesion depends on total number of classes
               %forexample: if we have three classes then  m will be three
               %the value of each row is either zero or one. 0 reresent this
               %particular row doesnot belong to coressponding class of
               %training input and 1 represent this row belongs to
               %correspnding class of training input
               %n: total number of training inputs
               %example: 3*20 matrix will be represent the labels of 3
               %classes for total 20 training examples
               
               
      %confNet: is an an object of built-in class of neural networks and is
      %property of this network
      % The name 'confNet' corresponds to configured neural network
      % according to the dimension of input and output of input and labels
      % as 'confNet' is an object so it must have properties and the 
      % explantion of each used is explaind in one of class method called
      %feedForward (see feeForward)
       
    
    properties
        %For details read above secetion of properties
        layers
        confNet1 %configured net is an object of neural networks
        trainingRecord
        
    end


    methods
        function self = NeuralNetworks(varargin)
            
            %Constructor:
            %There are two options to set the pramters of neural netwrok:
            %Default
            %Customize:
            %default will be alloted if customize are not provided:
            parameters = struct('layers',[30,15]);
            %This is the default value of layer if needed to be changed can
            %be changed as for example:
            %---NeuralNetworks('layers',[20,8])
            paramtersNames = fieldnames(parameters);
            
            %if paramters are provided from outside:
            
            for pair = reshape(varargin,2,[]) %# pair is {propName;propValue}
                inpName = lower(pair{1}); %# make case insensitive
                if any(cell2mat(strfind(paramtersNames, inpName)))
                    %# overwrite options. If you want you can test for the right class here
                    %# Also, if you find out that there is an option you keep getting wrong,
                    %# you can use "if strcmp(inpName,'problemOption'),testMore,end"-statements
                    parameters.(inpName) = pair{2};
                else
                        error('%s is not a recognized parameter name',inpName)
                end
            end
            
            
            self.layers=parameters.layers;
        end
        
        function [objectNetwork,trainingRecordNetwork]=train(self,trainingData,testData)
            %Explanation: This function is used to trained the neural network with
            % architecture exaplined above
            %input paramters: self
            %self is an object this class
            
            %feed forward will propogate the input in the forward and will 
            %configure(set) the self.confNet1 according to architecture of
            %defined network
            [trainData,trainLabels]=Decoder.NeuralNetworks.makeComp4NN(trainingData.data,trainingData.labels);
            trData.data=trainData;
            trData.labels=trainLabels;
            feedForward(self,trData)
            %The configured networks is then backward propogated to
            %claculate the erros at each layer for each neuron a to 
            %updated weights and biases by using the function
            %scaledConjugateGradBackprop
            
            [tesData,tesLabels]=Decoder.NeuralNetworks.makeComp4NN(testData.data,testData.labels);
            teData.data=tesData;
            teData.labels=tesLabels;
            scaledConjGradBackprop(self,trData,teData);
            objectNetwork = self.confNet1;
            trainingRecordNetwork = self.trainingRecord;
            
            
        end
        
        function predOutput=test(self,X)
            %Explantion: This function is used to evaluate the network
            %input Parameter: 
            %self: object of  this class
            %X:test input 
            %Dimension of test input should be equal to m*1
            % m=total number of features
            %total number of features training input and test input must be
            %same
           predOutput=self.confNet1(X);
        end
        
        

        function feedForward(self,trainingData)
            %Explantion:
            %This function is used to configure the object of class neural 
            %network(built in) and then for forward propogating training and
            %first to train the network and then to evaluate the network
            
            net= patternnet(self.layers); %Creating an object net for feed-forward fully connetced neural network
            featVec=trainingData.data;  %feature vectors
            targets=trainingData.labels;  %labels
            preTrainConfNet=configure(net,featVec,targets); %will configure the object 'net' according to defined input and desired output
            % Initialzing Parametters of configured network
            sizeInputWeightsMatrix=size(preTrainConfNet.IW{1,1}); % Intializing input Weight matrix, connected between 1st hidden layer and input layer
            preTrainConfNet.iw{1,1}=normrnd(0,1.0,sizeInputWeightsMatrix); % normal random distribution
            totalLayers=length(self.layers)+1; % total number of layers including input layer
            for ii=2:1:totalLayers   % intiazing remaining weight matrices of network
                sizeWeightsMatrix_ii =size(preTrainConfNet.LW{ii,ii-1});% calculating the dimension of weight matrix for for hidden layer
                preTrainConfNet.LW{ii,ii-1}=normrnd(0,1,sizeWeightsMatrix_ii);%seeding the weight and biases with standard normal distribution
            end
            for jj=1:1:totalLayers %Initizing biases of network and assigning non linearity to eacl layer
                sizeBiasVector_jj=size(preTrainConfNet.b{jj});%claculating the dimension of biases at every hidden layer and outpur layer
                preTrainConfNet.b{jj}=normrnd(0,1,sizeBiasVector_jj);%seeding the weight and biases with standard normal distribution
                preTrainConfNet.layers{jj}.transferFcn ='tansig';%setting the activation function of each hidden layer to tansig 
                if jj==totalLayers
                    preTrainConfNet.layers{jj}.transferFcn='softmax'; %setting the activation function of last lyaer as 'softamx'
                    %change the activation function t sigmoid, for regression task                                            
                                                                       
                                                                                                                                         
                    
                end
            end
            self.confNet1=preTrainConfNet;%pretrainConfnet: is an object of the class, which is cmpletly customized
            
        end
        function scaledConjGradBackprop(self,trainingData,testData)
            %Explanation : This function will use the self.confnet1
            %property of object and will train ten different result and
            %late update the the property self.confNet1 with highest
            %performing(fully trained) object 

            
            
            x1 = trainingData.data; %train_x
            t1=trainingData.labels; %train_y
            totalNN=10;    %total number neural netwroks created
            netsTrained=cell(1,totalNN); % creating 10 different neural networks
            netTrainingRecord=cell(1,totalNN); %
            self.confNet1.trainparam.showWindow=false;
            self.confNet1.divideParam.trainRatio = 0.8; %training Input ratio
            self.confNet1.divideParam.valRatio = 0.1; %validation ratio
            self.confNet1.divideParam.testRatio = 0.1;%test ratio
            
            for ii=1:totalNN %iterate through one of ten objects everytime
                disp(['Training ' num2str(ii) '/' num2str(totalNN)])
                
                [netsTrained{ii},netTrainingRecord{ii}] =  train(self.confNet1,x1,t1); %training_using_scaled_conjugate_gradient_backpropogation
%                 self.confNet1.divideFcn= 'divideind';
%                 self.confNet1.divideParam.trainInd=netTrainingRecord{ii}.trainInd;
%                 self.confNet1.divideParam.valInd =netTrainingRecord{ii}.valInd;
%                 self.confNet1.divideParam.testInd =netTrainingRecord{ii}.testInd;
            end
            performance = testNetwork(netsTrained,totalNN,testData); %calling the function testNetwork
            [~,selectedNetInd] = max(performance);
            self.confNet1=netsTrained{selectedNetInd};
            self.trainingRecord=netTrainingRecord{selectedNetInd};
            
            
            function performance = testNetwork(netsTrained,totalNN,testData)
                %Explantion:
                %This function will take all the trained models(object) and
                %evaluate each network on unseen test inputs and outputs
                %the performance of every network
                
                %input parameters : 
                %netsTrained: is cell array it contain
                %all the trained objects
                %totalNN:total number of trained objects%notrequired
                %self.testData: is the property that will be used by this
                %function to evallutae the networks
               
                x2 = testData.data; %test_x
                t2=testData.labels;% test_y(true output)
                performance = zeros(1,totalNN);%preallocation
                y2Total = 0; %
                for jj=1:totalNN
                    neti = netsTrained{jj};
                    y2 = neti(x2);
                    performance(jj) = mse(neti,t2,y2);%calculate the mse
                    y2Total = y2Total + y2;
                end
                performance
                y2AverageOutput = y2Total / totalNN;
                perfAveragedOutputs = mse(netsTrained{1},t2,y2AverageOutput)
            end
            
        end

    end

    methods(Static)
        function [compFeatNN,compLabNN] = makeComp4NN(featureVectors,labels)
            %This Function takes as input argumenmts raw extracted features vectors and
            %labesl. And produce features vectors and  labels, which are compitabale with the
            %architecture of neural networks
            totalNumberInputs = length(labels); %total amount of data
            totalClasses=max(labels); % total number of classes(i.e R,P,S=3)
            
            %making the labels compitable with neural network
             compLabNN=zeros(totalClasses,totalNumberInputs);
             for ii=1:totalNumberInputs
                labels_ii=labels(ii);
                compLabNN(labels_ii,ii)=1;
             end
            %each row is an observation
            %each columns is one complete input that can be feeded to neural networks
            
            compFeatNN=featureVectors';
             
            
        end
        function plotConfusionMatrix(confNet1,trainingRecord,trainingData)
        [trainData,trainLabels]=Decoder.NeuralNetworks.makeComp4NN(trainingData.data,trainingData.labels);
        %get the predicted output
        predOutput=confNet1(trainData);
        %getting the trainingInput indices
        trainInd=trainingRecord.trainInd;
        %gettting the testInput  indices
        testInd=trainingRecord.testInd;
        %getting the valdation input indeices
        valInd=trainingRecord.valInd;
        
        %now getting predicted output and true output for training data
        trainDataPredOutput=predOutput(:,trainInd);
        trainDataTrueOutput=trainLabels(:,trainInd);
        %now getting the predicted and true output for test data
        testDataPredOutput=predOutput(:,testInd);
        testDataTrueOutput=trainLabels(:,testInd);
        %now getting the predicted and true output for validation data
        valDataPredOutput = predOutput(:,valInd);
        valDataTrueOutput = trainLabels(:,valInd);
        
%         [testUnseenData,testUnseenLabels]=Decoder.NeuralNetworks.makeComp4NN(testDataUnseen.data,testDataUnseen.labels);
%         predOutputUnseenTest=confNet1(testUnseenData);
        
        figure
        %
        plotconfusion(trainDataTrueOutput,trainDataPredOutput,'Training Data',...
            testDataTrueOutput,testDataPredOutput,'Test Data',...
            valDataTrueOutput,valDataPredOutput,'validation Data', ...
            trainLabels,predOutput,'Overall')
        
        
        
        
        
        end

    end
end


