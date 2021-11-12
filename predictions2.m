function [results] = predictions2(MLdata, TRIAdata)

% indl = 40% dataset for learners training
% indm = 40% dataset for meta-learners training
% indp = 20% dataset for validation
% learnersV = number of ML's
% learners -> function with ML's
% metaLearnersV = number of meta-learners
% metaLearners -> function with meta-learners
% triangulationMethodsV = number of triangulation methods
% triangulationMethods = function with the triangulation methods

cidade = 'ouricuriTRI2';

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
learnersV = 2;
metaLearnersV = 2;
triangulationMethodsV = 5;
M1=[];
P1=[];
finalLevel = [];

for index=1:4
        for i=1:(metaLearnersV)
            for j=1:(learnersV)
                [l,c]=size(MLdatan);
                for k=1
                    L = mlData(index,MLdatan(indl,:));
                    M = mlData(index,MLdatan(indm,:));
                    P = mlData(index,MLdatan(indp,:));
                    model = learners(j,L);
                    [~,colunas] = size(M);
                    switch (j)
                        case 1
                            M1 = [M1;M(:,(colunas-3):(colunas-1)) predict(model,M(:,1:(colunas-1)))];
%                             P1 = [P1;P(:,(colunas-3):(colunas-1)) predict(model,P(:,1:(colunas-1)))];
                        case 2
                            M1 = [M1;M(:,(colunas-3):(colunas-1)) model(M(:,1:(colunas-1))')'];
%                             P1 = [P1;P(:,(colunas-3):(colunas-1)) model(P(:,1:(colunas-1))')'];
%                         case 3
%                             M1 = [M1;M(:,(colunas-3):(colunas-1)) predict(model,M(:,1:(colunas-1)))];
%                             P1 = [P1;P(:,(colunas-3):(colunas-1)) predict(model,P(:,1:(colunas-1)))];
                    end
                end 
                
            end
            T1 = TRIAdatan(indm,:);
            T2 = TRIAdatan(indp,:);
            for t=1:triangulationMethodsV 
                M1 = [M1; triangulationMethods(t,T1,index)];
%                 P1 = [P1; triangulationMethods(t,T2)];
            end
            
            M11 = janelaDeslizante(M1,4);
            P11 = janelaDeslizante(P,4);
            
            for contador = 1:30
                metaModel = metaLearners(i,M11);
                finalLevel = [];
                [~,colunas] = size(P11);
                switch (i)
                    case 1
                        finalLevel = [P11(:,(colunas-3):(colunas-1)) predict(metaModel,P11(:,1:(colunas-1)))];

                    case 2
                        finalLevel = [P11(:,(colunas-3):(colunas-1)) metaModel(P11(:,1:(colunas-1))')'];
    % 
    %                 case 3
    %                     finalLevel = [finalLevel;P11(:,(colunas-3):(colunas-1)) predict(metaModel,P11(:,1:(colunas-1)))];

                end

                eQM(contador) = 0;
                [l,c]=size(finalLevel);
                 for i_erro=1:length(finalLevel)

                     eQM_aux(i_erro) = (finalLevel(i_erro,c)-P11(i_erro,colunas))^2;
                     em_aux(i_erro) = abs(finalLevel(i_erro,c)-P11(i_erro,colunas))/P11(i_erro,colunas);

                 end
                  erro(contador,:)= [mean(eQM_aux) mean(em_aux)];
                  clear metaModel;
                  eQM_aux=[];
                  em_aux=[];
            end
              
              M1=[];
              P1=[];
              
              switch (index)
                  case 1
                      if i == 1
                        xlswrite(strcat(cidade,'metaTBprecipitacao'),erro);

                      else 
                        xlswrite(strcat(cidade,'metaNNprecipitacao'),erro);
                      end
                      
                  case 2
                      if i == 1
                        xlswrite(strcat(cidade,'metaTBtmax'),erro);

                      else 
                        xlswrite(strcat(cidade,'metaNNtmax'),erro);
                      end
                      
                  case 3
                      if i == 1
                        xlswrite(strcat(cidade,'metaTBtmin'),erro);

                      else 
                        xlswrite(strcat(cidade,'metaNNtmin'),erro);
                      end
                      
                  case 4
                      if i == 1
                        xlswrite(strcat(cidade,'metaTBumidadeRelativa'),erro);

                      else 
                        xlswrite(strcat(cidade,'metaNNumidadeRelativa'),erro);
                      end
              end
                      
            
        end
end
    
end