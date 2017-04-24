classdef DimesionalityReduction
    %This class will contain different algorithm to Reduce the dimension
    %of extracted feature by removing those features which does not
    %contain any pattern or  contain redundant information
    
    %Almost all of the algorithm are unsupervised in nature
    
    %object : object of this class is 'self'
    
    %Properties:
    %1)featuresVectors:
    %Type : matrix ,Dimension =m*n
    %m=Total number of training examples
    %n = Total number of features
    
    
    
    properties (Access=public)
        featuresVectors
        labels
    end
    
    methods
        function self = DimesionalityReduction(featuresVectors,labels)
            %featuresVectors :Type, matrix; Dimension =m*n
            %m=Total number of training examples
            %n = Total number of features
            
            self.featuresVectors = featuresVectors;
            self.labels=labels;
        end
        
        %-------------------PrincipalComponentAnalysis(PCA)----------------
        function [trainingData,testData] = PCADimRed(self,varargin)
            %This function will be used for dimensionality reduction:
            %input paramters :
            %self: it will take object of the class as an input arguments
            %varargin:
            
            %Default setting : if 'varargin' is not present at all.
            options = struct('variability',.10,'trainingratio',.80);
            %--'variability' -- by default it will mainain 90 percent of
            %variablity int the data
            %--'trainingratio' -- by default it will divide the data in two
            % tuples traininidata nad validation data with the ratio of 80 
            % 20 percent
            optionNames = fieldnames(options);
            
            
            %# count arguments
            %nArgs = length(varargin);
            
            for pair = reshape(varargin,2,[]) %# pair is {propName;propValue}
                inpName = lower(pair{1}); %# make case insensitive
                
                if any(cell2mat(strfind(optionNames, inpName)))
                    
                    %# overwrite options. If you want you can test for the right class here
                    %# Also, if you find out that there is an option you keep getting wrong,
                    %# you can use "if strcmp(inpName,'problemOption'),testMore,end"-statements
                    options.(inpName) = pair{2};
                else
                    error('%s is not a recognized parameter name',inpName)
                end
            end
            
            
            totalTrainingExamples = length(self.featuresVectors(:,1));
            %calculate the covriance marix by calling the function
            %'PCACovrainceMatrix', which is a class method defined below
            
            covarianceMatrix = PCACovrainceMatrix(self);
            %Next step is eigen value decomposition of covariance matrix
            %Singular value decomposition is way to calculate eigen value
            %and correspponding eigen vectors
            
            [U,S,V] = svd(covarianceMatrix); %Singular value decomposition
            
            %U:is n*n Matirx: Columns of U matrix are eigen vectors
            %S:is n*n Matrix: matrix will represent the eigne values of the covariance
            %matirx
            %all the eigen value are the diagnol element of  S matrix the
            %magnitude if eigen value represent the importnace of
            %coreeposnding direction, higher value mean the
            %coreesponding eigen vector is important and it capture the
            %reasonable amount of variance
            
            %Next Step , calculate the amount of required eigen vectors that 
            %ecapuslate required amount of  variance in the presented data
            
            sumOfAllPrinCs=sum(diag(S));
            
            diagSElements = diag(S);
            
            var=1;%the maximum amount of loss of variance
            k=1; %Intilizing the required amount of principal components
            
            while var >= options.variability
                sumOfSelectedPrinCs=sum(diagSElements(1:k));
                var=1-sumOfSelectedPrinCs/sumOfAllPrinCs;
                k=k+1;
            end
            
            Ureduce =U(:,1:k); %selecting the 'k' eigen vectors,
            %which contain the amount of the variance you want to capture
            
            featuresVectorsReduceDim=zeros(totalTrainingExamples,k); %pre allocation
            
            for l=1:totalTrainingExamples
                featuresVector_l=self.featuresVectors(l,:);
                featuresVectorDimRed_l = Ureduce'*featuresVector_l';
                featuresVectorDimRed_l= featuresVectorDimRed_l';
                featuresVectorsReduceDim(l,:) = featuresVectorDimRed_l;
                
            end
            % Now calling the static method of class to divide the data in two parts and each part is of type struct 
            [trainingData,testData] = DimesionalityReduction.getTrainingTestdata(featuresVectorsReduceDim,self.labels,options.trainingratio);
        end
            
                                  
        
        function  PCAVisTrainData(self,plotingDimension)
            % This function is used to plot 
            totalTrainingExamples = length(self.featuresVectors(:,1));
            covarianceMatrix = PCACovrainceMatrix(self);
            [U,S,V] = svd(covarianceMatrix); %Singular value decomposition
            
            switch plotingDimension
                case 2
                    k=2;
                    Ureduce=U(:,1:k);
                    featuresVectorsReduceDim=zeros(totalTrainingExamples,k); %pre allocation
                    for l=1:totalTrainingExamples
                        featuresVector_l=self.featuresVectors(l,:);
                        featuresVectorDimRed_l = Ureduce'*featuresVector_l';
                        featuresVectorDimRed_l= featuresVectorDimRed_l';
                        featuresVectorsReduceDim(l,:) = featuresVectorDimRed_l;                        
                    end
                    h=figure
                    gscatter(featuresVectorsReduceDim(:,1),featuresVectorsReduceDim(:,2),self.labels)
                    a=legend;
                    a=a.String;
                    groupsName = cell(length(a),1);
                    %------------------------------------------------------
                    %-----------Here some changes are requiured------------
                    %------------------------------------------------------
                    for k=1:length(a)
                        switch a{k}
                            case '1'
                               groupsName{k}='Rock';
                            case '2'
                                groupsName{k}='Paper';
                            case '3'
                                groupsName{k}='Scissors';      
                        end
                    end
                    
                    switch length(a)
                       case 1
                           legend(groupsName{1})
                       case 2 
                           legend(groupsName{1},groupsName{2})
                       case 3
                           legend (groupsName{1},groupsName{2},groupsName{3})      
                   end
                    
                    %legend('Rock','Paper','Scissors')
                    title('Visualization:2-D')
                    xlabel('Feature 1')
                    ylabel('Feature 2')
                    
                    
                case 3
                    k=3;
                    Ureduce=U(:,1:k);
                    featuresVectorsReduceDim=zeros(totalTrainingExamples,k); %pre allocation
                    for l=1:totalTrainingExamples
                        featuresVector_l=self.featuresVectors(l,:);
                        featuresVectorDimRed_l = Ureduce'*featuresVector_l';
                        featuresVectorDimRed_l= featuresVectorDimRed_l';
                       featuresVectorsReduceDim(l,:) = featuresVectorDimRed_l;                       
                    end
                   x = featuresVectorsReduceDim(:,1);
                   y = featuresVectorsReduceDim(:,2);
                   z = featuresVectorsReduceDim(:,3);
                   uniqueGroups = unique(self.labels); 
                   % RGB values of your favorite colors: 
                   colors = brewermap(length(uniqueGroups),'Set1');
                   % Initialize some axes
                   h=figure;
                   view(3)
                   grid on
                   hold on
                   % Plot each group individually:
                   groupsName = cell(length(uniqueGroups),1);
                   for k = 1:length(uniqueGroups)
                       % Get indices of this particular unique group:
                        ind = self.labels==uniqueGroups(k); 
                        % Plot only this group: 
                        plot3(x(ind),y(ind),z(ind),'.','color',colors(k,:),'markersize',20);
                        switch uniqueGroups(k)
                            case 1
                                groupsName{k}='Rock';
                            case 2
                               
                                groupsName{k}='Paper';
                            case 3                                 
                                groupsName{k}='Scissors';
                        end
                   end
                   switch length(uniqueGroups)
                       case 1
                           legend(groupsName{1})
                       case 2 
                           legend(groupsName{1},groupsName{2})
                       case 3
                           legend (groupsName{1},groupsName{2},groupsName{3})      
                   end
                   title('Visualization:3-D')
                   xlabel('Feature 1')
                   ylabel('Feature 2')
                   zlabel('Feature 3')
                  
                otherwise
                    error('visualization is only possible in 2-d or 3-d')
                    
                    
            end           
            
        end
        
        function covarianceMatrix = PCACovrainceMatrix(self)
            
            %The  function
            totalTrainingExamples = length(self.featuresVectors(:,1));
            totalFeatures=length(self.featuresVectors(1,:));
            %
            %Preprocessing:
            %###MeanNormalization######
            meanFeaturesVectors=zeros(1,totalFeatures);
            %Calculating mean for every features
            for i =1:totalFeatures
                meanFeaturesVectors(i)=mean(self.featuresVectors(:,i));
            end
            %Calculating the mean normalized features-vector
            normalizedFeaturesVectors = zeros(totalTrainingExamples,totalFeatures);
            
            for j = 1:totalTrainingExamples
                normalizedFeaturesVectors(j,:) =self.featuresVectors(j,:) - meanFeaturesVectors;
            end
            
            covarianceMatrix = (1/totalTrainingExamples)* (normalizedFeaturesVectors'*normalizedFeaturesVectors);
        end
        %End-----------------------PCA(Algo)-------------------------------
    end
    methods(Static)
         function[trainingData,testData] = getTrainingTestdata(featuresVectors,labels,varargin)
            %Explanation:The purpose of function is very simple, it
            %will slice matrix feature vectorS and labelos into two chunks
            %training Data and TestData
            
            %input Paramters:
            
            %featureVectors: is (m*n)matrix 
                            %m=total number features vectors
                            %n=total number of features in one feature
                            %vector
            %labels: is (m*1)matrix 
                        %m:labels associated with each features vectors
                       
                        
            %varargin: is optinal paramter and expect scalar real value
                      %forexample: if you wan to  slice your data with 80%
                      %training Data and 20% percent test data. then 
                      %varargin{1}=0.8
            %if optional parameter is not provided then by default data
            %will be ditributed automaticall in 80% training and 20% test
            
            x=featuresVectors; % matrix of all features vectors
            t=labels; %labels
            Q = size(x,1); %total number of inputs
            if length(varargin)>=1
                 Q1 = floor(Q*varargin{1});
                 Q2 = Q-Q1;
            else
                 Q1 = floor(Q*0.80); % total number of inputs selected for training
                Q2 = Q-Q1;  %total_number of inputs seleccted for test purpose
                 
            end
            ind = randperm(Q);%producing 1:Q, random numbers
            ind1 = ind(1:Q1); % first 80% is slected for training
            ind2=ind(Q1+(1:Q2));% rest of 20% is selected for test purpose
            
            trainingData.data = x(ind1,:); %train_x
            trainingData.labels = t(ind1,:);% train_y
            testData.data = x(ind2,:); %test_x
            testData.labels = t(ind2,:);% test_y
            
        end
    end
end