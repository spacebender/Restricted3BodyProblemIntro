%{
...
Created on  26/2/2020 12:58
Modified to Final Form : 27/2/2020 20:00

This File performs the Continuation Process.
Inputs
------
1) X_Guess - Initial guess Calculated by the 'InitialGuess' function file.
2) NoofFam - User Supplied in MAINScript-See description in
   MAINScript
3) CorrecPlot - User Supplied in MAINScript(will be 0/1)-See description in
   MAINScript

Outputs
--------
for all families
1) tCorrec - Corrected half time value for perpendicular XZ plane crossing
2) xCorrec - Corrected Initial Value to obtain the periodic orbit.
3) DF - Final DF matrix(this is just for the user to see)

Dependencies
------------
1) DiffCorrec(XGuess,CorrecPlot);

References
----------
1) Wang Sang Koon, Martin W Lo,JE Marsden, Shane D Ross - "Dynamical
   Systems,the Three Body Problem and Space Mission Design", 2011(Main
   Procedure- Pg 112 Chapter 4)
2) Tatiana Mar Vaquero Escribano - "Poincare Sections And Resonant Orbits In 
   the Restricted Three Body Problem",MS Thesis,Purdue University,2010.
   (Chapter 2 - Sec 2.3 and 2.4).
3) Thomas A. Pavlak - "Mission Design Applications In the Earth Moon
   System:Transfer Trajectories And StationKeeping",MS Thesis, Purdue
   University, 2010 May
   (Chapter 2 - Sec 2.3 and 2.4)

Note: These references DONOT have different methods , underlying concept is Newtons
method, refrences are just for convinience one can follow any source. 
...
%}
function [tCorrec,xCorrec,DF] = Continuation(XGuess,NoofFam,CorrecPlot,G_var)



family = 1;
fprintf('===============================================\n')
fprintf('Obtaining the Corrected Values for family:- %d\n',family)
fprintf('===============================================\n')
fprintf('\nThe Guess X value is : [%f %f %f %f %f %f]\n',XGuess.one)
[tCorrec(family,1),xCorrec(family,:),DF(:,:,family)] = DiffCorrec(XGuess.one,CorrecPlot,G_var);

family = 2;
fprintf('\n===============================================\n')
fprintf('Obtaining the Corrected Values for family:- %d\n',family)
fprintf('===============================================\n')
fprintf('\nThe Guess X value is : [%f %f %f %f %f %f]\n',XGuess.two)
[tCorrec(family,1),xCorrec(family,:),DF(:,:,family)] = DiffCorrec(XGuess.two,CorrecPlot,G_var);

for family = 3:NoofFam
fprintf('\n===============================================\n')
fprintf('Obtaining the Corrected Values for family:- %d\n',family)
fprintf('===============================================\n')
% Continuation Process from Ref[1]
delta = xCorrec(family-1,:) - xCorrec(family-2,:);
GuessX = xCorrec(family-1,:) + delta;
fprintf('\nThe Guess X value is : [%f %f %f %f %f %f]\n',GuessX)
[tCorrec(family,1),xCorrec(family,:),DF(:,:,family)] = DiffCorrec(GuessX,CorrecPlot,G_var);

end







