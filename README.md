TMSRegressionClean
==================
EEGLAB plugin that filters TMS-artifacted EEG with butterworth filters and removes decay artifact with an exponential fit. (based on ASALAB's cleaning approach)

It returns a "cleaned" continuous EEG dataset. The input dataset should be continuous as well. An example dataset is provided (.set), event 2 marks tms impulse onset.

Before running tmsclean, make sure you remove HEOG and VEOG channels. Cleans TMS artifacted data. First the signal is rereferenced to the common average reference. Afterwards the raw signal is reverse-time filtered by a 5th order band pass butterworth  and notch (which distorts only pre stimulus values). A post-stimulus region is then rejected based on visually determining where the exponential restabilization begins. An exponential regression is then performed for a certain window after the rejected window and substracted from the altered signal. Additionally, a prestimulus region is kept by forward-time filtering the raw signal and extracting the specified pre stimulus window. Requires the signal processing and curve fitting toolboxes.

Dependencies
============
You will need MATLAB's Signal Processing Toolbox and Curve Fitting Toolbox.

Installation
============
Place a folder containing all these files into {EEGLAB-DIRECTORY}/plugins (this is for all eeglab plugins). Run eeglab in MATLAB, and if properly placed you should see a line printed in the command line stating 'EEGLAB: adding "TMSRegressionClean" v? (see >> help eegplugin_TMSRegressionClean)'.

The plugin is accessible through the Tools menu.


(tested using eeglab 13.1.1b)
