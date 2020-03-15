function [tCorrec,xCorrec,DF] = GrebowContinuation(XGuess,NoofFam,CorrecPlot)

family = 1;
fprintf('===============================================\n')
fprintf('Obtaining the Corrected Values for family:- %d\n',family)
fprintf('===============================================\n')
fprintf('\nThe Guess X value is : [%f %f %f %f %f %f]\n',XGuess.one)
[tCorrec(family,1),xCorrec(family,:),DF(:,:,family)] = DiffCorrec(XGuess.one,CorrecPlot);

 deltaS = 0.00012; % increasing thos will fail to converge.
for family = 2:NoofFam

fprintf('===============================================\n')
fprintf('Obtaining the Corrected Values for family:- %d\n',family)
fprintf('===============================================\n')
% Continuation Process from Ref[2]
GuessX = xCorrec(family-1,:)-deltaS*[1 0 0 0 0 0];

fprintf('The Guess X value is [%f %f %f %f %f %f]\n',GuessX)
[tCorrec(family,1),xCorrec(family,:),DF(:,:,family)] = DiffCorrec(GuessX,CorrecPlot);
end