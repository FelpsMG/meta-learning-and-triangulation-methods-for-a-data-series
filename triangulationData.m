function [TRIAdata] = triangulationData(select, dados)

%% Escolhendo indicador foco, 8 indicadores totais

switch (select)
    
    case 1
        ind = 'precipitacao';
        pos = 4; %posição do indicador 
    case 2
        ind = 'tmax';
        pos = 8; %posição do indicador 
    case 3 
        ind = 'tmed';
        pos = 12; %posição do indicador 
    case 4
        ind = 'tmin';
        pos = 16; %posição do indicador 
    case 5
        ind = 'umidadeRelativa';
        pos = 20; %posição do indicador 
   
end

date = dados(:,1:3);
TRIAdata= [date dados(:,pos:(pos+3))];

m = 1;
    while m <= length(TRIAdata)
        for n = 2:length(TRIAdata(1,:))
            if isnan(TRIAdata(m,n))
                TRIAdata(m,:) = [];
                m = m - 1;
                break
            end
        end
        m = m + 1;
    end