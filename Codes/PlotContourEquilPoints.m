function PlotContourEquilPoints(G_var,type)
%{
...
Created on 21/2/2020 17:50

What it does ?
Function for plotting other general system points of interest.

Inputs:
-------
      1)  G_var - GLobal Data
      2)  type - Choose between 2D and 3D isosurface

and gives
Outputs:
-------
     1) Plots the ZVC and marks the planets and equilibrium Points (or)
     2) Plots 3D isosurface 
     3) Only euilibrium points and primaries
     4) Plots L1 L2 and secondary (to view with lyapunov orbits
depending on the 'type'

Modifications
-------------
1) Case 'Only_EquilPts' added on 25/2/2020 17:00
 ------------------------------------------------------------------------
...
%}

%G_var = GlobalData;
LagPts = G_var.LagPts;
mu = G_var.Constants.mu;
ReqEnergy = G_var.Constants.ReqEnergy;



switch type
    case '2DContour'
        x = linspace(-1.5,1.5,1000);
        y = linspace(-1.5,1.5,1000);
        [X,Y] = meshgrid(x,y);


        r=sqrt(((X-1+mu).^2)+(Y.^2));
        d=sqrt(((X+mu).^2)+(Y.^2));

        jacobiConst = (X.^2)+(Y.^2) +(2*(1-mu)./d)+(2*mu./r);

        contour(X,Y,jacobiConst,(ReqEnergy:-0.01:LagPts.Energy.L4-0.01))
        hold on
        scatter([LagPts.L1(1),LagPts.L2(1),LagPts.L3(1),LagPts.L4(1),LagPts.L5(1)],...
        [LagPts.L1(2),LagPts.L2(2),LagPts.L3(2),LagPts.L4(2),LagPts.L5(2)],40,'*');
        grid on

        scatter(-mu,0,100,'o','MarkerFaceColor','red')

        scatter(1-mu,0,'o','MarkerFaceColor','blue')
        xlabel('\it{x-axis}')
        ylabel('\it{y-axis}')
        title(['\it{Contour Plot for Energy: }',num2str(ReqEnergy)])
        set(gcf,'PaperPosition',[0 0 5 5]);
        set(gcf,'PaperSize',[5 5])
        %saveas(gcf, 'ContourPlot', 'pdf');


    case '3DSurface'
        x = linspace(-1.5,1.5,100);
        y = linspace(-1.5,1.5,100);
        z = linspace(-1.5,1.5,100);

        [X,Y,Z] = meshgrid(x,y,z);


        r=sqrt(((X-1+mu).^2)+(Y.^2)+(Z.^2));
        d=sqrt(((X+mu).^2)+(Y.^2)+(Z.^2));

        jacobiConst = (X.^2)+(Y.^2) +(2*(1-mu)./d)+(2*mu./r);
        
        subplot(1,2,1)
        p = patch(isosurface(X,Y,Z,jacobiConst,ReqEnergy));
        p.FaceColor = 'green';
        p.EdgeColor = 'none';
        p.AmbientStrength = 0.3;
        p.DiffuseStrength = 0.8;
        p.SpecularStrength = 0.9;
        p.SpecularExponent = 25;
        camlight
        p.FaceLighting  = 'gouraud';
        lightangle(-45,30)

        if ReqEnergy>=LagPts.Energy.L4 && ReqEnergy<=LagPts.Energy.L1
        view(0,90)
        else
        view(360,0)
        end

        hold on
        scatter([LagPts.L1(1),LagPts.L2(1),LagPts.L3(1),LagPts.L4(1),LagPts.L5(1)],...
        [LagPts.L1(2),LagPts.L2(2),LagPts.L3(2),LagPts.L4(2),LagPts.L5(2)],40,'*');
        grid on
        scatter(-mu,0,100,'o','MarkerFaceColor','red')
        scatter(1-mu,0,'o','MarkerFaceColor','blue')
        xlabel('\it{x}')
        ylabel('\it{y}')
        

        subplot(1,2,2)
        p = patch(isosurface(X,Y,Z,jacobiConst,ReqEnergy));
        p.FaceColor = 'green';
        p.EdgeColor = 'none';
        p.AmbientStrength = 0.3;
        p.DiffuseStrength = 0.8;
        p.SpecularStrength = 0.9;
        p.SpecularExponent = 25;
        camlight
        p.FaceLighting  = 'gouraud';
        lightangle(-45,30)
        view([5,-7,4])
        
        hold on
        scatter([LagPts.L1(1),LagPts.L2(1),LagPts.L3(1),LagPts.L4(1),LagPts.L5(1)],...
        [LagPts.L1(2),LagPts.L2(2),LagPts.L3(2),LagPts.L4(2),LagPts.L5(2)],40,'*');
        grid on
        scatter(-mu,0,100,'o','MarkerFaceColor','red')
        scatter(1-mu,0,'o','MarkerFaceColor','blue')
        xlabel('\it{x}')
        ylabel('\it{y}')
        zlabel('\it{z}')
        sgtitle(['\it{Surface Plot for Energy: }',num2str(ReqEnergy)])
        set(gcf,'PaperPosition',[0 0 5 5]);
        set(gcf,'PaperSize',[5 5])
        %saveas(gcf, 'SurfacePlot', 'pdf');


    case 'EquilPointsNPrim'
        
      
        hold on
        grid on
        scatter([LagPts.L1(1),LagPts.L2(1),LagPts.L3(1),LagPts.L4(1),LagPts.L5(1)],...
        [LagPts.L1(2),LagPts.L2(2),LagPts.L3(2),LagPts.L4(2),LagPts.L5(2)],55,'*');
        

        scatter(-mu,0,200,'o','MarkerFaceColor','red')

        scatter(1-mu,0,75,'o','MarkerFaceColor','blue')
        line([-1.5,1.5],[0,0],'Color','black','LineWidth',0.75)
        line([0,0],[-1,1],'Color','black','LineWidth',0.75)
        
        line([-mu,LagPts.L4(1)],[0,LagPts.L4(2)],'Color','black','LineWidth',2)
        line([1-mu,LagPts.L4(1)],[0,LagPts.L4(2)],'Color','black','LineWidth',2)
        line([-mu,LagPts.L5(1)],[0,LagPts.L5(2)],'Color','black','LineWidth',2)
        line([1-mu,LagPts.L5(1)],[0,LagPts.L5(2)],'Color','black','LineWidth',2)
        xlabel('\it{x-axis}')
        ylabel('\it{y-axis}')
        title('Eqilibrium Points and Primaries')
        
        set(gcf,'PaperPosition',[0 0 5 5]);
        set(gcf,'PaperSize',[5 5])
        %saveas(gcf, 'PrimAndEqPts', 'pdf');

    case 'L1L2NsecPrim'
        
      
        hold on
        grid on
        scatter([LagPts.L1(1),LagPts.L2(1)],...
        [LagPts.L1(2),LagPts.L2(2)],55,'*');
        

        scatter(-mu,0,200,'o','MarkerFaceColor','red')

        scatter(1-mu,0,75,'o','MarkerFaceColor','blue')
        
       
        xlabel('\it{x-axis}')
        ylabel('\it{y-axis}')
        
        
end



