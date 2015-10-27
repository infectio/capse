Infectio (CAPSE implementation)
=====

a Generic Simulation Framework for Predicting Virus Transmission between Biological Cells
-----------------------------------------------------------------------------------------
Welcome to Infectio CAPSE implementation - an open source project is aimed at simulating viral transmission in a population of cells. This webpage/readme is aimed at introducing you to the project and getting started with using the software.



Background Information about the Project
----------------------------------------
Viruses spread between cells, tissues and organisms by cell-free and cell-cell mechanisms depending on the cell types, viruses or phase of infection cycle.  These two principle modes of transmission can be nearly exclusive, or simultaneous, depending on the virus, cell and time of infection.  The mode of viral transmission has a large impact on disease development and the outcome of anti-viral therapies.  Yet, it has been difficult to distinguish between different transmission modes due to the complex underlying biology.  Using live-cell imaging we have previously characterized the cell-free transmission mode of human adenovirus in monolayers of epithelial cells, and developed an *in silico* model with multi-scale hybrid dynamics, cellular automata and particle strength exchange.   Here we enhance this model to incorporate cell-to-cell and mixed modes of virus transmission using experimental data for vaccinia virus. We postulate that a generic plaque formation model requires cellular and cell-free components.  Since validation of this postulate requires modeling every virus known, we make our generalized open source simulation framework which is receptive for both experimental and programming contributions through a crowd sourcing platform.  The framework will enable better understanding of key parameters controlling the spatial dynamics of viral spreading.



##Getting Started

1. Clone the Projects repository from the [https://github.com/infectio/capse](https://github.com/infectio/capse) or download a zip and unpack it.

2. Open MATLAB Integrated Development Environment (IDE) and navigate to the folder containing the repository (or the unpacked contents of the ZIP).

3. In MATLAB IDE open ../src/matlab/infectioGUI.m and start it - a window of the Infectio Graphic User Interface (GUI) should open.

4. In the Infectio GUI window under 'Select Simulation Parameters Set' select the parameters set you would like to run (e.g. 'VirusModel_Test.m').

5. Below under 'Please Specify Output Folder...' press 'Browse' and select your output directory. That is the directory where simulation output plots (TIFF) will be saved.

6. Once set up press 'run' button in the lower right of the screen.

7. Upon each step the graphical output of the simulation will be displayed and saved in in the user specified directory.




##Changing or Creating a New Set of Simulation Parameters

1. Navigate to the capse/src/matlab/+caps/+models

2. Open a .m file or create a new one and copy the contents of the VirusModel_Test.m file to the newly created file

3. Edit values of the following variables to override the default values and alter your simulations conditions:

*Virus Type - these values are based on the experimentally measured particle to GFP intensity abstraction (see Yakimovich et al. 2012 for more details). Adding new viruses requires a comparable data table for the virus of interest which could be found in capse/src/matlab/input/parameters.*

```
% Declare Virus strain (type). Possible values are: % {'HAdV-E3B','HAdV-E1B', 'VACV-IHD-J', 'VACV-WR'}
```
```
virusType = 'VACV-WR';
```
 
 *Model size defined by the number of the horizontal cells in the hexagonal lattice*
```
cells_x = 5; % small model for debug purposes
``` 
 *If set to TRUE the following parameter will wait for key stroke or user input after every iteration of the CA (useful for debugging):*
``` 
pauseOnCAIterations = false; % Wait for key stroke or user input after every iteration
```
*Choose whether the PSE particles should be displayed on top of the CA cells in the simulation output (useful for debugging):*
```
virusFlags.plotImagesWithParts = false; % Should the images be displayed with or without PSE particles
```
*Choose whether to apply advection. Advection: true - apply flow, flase - don't:*
```
virusFlags.isAdvectionEnabled = false; % advection: true - apply flow, flase - don't
```
*Total time steps for the model to run in hours post infection:*
```
TotalTimeStepsHPI = 10; % Total time steps for the model to run in hours post infection
```
*The following parameter switches the cell-to-cell spread ON and OFF:*

```
virusFlags.isSpreadCell2CellLimitedByTime = true;
```

*The following parameter switches the limitation by the produced virus in the cell-to-cell spread ON and OFF (see paper by Yakimovich and Yakimovich for more details):*
```
virusFlags.isSpreadCell2CellLimitedByVirusAmount = false;
```
*The following parameter switches the cell-free spread ON and OFF:*
```
virusFlags.isCellFreeSpreadEnabled = false;
```

*The following parameter defines the initial cell-to-cell infection:*
```
initialC2cInfection = 1;
```













Copyright © 2014 - 2016 Artur Yakimovich and Yauhen Yakimovich

