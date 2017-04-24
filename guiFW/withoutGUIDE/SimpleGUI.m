classdef SimpleGUI < handle
    properties
        hFig % is the canvas
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        hPbData %Pushbutton:For data collection        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        hBgFeatExtOff % is the buttongroup for features extraction(Offline)
        
        hRUnsortSPikes %is the radio button(Unsorted spikes)
        hRSortSpikes % is the radio button (Sorted SPikes)
        hRLFP % is the radip button (LFP)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        hBgFeatRed % is the button group for features selection/reduction/Visualization
        
        hRPCA %is the radio button for PCA
        hRICA % is the radio button for ICA
        hRAutoEnco % is the radio button for auto encoders
        hRNoRed  % is the readio button reresenting features vector without 
                    % features reduction
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        hFigFeatRed %visulaizing the reduced features
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        hPlDeco % is the main pannel for different type of decoders
        %%%%%%%
        hBgNN % is the button group for neural networks
        
        hRTrainNN % is a radio button (train NN)
        hRTestNN % is a radio button (test NN)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        hBgSVM % is the buuton group for SVM, Placed on the decoder pannel'hPlDeco'
        
        hRTrainSVM %is a radio button (train SVM)
        hRTestSVM %is a radio button (test SVM)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        hBgKNN % is the button group for KNN, Placed on the decoder pannel 'hPlDeco'
        
        hRTrainKNN % is a radio button (train KNN)
        hRTestKNN % is a radio button (test KNN)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%
        hFigTrainTestAccu % is a plot for training and test accuracy of decoder
        
        hBgFeatExtOnline % is the button group for online features extraction
        
        hRUnsortSpikesOnline %is the radio button for online unsorted features extraction
        hRSortSpikesOnline % is the radio button for online sortted features extraction
        hRLFPOnline %is the radio button for online LFP features extraction
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        hFigWidth %canvas width
        hFigHeight%canvas height
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        data % is a struct and it will contain the user defined data
        
        dataUnsortedSpikes % is a struct contain two fields features vector and label
        dataSortedSpikes %% is a struct contain two fields features vector and label
        
        decoders %is a struct and it will trained model of all the decoders in it corresponding field
        featuresVectorOnline % is a struct of online features vectors
        
        

        
        
    end
    methods
        function hSelf= SimpleGUI
            hSelf.hFigWidth=0.8;
            hSelf.hFigHeight=0.7;
            hSelf.hFig=figure(...
                'NumberTitle','off',...
                'Name','Simple button group GUI',...
                'Units','normalized', ...
                'Position',[0.05 0.2 hSelf.hFigWidth hSelf.hFigHeight]);
            main(hSelf)
        end
        
        function main(hSelf)
            
            %Push Button
            iconpath='toolbox/matlab/icons/file_open.png';
            useicon=fullfile(matlabroot,iconpath);
            iconlabel=SimpleGUI.iconstring(useicon, 'User defined data');
            hSelf.hPbData=uicontrol('Style','pushbutton');
            set(hSelf.hPbData,'string',iconlabel)
            set(hSelf.hPbData,'unit','norm','position',[0.01,0.484,0.12,0.05],...
                               'FontWeight','bold', ...
                               'FontAngle','italic');
            
