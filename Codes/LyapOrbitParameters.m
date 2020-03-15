%{
...
Created on  9/3/2020 18:47

This File does the continuation and gets all the Lyapunov orbit parameters.

Inputs
------
1) UserDat - Supplied UserData in main file.
2) G_var   - Global data.

Outputs
--------
1) LyapOrb - A structure (1 x NoofEqPoints) containing 
                - time      - full time period for each lyapunov orbits.
                - IC        - Initial Conditions for all Lyapunov Orbits.
                - Energy    - Energy Value for all Lyapunov Orbits.
                - Monodromy - Monodromy matrix of all Lyapunov Orbits.
                - Eigens    - Eigen Values and Eigen Vectors for all Lyapunov Orbits.
                                    - Stable,Unstable and Center Eigen Values
                                    - Stable,Unstable and Center Eigen Vectors

Note that the size of eigen values and eigen vectors might change

Dependencies
------------
1) InitialGuess(PointLoc,G_var)
2) DiffCorrec(X_Guess,Plot,G_var)
                        

Reference for continuation 
--------------------------
1) Wang Sang Koon, Martin W Lo,JE Marsden, Shane D Ross - "Dynamical
   Systems,the Three Body Problem and Space Mission Design", 2011
...
%}
function [LyapOrb] = LyapOrbitParameters(UserDat,G_var)
% Extract the parameters
NoofFam    = UserDat.NoofFam;
CorrecPlot = UserDat.CorrectionPlot;
NoofEqPoints = UserDat.PointLoc;
Dimension = UserDat.Dimension;
mu = G_var.Constants.mu;
funVarEq = G_var.IntFunc.VarEqAndSTMdot;

% Initialize
tCorrec = zeros(NoofFam,1);
xCorrec = zeros(NoofFam,2*Dimension);
Energy = zeros(NoofFam,1);
Monodromy = zeros(2*Dimension,2*Dimension,NoofFam);



for PointLoc = 1:NoofEqPoints
fprintf('*******************************************\n')
fprintf('Starting the process for L%d Eq.Point\n',PointLoc)
fprintf('*******************************************\n')

[XGuessL] = InitialGuess(PointLoc,G_var);
if Dimension == 3
XGuessL = XGuessL(1);
elseif Dimension == 2
XGuessL = XGuessL(2);
end



family = 1;
fprintf('===============================================\n')
fprintf('Obtaining the Corrected Values for family:- %d\n',family)
fprintf('===============================================\n')
fprintf('\nThe Guess X value is : [%f %f %f %f %f %f]\n',XGuessL.one)
[tCorrec(family,1),xCorrec(family,:),DF(:,:,family)] = DiffCorrec(XGuessL.one,CorrecPlot,G_var);


fprintf('\n')
fprintf('Determining th orbits Parameters ..\n')
fprintf('\n')

Energy(family,1) = jacobiValue3D(xCorrec(family,:),mu);
[~,Monodromy(:,:,family),~,~] = StateTransAndX(G_var,xCorrec(family,:),funVarEq,tCorrec(family,1));
[Eigens(family).S_EigVal,Eigens(family).US_EigVal,Eigens(family).C_Val,Eigens(family).S_EigVec,...
    Eigens(family).US_EigVec,Eigens(family).C_EigVec] = CalcEigenValVec(Monodromy(:,:,family),1) ;

% fprintf('Energy of the orbit:- %d\n',Energy(family,1))
% fprintf('Monodromy Matrix:- %d\n',Monodromy(:,:,family))
% fprintf('Stable Eigen Value:- %d\n',Eigens(family).S_EigVal)
% fprintf('Unstable Eigen Value:- %d\n',Eigens(family).US_EigVal)
% fprintf('Center Eigen Value:- %d\n',Eigens(family).C_Val)
% fprintf('Stable Eigen Vector:- %d\n',Eigens(family).S_EigVec)
% fprintf('Unstable Eigen Vector:- %d\n',Eigens(family).US_EigVec)
% fprintf('Center Eigen Vector:- %d\n',Eigens(family).C_EigVec)


