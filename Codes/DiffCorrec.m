%{
...
Created on  27/2/2020 17:42

This File performs the Diffrential Correction Process.

Inputs
------
1) X_Guess - initial guess Calculated by the 'InitialGuess' function file.
2) Plot - User Supplied in MAINScript(will be 0/1)-See description in
   MAIN_LyapOrbit.m

Outputs
--------
1) tCorrec - Corrected half time value for perpendicular XZ plane crossing
2) xCorrec - Corrected Initial Value to obtain the periodic orbit.
3) DF - Final DF matrix(this is just for the user to see)

References
----------
1) Wang Sang Koon, Martin W Lo,JE Marsden, Shane D Ross - "Dynamical
   Systems,the Three Body Problem and Space Mission Design", 2011
2) Tatiana Mar Vaquero Escribano - "Poincare Sections And Resonant Orbits In 
   the Restricted Three Body Problem",MS Thesis,Purdue University,2010.
   (Chapter 2 - Sec 2.3 and 2.4).
3) Thomas A. Pavlak - "Mission Design Applications In the Earth Moon
   System:Transfer Trajectories And StationKeeping",MS Thesis, Purdue
   University, 2010 May
   (Chapter 2 - Sec 2.3 and 2.4)

Note: These references DONOT have different methods , underlying concept is Newton's
method, refrences are just for convinience, one can follow any source. 
...
%}

function [tCorrec,xCorrec,DF] = DiffCorrec(X_Guess,Plot,G_var)
% Extract from Global Data

f1 = G_var.IntFunc.EOM;
f2 = G_var.IntFunc.VarEqAndSTMdot;
tspan = [0 10];


MaxIteration = 10;
iteration = 1; % set the iteration value

if length(X_Guess) < 6
    Xfree = X_Guess(4);
elseif X_Guess(3)== 0
    Xfree = X_Guess(5);
else 
    Xfree = [X_Guess(3);X_Guess(5)];
end
del_xDotf = 1;
del_zDotf = 1;
Fx = [del_xDotf;del_zDotf];
while  norm(Fx)>1.e-10
    ax = gca; ax.ColorOrderIndex = iteration;
    
% Check the max iteration and stop
if iteration > MaxIteration
    disp('Maximum number of iterations exceded: Check for errors in script') 
    break;
end

fprintf('\nDiffrenrential Correction iteration no: %d',iteration)

% Obtain a Baseline Solution (This gives the variational end point which is
% the constarint to be satisfied)
[tb,xb] = Integrator(G_var,f1,X_Guess,tspan,'Events');

% Develop the constraint vector
if length(X_Guess)<6
    del_yf = xb(end,2) ;
    del_xDotf =xb(end,3); 
    del_yDotf = xb(end,4); 
    Fx = del_xDotf;
elseif X_Guess(3) == 0
    del_yf = xb(end,2) ;
    del_xDotf =xb(end,4); 
    del_yDotf = xb(end,5); 
    Fx = del_xDotf;
else 
    del_yf = xb(end,2) ;
    del_xDotf =xb(end,4) ;
    del_zDotf = xb(end,6);
    Fx = [del_xDotf;del_zDotf];
    
end


% Plot If Required
if Plot == 1
if length(X_Guess)<6 || X_Guess(3) == 0

    plot(xb(:,1),xb(:,2))
        ax = gca; ax.ColorOrderIndex = iteration;
    hold on
    plot(xb(1,1),xb(1,2),'*')
        ax = gca; ax.ColorOrderIndex = iteration;
    plot(xb(end,1),xb(end,2),'o')
        ax = gca; ax.ColorOrderIndex = iteration;
    axis tight
else

    plot3(xb(:,1),xb(:,2),xb(:,3))
        ax = gca; ax.ColorOrderIndex = iteration;
    hold on
    plot3(xb(1,1),xb(1,2),xb(:,3),'*')
        ax = gca; ax.ColorOrderIndex = iteration;
    plot3(xb(end,1),xb(end,2),xb(:,3),'o')
        ax = gca; ax.ColorOrderIndex = iteration;
    axis tight
end
end


% Now get the STM(State Transistion Matrix)

[t,PHItf,x,xf] = StateTransAndX(G_var,X_Guess,f2,tb(end));
% Get the final Vector Field from the EOM

X_DotDotf = CRes3BP_EOM([],xb(end,:),G_var.Constants.mu);
if length(X_Guess)<6
    y_Dotf = X_DotDotf(2);
    x_DotDotf = X_DotDotf(3);
    DF = (PHItf(3,4)*y_Dotf - PHItf(2,4)*x_DotDotf)/y_Dotf;
    Xfree = Xfree - (1/DF)*Fx;
    X_Guess(4) = Xfree; % Corrected yDot value
elseif X_Guess(3) == 0
    y_Dotf = X_DotDotf(2);
    x_DotDotf = X_DotDotf(4);
    DF = (PHItf(4,5)*y_Dotf - PHItf(2,5)*x_DotDotf)/y_Dotf;
    Xfree = Xfree - (1/DF)*Fx;
    X_Guess(5) = Xfree; % Corrected yDot value
else
    y_Dotf = X_DotDotf(2);
    x_DotDotf = X_DotDotf(4);
    z_DotDotf = X_DotDotf(6);
    DF = ([PHItf(4,3) PHItf(4,5);PHItf(6,3) PHItf(6,5)] - (1/y_Dotf)*[x_DotDotf;z_DotDotf]*[PHItf(2,3) PHItf(2,5)]);
    Xfree = Xfree - DF\Fx;
    X_Guess(3) = Xfree(1);
    X_Guess(5) = Xfree(2);
end
% DF matrix




iteration = iteration + 1;  % Update Iteration   

end
xCorrec = X_Guess;
tCorrec = 2*tb(end);
%DF = ([PHItf(4,3) PHItf(4,5);PHItf(6,3) PHItf(6,5)] - (1/y_Dotf)*[x_DotDotf;z_DotDotf]*[PHItf(2,3) PHItf(2,5)]);
%null(DF)

if length(xCorrec) >4
fprintf('\n\nThe Corrected Initial Value is : [%f %f %f %f %f %f]\n',xCorrec)
fprintf('The final X(Xf) is : [%f %f %f %f %f %f]\n',xb(end,:))
else
fprintf('\nThe Corrected Initial Value is : [%f %f %f %f]\n',xCorrec)
fprintf('The final X(Xf) is : [%f %f %f %f]\n',xb(end,:))
end
    