%             hSelf.hPbData=uicontrol('Parent', hSelf.hFig, ...
%                 'String','Get User Defined Data', ...
%                 'Style', 'pushbutton', ...
%                 'FontWeight','bold', ...
%                 'FontSize',11,...
%                 'FontAngle','italic', ...
%                 'Units', 'normalized', ...
%                 'Position', [0.01,0.484,0.12,0.05]); %hPbDataCallback
            set(hSelf.hPbData, 'callback', @(src, event) hPbDataCallback(hSelf, src, event));
            
            %Button group
            hSelf.hBgFeatExtOff=uibuttongroup('Parent', hSelf.hFig, ...
                'Title','Offline Features Extraction',...
                'FontAngle','italic', ...
                'FontSize',10.0,...
                'FontWeight','bold',...
                'Units','normalized', ...
                'Position',[0.15,0.55,0.12,0.15]);
            
            
            %Now Radio button for unsorted spikes , placed on the button group
            hSelf.hRUnsortSPikes=uicontrol('Parent', hSelf.hBgFeatExtOff, ...
                'String','UnsortedSpikes', ...
                'Style','radiobutton', ...
                'Units','normalized', ...
                'Value',0.0,...
                'Position',[0.1,0.75,0.7,0.15]);
            set(hSelf.hRUnsortSPikes, 'callback', @(src, event) hRUnsortSPikesCallback(hSelf, src, event));
            
            % Now Radio button for sorted spikes, placed on the button group
            hSelf.hRSortSpikes=uicontrol('Parent',hSelf.hBgFeatExtOff, ...
                'String','SortedSpikes', ...
                'Style', 'radiobutton', ...
                'Units', 'normalized', ...
                'Position', [0.1,0.55,0.7,0.15]);
            
            set(hSelf.hRSortSpikes, 'callback', @(src, event) hRSortSPikesCallback(hSelf, src, event));
            
            %Radio button local field potential(LFP), Placed on the button group
            hSelf.hRLFP=uicontrol('Parent', hSelf.hBgFeatExtOff, ...
                'String','LFP', ...
                'Style','radiobutton', ...
                'Units','normalized', ...
                'Position',[0.1,0.35,0.7,0.15]);
             set(findall(hSelf.hBgFeatExtOff, '-property', 'enable'), 'enable', 'off')
            
            %Features-Reduction: After The process of features extraction
            %Next step could be features reduction
            
            % I have not written the script of any kind of features
            % reduction, however there is a plan, that i will try to reduce
            % the features using different kind of features reduction
            % techniques
            
            %Button group: for different kind of fetaures extraction
            hSelf.hBgFeatRed=uibuttongroup('Parent',hSelf.hFig, ...
                'Title','Features Reduction', ...
                'FontAngle','italic', ...
                'FontSize',10.0, ...
                'FontWeight','bold',...
                'Units','normalized', ...
                'Position',[0.306,0.55,0.1,0.15]);
            
            hSelf.hRPCA=uicontrol('Parent', hSelf.hBgFeatRed, ...
                'String','PCA', ...
                'Style','radiobutton', ...
                'Units','normalized', ...
                'Position',[0.1,0.75,0.5,0.15]);
            
            hSelf.hRICA=uicontrol('Parent', hSelf.hBgFeatRed, ...
                'String','ICA', ...
                'Style','radiobutton', ...
                'Units','normalized', ...
                'Position',[0.1,0.55,0.5,0.15]);
            
            hSelf.hRAutoEnco=uicontrol('Parent', hSelf.hBgFeatRed, ...
                'String','Auto Encoder', ...
                'Style','radiobutton', ...
                'Units','normalized', ...
                'Position',[0.1,0.35,0.75,0.15]);
            
            hSelf.hRNoRed=uicontrol('Parent',hSelf.hBgFeatRed, ...
                'String','None', ...
                'Style','radiobutton', ...
                'Units','normalized', ...
                'Position',[0.1,0.15,0.75,0.15]);
            set(hSelf.hRNoRed, 'callback', @(src, event)hRNoRedCallback(hSelf, src, event));
                                
             set(findall(hSelf.hBgFeatRed, '-property', 'enable'), 'enable', 'off')
            
            
            
            
            %visualizing reduced features :
            hSelf.hFigFeatRed= axes('Units','normalized',...
                'Position',[0.15,0.75,0.25,0.20]);
            %[220,625,434,200]
            
            
            %Next Step:  main Pannel for deocoders
            
            hSelf.hPlDeco = uibuttongroup('Parent',hSelf.hFig, ...
                'Title','Decoders', ...
                'FontSize',13,...
                'FontAngle','italic', ...
                'FontWeight','bold', ...
                'Position',[0.47,0.37,0.19,0.35]);
            
            
            
            %Radio Pannel for neural networks placed in the  in the main
            % pannel
            
            hSelf.hBgNN=uibuttongroup('Parent',hSelf.hPlDeco, ...
                'Title','Neural Networks',...
                'FontAngle','italic',...
                'FontSize',10,...
                'FontWeight','bold',...
                'Units','normalized', ...
                'Position',[0.15,0.67,0.75,0.30]);
            
            
            %Radio button for train neural network
            
            
            hSelf.hRTrainNN=uicontrol('Parent',hSelf.hBgNN, ...
                'String','Train NN', ...
                'Style', 'radiobutton', ...
                'Units', 'normalized', ...
                'Position', [0.1,0.65,0.75,0.30]);
            
            set(hSelf.hRTrainNN, 'callback', @(src, event) hRTrainNNCallback(hSelf, src, event));
            
            %Radio button for test Neural networks
            
            hSelf.hRTestNN=uicontrol('Parent',hSelf.hBgNN, ...
                'String','Test NN', ...
                'Style', 'radiobutton', ...
                'Units', 'normalized', ...
                'Position', [0.1,0.30,0.75,0.30]);
            set(hSelf.hRTestNN, 'callback', @(src, event) hRTestNNCallback(hSelf, src, event));
            
            %Radio Pannel for SVM placed in the  in the main
            % pannel
            
            hSelf.hBgSVM=uibuttongroup('Parent',hSelf.hPlDeco, ...
                'Title','SVM',...
                'FontAngle','italic', ...
                'FontWeight','bold', ...
                'FontSize',10, ...
                'Units','normalized', ...
                'Position',[0.15,0.37,0.75,0.30]);
            
            %Radio button for SVM
            
            hSelf.hRTrainSVM=uicontrol('Parent',hSelf.hBgSVM, ...
                'String','Train SVM', ...
                'Style', 'radiobutton', ...
                'Units', 'normalized', ...
                'Position', [0.1,0.65,0.75,0.25]);
            
            %Radio button for test SVM
            
            hSelf.hRTestNN=uicontrol('Parent',hSelf.hBgSVM, ...
                'String','Test SVM', ...
                'Style', 'radiobutton', ...
                'Units', 'normalized', ...
                'Position', [0.1,0.30,0.75,0.25]);
            
            
            %Radio button group for KNNs placed on the main pannel(Decoder
            % pannel)
            
            hSelf.hBgKNN=uibuttongroup('Parent',hSelf.hPlDeco, ...
                'Title','K-NNs',...
                'FontAngle','italic',...
                'FontWeight','bold', ...
                'FontSize',10,...
                'Units','normalized', ...
                'Position',[0.15,0.07,0.75,0.30]);
            
            %Radio button for train KNNs
            
            hSelf.hRTrainSVM=uicontrol('Parent',hSelf.hBgKNN, ...
                'String','Train K-NNs', ...
                'Style', 'radiobutton', ...
                'Units', 'normalized', ...
                'Position', [0.1,0.65,0.75,0.25]);
            
            %Radio button for test SVM
            
            hSelf.hRTestNN=uicontrol('Parent',hSelf.hBgKNN, ...
                'String','Test K-NNs', ...
                'Style', 'radiobutton', ...
                'Units', 'normalized', ...
                'Position', [0.1,0.30,0.75,0.25]);
            
            
            set(findall(hSelf.hPlDeco, '-property', 'enable'), 'enable', 'off')
            
           %ploting Test and training accuracy
           
           hself.hFigTrainTestAccu =axes('Units','normalized',...
                'Position',[0.7,0.4,0.25,0.25]);
            
            %Button group for featture extraction(Online)
            
            
            hSelf.hBgFeatExtOnline=uibuttongroup('Parent',hSelf.hFig,...
                'Title','Online Features Extraction',...
                'FontAngle','italic', ...
                'FontSize',10, ...
                'FontWeight','bold', ...
                'Units','normalized',...
                'Position',[0.15,0.30,0.12,0.15]);
