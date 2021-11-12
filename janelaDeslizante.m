function [dadosJanela] = janelaDeslizante(dados,n_entradas)
%% Preparar Matriz para Machine Learning

conjunto = 5;%tamanho da janela deslizante
% n_entradas = 4;
    
    entrou = 0;
    cont = 1;
    dadosJanela = [];
    
    for i=1:length(dados)-(conjunto-1)
        
        for j=0:conjunto-1 
            if j==conjunto-1
                dadosJanela(i,1+(n_entradas*j)) = dados(i+j,1);
                dadosJanela(i,2+(n_entradas*j)) = dados(i+j,2);
                dadosJanela(i,3+(n_entradas*j)) = dados(i+j,3);
                dadosJanela(i,4+(n_entradas*j)) = dados(i+j,4);
            else
                dadosJanela(i,1+(n_entradas*j)) = dados(i+j,1);
                dadosJanela(i,2+(n_entradas*j)) = dados(i+j,2);
                dadosJanela(i,3+(n_entradas*j)) = dados(i+j,3);
                dadosJanela(i,4+(n_entradas*j)) = dados(i+j,4);
            end
        end
    end
    m = 1;
    while m <= length(dadosJanela)
        for n = 2:length(dadosJanela(1,:))
            if isnan(dadosJanela(m,n))
                dadosJanela(m,:) = [];
                m = m - 1;
                break
            end
        end
        m = m + 1;
    end
end