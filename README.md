TMSRegressionClean
==================
EEGLAB plugin that filters TMS-artifacted EEG with butterworth filters and removes decay artifact with an exponential fit. (based on ASALAB's cleaning approach)

Dependencies
============
You will need the MATLAB's Signal Processing Toolbox and Curve Fitting Toolbox.

Installation
============
Place a folder containing all these files into {EEGLAB-DIRECTORY}/plugins (this is for all eeglab plugins). Run eeglab in MATLAB, and if properly placed you should see a line printed in eeglab stating 'EEGLAB: adding "TMSRegressionClean" v? (see >> help eegplugin_TMSRegressionClean)'.

The plugin is accessible through the Tools menu.

(tested using eeglab 13.1.1b)