%             set(hSelf.hBgFeatExtOnline, 'SelectionChangedFcn', @(src, event) hBgFeatExtOnlineSelectionChangedFcn(hSelf, src, event));
            
            
            %Radio Button for online unsorted features vectors
            
            hSelf. hRUnsortSpikesOnline = uicontrol('Parent',hSelf.hBgFeatExtOnline, ...
                'Style','radiobutton', ...
                'String','UnsortedSpikes', ...
                'Units','normalized', ...
                'Position',[0.1,0.75,0.70,0.15] );
             set(hSelf.hRUnsortSpikesOnline, 'callback', @(src, event) hRUnsortSpikesOnlineCallback(hSelf, src, event));
            
            %Radio button for online sorted features vectors
            hSelf.hRSortSpikesOnline = uicontrol('Parent', hSelf.hBgFeatExtOnline, ...
                'Style','radiobutton', ...
                'String','SortedSpikes', ...
                'Units','normalized', ...
                'Position',[0.1,0.55,0.70,0.15]);
            
            
            %Radio button for online LFP features Extraction
            
            hSelf.hRLFPOnline=uicontrol('Parent', hSelf.hBgFeatExtOnline, ...
                'Style','radiobutton', ...
                'String', 'LocalFieldPotential', ...
                'Units','normalized', ...
                'Position',[0.1,0.35,0.80,0.15]);
            
            %Now,i will disable all the defoned handle objects
            
            set(findall(hSelf.hBgFeatExtOnline, '-property', 'enable'), 'enable', 'off')
            

            
            
            
            
            
        end
        function hPbDataCallback(hSelf,src, event)

            [fileNameBehav,pathNameBehav]=uigetfile({'*.mat'},'Behavioral data');
            bd=strcat(pathNameBehav,fileNameBehav);
            
            [fileNameNeuralSpikes,pathNameNeuralSPikes]=uigetfile({'*.mat'},'Neural SPikes Data');
            nsd=strcat(pathNameNeuralSPikes,fileNameNeuralSpikes);
            
            defaultans = {'[     ]','[     ]'};
            x = inputdlg({'Starting index and Offset','ending index and Offset'},...
                'Decoding Index with Offset', [1 50; 1 50],defaultans);
            
            startingIndexOffset=str2num(x{1, 1});
            endingIndexOffset=str2num(x{2, 1});

