%{
...
Created on 8/3/2020 1:26 AM
This file contains some important parameters of Sun,Planets and Natural
Satellites

natural Satellites in order
-------------------
- First four belongs to Jovian  
- Earth's  
- Saturn's
- Neptune's 

Inputs
------
1) Primary - Sun or any of the nine planets
2) Secondary - Any of nine Planets or any of Moons Listed

Outputs
--------
1) mu - The Constant Mass Parameter for ThreeBodyProblem.

Reference
-----------
All the values are taken from NASA Planetary facts.
...
%}
function [mu] = SunPlanetMoonParameters(Primary,Secondary)
Mass_Mfactor = 1e24;
SunDist = 1e6;

%% Star Parameters
% ---------------------
Star.Name                   = {'Sun'};
Star.Mass                   = 1988500*Mass_Mfactor;
Star.G_accel                = 274.0;
Star.EscapeVelocity         = 617.6;
Star.SiderealRotPeriod      = 609.12;
Star.Obliquity              = 7.25;

%% Planet Parameters
% ----------------------
Planets.Names               = {'Mercury' 'Venus'  'Earth'  'Mars'   'Jupiter' 'Saturn' 'Uranus' 'Neptune' 'Pluto'};
Planets.Masses              = [0.033011   4.8675   5.9723   0.64171  1898.19   568.34   86.813   102.413   0.01303]*Mass_Mfactor;
Planets.G_accel             = [3.70       8.87     9.798    3.71     24.79     10.44    8.87     11.15     0.62];
Planets.EscapeVelocity      = [4.3        10.36    11.186   5.03     59.5      35.5     21.3     23.5      1.21];
Planets.Perhelion           = [46.00      107.48   147.09   206.62   740.52    1352.55  2741.30  4444.45   4436.82]*SunDist;
Planets.Aphelion            = [69.82      108.94   152.10   249.23   816.62    1514.50  3003.62  4545.64   7375.93]*SunDist;
Planets.MaxOrbitalVel       = [47.36      35.26    30.29    26.50    13.72     10.18    7.11     5.50      6.10];
Planets.MinOrbitalVel       = [38.86      34.79    29.29    21.97    12.44     9.09     6.46     5.37      3.71];
Planets.SiderealRotPeriod   = [1407.6     -5832.6  23.9345  24.6229  9.9250    10.656   -17.24   16.11     -153.2928];
Planets.LengthofDay         = [4222.6     2802.00  24       24.6597  9.9259    10.656   17.24    16.11     153.2820];
Planets.Obliquity           = [0.034      177.36   23.44    25.19    3.13      26.73    82.23    28.32     122.53];
Planets.Eccentricity        = [0.2056     0.0067   0.0167   0.0935   0.0489    0.0565   0.0457   0.0113    0.2488];

Planets.MeanOrbitalVel      = (Planets.MaxOrbitalVel + Planets.MinOrbitalVel)/2;
Planets.SemiMajorAxis       = (Planets.Perhelion + Planets.Aphelion)/2;


%% Moons Parameters
% --------------------
Moons.Names                 = {'Callisto' 'Ganymede' 'Europa'  'IO'      'Moon'    'Titan'    'Triton'};
Moons.Masses                = [107.6       148.2      48.0      89.3      73.5      134.6      21.5]*1e21;
Moons.G_accel               = [1.24        1.43       1.31      1.80      1.6       1.35       0.78];
Moons.EscapeVelocity        = [2.4         2.7        2.0       2.6       2.4       2.6        1.5];
Moons.Periapse              = [1870        1068       664       420       363       1186       354.76]*1e3;
Moons.Apoapse               = [1896        1072       678       424       406       1258       354.76]*1e3;
Moons.OrbitalVel            = [8.2         10.9       13.7      17.3      1.052     5.6        4.4];
Moons.OrbitalPeriod         = [16.689017   7.154553   3.551181  1.769138  27.3217   15.945421  5.87685];
Moons.Inclination           = [0.19        0.18       0.47      0.04      18.28     0.33       157.345];
Moons.Eccentricty           = [0.007       0.001      0.009     0.004     0.0549    0.0292     0.000016];
Moons.SemimajorAxis         = [1882.7      1070.4     671.1     421.8     384.4     1221.83    354.76]*1e3;

%% Required Outputs
% ---------------------
if strcmpi('Sun',Primary) == 1 && any(contains(Planets.Names,Secondary,'IgnoreCase',true))
    Prim_Mass = Star.Mass;
    Index = contains(Planets.Names,Secondary,'IgnoreCase',true);
    Sec_Mass = Planets.Masses(Index);
elseif any(contains(Planets.Names,Primary,'IgnoreCase',true))
    Index1 = contains(Planets.Names,Primary,'IgnoreCase',true);
    Prim_Mass = Planets.Masses(Index1);
    Index2 = contains(Moons.Names,Secondary,'IgnoreCase',true);
    Sec_Mass = Moons.Masses(Index2);
elseif strcmpi('Sun',Primary) == 1 && strcmpi('EarthMoon',Secondary)
    Prim_Mass = Star.Mass;
    Sec_Mass = Planets.Masses(3) + Moons.Masses(5);
end
mu = Sec_Mass/(Sec_Mass + Prim_Mass);



            
         
end
