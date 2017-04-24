function varargout = guiBCIGuide(varargin)
% GUIBCIGUIDE MATLAB code for guiBCIGuide.fig
%      GUIBCIGUIDE, by itself, creates a new GUIBCIGUIDE or raises the existing
%      singleton*.
%
%      H = GUIBCIGUIDE returns the handle to a new GUIBCIGUIDE or the handle to
%      the existing singleton*.
%
%      GUIBCIGUIDE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUIBCIGUIDE.M with the given input arguments.
%
%      GUIBCIGUIDE('Property','Value',...) creates a new GUIBCIGUIDE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before guiBCIGuide_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to guiBCIGuide_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help guiBCIGuide

% Last Modified by GUIDE v2.5 20-Feb-2017 14:07:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @guiBCIGuide_OpeningFcn, ...
                   'gui_OutputFcn',  @guiBCIGuide_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before guiBCIGuide is made visible.
function guiBCIGuide_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to guiBCIGuide (see VARARGIN)

% Choose default command line output for guiBCIGuide
handles.output = hObject;
%%%%Features Vectors diasble
set(handles.radSortSpikes,'Enable','Off')
set(handles.radUnsortSpikes,'Enable','Off')
set(handles.radLFP,'Enable','Off')

%Decoder Disable

set(handles.radTrainNN,'Enable','Off')

set(handles.radTestNN,'Enable','Off')

set(handles.radTrainSVM,'Enable','Off')
set(handles.radTestSVM,'Enable','Off')

set(handles.radTrainKNN,'Enable','Off')
set(handles.radTestKNN,'Enable','Off')

%Features Vectors Online Disable
set(handles.radSortSpikesOnline,'Enable','off');
set(handles.radUnsortSpikesOnline,'Enable','off');
set(handles.radLFPOnline,'Enable','off');



% Update handles structure
guidata(hObject, handles);

% UIWAIT makes guiBCIGuide wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = guiBCIGuide_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pbGetData.
function pbGetData_Callback(hObject, eventdata, handles)
% hObject    handle to pbGetData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% [fileNameBehav,pathNameBehav]=uigetfile({'*.mat'},'Behavioral data');
% bd=strcat(pathNameBehav,fileNameBehav);
% 
% 
% [fileNameNeuralSpikes,pathNameNeuralSPikes]=uigetfile({'*.mat'},'Neural SPikes Data');
% nsd=strcat(pathNameNeuralSPikes,fileNameNeuralSpikes);


% startingIndexOffset=[2,0.4];
% endingIndexOffset=[7,0.6];

% defaultans = {'[     ]','[     ]'};
% x = inputdlg({'Starting index and Offset','ending index and Offset'},...
%               'Decoding Index with Offset', [1 50; 1 50],defaultans);
  

          
% startingIndexOffset=str2num(x{1, 1});
% endingIndexOffset=str2num(x{2, 1});
bd='C:\Users\KlaesLab03\Desktop\OneDrive - rub.de\MatlabScripts\PhDStuff\BCIPackages\Data\20131016-115158_rps_01_behav.mat';
nsd='C:\Users\KlaesLab03\Desktop\OneDrive - rub.de\MatlabScripts\PhDStuff\BCIPackages\Data\rps_20131016-115158-NSP1-001.mat';
startingIndexOffset=[2,0.4];
endingIndexOffset=[7,0.6];

handles.data.behavioralData=bd;
handles.data.neuralSpikesData=nsd;
handles.data.startingIndexOffset=startingIndexOffset;
handles.data.endingIndexOffset=endingIndexOffset;
set(handles.radSortSpikes,'Enable','On')%%%
set(handles.radUnsortSpikes,'Enable','On')
% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in radSortSpikes.
function radSortSpikes_Callback(hObject, eventdata, handles)
% hObject    handle to radSortSpikes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radSortSpikes
startingIndexOffset=handles.data.startingIndexOffset;
endingIndexOffset=handles.data.endingIndexOffset;
bd=handles.data.behavioralData;
nsd=handles.data.neuralSpikesData;

data=Data(startingIndexOffset,endingIndexOffset,bd,nsd);
[extractedFeaturesSortedVector,extractedSortedLabels]=data.featuresVectorsAndLabelsSorted();
handles.sortedFeaturesVectorsLabels.featuresVectors = extractedFeaturesSortedVector;
handles.sortedFeaturesVectorsLabels.labels = extractedSortedLabels;
set(handles.radTrainNN,'Enable','On')
%set(handles.radTestNN,'Enable','On')

set(handles.radTrainSVM,'Enable','On')
%set(handles.radTestSVM,'Enable','On')

set(handles.radTrainKNN,'Enable','On')
%set(handles.radTestKNN,'Enable','On')
% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in radUnsortSpikes.
function radUnsortSpikes_Callback(hObject, eventdata, handles)
% hObject    handle to radUnsortSpikes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radUnsortSpikes
startingIndexOffset=handles.data.startingIndexOffset;
endingIndexOffset=handles.data.endingIndexOffset;
bd=handles.data.behavioralData;
nsd=handles.data.neuralSpikesData;
data=Data(startingIndexOffset,endingIndexOffset,bd,nsd);
[extractedFeaturesUnsortedVector,extractedUnSortedLabels]=data.featuresVectorsAndLabelsUnsorted();
handles.unSortedFeaturesVectorsLabels.featuresVectors = extractedFeaturesUnsortedVector;
handles.unSortedFeaturesVectorsLabels.labels = extractedUnSortedLabels;
set(handles.radTrainNN,'Enable','On')
%set(handles.radTestNN,'Enable','On')

