classdef ControllerGUIBCIFW2 < handle
    properties
        model %object of model class
        view % object of view class
    end
    methods
        function hSelf = ControllerGUIBCIFW2(model)
            hSelf.model=model;
            hSelf.view=ViewGUIBCIFW2(hSelf);
        end
        %------------------------------------------------------------------
        %---------------Data Tab-------------------------------------------
        %------------------------------------------------------------------
        function setNeuralSpikesBehavioralData(hSelf)
            hSelf.model.setNeuralSpikesBehavioralData() ;           
        end
        
        function setStartingOffset(hSelf,startingOffset)
            hSelf.model.setStartingOffset(startingOffset);
        end
        function setEndingOffset(hSelf,endingOffset)
            hSelf.model.setEndingOffset(endingOffset);
        end
        function setStartingEvent(hSelf,startingEvent)
            hSelf.model.setStartingEvent(startingEvent);
        end
        
        function setEndingEvent (hSelf,endingEvent)
            hSelf.model.setEndingEvent(endingEvent);
        end
        %------------------------------------------------------------------
        %---------------FeaturesExtraction&Reduction Tab-------------------
        %------------------------------------------------------------------
        
        %FeaturesExtraction Pannel-----------------------------------------
        
        %------------------------------------------------------------------
        function getFeaturesExtAlgo(hSelf,selectedFeatExtAlgo)
            hSelf.model.getFeaturesExtAlgo(selectedFeatExtAlgo);     
        end
        %------------------------------------------------------------------
        function getFeatExtParamSettingMod(hSelf,selectedSettingName)
            hSelf.model.getFeatExtParamSettingMod(selectedSettingName)
        end
        %------------------------------------------------------------------
        function getExtractFeatOffline(hSelf)
            %This function will be called in the callback of 'hPbExtractFeatOffline'
            %Next question is what this function is doing?
            %My answer to this question is:
            %I need to know three things :
            %1)Which feature alogortihm is selected?
            %2)Mode of parmeters setting for feature extraction algortihm
            %3)I also want to know about the selection of classes for which
            %i am responsible for features extraction.
            %The answer to these question are implemented in the logic
            %given below :)
            
            featExtAlgos=get(hSelf.view.gui.hPopupFeatExtOffline,'String');
            selectedAlgoInd=get(hSelf.view.gui.hPopupFeatExtOffline,'Value');
            selectedAlgoName =featExtAlgos{selectedAlgoInd};
            
            classesModes = get(hSelf.view.gui.hPopupClasses,'String');
            selectedClassesModeInd = get(hSelf.view.gui.hPopupClasses,'Value');
            selectedClassesModeName = classesModes{selectedClassesModeInd};
            
            featExtParamModes = get(hSelf.view.gui. hPopupFeatExtParamSettingsModes, 'String');
            selectedFeatExtModeInd = get(hSelf.view.gui. hPopupFeatExtParamSettingsModes, 'Value');
            selectedFeatExtModeName = featExtParamModes {selectedFeatExtModeInd};
            
            switch selectedClassesModeName
                case 'All'
                    switch selectedFeatExtModeName
                        case 'Default'
                            switch selectedAlgoName
                                case 'SortedSpikes'
                                    hSelf.model.featExtSortedSpikes()
                                case 'UnsortedSpikes' 
                                     hSelf.model.featExtUnsortedSpikes()
                                case 'LocalFieldPotential(LFP)'
                                   
                                case 'ConvolutionalStackedAuto-Encoders'
                                otherwise
                                    errordlg('Select Valid Features Extraction algorithm','Features Extraction Algo Error')
                                
                            end %End selectedFeatExtname
                        case 'customize'
                            switch selectedAlgoName
                                case 'SortedSpikes'
                                    
                                case 'UnsortedSpikes'
                                    
                                case 'LocalFieldPotential(LFP)'
                                    
                                case 'ConvolutionalStackedAuto-Encoders'
                            end %End selectedfeatExtname            
                    end %featExtParamModes
                    
                case 'Customize'
                    switch selectedFeatExtModeName
                        case 'Default'
                            switch selectedAlgoName
                                case 'SortedSpikes'
                                    selectedClasees = str2num(get(hSelf.view.gui.hPbClassesGetData,...
                                        'Tag'));
                                    
                                  featExtSortedSpikes(hSelf.model,selectedClasees)
                                  
                                case 'UnsortedSpikes'
                                    selectedClasees = str2num(get(hSelf.view.gui.hPbClassesGetData,...
                                        'Tag'));
                                    
                                    featExtUnsortedSpikes(hSelf.model,selectedClasees)
                                    
                                case 'LocalFieldPotential(LFP)'
                                    
                                case 'ConvolutionalStackedAuto-Encoders'
                                
                            end %End:selectedFeatExtname
                        case 'customize'
                            switch selectedAlgoName
                                case 'SortedSpikes'
                                    
                                case 'UnsortedSpikes'
                                    
                                case 'LocalFieldPotential(LFP)'
                                    
                                case 'ConvolutionalStackedAuto-Encoders'
                            end %End: selectedfeatExtname            
                    end %End: featExtParamModes   
            end %End: classesModes                
        end %End:getExtractFeatOffline
        %------------------------------------------------------------------
        
        %-FeaturesReduction Pannel-----------------------------------------
        
        %------------------------------------------------------------------
        function getFeaturesRedAlgo(hSelf,selectedFeatRedAlgo)
            hSelf.model.getFeaturesRedAlgo(selectedFeatRedAlgo);
        end
        %------------------------------------------------------------------
        function getFeatRedParamSettingMod(hSelf,selectedSettingName)
            hSelf.model.getFeatRedParamSettingMod(selectedSettingName)
        end
        function getReduceFeatOffline(hSelf)
            
            featRedAlgos=get(hSelf.view.gui.hPopupFeatRedOffline,'String');
            selectedAlgoInd=get(hSelf.view.gui.hPopupFeatRedOffline,'Value');
            selectedAlgoName =featRedAlgos{selectedAlgoInd};         
            
            featRedParamModes = get(hSelf.view.gui. hPopupFeatRedParamSettingsModes, 'String');
            selectedFeatRedModeInd = get(hSelf.view.gui. hPopupFeatRedParamSettingsModes, 'Value');
            selectedFeatExtModeName = featRedParamModes {selectedFeatRedModeInd};
            
            switch selectedFeatExtModeName
                case 'Default'
                    switch selectedAlgoName
                        case 'Principal Componenet Analysis(PCA)'
                            
                            featRedPCA(hSelf.model)
                        case 'Independent Component Analysis(ICA)'
                        case 'Restricted Boltzman Machine(RBM)'
                        case 'Auto-Encoders'
                        case 'None'
                    end
                case'Customize'
                    switch selectedAlgoName
                        case 'Principal Componenet Analysis(PCA)'
                            featRedSetting=get(hSelf.view.gui.hPbGetCustomFeatRedParamSetting,'Tag');
                            featRedSetting = str2struct(featRedSetting);
                            paramFeatRed=featRedSetting.ParamSetting;
                            trainingRatio=featRedSetting.DataDistribuitionRatio;
                            
                            paramFeatRed=1-paramFeatRed/100;
                            paramTrainingRatio=trainingRatio/100;
                            
                            featRedPCA(hSelf.model,paramFeatRed,paramTrainingRatio);
                        case 'Independent Component Analysis(ICA)'
                        case 'Restricted Boltzman Machine(RBM)'
                        case 'Auto-Encoders'
                        case 'None'
                    end
                       
            end
            
        end
        
        function plotReducedFeaturesPCA(hSelf)
            plotingModes=get(hSelf.view.gui.hPopupPlotFeatRed,'String');
            selectedModeInd=get(hSelf.view.gui.hPopupPlotFeatRed,'Value');
            selectedMode =plotingModes{selectedModeInd};
            
            
            switch selectedMode
                case 'PCA:2-D'
                    plotReducedFeaturesPCA(hSelf.model,2)
                    
                case 'PCA:3-D'
                    plotReducedFeaturesPCA(hSelf.model,3)
                    
            end
            
        end
        
        %------------------------------------------------------------------
        %--------------------------Decoder Tab-----------------------------
        %------------------------------------------------------------------
        
        function getDecoMod(hSelf,selectedDecoMod)
            hSelf.model.getDecoMod(selectedDecoMod);
        end
        
        function getDecoAlgo(hSelf,selectedDecoAlgo)
            hSelf.model.getDecoAlgo(selectedDecoAlgo);
        end
        
        function getTrainDecoParamSettingMod(hSelf,selectedTrainDecoParamSettingMod)
            hSelf.model.getTrainDecoParamSettingMod(selectedTrainDecoParamSettingMod)
        end
        
        function trainSelectedDecoAlgo(hSelf)
            %This Function will be executed in response to callback
            %function of pushbutton traindecoder:
            
            %To train one particular selected decoder. following
            %inforamtion is required
            %1- Which type of task it is?
            %2- Name of the decoding algo?
            %3- Decoding algo require paramters to train, and there are two
            %possible modes, which type of mode is selected?
            
            %The answer to above raised is given below:
            tasksType = get(hSelf.view.gui.hPopupTaskType,'String');
            selecteTypeInd=get(hSelf.view.gui.hPopupTaskType,'Value');
            selectedTaskType =tasksType{selecteTypeInd};
            
            decoAlgos = get(hSelf.view.gui.hPopupDecoAlgo,'String');
            selectedDecoAlgoInd = get(hSelf.view.gui.hPopupDecoAlgo,'Value');
            selectedDecoAlgo = decoAlgos{selectedDecoAlgoInd};
            
            DecoAlgosParamModes = get(hSelf.view.gui. hPopupTrainDecoParamSettingsModes, 'String');
            selectedDecoAlgoParamtModeInd = get(hSelf.view.gui. hPopupTrainDecoParamSettingsModes, 'Value');
            selectedFeatExtModeName = DecoAlgosParamModes {selectedDecoAlgoParamtModeInd};
            
            %The logic to train selected algo is given below:
            switch selectedTaskType
                case 'Classification'
                    switch selectedFeatExtModeName
                        case 'Default'
                            switch selectedDecoAlgo
                                case 'NeuralNetworksC'                                    
                                    trainNeuralNetworksC(hSelf.model)
                                case 'LinearRegressionC'
                                    msgbox('Only Neural Network for classification mode is ready')
                                case 'LogisticRegressionC'
                                    msgbox('Only Neural Network for classification mode is ready')
                                case 'SupportVectorMachineC'
                                    msgbox('Only Neural Network for classification mode is ready')
                                case 'RandomForestC'
                                    msgbox('Only Neural Network for classification mode is ready')
                                case 'K-NearestNeighboursC'
                                    msgbox('Only Neural Network for classification mode is ready')
                                case 'LinearDiscriminativeClassifierC'
                                    msgbox('Only Neural Network for classification mode is ready')
                            end
                        case 'Customize'
                            switch selectedDecoAlgo
                                case 'NeuralNetworksC'
                                    layers=str2num(get(hSelf.view.gui.hPbGetCustomDecoAlgoParamSetting,'Tag'))
                                    trainNeuralNetworksC(hSelf.model,layers)
                                case 'LinearRegressionC'
                                    msgbox('Only Neural Network for classification mode is ready')
                                case 'LogisticRegressionC'
                                    msgbox('Only Neural Network for classification mode is ready')
                                case 'SupportVectorMachineC'
                                    msgbox('Only Neural Network for classification mode is ready')
                                case 'RandomForestC'
                                    msgbox('Only Neural Network for classification mode is ready')
                                case 'K-NearestNeighboursC'
                                    msgbox('Only Neural Network for classification mode is ready')
                                case 'LinearDiscriminativeClassifierC'
                                    msgbox('Only Neural Network for classification mode is ready')
                            end
                    end
                case 'Regression'
                    switch selectedFeatExtModeName
                        case 'Default'
                            switch selectedDecoAlgo
                                case 'NeuralNetworksR'
                                case 'LinearRegressionR'
                                case 'LogisticRegressionR'
                                case 'RecurrentNeuralNetworks'
                                case 'KalmanFilters'
                            end
                        case 'Customize'
                            switch selectedDecoAlgo
                                case 'NeuralNetworksR'
                                case 'LinearRegressionR'
                                case 'LogisticRegressionR'
                                case 'RecurrentNeuralNetworks'
                                case 'KalmanFilters'
                            end
                    end
            end
        end
        function plotDecoderSelectedPerformanceMeasure(hSelf)
            
            tasksType = get(hSelf.view.gui.hPopupTaskType,'String');
            selecteTypeInd=get(hSelf.view.gui.hPopupTaskType,'Value');
            selectedTaskType =tasksType{selecteTypeInd};
            
            decoAlgos = get(hSelf.view.gui.hPopupDecoAlgo,'String');
            selectedDecoAlgoInd = get(hSelf.view.gui.hPopupDecoAlgo,'Value');
            selectedDecoAlgo = decoAlgos{selectedDecoAlgoInd};
            
            
            switch selectedTaskType
                case 'Classification'
                    evalutionMetrices=get(hSelf.view.gui.hPopupDecoPer,'String');
                    selectedMetricInd=get(hSelf.view.gui.hPopupDecoPer,'Value');
                    selectedMetricName=evalutionMetrices{selectedMetricInd};
                    switch selectedDecoAlgo
                        %--Possible classifiers:
                        case 'NeuralNetworksC'
                            plotNeuralNetwroksC(hSelf.model,selectedMetricName)                            
                        case 'LinearRegressionC'
                            msgbox('Only Neural Network for classification mode is ready')
                        case 'LogisticRegressionC'
                            msgbox('Only Neural Network for classification mode is ready')
                        case 'SupportVectorMachineC'
                            msgbox('Only Neural Network for classification mode is ready')
                        case 'RandomForestC'
                            msgbox('Only Neural Network for classification mode is ready')
                        case 'K-NearestNeighboursC'
                            msgbox('Only Neural Network for classification mode is ready')
                        case 'LinearDiscriminativeClassifierC'
                            msgbox('Only Neural Network for classification mode is ready')
                    end
                    
                    %--Possible Regressors:
                case 'Regression'
                    
                    switch selectedDecoAlgo                       
                        case 'NeuralNetworksR'
                            msgbox('Only Neural Network for classification mode is ready')
                        case 'LinearRegressionR'
                            msgbox('Only Neural Network for classification mode is ready')
                        case 'LogisticRegressionR'
                            msgbox('Only Neural Network for classification mode is ready')
                        case 'RecurrentNeuralNetworks'
                            msgbox('Only Neural Network for classification mode is ready')
                        case 'KalmanFilters'
                            msgbox('Only Neural Network for classification mode is ready')
                    end

            end
                    

                    
            end
            
        %------------------------------------------------------------------
        %-----------------------TestDecoder-Offline------------------------
        %------------------------------------------------------------------
        function setNeuralBehavDataTest(hSelf)
            hSelf.model.setNeuralBehavDataTest();                  
        end
        

        

    end
end