%             
%             bd='C:\Users\KlaesLab03\Desktop\OneDrive - rub.de\MatlabScripts\PhDStuff\BCIPackages\Data\20131016-115158_rps_01_behav.mat';
%             nsd='C:\Users\KlaesLab03\Desktop\OneDrive - rub.de\MatlabScripts\PhDStuff\BCIPackages\Data\rps_20131016-115158-NSP1-001.mat';
%             startingIndexOffset=[2,0.4];
%             endingIndexOffset=[7,0.6];
            
            hSelf.data.behavioralData=bd;
            hSelf.data.neuralSpikesData=nsd;
            hSelf.data.startingIndexOffset=startingIndexOffset;
            hSelf.data.endingIndexOffset=endingIndexOffset;
            
            set(findall(hSelf.hBgFeatExtOff, '-property', 'enable'), 'enable', 'on')
            

            
            %
        
        end
        function hRUnsortSPikesCallback(hSelf, src, event)
            startingIndexOffset=hSelf.data.startingIndexOffset;
            endingIndexOffset=hSelf.data.endingIndexOffset;
            bd=hSelf.data.behavioralData;
            nsd=hSelf.data.neuralSpikesData;
            featLabUnsort=Data(startingIndexOffset,endingIndexOffset,bd,nsd);
            [trainingDataUnsorted,testDataUnsorted]=featLabUnsort.featuresVectorsAndLabelsUnsorted();
            hSelf.dataUnsortedSpikes.trainingData = trainingDataUnsorted;
            hSelf.dataUnsortedSpikes.testData = testDataUnsorted;
            
            set(findall(hSelf.hBgFeatRed, '-property', 'enable'), 'enable', 'on')

            
        end
        
        function hRSortSPikesCallback(hSelf, src, event)
            startingIndexOffset=hSelf.data.startingIndexOffset;
            endingIndexOffset=hSelf.data.endingIndexOffset;
            bd=hSelf.data.behavioralData;
            nsd=hSelf.data.neuralSpikesData;
            featLabSort=Data(startingIndexOffset,endingIndexOffset,bd,nsd);
            [trainingDataSorted,testDataSorted]=featLabSort.featuresVectorsAndLabelsSorted();
            hSelf.dataSortedSpikes.trainingData = trainingDataSorted;
            hSelf.dataSortedSpikes.testData = testDataSorted;
            
            set(findall(hSelf.hBgFeatRed, '-property', 'enable'), 'enable', 'on')

            
            
        end
        function hRNoRedCallback(hSelf, src, event)
            
            set(findall(hSelf.hPlDeco, '-property', 'enable'), 'enable', 'on')
        
        end
        
        
        function hRTrainNNCallback(hSelf, src, event)
            blah = get(hSelf.hBgFeatRed,'SelectedObject');
            featRed=get(blah,'String');
            switch featRed
                case 'None'
                    blah1=get(hSelf.hBgFeatExtOff,'SelectedObject');
                    featExt=get(blah1,'String');
                    switch featExt
                        case 'UnsortedSpikes'
                            trainingData=hSelf.dataUnsortedSpikes.trainingData;
                            testData=hSelf.dataUnsortedSpikes.testData;
                            %cmpFeatLab=CompatibleFeaturesLabels(trainingData,testData);
                            %[featUnsortedNN,labUnsortedNN]=cmpFeatLab.makeComp4NN();
                            %[trainingData,testData]=GetTrainingTestData.dataLoader4NN(featUnsortedNN,labUnsortedNN);
