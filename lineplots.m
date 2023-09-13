clear all;
clc

%Loading measured data
load('/Users/fernanda/Documents/Tese_Mestrado/GitHub/Plastic-Strain-Predictions/data/Sample_1/RDM_Sample_1.mat')

%Loading predicted data
load('/Users/fernanda/Documents/Tese_Mestrado/GitHub/Plastic-Strain-Predictions/MLP/Sample1_generated/Raw/RDM_MLP_35.mat')
load('/Users/fernanda/Documents/Tese_Mestrado/GitHub/Plastic-Strain-Predictions/MLP/Sample1_generated/Augmented/RDM_MLP_35_aug.mat')
% load('Predicted\Python\Sample2\PCA_35\DT\RDM_DT_35.mat')

%Interpolating data
INTS{1} = DICInterpolate(RDM);
INTS{2} = DICInterpolate(RDM_MLP_35);
INTS{3} = DICInterpolate(RDM_MLP_35_aug);
% INTS{4} = DICInterpolate(RDM2nn3);
% INTS{5} = DICInterpolate(RDM2nn123);
    
NB = 4; %Number of GB to select (1,2 or 3)
colors = {'red','blue','green'};
for BD = 1 : NB
    
    color = colors{BD};
    
    %Gathering data from lines for Etn
    [c,s1,pts1] = DIClineplot_tn(INTS{1});
    [~,s2,pts2] = DIClineplot_tn(INTS{2},c);
    [~,s3,pts3] = DIClineplot_tn(INTS{3},c);
    % [~,s4,pts4] = DIClineplot_tn(INTS{4},c);
    % [~,s5,pts5] = DIClineplot_tn(INTS{5},c);
    
    %Gathering data from lines for Enn
    [~,s1n,pts1n] = DIClineplot_nn(INTS{1},c);
    [~,s2n,pts2n] = DIClineplot_nn(INTS{2},c);
    [~,s3n,pts3n] = DIClineplot_nn(INTS{3},c);
    % [~,s4n,pts4n] = DIClineplot_nn(INTS{4},c);
    % [~,s5n,pts5n] = DIClineplot_nn(INTS{5},c);

    %Line plots for Etn from all NN
    f = figure('visible','off');
    plot(s1,pts1,'-','LineWidth',4,'color',color)
    hold on
    plot(s2,pts2,'--','LineWidth',2,'color',color)
    hold on
    plot(s3,pts3,':','LineWidth',2,'color',color)
    hold on
    % plot(s4,pts4,'-.','LineWidth',2,'color',color)
    % hold on
    % plot(s5,pts5,'-','LineWidth',2,'color',color)
    xlim([min(min(s1n)),max(max(s1n))])
    xlabel('GB point index')
    ylabel('\epsilon_t_n')
    saveFigure(['Plots\',sprintf('Etn %d.tif',BD)]);

    %Line plots for Enn from all NN
    f1 = figure('visible','off');
    plot(s1n,pts1n,'-','LineWidth',4,'color',color)
    hold on
    plot(s2n,pts2n,'--','LineWidth',2,'color',color)
    hold on
    plot(s3n,pts3n,':','LineWidth',2,'color',color)
    hold on
    % plot(s4n,pts4n,'-.','LineWidth',2,'color',color)
    % hold on
    % plot(s5n,pts5n,'-','LineWidth',2,'color',color)
    xlim([min(min(s1n)),max(max(s1n))])
    xlabel('GB point index')
    ylabel('\epsilon_n_n')
    saveFigure(['Plots\',sprintf('Enn %d.tif',BD)]);
    
    %Calculating correlations for combined NN
    [rho,p]=corr([transpose(pts1),transpose(pts3)]);
    [rhon,pn]=corr([transpose(pts1n),transpose(pts3n)]);
    
    %Correlation Plot for Enn
    fitresn = fit(transpose(pts1n),transpose(pts3n),'poly1');
    f2 = figure('visible','off');
    plot([-1,1],[-1,1],'--','color','black');
    hold on
    h = plot(fitresn);
    hold on
    plot(pts1n,pts3n,'+','MarkerSize',4,'color',color)
    set(h,'color','black')
    xlim([min(min(pts1n))-0.01,max(max(pts1n))+0.01])
    ylim([min(min(pts3n))-0.01,max(max(pts3n))+0.01])
    legend off
    title(sprintf('Correlation = %.2f   p-value = %.4f < 0.05',rhon(2,1),pn(2,1)))
    xlabel('Measured \epsilon_n_n')
    ylabel('Predicted \epsilon_n_n')
    saveFigure(['Plots\',sprintf('EnnCORR %d.tiff',BD)]);
    
    %Correlation Plot for Etn
    fitres = fit(transpose(pts1),transpose(pts3),'poly1');
    f3 = figure('visible','off');
    plot([-1,1],[-1,1],'--','color','black');
    hold on
    h=plot(fitres);
    hold on
    plot(pts1,pts3,'+','MarkerSize',4,'color',color)
    set(h,'color','black')
    xlim([min(min(pts1))-0.01,max(max(pts1))+0.01])
    ylim([min(min(pts3))-0.01,max(max(pts3))+0.01])
    legend off
    title(sprintf('Correlation = %.2f   p-value = %.4f < 0.05',rho(2,1),p(2,1)))
    xlabel('Measured \epsilon_t_n')
    ylabel('Predicted \epsilon_t_n')
    saveFigure(['Plots\',sprintf('EtnCORR %d.tiff',BD)]);

end
