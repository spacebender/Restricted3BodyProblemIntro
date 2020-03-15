% Created on 10/3/2020 17:36
% This function just plots call different plot functions 
% Choose any of the four
        % '2DContour'
        % '3DSurface'
        % 'EquilPointsNPrim'
        % 'L1L2NsecPrim'
function Plotter(G_var)
fprintf('\n\n')
fprintf('----------------------\n')
fprintf('Plotting figures...\n')
fprintf('----------------------\n')

fprintf('\n')
fprintf('Plotting Contour,Surface and equilibrium points plots ...\n')
fprintf('\n')

figure()
PlotContourEquilPoints(G_var,'3DSurface')
figure()
PlotContourEquilPoints(G_var,'2DContour')
figure()
PlotContourEquilPoints(G_var,'EquilPointsNPrim')

LyapunovPlotter(G_var) % seperate figures are defined inside 
 
figure()
fprintf('\n')
fprintf('Plotting manifolds at equilibrium points ...\n')
fprintf('\n')
plotEqPointManifold(G_var)



fprintf('\n')
fprintf('Simulation completed Succesfully !!!\n')