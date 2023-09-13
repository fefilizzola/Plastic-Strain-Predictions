clear all; clc;

%Loading measured data
load ('/Users/fernanda/Documents/Tese_Mestrado/GitHub/Plastic-Strain-Predictions/data/Sample_1/RDM_Sample_1.mat')

%Loading predicted data
load ('/Users/fernanda/Documents/Tese_Mestrado/GitHub/Plastic-Strain-Predictions/MLP/Sample1_generated/Enn_MLP_35.mat')
load ('/Users/fernanda/Documents/Tese_Mestrado/GitHub/Plastic-Strain-Predictions/MLP/Sample1_generated/Etn_MLP_35.mat')
load ('/Users/fernanda/Documents/Tese_Mestrado/GitHub/Plastic-Strain-Predictions/MLP/Sample1_generated/Ett_MLP_35.mat')

RDM.Strains.Enn = Enn_MLP_35;
RDM.Strains.Etn = Etn_MLP_35;
RDM.Strains.Ett = Ett_MLP_35;

RDM_MLP_35 = RDM;

save('RDM_MLP_35.mat','RDM_MLP_35');

% o numero 1 faz com que o manto od grao nao saia na imagem, apenas o
% contorno
DICPlot(RDM_MLP_35, 1); 
