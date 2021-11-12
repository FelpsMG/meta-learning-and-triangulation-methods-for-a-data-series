function [methodRes] = triangulationMethods(select, data,indice)
aux=[];
data=triangulationData(indice,data);
methodRes=[];
%% Coordinates 
% bh = [-19.93444 -43.952222];
% florestal = [-19.99542 -44.416889];
% d1 = haversine(bh,florestal);
% ibirite = [-20.0166 -44.084722];
% d2 = haversine(bh,ibirite);
% seteLagoas = [-19.48454 -44.173798];
% d3 = haversine(bh, seteLagoas);
% d = [d1 d2 d3];
belterra = [-2.6422222 -54.94388888];
monteAlegre = [-2 -54.07638888];
d1 = haversine(belterra,monteAlegre);
obidos = [-1.905 -55.5236111];
d2 = haversine(belterra,obidos);
parintins = [-2.63 -56.73];
d3 = haversine(belterra, parintins);
d = [d1 d2 d3];
%% Altitude
% bhA = 0.91547;
% florestalA = 0.75351;
% ibiriteA = 0.82208;
% seteLagoasA = 0.75368;
% altitude = [bhA florestalA ibiriteA seteLagoasA];
belterraA = 164.3;
monteAlegreA = 100.52;
obidosA = 54.72;
parintinsA = 29;
altitude = [belterraA monteAlegreA obidosA parintinsA];
%% IMAD -> indicator monthly average dataset
iMAD = []; 
cont=1;
        for i=1:length(data)-1
            
           if i==length(data)-1
              iMAD = [iMAD;aux(1,2:3) mean(aux(:,4),'omitnan') mean(aux(:,5),'omitnan') mean(aux(:,6),'omitnan') mean(aux(:,7),'omitnan')];
              cont=cont+1;
              aux=[];
           end
            if data(i,2) == data(i+1,2)
                aux = [aux;data(i,:)];   
            else
                if i~=1
                    iMAD = [iMAD;aux(1,2:3) mean(aux(:,4),'omitnan') mean(aux(:,5),'omitnan') mean(aux(:,6),'omitnan') mean(aux(:,7),'omitnan')];
                    cont=cont+1;
                    aux=[];       
                end
            end
        end
if isempty(data)
    methodRes=[];
