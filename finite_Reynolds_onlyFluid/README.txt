**************************************************************************
K. Wittkowski, LFMI, EPF Lausanne
A. Ponte, DICCA, Università di Genova
P.G. Ledda, DICAAR, Università di Cagliari
G.A. Zampogna, LFMI, EPF Lausanne
 
"Quasi-linear homogenization for large-inertia laminar transport 
across permeable membranes", 2024
**************************************************************************
The files in this folder correspond to ReL finite and no solute transport.
We propose the case ReL=400,alpha=75°,epsilon=0.1, with circular inclusions 
of porosity 0.7.

CA=constant advection closure
VA=variable advection closure

The files have been created in COMSOL Multiphysics 6.0 and tested on 
Matlab 2021 Livelink for COMSOL.
The use of different versions of may result in compatibility issues.

-"FS.mph" runs the full scale simulation;
-"MAIN_onlyFluid.m" is the main script to run the macroscopic simulations
	the first iteration always corresponds to the Stokes model,
	mode CA and VA are available;
-"macro.m" (function) runs a single macroscopic computation,
	requires the input of strings of tensors and outputs the 
	stresses (U,D) and velocity on the membrane cellwise;
-"micro_CA.m" (function) runs microscopic problems with constant 
	advection model. Input: list of velocities, output: M_ij,N_ij values;
-"micro_VA.m" (function) runs microscopic problems with variable
	advection model. Input: list of stresses, output: M_ij,N_ij values;
-"rel_error.m" (function) computes the relative error velocity magnitude
	on the membrane between two iterations;
-"string_writer.m" (function): produces strings of M_ij,N_ij values for the
	 macroscopic simulation;
-"cellwise_reader.m" (function) reads the cellwise stress and velocity 
	values and produces a list for the microscopic simulations;
-"reader.m" manually operated, plots the velocity on the membrane.