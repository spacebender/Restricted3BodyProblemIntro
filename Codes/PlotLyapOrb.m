%{
...
Created on 28/02/2020  16:31 and modified on 9/3/2020

Plots the Lyapunov Orbits
...
%}
function PlotLyapOrb(G_var)


OrbPar = load('LyapOrbPar.mat');
LyapOrbPar = OrbPar.LyapOrb;
fun_EOM = G_var.IntFunc.EOM;
NoofFam = size(LyapOrbPar(1).time,1);
mu = G_var.Constants.mu;

%% ---------------------Lyap_L1 and Lyap_L2 Lyap_Lyap orbits-----------------------------
fprintf('\n')
fprintf('Plotting the Lyapunov orbits of L1 and L2 ...\n')
fprintf('\n')
figure()
for Loc  = 1:size(LyapOrbPar,2)
for i = 1: 2: NoofFam
    [~,x] = Integrator(G_var,fun_EOM,LyapOrbPar(Loc).IC(i,:),[0 LyapOrbPar(Loc).time(i,1)]);
        if Loc == 1
            plot(x(:,1),x(:,2),'k')
        else 
            plot(x(:,1),x(:,2),'r')
        end
    hold on
    grid on
end
    hold on
end
    PlotContourEquilPoints(G_var,'L1L2NsecPrim')
    if mu < 1e-6
    xlim([0.96 1.03])
    ylim([-0.025 0.025])
    elseif mu  < 1e-4 && mu >1e-6
    xlim([0.8 1.25])
    ylim([-0.18 0.18])
    elseif mu > 1e-3
    xlim([0.3 1.7])
    ylim([-0.4 0.4])
    end
    xlabel('\it{x-axis}')
    ylabel('\it{y-axis}')
    title('\it{Lyapunov orbits of L_{1} and L_{2}}')
    
    set(gcf,'PaperPosition',[0 0 5 5]);
    set(gcf,'PaperSize',[5 5])
    %saveas(gcf, 'Lyap_L1L2_Orbits', 'pdf');
%% ---------------------Lyap_L1 Lyap_Lyap orbits-----------------------------
figure()
for i = 1: 2: NoofFam
    [~,x] = Integrator(G_var,fun_EOM,LyapOrbPar(1).IC(i,:),[0 LyapOrbPar(1).time(i,1)]);
    plot(x(:,1),x(:,2),'k')
    hold on
   
end
 grid on
    PlotContourEquilPoints(G_var,'L1L2NsecPrim')
     if mu < 1e-6
     xlim([0.96 1.03])
    ylim([-0.025 0.025])
    elseif mu  < 1e-4 && mu >1e-6
    xlim([0.8 1.25])
    ylim([-0.18 0.18])
    else
    xlim([0.2 1.5])
    ylim([-0.5 0.5])
    end
   
    xlabel('\it{x-axis}')
    ylabel('\it{y-axis}')
    title('\it{Lyapunov Orbits of L_1}')
    
    set(gcf,'PaperPosition',[0 0 5 5]);
    set(gcf,'PaperSize',[5 5])
    saveas(gcf, 'G:\My Drive\MATLAB\Matlb3BP\ThreeBodyProblemCodes\Restricted3BodyProblem\Figures\Lyap_L1_Orbit', 'pdf');
    %saveas(gcf, 'Lyap_L1_Orbits', 'pdf');
%% ---------------------Lyap_L2 Lyap_Lyap orbits-----------------------------
figure()
for i = 1: 2: NoofFam
    [~,x] = Integrator(G_var,fun_EOM,LyapOrbPar(2).IC(i,:),[0 LyapOrbPar(2).time(i,1)]);
    plot(x(:,1),x(:,2),'k')
    hold on
end
 grid on
    PlotContourEquilPoints(G_var,'L1L2NsecPrim')
    if mu < 1e-6
     xlim([0.96 1.03])
    ylim([-0.025 0.025])
    elseif mu  < 1e-4 && mu >1e-6
    xlim([0.8 1.25])
    ylim([-0.18 0.18])
    else
    xlim([0.2 1.5])
    ylim([-0.5 0.5])
    end
    xlabel('\it{x-axis}')
    ylabel('\it{y-axis}')
    title('\it{Lyapunov Orbits of L_2}')
    
    set(gcf,'PaperPosition',[0 0 5 5]);
    set(gcf,'PaperSize',[5 5])
    %saveas(gcf, 'Lyap_L2_Orbits', 'pdf');
 
 