else
    switch (select)

        case 1
            %% Arithmetic Average
            for i=1:length(data)
                methodRes = [methodRes; data(i,1:3) mean(data(i,5:7),'omitnan')];
            end

        case 2
            %% Inverse Distance Weighted
            for i=1:length(data)
                if isnan(data(i,5)) && isnan(data(i,6)) && isnan(data(i,7))

                    methodRes = [methodRes;data(i,1:3) NaN];

                elseif isnan(data(i,5)) && ~(isnan(data(i,6))) && ~(isnan(data(i,7)))

                    methodRes = [methodRes;data(i,1:3) (( data(i,6)/d2 + data(i,7)/d3) / ( 1/d2 + 1/d3))];

                elseif ~(isnan(data(i,5))) && isnan(data(i,6)) && ~(isnan(data(i,7)))

                    methodRes = [methodRes;data(i,1:3) (( data(i,5)/d1 + data(i,7)/d3) / ( 1/d1 + 1/d3))];

                elseif ~(isnan(data(i,5))) && ~(isnan(data(i,6))) && isnan(data(i,7))

                    methodRes = [methodRes;data(i,1:3) (( data(i,5)/d1 + data(i,6)/d2) / ( 1/d1 + 1/d2))];

                elseif isnan(data(i,5)) && isnan(data(i,6)) && ~(isnan(data(i,7)))

                    methodRes = [methodRes;data(i,1:3) (( data(i,7)/d3) / ( 1/d3))];

                elseif isnan(data(i,5)) && ~(isnan(data(i,6))) && isnan(data(i,7))

                     methodRes = [methodRes;data(i,1:3) (( data(i,6)/d2) / ( 1/d2))];

                elseif ~(isnan(data(i,5))) && isnan(data(i,6)) && isnan(data(i,7))

                    methodRes = [methodRes;data(i,1:3) (( data(i,5)/d1) / ( 1/d1))];

                else
                    methodRes = [methodRes;data(i,1:3) ((data(i,5)/d1 + data(i,6)/d2 + data(i,7)/d3) / ( 1/d1 + 1/d2 + 1/d3))];
                end

            end

        case 3
            %% Optimized Inverse Distance Weighted
            cont = 1;
            aux = 1;
            while aux<=length(data)

                if data(aux,2) == iMAD(cont,1)


                    if isnan(data(aux,5)) && isnan(data(aux,6)) && isnan(data(aux,7))

                    methodRes = [methodRes;data(i,1:3) NaN];

                    elseif isnan(data(aux,5)) && ~(isnan(data(aux,6))) && ~(isnan(data(aux,7)))

                        vecSum(1) = (data(aux,4+2)/d(2) * iMAD(cont,3)/iMAD(cont,3+2) * log(altitude(1))/log(altitude(1+2)))/(1/d(2));
                        vecSum(2) = (data(aux,4+3)/d(3) * iMAD(cont,3)/iMAD(cont,3+3) * log(altitude(1))/log(altitude(1+3)))/(1/d(3));
                        methodRes = [methodRes; data(aux,1:3) (sum(vecSum,'omitnan'))];

                    elseif ~(isnan(data(aux,5))) && isnan(data(aux,6)) && ~(isnan(data(aux,7)))

                        vecSum(1) = (data(aux,4+1)/d(1) * iMAD(cont,3)/iMAD(cont,3+1) * log(altitude(1))/log(altitude(1+1)))/(1/d(1));
                        vecSum(2) = (data(aux,4+3)/d(3) * iMAD(cont,3)/iMAD(cont,3+3) * log(altitude(1))/log(altitude(1+3)))/(1/d(3));

                        methodRes = [methodRes; data(aux,1:3) (sum(vecSum,'omitnan'))];

                    elseif ~(isnan(data(aux,5))) && ~(isnan(data(aux,6))) && isnan(data(aux,7))

                        for i=1:2 % de 1 ate o numero de cidades vizinhas
                            vecSum(i) = (data(aux,4+i)/d(i) * iMAD(cont,3)/iMAD(cont,3+i) * log(altitude(1))/log(altitude(1+i)))/(1/d(i));
                        end

                        methodRes = [methodRes; data(aux,1:3) (sum(vecSum,'omitnan'))];

                    elseif isnan(data(aux,5)) && isnan(data(aux,6)) && ~(isnan(data(aux,7)))

                        for i=3 % de 1 ate o numero de cidades vizinhas
                            vecSum(i) = (data(aux,4+i)/d(i) * iMAD(cont,3)/iMAD(cont,3+i) * log(altitude(1))/log(altitude(1+i)))/(1/d(i));
                        end

                        methodRes = [methodRes; data(aux,1:3) (sum(vecSum,'omitnan'))];

                    elseif isnan(data(aux,5)) && ~(isnan(data(aux,6))) && isnan(data(aux,7))

                         for i=2 % de 1 ate o numero de cidades vizinhas
                            vecSum(i) = (data(aux,4+i)/d(i) * iMAD(cont,3)/iMAD(cont,3+i) * log(altitude(1))/log(altitude(1+i)))/(1/d(i));
                        end

                        methodRes = [methodRes; data(aux,1:3) (sum(vecSum,'omitnan'))];

                    elseif ~(isnan(data(aux,5))) && isnan(data(aux,6)) && isnan(data(aux,7))

                        for i=1 % de 1 ate o numero de cidades vizinhas
                            vecSum(i) = (data(aux,4+i)/d(i) * iMAD(cont,3)/iMAD(cont,3+i) * log(altitude(1))/log(altitude(1+i)))/(1/d(i));
                        end

                        methodRes = [methodRes; data(aux,1:3) (sum(vecSum,'omitnan'))];

                    else
                        for i=1:3 % de 1 ate o numero de cidades vizinhas
                            vecSum(i) = (data(aux,4+i)/d(i) * iMAD(cont,3)/iMAD(cont,3+i) * log(altitude(1))/log(altitude(1+i)))/(1/d(i));
                        end

                        methodRes = [methodRes; data(aux,1:3) (sum(vecSum,'omitnan'))];
                    end

                    vecSum = [];
                    aux = aux + 1;
                else
                    if aux==1
                        aux=aux+1;
                    else
                        cont=cont+1;
                    end

                end
            end

        case 4
            %% Optimized Normal Ratio
            monthlyCorrelation=[];
            for i=1:length(data)-1
                if data(i,2) == data(i+1,2)
                    aux = [aux;data(i,:)];       
                else
                    if i~=1
                        r1 = corrcoef(aux(:,4),aux(:,5));
                        r2 = corrcoef(aux(:,4),aux(:,6));
                        r3 = corrcoef(aux(:,4),aux(:,7));
                        monthlyCorrelation = [monthlyCorrelation;aux(1,2:3) r1(1,2) r2(1,2) r3(1,2)];
                        aux=[];
                    end
                end
            end
            correction = monthlyCorrelation(1,:);
            monthlyCorrelation(1,:)=[];
            monthlyCorrelation(length(monthlyCorrelation),:) = correction;
            cont = 1;
            aux = 1;
            aux2 = 0;
            while cont<length(monthlyCorrelation)-1

                if data(aux,2) == monthlyCorrelation(cont,1)

                    if isnan(data(aux,5)) && isnan(data(aux,6)) && isnan(data(aux,7))

                        methodRes = [methodRes;data(i,1:3) NaN];

                    elseif isnan(data(aux,5)) && ~(isnan(data(aux,6))) && ~(isnan(data(aux,7)))

                        vecSum(1)= abs(data(aux,4+2) * ( monthlyCorrelation(cont,2+2)^(2*((30-2)/(1-monthlyCorrelation(cont,2+2)^2)))) ); 
                        vecSum(2)= abs(data(aux,4+3) * ( monthlyCorrelation(cont,2+3)^(2*((30-2)/(1-monthlyCorrelation(cont,2+3)^2)))) );
                        vecSum1(1) = abs( monthlyCorrelation(cont,2+2)^(2*((30-2)/(1-monthlyCorrelation(cont,2+2)^2))));
                        vecSum1(2) = abs( monthlyCorrelation(cont,2+3)^(2*((30-2)/(1-monthlyCorrelation(cont,2+3)^2))));

                        methodRes = [methodRes; data(aux,1:3) sum(vecSum)/sum(vecSum1)];

                    elseif ~(isnan(data(aux,5))) && isnan(data(aux,6)) && ~(isnan(data(aux,7)))


                        vecSum(1)= abs(data(aux,4+1) * ( monthlyCorrelation(cont,2+1)^(2*((30-2)/(1-monthlyCorrelation(cont,2+1)^2)))) ); 
                        vecSum(2)= abs(data(aux,4+3) * ( monthlyCorrelation(cont,2+3)^(2*((30-2)/(1-monthlyCorrelation(cont,2+3)^2)))) ); 
                        vecSum1(1)= abs( monthlyCorrelation(cont,2+1)^(2*((30-2)/(1-monthlyCorrelation(cont,2+1)^2))));
                        vecSum1(2)= abs( monthlyCorrelation(cont,2+3)^(2*((30-2)/(1-monthlyCorrelation(cont,2+3)^2))));

                        methodRes = [methodRes; data(aux,1:3) sum(vecSum)/sum(vecSum1)];

                    elseif ~(isnan(data(aux,5))) && ~(isnan(data(aux,6))) && isnan(data(aux,7))

                        for j=1:2 % de 1 ate o numero de cidades vizinhas
                            vecSum(j)= abs(data(aux,4+j) * ( monthlyCorrelation(cont,2+j)^(2*((30-2)/(1-monthlyCorrelation(cont,2+j)^2)))));  
                            vecSum1(j) = abs( monthlyCorrelation(cont,2+j)^(2*((30-2)/(1-monthlyCorrelation(cont,2+j)^2))));
                        end

                        methodRes = [methodRes; data(aux,1:3) sum(vecSum)/sum(vecSum1)];

                    elseif isnan(data(aux,5)) && isnan(data(aux,6)) && ~(isnan(data(aux,7)))

                        for j=3 % de 1 ate o numero de cidades vizinhas
                            vecSum(j)= abs(data(aux,4+j) * ( monthlyCorrelation(cont,2+j)^(2*((30-2)/(1-monthlyCorrelation(cont,2+j)^2)))));  
                            vecSum1(j) = abs( monthlyCorrelation(cont,2+j)^(2*((30-2)/(1-monthlyCorrelation(cont,2+j)^2))));
                        end

                        methodRes = [methodRes; data(aux,1:3) sum(vecSum)/sum(vecSum1)];

                    elseif isnan(data(aux,5)) && ~(isnan(data(aux,6))) && isnan(data(aux,7))

                         for j=2 % de 1 ate o numero de cidades vizinhas
                            vecSum(j)= abs(data(aux,4+j) * ( monthlyCorrelation(cont,2+j)^(2*((30-2)/(1-monthlyCorrelation(cont,2+j)^2)))));  
                            vecSum1(j) = abs( monthlyCorrelation(cont,2+j)^(2*((30-2)/(1-monthlyCorrelation(cont,2+j)^2))));
                        end

                        methodRes = [methodRes; data(aux,1:3) sum(vecSum)/sum(vecSum1)];

                    elseif ~(isnan(data(aux,5))) && isnan(data(aux,6)) && isnan(data(aux,7))

                        for j=1 % de 1 ate o numero de cidades vizinhas
                            vecSum(j)= abs(data(aux,4+j) * ( monthlyCorrelation(cont,2+j)^(2*((30-2)/(1-monthlyCorrelation(cont,2+j)^2)))));  
                            vecSum1(j) = abs( monthlyCorrelation(cont,2+j)^(2*((30-2)/(1-monthlyCorrelation(cont,2+j)^2))));
                        end

                        methodRes = [methodRes; data(aux,1:3) sum(vecSum)/sum(vecSum1)];

                    else
                        for j=1:3 % de 1 ate o numero de cidades vizinhas
                            vecSum(j)= abs(data(aux,4+j) * ( monthlyCorrelation(cont,2+j)^(2*((30-2)/(1-monthlyCorrelation(cont,2+j)^2)))));  
                            vecSum1(j) = abs( monthlyCorrelation(cont,2+j)^(2*((30-2)/(1-monthlyCorrelation(cont,2+j)^2))));
                        end

                        methodRes = [methodRes; data(aux,1:3) sum(vecSum)/sum(vecSum1)];

                    end

                    vecSum = [];
                    vecSum1 = [];

    %                for j=1:3 % de 1 ate o numero de cidades vizinhas
    %                    vecSum(j)= (data(aux,4+j) * ( monthlyCorrelation(cont,2+j)^(2*((30-2)/(1-monthlyCorrelation(cont,2+j)^2)))));  
    %                    vecSum1(j) = ( monthlyCorrelation(cont,2+j)^(2*((30-2)/(1-monthlyCorrelation(cont,2+j)^2))));