set(handles.radTrainSVM,'Enable','On')
%set(handles.radTestSVM,'Enable','On')

set(handles.radTrainKNN,'Enable','On')
%set(handles.radTestKNN,'Enable','On')
% Update handles structure
guidata(hObject, handles);



% --- Executes on button press in radTrainNN.
function radTrainNN_Callback(hObject, eventdata, handles)
% hObject    handle to radTrainNN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radTrainNN
set(handles.radTrainSVM,'Enable','Off');
set(handles.radTestSVM,'Enable','Off');

set(handles.radTrainKNN,'Enable','Off');
set(handles.radTestKNN,'Enable','Off');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
set(handles.radTestNN,'Enable','On');%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
blah=get(handles.bgnFeatExt,'SelectedObject');
selec=get(blah,'Tag');
switch selec
    case'radSortSpikes'
        
        featVectSorted=handles.sortedFeaturesVectorsLabels.featuresVectors;
        labelsSorted=handles.sortedFeaturesVectorsLabels.labels;
        cmpFeatLab=CompatibleFeaturesLabels(featVectSorted,labelsSorted);
        [featSortedNN,labSortedNN]=cmpFeatLab.makeComp4NN();
        [trainingData,testData]=GetTrainingTestData.dataLoader4NN(featSortedNN,labSortedNN);
        %layers=[30,15];
        defaultans = {'[     ]'};
        x = inputdlg({'layers'},...
              'Enter the number neurons per layer', [1 50],defaultans);
        layers=str2num(x{1, 1});
        
        nnDec=Decoder.NeuralNetworks(layers);
        
        
        nnDec.train(trainingData,testData);
        handles.decoders.neuralNetworks=nnDec;
        set(handles.radSortSpikesOnline,'Enable','on')
        guidata(hObject, handles);
        
        
        
    case'radUnsortSpikes'
        
        featVectunSorted=handles.unSortedFeaturesVectorsLabels.featuresVectors;
        labelsunSorted=handles.unSortedFeaturesVectorsLabels.labels;        
        cmpFeatLab=CompatibleFeaturesLabels(featVectunSorted,labelsunSorted);
        [featUnsortedNN,labUnsortedNN]=cmpFeatLab.makeComp4NN();
        [trainingData,testData]=GetTrainingTestData.dataLoader4NN(featUnsortedNN,labUnsortedNN);
        %layers=[30,15];
        defaultans = {'[     ]'};
        x = inputdlg({'layers'},...
              'Enter the number neurons per layer', [1 50],defaultans);
        layers=str2num(x{1, 1});
        
        nnDec=Decoder.NeuralNetworks(layers);
        
        
        nnDec.train(trainingData,testData);
        
        handles.decoders.neuralNetworks=nnDec;
        
        set(handles.radUnsortSpikesOnline,'Enable','on')
        guidata(hObject, handles)
        
        
    case'radLFP'
        msgbox('I am not ready to train :)')
        
    
end
% Update handles structure
guidata(hObject, handles);




% --- Executes on button press in radTrainKNN.
function radTrainKNN_Callback(hObject, eventdata, handles)
% hObject    handle to radTrainKNN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radTrainKNN


% --- Executes on button press in radTestKNN.
function radTestKNN_Callback(hObject, eventdata, handles)
% hObject    handle to radTestKNN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radTestKNN


% --- Executes on button press in radTrainSVM.
function radTrainSVM_Callback(hObject, eventdata, handles)
% hObject    handle to radTrainSVM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radTrainSVM


% --- Executes on button press in radTestSVM.
function radTestSVM_Callback(hObject, eventdata, handles)
% hObject    handle to radTestSVM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radTestSVM


% --- Executes on button press in radTestNN.
function radTestNN_Callback(hObject, eventdata, handles)
% hObject    handle to radTestNN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radTestNN
nnDec=handles.decoders.neuralNetworks;
blah=get(handles.bgpFeatExtOnline,'SelectedObject')
selec=get(blah,'Tag')
switch selec
    case 'radUnsortSpikesOnline'
        testInput=handles.featuresVectorOnline.unsortedSpikes;
        controlSignal=nnDec.test(testInput)
    case 'radSortSpikesOnline'
        disp('I am not ready')
end
% network.test();




% --- Executes on button press in radUnsortSpikesOnline.
function radUnsortSpikesOnline_Callback(hObject, eventdata, handles)
% hObject    handle to radUnsortSpikesOnline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radUnsortSpikesOnline
behavioralData=load(handles.data.behavioralData);
trialStartingIndexOffset=handles.data.startingIndexOffset;
trialEndingIndexOffset=handles.data.endingIndexOffset;
trialNumber=1;
featVect=ExtractFeaturesVectorOnline(behavioralData,trialNumber,trialStartingIndexOffset,trialEndingIndexOffset);
handles.featuresVectorOnline.unsortedSpikes = featVect.getFeaturesVectorUnsortedOnline();
% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in radSortSpikesOnline.
function radSortSpikesOnline_Callback(hObject, eventdata, handles)
% hObject    handle to radSortSpikesOnline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radSortSpikesOnline


% --- Executes on button press in radLFPOnline.
function radLFPOnline_Callback(hObject, eventdata, handles)
% hObject    handle to radLFPOnline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radLFPOnline
