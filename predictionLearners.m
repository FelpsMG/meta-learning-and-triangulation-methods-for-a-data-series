function [results] = predictionsLearners(MLdata)

% indl = 40% dataset for learners training
% indm = 40% dataset for aprendiz-learners training
% indp = 20% dataset for validation
% learnersV = number of ML's
% learners -> function with ML's
% learnersV = number of aprendiz-learners
% learners -> function with aprendiz-learners
% triangulationMethodsV = number of triangulation methods
% triangulationMethods = function with the triangulation methods

cidade = 'bhTRI1';

% Para normalizar os dados    
for i = 1:length(MLdata(1,:))
    MLdatan(:,i) = ((MLdata(:,i) - min(MLdata(:,i)))/(max(MLdata(:,i)) - min(MLdata(:,i)))) * 0.6 + 0.2;%normalizaçao dos dados, para que todos os dados tenham o mesmo peso
end

indl = 1:(round(size(MLdatan,1)*0.7));
indp = (round(size(MLdatan,1)*0.7)):(round(size(MLdatan,1)*1));
learnersV = 2;
M1=[];
P1=[];
finalLevel = [];

for index=1:4
        for i=1:(learnersV)
            
            L = mlData(index,MLdatan(indl,:));
            P = mlData(index,MLdatan(indp,:));
                   
            
            for contador = 1:30
                model = learners(i,L);
                finalLevel = [];
                [~,colunas] = size(P);
                switch (i)
                    case 1
                        finalLevel = [P(:,(colunas-3):(colunas-1)) predict(model,P(:,1:(colunas-1)))];

                    case 2
                        finalLevel = [P(:,(colunas-3):(colunas-1)) model(P(:,1:(colunas-1))')'];
    % 
    %                 case 3
    %                     finalLevel = [finalLevel;P(:,(colunas-3):(colunas-1)) predict(model,P(:,1:(colunas-1)))];

                end

                eQM(contador) = 0;
                [l,c]=size(finalLevel);
                 for i_erro=1:length(finalLevel)

                     eQM_aux(i_erro) = (finalLevel(i_erro,c)-P(i_erro,colunas))^2;
                     em_aux(i_erro) = abs(finalLevel(i_erro,c)-P(i_erro,colunas))/P(i_erro,colunas);

                 end
                  erro(contador,:)= [mean(eQM_aux) mean(em_aux)];
                  clear model;
                  eQM_aux=[];
                  em_aux=[];
            end
              
              M1=[];
              P1=[];
              
              switch (index)
                  case 1
                      if i == 1
                        xlswrite(strcat(cidade,'aprendizTBprecipitacao'),erro);

                      else 
                        xlswrite(strcat(cidade,'aprendizNNprecipitacao'),erro);
                      end
                      
                  case 2
                      if i == 1
                        xlswrite(strcat(cidade,'aprendizTBtmax'),erro);

                      else 
                        xlswrite(strcat(cidade,'aprendizNNtmax'),erro);
                      end
                      
                  case 3
                      if i == 1
                        xlswrite(strcat(cidade,'aprendizTBtmin'),erro);

                      else 
                        xlswrite(strcat(cidade,'aprendizNNtmin'),erro);
                      end
                      
                  case 4
                      if i == 1
                        xlswrite(strcat(cidade,'aprendizTBumidadeRelativa'),erro);

                      else 
                        xlswrite(strcat(cidade,'aprendizNNumidadeRelativa'),erro);
                      end
              end
                      
            
        end
end
    
end