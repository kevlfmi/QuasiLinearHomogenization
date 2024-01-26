**************************************************************************
K. Wittkowski, LFMI, EPF Lausanne
A. Ponte, DICCA, Università di Genova
P.G. Ledda, DICAAR, Università di Cagliari
G.A. Zampogna, LFMI, EPF Lausanne
 
"Quasi-linear homogenization for large-inertia laminar transport 
across permeable membranes", 2024
**************************************************************************
The files in this folder correspond to ReL=0, PeL=1000
alpha=90° and epsilon=0.1, with circular inclusions of porosity 0.7.

CA=constant advection closure
VA=variable advection closure

The files have been created in COMSOL Multiphysics 6.0 and tested on 
Matlab 2021 Livelink for COMSOL.
The use of different versions of may result in compatibility issues.

-"FS.mph" runs the full scale simulation;
-"MAIN_slt.m" is the main script to run the macroscopic simulations
	the first iteration always corresponds to the Stokes model,
	mode CA and VA are available;
-"macro_slt.m" (function) runs a single macroscopic computation,
	requires the input of strings of tensors and outputs the 
	stresses (U,D) and velocity on the membrane cellwise;
-"micro_slt_CA.m" (function) runs microscopic problems with constant 
	advection model. Input: list of velocities, output: T,S values;
-"micro_slt_VA.m" (function) runs microscopic problems with variable
	advection model. Input: list of stresses, output: T,S values;
-"rel_error_slt.m" (function) computes the relative error on concentration
	between two iterations;
-"string_writer.m" (function): produces strings of T,S values for the
	 macroscopic simulation;
-"cellwise_reader_slt.m" (function) reads the cellwise stress and velocity 
	values and produces a list for the microscopic simulations;
-"results_reader.m" manually operated, plots the velocity and concentration 
	on the membrane.
**************************************************************************
All the files are available under

MIT License

Copyright (c) 2024 Kevin Wittkowski, Alberto Ponte, Pier Giuseppe Ledda, 
Giuseppe Antonio Zampogna

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
