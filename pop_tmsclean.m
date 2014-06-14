% pop_tmsclean() - Before running tmsclean, make sure you remove HEOG and VEOG
% channels. Cleans TMS artifacted data. First the signal is rereferenced
% to the common average reference. Afterwards the raw signal is
% reverse-time filtered by a 5th order band pass butterworth  and notch
% (which distorts only pre stimulus values). A region post-stimulus is then 
% rejected based on visually determining where the exponential restabilization 
% begins. An exponential regression is then performed for a certain window 
% after the rejected window and substracted from the altered signal. 
% Additionally, a prestimulus region is kept by forward-time filtering the 
% raw signal and extracting the specified pre stimulus window. Requires the signal
% processing and curve fitting toolboxes.
%
% Usage:
%   >> [EEG] = pop_tmsclean(EEG);
%   >> [EEG] = pop_tmsclean( EEG, chan, lowcut, highcut, notch, targevent,  prestim, exclude, explen);
%
% Graphic interface:
%
%   "Channel number ([ ] m" -   [edit box] specify name of channel number
%                               to filter. [] corresponds to all channels.
%                             
%   "Low cut [Hz]"          -   [edit box] specify low cutoff frequency of
%                               band pass
%
%   "High cut [Hz]"         -   [edit box] specify high cutoff frequency
%                                of band pass
%
%   "Notch [Hz]"            -   [edit box] specify notch frequency
%
%   "Event Labels corre[s]" -   [edit box] specify event Label for event which 
%                               must be just before the TMS pulse.
%
%   "Pre-stimulus Inter[s]" -   [edit box] specify window before the tms onset
%                                event which will be kept 
%
%   "Artifact Exclusion[s]" -   [edit box] specify window after event
%                               corresponding to region before exponential 
%                               restabilizaiton
%
%   "Regression Window [s]" -   [edit box] specify length of regression
%                               after artifact exclusion used to compute
%                               regression
%
% Inputs:
%   filename                   - file name
%
%
% Outputs:
%   [EEG]                       - EEGLAB data structure
%
%
% Author: Prasad Tendolkar, Biomedical Engineering Department, New Jersey Institute of Technology, 2014
%
% See also: eeglab()

function EEG = pop_tmsclean(EEG, varargin)
    if (nargin < 9)
        if(nargin>1)
            warning(cat(2, num2str(nargin-1), ' parameters specified. Need 9.'));
        end
        
        g = [1 0.3];
        geometry = {g g g g g g g g};

        uilist = { ...
          { 'Style', 'text', 'string', 'Channel number ([ ] means all)', 'fontweight', 'bold'  } ...
          { 'Style', 'edit', 'string', '15' 'tag' 'chan'} ...
          ...
          { 'Style', 'text', 'string', 'Low Cut [Hz]', 'fontweight', 'bold'} ...
          { 'Style', 'edit', 'string', '1' 'tag' 'lowcut'} ...
          ...
          { 'Style', 'text', 'string', 'High Cut [Hz]', 'fontweight', 'bold'} ...
          { 'Style', 'edit', 'string', '100' 'tag' 'highcut'} ...
          ...
          { 'Style', 'text', 'string', 'Notch [Hz]', 'fontweight', 'bold'} ...
          { 'Style', 'edit', 'string', '60' 'tag' 'notch'} ...
          ...
          { 'Style', 'text', 'string', 'Event label corresponding to TMS onset [s]', 'fontweight', 'bold'} ...
          { 'Style', 'edit', 'string', '2' 'tag' 'targevent'} ...
          ...
          { 'Style', 'text', 'string', 'Pre-stimulus interval [s]', 'fontweight', 'bold'} ...
          { 'Style', 'edit', 'string', '0.025' 'tag' 'prestim'} ...
          ...
          { 'Style', 'text', 'string', 'Artifact exclusion interval [s]', 'fontweight', 'bold'} ...
          { 'Style', 'edit', 'string', '0.015' 'tag' 'exclude'} ...
          ...
          { 'Style', 'text', 'string', 'Regression Window Length [s]', 'fontweight', 'bold'} ...
          { 'Style', 'edit', 'string', '0.100' 'tag' 'explen'} ...
          };

      [ ~, ~, ~, structout ] = inputgui( geometry, uilist, ...
           'pophelp(''pop_tmsclean'');', 'TMS Artifact Removal');
        EEG = tmsclean( EEG, int32(str2double(structout.chan)),...
                        str2double(structout.lowcut) , str2double(structout.highcut), ...
                        str2double(structout.notch), structout.targevent,...
                        str2double(structout.prestim), str2double(structout.exclude),...
                        str2double(structout.explen));
    else
        EEG = tmsclean( EEG, varargin{1}, varargin{2}, varargin{3}, varargin{4}. varargin{5}, varargin{6}, varargin{7}, varargin{8});
    end
    fprintf('Completed.\n');
end