%     %                end
% 
%                     methodRes = [methodRes; data(aux,1:3) sum(vecSum)/sum(vecSum1)];
                    aux=aux+1;
                else
                    cont=cont+1;
                end
            end
        case 5  
            %% Regional Weight

            cont = 1;
            aux = 1;
            while aux<=length(data)

                if data(aux,2) == iMAD(cont,1)

                    if isnan(data(aux,5)) && isnan(data(aux,6)) && isnan(data(aux,7))

                    methodRes = [methodRes;data(i,1:3) NaN];

                    elseif isnan(data(aux,5)) && ~(isnan(data(aux,6))) && ~(isnan(data(aux,7)))

                        vecSum(1) = ( ( iMAD(cont,3)/iMAD(cont,3+2) ) * data(aux,4+2) );
                        vecSum(2) = ( ( iMAD(cont,3)/iMAD(cont,3+3) ) * data(aux,4+3) );
                        methodRes = [methodRes; data(aux,1:3) (sum(vecSum,'omitnan'))/2];

                    elseif ~(isnan(data(aux,5))) && isnan(data(aux,6)) && ~(isnan(data(aux,7)))

                        vecSum(1) = ( ( iMAD(cont,3)/iMAD(cont,3+1) ) * data(aux,4+1) );
                        vecSum(2) = ( ( iMAD(cont,3)/iMAD(cont,3+3) ) * data(aux,4+3) );

                        methodRes = [methodRes; data(aux,1:3) (sum(vecSum,'omitnan'))/2];

                    elseif ~(isnan(data(aux,5))) && ~(isnan(data(aux,6))) && isnan(data(aux,7))

                        for i=1:2 % de 1 ate o numero de cidades vizinhas
                            vecSum(i) = ( ( iMAD(cont,3)/iMAD(cont,3+i) ) * data(aux,4+i) );
                        end

                        methodRes = [methodRes; data(aux,1:3) (sum(vecSum,'omitnan'))/2];

                    elseif isnan(data(aux,5)) && isnan(data(aux,6)) && ~(isnan(data(aux,7)))

                        for i=3 % de 1 ate o numero de cidades vizinhas
                            vecSum(i) = ( ( iMAD(cont,3)/iMAD(cont,3+i) ) * data(aux,4+i) );
                        end

                        methodRes = [methodRes; data(aux,1:3) (sum(vecSum,'omitnan'))];

                    elseif isnan(data(aux,5)) && ~(isnan(data(aux,6))) && isnan(data(aux,7))

                         for i=2 % de 1 ate o numero de cidades vizinhas
                            vecSum(i) = ( ( iMAD(cont,3)/iMAD(cont,3+i) ) * data(aux,4+i) );
                        end

                        methodRes = [methodRes; data(aux,1:3) (sum(vecSum,'omitnan'))];

                    elseif ~(isnan(data(aux,5))) && isnan(data(aux,6)) && isnan(data(aux,7))

                        for i=1 % de 1 ate o numero de cidades vizinhas
                            vecSum(i) = ( ( iMAD(cont,3)/iMAD(cont,3+i) ) * data(aux,4+i) );
                        end

                        methodRes = [methodRes; data(aux,1:3) (sum(vecSum,'omitnan'))];

                    else
                        for i=1:3 % de 1 ate o numero de cidades vizinhas
                            vecSum(i) = ( ( iMAD(cont,3)/iMAD(cont,3+i) ) * data(aux,4+i) );
                        end

                        methodRes = [methodRes; data(aux,1:3) sum(vecSum,'omitnan')/3];
                    end

                    vecSum = [];
                    aux=aux+1;

                else
                    if aux==1
                        aux=aux+1;
                    else
                        cont=cont+1;
                    end
                end
            end
    end

end



end