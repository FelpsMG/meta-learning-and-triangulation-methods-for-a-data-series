function [results] = predictionsTriangulacao(TRIAdata)

% indl = 40% dataset for learners training
% indm = 40% dataset for meta-learners training
% indp = 20% dataset for validation
% learnersV = number of ML's
% learners -> function with ML's
% metaLearnersV = number of meta-learners
% metaLearners -> function with meta-learners
% triangulationMethodsV = number of triangulation methods
% triangulationMethods = function with the triangulation methods

cidade = 'bhTRI4';

% Para normalizar os dados    

for i = 1:length(TRIAdata(1,:))
    TRIAdatan(:,i) = ((TRIAdata(:,i) - min(TRIAdata(:,i)))/(max(TRIAdata(:,i)) - min(TRIAdata(:,i)))) * 0.6 + 0.2;%normalizaçao dos dados, para que todos os dados tenham o mesmo peso
end

indl = 1:(round(size(TRIAdatan,1)*0.4));
indm = (round(size(TRIAdatan,1)*0.4)):(round(size(TRIAdatan,1)*0.8));
indp = (round(size(TRIAdatan,1)*0.8)):(round(size(TRIAdatan,1)*1));

triangulationMethodsV = 5;
M1=[];
P1 = [];

for index=1:4
    for t=4%triangulationMethodsV     
            T1 = TRIAdatan(indm,:);
            T2 = TRIAdatan(indp,:);
            
            M1 = [triangulationMethods(t,T1,index)];
            P1 = [triangulationMethods(t,TRIAdatan,index)];
            
            T1=triangulationData(index, T1);
           

                eQM(t) = 0;
                [l,c]=size(P1);
                 for i_erro=1:l

                     eQM_aux(i_erro) = (P1(i_erro,c)-T2(i_erro,c))^2;
                     em_aux(i_erro) = abs(P1(i_erro,c)-T2(i_erro,c))/T2(i_erro,c);

                 end
                  erro(t,:)= [mean(eQM_aux) mean(em_aux)];
                 
                  eQM_aux=[];
                  em_aux=[];
              
              M1=[];
              P1=[];
              
              switch (index)
                  case 1
                      if t == 1
                        xlswrite(strcat(cidade,'TmediaAritimeticaChuva'),erro);

                      elseif t == 2
                        xlswrite(strcat(cidade,'TinversoDistanciaChuva'),erro);
                        
                      elseif t == 2
                        xlswrite(strcat(cidade,'TinversoDistanciaOtimizadoChuva'),erro);
                        
                      elseif t == 2
                        xlswrite(strcat(cidade,'TnormalRatioChuva'),erro);
                        
                      elseif t == 2
                        xlswrite(strcat(cidade,'TpesoRegionalChuva'),erro);
                        
                      end
                      
                  case 2
                      if t == 1
                        xlswrite(strcat(cidade,'TmediaAritimeticaTmax'),erro);

                      elseif t == 2
                        xlswrite(strcat(cidade,'TinversoDistanciaTmax'),erro);
                        
                      elseif t == 2
                        xlswrite(strcat(cidade,'TinversoDistanciaOtimizadoTmax'),erro);
                        
                      elseif t == 2
                        xlswrite(strcat(cidade,'TnormalRatioTmax'),erro);
                        
                      elseif t== 2
                        xlswrite(strcat(cidade,'TpesoRegionalTmax'),erro);
                        
                      end
                      
                  case 3
                      if t== 1
                        xlswrite(strcat(cidade,'TmediaAritimeticaTmin'),erro);

                      elseif t== 2
                        xlswrite(strcat(cidade,'TinversoDistanciaTmin'),erro);
                        
                      elseif t== 2
                        xlswrite(strcat(cidade,'TinversoDistanciaOtimizadoTmin'),erro);
                        
                      elseif t== 2
                        xlswrite(strcat(cidade,'TnormalRatioTmin'),erro);
                        
                      elseif t== 2
                        xlswrite(strcat(cidade,'TpesoRegionalTmin'),erro);
                        
                      end
                      
                  case 4
                      if t== 1
                        xlswrite(strcat(cidade,'TmediaAritimeticaUmidade'),erro);

                      elseif t== 2
                        xlswrite(strcat(cidade,'TinversoDistanciaUmidade'),erro);
                        
                      elseif t== 2
                        xlswrite(strcat(cidade,'TinversoDistanciaOtimizadoUmidade'),erro);
                        
                      elseif t== 2
                        xlswrite(strcat(cidade,'TnormalRatioUmidade'),erro);
                        
                      elseif t== 2
                        xlswrite(strcat(cidade,'TpesoRegionalUmidade'),erro);
                        
                      end
                      
              end
    end  
end
end