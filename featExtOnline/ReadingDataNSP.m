classdef ReadingDataNSP
    %Explanation:
    % This class is used to get neuralData streaming from NSP online.
    % There can be different type of neural data that can be extracted.
    % Data can be spikes or continuous
    
    %Obj: Objet of this class is self
    
    %properties:
    %StartingTime. is of data real veluae scalar and the unit of time is
    %seconds
    
    %EndingTime: is of data real veluae scalar and the unit of time is
    %seconds
    
    %Class Methods:
    % gettingSpikesDataNSP:  this function is used to get spiking
    % information between starting and ending time and it will return 
    %spikingActivityTask:
    
    properties
        startingTime
        endingTime
        
    end
    methods
        function self = ReadingDataNSP(startingTime,endingTime)
            self.startingTime=startingTime;
            self.endingTime=endingTime;
        end
        
        function[spikingActivityTask,trialTime] = gettingSpikesDataNSP(self)
            cbmex('open');% Establish the interface between NSP and MATLAB
            cbmex('system','reset')
            time=cbmex('time'); % will give current time of nsp in seconds
            while time < self.startingTime
                time=cbmex('time')
            end
            cbmex('trialconfig', 1); %flush the data cache and and start refiling the cache again with new data
            holdTime=self.endingTime-self.startingTime;%hold time
            pause(holdTime);%pause for the time equal to hold time 
            spikingActivityTask = cbmex('trialdata', 1); %will get the data starting from start time to ending time
            %And 'spikingActivityTask' would be cell array of size 152*7. The number 152 is the number of channels consisiting
            %128 from end amp channels, 16 analog input channels, 4 analog
            %output channels, 2 audio ouptut,digital input and serial
            %input. Each row in this matrix of cells contain the following
            %information 
            % 'channel name', [unclassifiedTimeStampvector],[u1TimeStampsVector]
            %[u2timeStampsVctor],[u3TimeStampsVector],[u4TimeStampsVector],
            %[u5TimeStampsVector]
            trialStartingTime=time;
            trialEndingTime=holdTime+trialStartingTime;
            trialTime=[trialStartingTime,trialEndingTime];
           
            
    
        end
        
    end
    
    
end
