function vers = eegplugin_TMSRegressionClean(fig, try_strings, catch_strings)

vers = 'TMSRegressionClean1.0';

toolmenu= findobj(fig, 'tag', 'tools');

cmd = [ try_strings.check_cont '[EEG LASTCOM] = pop_tmsclean(EEG);' catch_strings.new_and_hist ];
uimenu( toolmenu, 'label', 'TMS Artifact Removal', ...
    'callback', cmd);

end