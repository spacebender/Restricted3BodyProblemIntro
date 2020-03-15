
%{
...
Created 10/3/2020 14:58

What it does ?
Function for plotting the manifolds at the periodic orbits(Li1 and L2).

Inputs:
-------
      1)  G_var - GLobal Data
     
Outputs:
-------
     1) Plots the ZVC and marks the planets and equilibrium Points (or)
     2) Plots the manifolds at the L1 and L2 points 
     
Note: 
-----
At both the equilibrium points the colors of the manifolds are 

    Stable positive   - Black 
    Stable Negative   - Black dashed
    UnStable positive - Red 
    UnStable Negative - Red dashed

Modifications
-------------
1) Case 'Only_EquilPts' added on 25/2/2020 17:00
 ------------------------------------------------------------------------
...
%}
function PlotEqPointManifold(G_var)

mu = G_var.Constants.mu;
fun = G_var.IntFunc.EOM;


tspan = [0 10];
L1_xyPos = G_var.LagPts.L1';
L2_xyPos = G_var.LagPts.L2';
L1_StableEigVec = G_var.LagPts.SEigVec.L1;
L1_UStableEigVec = G_var.LagPts.USEigVec.L1;
L2_StableEigVec = G_var.LagPts.SEigVec.L2;
L2_UStableEigVec = G_var.LagPts.USEigVec.L2;

n = size(L1_StableEigVec,1);

if n < 6
    
    zero = zeros(2,1);
else
    
    zero = zeros(4,1);
end

% Eigen Vectors
L1StabPos   = [L1_xyPos;zero]  + 1e-6 *L1_StableEigVec;
L1StabNeg   = [L1_xyPos;zero]  - 1e-6 *L1_StableEigVec;
L1UstabPos  = [L1_xyPos;zero]  + 1e-6* L1_UStableEigVec;
L1UstabNeg  = [L1_xyPos;zero]   - 1e-6* L1_UStableEigVec;

L2StabPos   = [L2_xyPos;zero]  + 1e-6 *L2_StableEigVec;
L2StabNeg   = [L2_xyPos;zero]  - 1e-6 *L2_StableEigVec;
L2UstabPos  = [L2_xyPos;zero]  + 1e-6* L2_UStableEigVec;
L2UstabNeg  = [L2_xyPos;zero]  - 1e-6* L2_UStableEigVec;

Pert_EigVec = [L1StabPos L1StabNeg L2StabPos L2StabNeg L1UstabPos L1UstabNeg L2UstabPos L2UstabNeg];

for i = 1:4

[~,x] = Integrator(G_var,fun,Pert_EigVec(:,i),tspan,'backward');
    if i == 1 || i == 3
            plot(x(:,1),x(:,2),'k')
    elseif i == 2 || i == 4
            plot(x(:,1),x(:,2),'k--')
    end
hold on
grid on
end
%legend(x,'Stable Positive and Negative')

hold on
for i = 5:8
    
[~,x] = Integrator(G_var,fun,Pert_EigVec(:,i),tspan,'forward');
    if i == 5 || i == 7
        plot(x(:,1),x(:,2),'r')
    elseif i == 6 || i == 8
        plot(x(:,1),x(:,2),'r--')
    end
hold on
end
%legend(x,'Stable Positive and Negative')
%% Plot the  Contour
ReqEnergy = G_var.LagPts.Energy.L2;

x = linspace(-1.5,1.5,1000);
y = linspace(-1.5,1.5,1000);
[X,Y] = meshgrid(x,y);
r=sqrt(((X-1+mu).^2)+(Y.^2));
d=sqrt(((X+mu).^2)+(Y.^2));
jacobiConst = (X.^2)+(Y.^2) +(2*(1-mu)./d)+(2*mu./r);
contour(X,Y,jacobiConst,(ReqEnergy:-0.01:G_var.LagPts.Energy.L4-0.01))
scatter([G_var.LagPts.L1(1),G_var.LagPts.L2(1),G_var.LagPts.L3(1),G_var.LagPts.L4(1),G_var.LagPts.L5(1)],...
[G_var.LagPts.L1(2),G_var.LagPts.L2(2),G_var.LagPts.L3(2),G_var.LagPts.L4(2),G_var.LagPts.L5(2)],40,'*');
scatter(-mu,0,100,'o','MarkerFaceColor','red')
scatter(1-mu,0,'o','MarkerFaceColor','blue')     
xlim([0.7 1.25])
ylim([-0.3 0.3])
xlabel('\it{x-axis}')
ylabel('\it{y-axis}')
title('\it{Manifolds of Eqilibrium Points}')
        
%%  set the paper

set(gcf,'PaperPosition',[0 0 5 5]);
set(gcf,'PaperSize',[5 5])
%saveas(gcf, 'ManifoldsAtEqPoints', 'pdf');