family = 2;
fprintf('\n===============================================\n')
fprintf('Obtaining the Corrected Values for family:- %d\n',family)
fprintf('===============================================\n')
fprintf('\nThe Guess X value is : [%f %f %f %f %f %f]\n',XGuessL.two)
[tCorrec(family,1),xCorrec(family,:),DF(:,:,family)] = DiffCorrec(XGuessL.two,CorrecPlot,G_var);

fprintf('\n')
fprintf('Determining th orbits Parameters ..\n')
fprintf('\n')

Energy(family,1) = jacobiValue3D(xCorrec(family,:),mu);
[~,Monodromy(:,:,family),~,~] = StateTransAndX(G_var,xCorrec(family,:),funVarEq,tCorrec(family,1));
[Eigens(family).S_EigVal,Eigens(family).US_EigVal,Eigens(family).C_Val,Eigens(family).S_EigVec,...
    Eigens(family).US_EigVec,Eigens(family).C_EigVec] = CalcEigenValVec(Monodromy(:,:,family),1) ;

% fprintf('Energy of the orbit:- %d\n',Energy(family,1))
% fprintf('Monodromy Matrix:- %d\n',Monodromy(:,:,family))
% fprintf('Stable Eigen Value:- %d\n',Eigens(family).S_EigVal)
% fprintf('Unstable Eigen Value:- %d\n',Eigens(family).US_EigVal)
% fprintf('Center Eigen Value:- %d\n',Eigens(family).C_Val)
% fprintf('Stable Eigen Vector:- %d\n',Eigens(family).S_EigVec)
% fprintf('Unstable Eigen Vector:- %d\n',Eigens(family).US_EigVec)
% fprintf('Center Eigen Vector:- %d\n',Eigens(family).C_EigVec)


%% Start Continuation
for family = 3:NoofFam
fprintf('\n===============================================\n')
fprintf('Obtaining the Corrected Values for family:- %d\n',family)
fprintf('===============================================\n')

delta = xCorrec(family-1,:) - xCorrec(family-2,:);
GuessX = xCorrec(family-1,:) + delta;
fprintf('\nThe Guess X value is : [%f %f %f %f %f %f]\n',GuessX)
[tCorrec(family,1),xCorrec(family,:),DF(:,:,family)] = DiffCorrec(GuessX,CorrecPlot,G_var);

fprintf('\n')
fprintf('Determining th orbits Parameters ..\n')
fprintf('\n')

Energy(family,1) = jacobiValue3D(xCorrec(family,:),mu);
[~,Monodromy(:,:,family),~,~] = StateTransAndX(G_var,xCorrec(family,:),funVarEq,tCorrec(family,1));
[Eigens(family).S_EigVal,Eigens(family).US_EigVal,Eigens(family).C_Val,Eigens(family).S_EigVec,...
    Eigens(family).US_EigVec,Eigens(family).C_EigVec] = CalcEigenValVec(Monodromy(:,:,family),1) ;

% fprintf('Energy of the orbit:- %d\n',Energy(family,1))
% fprintf('Monodromy Matrix:- %d\n',Monodromy(:,:,family))
% fprintf('Stable Eigen Value:- %d\n',Eigens(family).S_EigVal)
% fprintf('Unstable Eigen Value:- %d\n',Eigens(family).US_EigVal)
% fprintf('Center Eigen Value:- %d\n',Eigens(family).C_Val)
% fprintf('Stable Eigen Vector:- %d\n',Eigens(family).S_EigVec)
% fprintf('Unstable Eigen Vector:- %d\n',Eigens(family).US_EigVec)
% fprintf('Center Eigen Vector:- %d\n',Eigens(family).C_EigVec)


%% Store all the values
LyapOrb(PointLoc).time      = tCorrec; %(NoofFam x 1) - Full Orbit Time
LyapOrb(PointLoc).IC        = xCorrec; %(NoofFam x UserDat.Dimension)
LyapOrb(PointLoc).Energy    = Energy;
LyapOrb(PointLoc).Monodromy = Monodromy;
LyapOrb(PointLoc).Eigens    = Eigens;

end
end
end

