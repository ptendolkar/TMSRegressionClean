function eegplugin_TMSRegressionClean(fig, try_srings, catch_strings)

vers = 'TMSRegressionClean1.0';

toolmenu= findobj(fig, 'tag', 'tools');
uimenu( toolmenu, 'label', 'TMS Artifact Removal', ...
    'callback', 'EEGnew = pop_tmsclean(EEG); [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEGnew, CURRENTSET); eeglab redraw');

end