%                             layers=[30,15];
                            defaultans = {'[     ]'};
                            x = inputdlg({'layers'},...
                                'Enter the number neurons per layer', [1 50],defaultans);
                            
                            layers=str2num(x{1, 1});
                            
                            nnDec=Decoder.NeuralNetworks(layers);
                            nnDec.train(trainingData,testData);
                            hSelf.decoders.neuralNetworks = nnDec;

                            set(hSelf.hRSortSpikesOnline,'Enable','off')
                            set(hSelf.hRLFPOnline,'Enable','off')
                            set(hSelf.hRUnsortSpikesOnline,'Enable','on')
                            
                            
                        case 'SortedSpikes'
                            trainingData =  hSelf.dataSortedSpikes.trainingData;
                            testData = hSelf.dataSortedSpikes.testData;
                            %cmpFeatLab=CompatibleFeaturesLabels(featVectSorted,labelsSorted);
                            %[featUnsortedNN,labUnsortedNN]=cmpFeatLab.makeComp4NN();
                            %[trainingData,testData]=GetTrainingTestData.dataLoader4NN(featUnsortedNN,labUnsortedNN);
                            layers=[30,15];
%                             defaultans = {'[     ]'};
%                             x = inputdlg({'layers'},...
%                                 'Enter the number neurons per layer', [1 50],defaultans);
%                             
%                             layers=str2num(x{1, 1});
                            nnDec=Decoder.NeuralNetworks(layers);
                            nnDec.train(trainingData,testData);
                            hSelf.decoders.neuralNetworks = nnDec;
                            
                            set(hSelf.hRSortSpikesOnline,'Enable','on')
                            set(hSelf.hRLFPOnline,'Enable','off')
                            set(hSelf.hRUnsortSpikesOnline,'Enable','off')
                            
                        case 'LFP'
                            
                            
                    end
                case 'Auto Encoder'
                    msgbox('I am not Ready, Please include me in the game later')
                case'PCA'
                    msgbox('I am not Ready, Please include me in the game later')
                case'ICA'
                    msgbox('I am not Ready, Please include me in the game later')
            end

            
        end
        
        function hRUnsortSpikesOnlineCallback(hSelf, src, event)
            trialNumber=1;
            behavioralData=load(hSelf.data.behavioralData);
            trialStartingIndexOffset=hSelf.data.startingIndexOffset;
            trialEndingIndexOffset=hSelf.data.endingIndexOffset;
            blah=get(hSelf.hBgFeatRed,'SelectedObject');
            featRedTech=get(blah,'String');
            switch featRedTech
                case 'None'

                    featVect=ExtractFeaturesVectorOnline(behavioralData,trialNumber,trialStartingIndexOffset,trialEndingIndexOffset);
                    hSelf.featuresVectorOnline.unsortedSpikes = featVect.getFeaturesVectorUnsortedOnline();
                case 'PCA'
                    disp('PCA')
                case 'ICA'
                    disp('ICA')
                case 'Auto Encoder'
                    disp('auto encoder')
            end                            
            
        end %End Function 
        
        function hRTestNNCallback(hSelf, src, event)
            nnModel=hSelf.decoders.neuralNetworks;
            blah=get(hSelf.hBgFeatExtOnline,'SelectedObject');
            selec=get(blah,'String');
            switch selec
                case 'UnsortedSpikes'
                    testInput=hSelf.featuresVectorOnline.unsortedSpikes;
                    controlSignal=nnModel.test(testInput)
                    
                case 'SortedSpikes'
                case'LocalFieldPotential'
                
            end
        end
        function delete(hSelf)
            if ~isempty(hSelf.hFig) && ishandle(hSelf.hFig)
                close(hSelf.hFig);
            end
        end % END function delete
    end %End class Methods
    
    
    
    methods(Static)
        function iconlabel=iconstring(iconpath,text)
            %Input: icon path. Icons installed with Matlab are recommended. These icons
            %are saved in several matlab directories. 
            %Input: text: String that show label of Matlab UI components
            %output: Icon and string in html format
            fontcolor='black';
            iconTxt=sprintf('<html><img src="file:/%s" height=%d width=%d/>',iconpath,16,16); %Icon size 16px x 16px. 
            msgTxt = ['&nbsp;<font color=',fontcolor,'>',text,'</font>'];
            iconlabel = [iconTxt,msgTxt];
        end
    end
end %End Class


