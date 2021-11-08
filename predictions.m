function [results] = predictions(MLdata, TRIAdata)

% indl = 40% dataset for learners training
% indm = 40% dataset for meta-learners training
% indp = 20% dataset for validation
% learnersV = number of ML's
% learners -> function with ML's
% metaLearnersV = number of meta-learners
% metaLearners -> function with meta-learners
% triangulationMethodsV = number of triangulation methods
% triangulationMethods = function with the triangulation methods

% Para normalizar os dados    
for i = 1:length(MLdata(1,:))
    MLdatan(:,i) = ((MLdata(:,i) - min(MLdata(:,i)))/(max(MLdata(:,i)) - min(MLdata(:,i)))) * 0.6 + 0.2;%normalizaçao dos dados, para que todos os dados tenham o mesmo peso
end
for i = 1:length(TRIAdata(1,:))
    TRIAdatan(:,i) = ((TRIAdata(:,i) - min(TRIAdata(:,i)))/(max(TRIAdata(:,i)) - min(TRIAdata(:,i)))) * 0.6 + 0.2;%normalizaçao dos dados, para que todos os dados tenham o mesmo peso
end

indl = 1:(round(size(MLdatan,1)*0.4));
indm = (round(size(MLdatan,1)*0.4)):(round(size(MLdatan,1)*0.8));
indp = (round(size(MLdatan,1)*0.8)):(round(size(MLdatan,1)*1));
learnersV = 3;
metaLearnersV = 3;
triangulationMethodsV = 5;
M1=[];
P1=[];
finalLevel = [];

    for i=1:(metaLearnersV)
        for j=1:(learnersV)
            [l,c]=size(MLdatan);
            for k=4%(c-3)
                L = mlData(k,MLdatan(indl,:));
                M = mlData(k,MLdatan(indm,:));
                P = mlData(k,MLdatan(indp,:));
                model = learners(j,L);
                [~,colunas] = size(M);
                switch (j)
                    case 1
                        M1 = [M1;M(:,(colunas-3):(colunas-1)) predict(model,M(:,1:(colunas-1)))];
                        P1 = [P1;P(:,(colunas-3):(colunas-1)) predict(model,P(:,1:(colunas-1)))];
                    case 2
                        M1 = [M1;M(:,(colunas-3):(colunas-1)) model(M(:,1:(colunas-1))')'];
                        P1 = [P1;P(:,(colunas-3):(colunas-1)) model(P(:,1:(colunas-1))')'];
                    case 3
                        M1 = [M1;M(:,(colunas-3):(colunas-1)) predict(model,M(:,1:(colunas-1)))];
                        P1 = [P1;P(:,(colunas-3):(colunas-1)) predict(model,P(:,1:(colunas-1)))];
                end
            end 
        end
        T1 = TRIAdatan(indm,:);
        T2 = TRIAdatan(indp,:);
        for t=1:triangulationMethodsV 
            M1 = [M1; triangulationMethods(t,T1)];
            P1 = [P1; triangulationMethods(t,T2)];
        end
        
        metaModel = metaLearners(i,M1);
        
        switch (i)
            case 1
                finalLevel = [finalLevel;P(:,1:3) predict(metaModel,P(:,1:3))];
                
            case 2
                finalLevel = [finalLevel;P(:,1:3) metaModel(P(:,1:3)')'];
                
            case 3
                finalLevel = [finalLevel;P(:,1:3) predict(metaModel,P(:,1:3))];
                
        end
         
        
%         eQM = sum

    end

end