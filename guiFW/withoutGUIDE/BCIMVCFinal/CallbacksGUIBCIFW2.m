classdef CallbacksGUIBCIFW2 < handle
    methods(Static)
        function hPopupDecoAlgoCallback(hSelf)
             Algos=get(hSelf.hPopupDecoAlgo,'String');
            selectedAlgoIndex=get(hSelf.hPopupDecoAlgo,'Value');
            
            selectedAlgo=Algos{selectedAlgoIndex};
            
            switch selectedAlgo
                case Algos{1}
                    set(hSelf.hEditParamLayersNNC,...
                        'Visible','on')
                    set(hSelf.hTxtParamLayersNNC,...
                        'Visible','on')
                    %%Please add further cases later on
            end
        
        end
        
        function hPopupEvalModeCallback(hSelf)
            evalModes = get(hSelf.hPopupEvalMode,'String');
            selectedEvalModeInd=get(hSelf.hPopupEvalMode,'Value');
            selectedEvalMode=evalModes{selectedEvalModeInd};
            
            switch selectedEvalMode
                case evalModes{1}
                    set(hSelf.hTxtTimeStampDataEvalOnline,...
                        'Visible','on')
                    set(hSelf.hTxtTimeStampDispDataEvalOnline, ...
                        'Visible','on')
                    set(hSelf.hTxtSystemLagDataEvalOnline, ...
                        'Visible','on')
                    set(hSelf.hTxtSytemDispDataEvalOnline, ...
                        'Visible','on')
                    
                    set(hSelf.hTxtNeuralBehavDataEvalOffline,...
                        'Visible','off')
                    set(hSelf.hPbNeuralBehavDataEvalOffline,...
                        'Visible','off')
                    set(hSelf.hTxtTrialIndEvalOffline,...
                        'Visible','off')
                    set(hSelf.hEditTrialIndEvalOffline,...
                        'Visible','off')

                    
                    
                    
                    
                case evalModes{2}
                    
                    set(hSelf.hTxtTimeStampDataEvalOnline,...
                        'Visible','off')
                    set(hSelf.hTxtTimeStampDispDataEvalOnline, ...
                        'Visible','off')
                    set(hSelf.hTxtSystemLagDataEvalOnline, ...
                        'Visible','off')
                    set(hSelf.hTxtSytemDispDataEvalOnline, ...
                        'Visible','off')
                    
                    set(hSelf.hTxtNeuralBehavDataEvalOffline,...
                        'Visible','on')
                    set(hSelf.hPbNeuralBehavDataEvalOffline,...
                        'Visible','on')
                    set(hSelf.hTxtTrialIndEvalOffline,...
                        'Visible','on')
                    set(hSelf.hEditTrialIndEvalOffline,...
                        'Visible','on')
            end
            
            
        end

    end
end