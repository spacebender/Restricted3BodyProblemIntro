%{
...
Created on  28/2/2020 9:09

This File Stores the corrected (time and Initial Xvalues) and also the
Complete trajectory time and values after integration.

Inputs
------
1) EOM - Equation of Morion Function(In Global Data.
2) NoofFam - User Supplied in MAINScript-See description in
   MAINScript
3) CorrecPlot - User Supplied in MAINScript(will be 0/1)-See description in
   MAINScript

Outputs
--------
for all families
1) Corrected - Structure file containg corrected time and initial Xvalues for all
   the familes
                * Corrected.time
                * Corrected.InitialX
2) PeriodicFam - Structure file containg integrated time and Xvalues(full trajectory of periodic orbit) for all
   the familes(Can be used for Plotting)
                * PeriodicFam(1:NoofFam).X
                * PeriodicFam(1:NoofFam).t
            This is a (1 x NoofFam) structure.

Dependencies
------------
1) InitialGuess(PointLoc)
1) Continuation(XGuess,NoofFam,CorrecPlot)
2) Integrator(fun,x0,[0 tspan]);
...
%}
function [Corrected,PeriodicFam] = PerodicOrbitFamilydats(XGuess,EOM,NoofFam,CorrecPlot)

% Get all the corrected initial values for required No of families.

[Corrected.time,Corrected.InitialX,Corrected.DF] = Continuation(XGuess,NoofFam,CorrecPlot);

fun = EOM;
x0 = Corrected.InitialX;
tspan = Corrected.time;

% Obtain full trajectory vector for all the initial points and store it 
for Fam = 1:NoofFam
    
[t,x] = Integrator(fun,x0(Fam,:),[0 tspan(Fam)]);

PeriodicFam(Fam).X = x;
PeriodicFam(Fam).t = t;
end