# General info
The following code performs a random walk using the dimensionless version of the Lagevin equation. A pdf with the respective equations can be found under the name Equation.pdf within this repository. 

# Libraries used
The programme mostly uses built-in FORTRAN 90 functions. 

* IEEE_ARITHMETIC - This library is used in order to detect NaN and Infty values that may cause the programme to crash.

Also two subroutines are used written within the code:

* Random_StdNormal - Which generates random numbers from random numbers taken from a normal distribution with mean 0 and varaince 1, using the Box-Muller method.

* File_Naming - Which names the file were the random steps are stored in a realiable way that enables the user to quickle know the parameters of the random walk.

# Setup
To compile and execute the code the compiler gfortran is necessary. 

* In Linux (Ubunut) the code is compiled by typing in terminal

gfortran Langevin_Random_Walk_Dimensionless.f90 -o Langevin_Random_Walk_Dimensionless

* To execute it type in terminal

./Langevin_Random_Walk_Dimensionless

* To use the code create and specific folder. In such folder compile the code and save the files to be used to create the histogram.

# Test datafile
In order for the user to give it a try along side this programme you can find a random walk file named 'STEPS_RNDM_WALK_13_  1.0000_0000001000_.dat' where a random walk has been stored.

I also provide a short script for gnuplot in order to visualize such random walk. The file is 'Plot_Rndm_Walk.plt'

