function bciGUI
%Here 'h' is struct and it will hold only handle objects in different fields

%h.figure: is field of struct h and it will hold handle object 'figure'
h.figure=figure; %figure: is a parent nad it will rest of the objects on it

%Now,a push button: the reposnsibilty of push button is to get all the user 
%defined data upon pressing
%lets create a push button

h.pbGetUserData = uicontrol('Parent',h.figure,...
    'Style','pushbutton', ...
    'String','Get Data', ...
    'Units','normalized', ...
    'Position',[0.035,0.5,0.10,0.05]);

%Now We have data; Next steps is to extract different kind of features
%for that, I have Placed button group on the can figure 'h.figure'
% I have populated the struct, Now with another field names as 'h..bgpFeatExtOf'

h.bgpFeatExtOf= uibuttongroup('Parent',h.figure,...
    'Title',' Features Extraction Offline', ...
    'Units','normalized', ...
    'Position',[0.25,0.75,0.15,0.15]);
%Now, I will place all 'radio buttons' on the button group with tag 'h.bgpFeatExtOf'
% one by one for now I have three kinds of features extraction techniques

%1: Extract unsorted spikes features vectors: handle object for this kind of 
%features extraction is 'h.bgpFeatExtOnRadUnsortSpikes'
h.bgpFeatExtOnRadUnsortSpikes=uicontrol('Parent',h.bgpFeatExtOf,... %placed on 'h.bgpFeatExtOf'
    'Style','radiobutton', ... %%it is radio button
    'String','Unsorted Spikes Features', ... %this will be displayed
    'Units','normalized', ... 
    'Position',[0.10,0.75,0.65,0.15]);

%2: Extract sorted spikes features vectors: handle object for this kind of 
%features extraction is 'h.bgpFeatExtOnRadSortSpikes'
h.bgpFeatExtOnRadSortSpikes=uicontrol('Parent',h.bgpFeatExtOf,... 
    'Style','radiobutton', ...
    'String','Sorted Spikes Features', ...
    'Units','normalized', ...
    'Position',[0.10,0.55,0.65,0.15]);

%3:Extract LFP features vectors: handle object for this kind of 
%features extraction is 'h.bgpFeatExtOnRadLFP'

h.bgpFeatExtOnRadLFP=uicontrol('Parent',h.bgpFeatExtOf,...
    'Style','radiobutton', ...
    'String','LFP Features', ...
    'Units','normalized', ...
    'Position',[0.10,0.35,0.65,0.15]);


%Now 'SelctionChangedFCN'  for this button group 'h.bgpFeatExtOf' will be
%called 
set(h.bgpFeatExtOf,'SelectionChangedFcn',{@bgpFeatExtOfflineSelectionChange,h})
                                                
set(h.pbGetUserData,'Callback',{@pbGetUserData,h})

                        
                        
                       
end


function pbGetUserData (hObjet,event,h)
% [fileNameBehav,pathNameBehav]=uigetfile({'*.mat'},'Behavioral data');
% bd=strcat(pathNameBehav,fileNameBehav);
% 
% 
% [fileNameNeuralSpikes,pathNameNeuralSPikes]=uigetfile({'*.mat'},'Neural SPikes Data');
% nsd=strcat(pathNameNeuralSPikes,fileNameNeuralSpikes);
% defaultans = {'[     ]','[     ]'};
% x = inputdlg({'Starting index and Offset','ending index and Offset'},...
%               'Decoding Index with Offset', [1 50; 1 50],defaultans);
  
bd='C:\Users\KlaesLab03\Desktop\OneDrive - rub.de\MatlabScripts\PhDStuff\BCIPackages\Data\20131016-115158_rps_01_behav.mat';
nsd='C:\Users\KlaesLab03\Desktop\OneDrive - rub.de\MatlabScripts\PhDStuff\BCIPackages\Data\rps_20131016-115158-NSP1-001.mat';
startingIndexOffset=[2,0.4];
endingIndexOffset=[7,0.6];
h.data.behavioralData=bd;
h.data.neuralSpikesData=nsd;
h.data.startingIndexOffset=startingIndexOffset;
h.data.endingIndexOffset=endingIndexOffset;        
end


function bgpFeatExtOfflineSelectionChange(source,event,h)
h.bgpFeatExtOf.SelectedObject.String
end



