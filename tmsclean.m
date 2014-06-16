function EEG = tmsclean(EEG, chan, lowcut, highcut, notch, targevent,  prestim, exclude, explen)
fprintf('Performing artifact removal with following parameters....\n');
fprintf('chan %d, lowcut %f, hightcut %f, notch %f, targevent %s, prestim %f, exclude %f, explen %f \n',...
        chan, lowcut, highcut, notch, targevent,  prestim, exclude, explen);
    
EEG2 = EEG; %this will be the forward filtered version

EEG = preExtraction(EEG);
EEG2 = preExtraction(EEG2);

fs = EEG.srate;
if(fs >1024)
    disp('resampling data...');
   EEG = eeg_checkset( EEG );
   EEG = pop_resample(EEG, 1024);
   EEG2 = EEG;
   fs = 1024;
end
 

[B, A] = butter(5, [lowcut highcut]/(fs/2));
[Bn, An] = butter(5, [notch-1 notch+1]/(fs/2), 'stop');

EEG = pop_reref(EEG, []);

if(chan ~= 0)
    EEG.data = EEG.data(chan, :);
    EEG.chanlocs = EEG.chanlocs(chan);

    EEG2.data = EEG2.data(chan, :);
    EEG2.chanlocs = EEG2.chanlocs(chan);
end

EEG.data = fliplr(EEG.data);
EEG.data = filter(B, A, double(EEG.data'))';
EEG.data = filter(Bn, An, double(EEG.data'))';
EEG.data = fliplr(EEG.data);

EEG2.data = filter(B, A, double(EEG2.data'))';
EEG2.data = filter(Bn, An, double(EEG2.data'))';

fprintf('Regression for each event has begun...\n');
%%
    pulsenum= 0;
    fprintf('Events Processed: ');
    for i =1:size(EEG.event,2)
        if(strcmp(EEG.event(i).type, targevent))
            pulsenum = pulsenum + 1;
            fprintf('%d,', pulsenum);
            
            tmst = int32(round(EEG.event(i).latency));
            ts = tmst + exclude*fs;

            tsw = (ts+1):(ts+explen*fs);
            x = 1:length(tsw);
%             fprintf('Number of chans:')
            for n = 1:size(EEG.data, 1)
                
                y = double(EEG.data(n, tsw));
                y0 = y(1);
                
                %exponential model of form yhat = a*exp(b*x) + c*exp(c.x);
                options = fitoptions('Method', 'NonlinearLeastSquares', 'StartPoint', [max(y)  0 1/mean(y0-y) 1/mean(y0-y)]);
                h = fit(x', y', 'exp2', options);
                yhat = h.a*exp(h.b*x) + h.c*exp(h.d*x);

                %remove exponential
                EEG.data(n, tsw) = y-yhat;

                %zero out values of tms-damaged region
                EEG.data(n, tmst:ts) = EEG.data(n, tsw(1));

                %use cleaned data as prestim
                EEG.data(n,(tmst-(1 + prestim*fs)):(tmst-1)) = EEG2.data(n, (tmst-(1 + prestim*fs)):(tmst-1));
%                 fprintf('%d,', n);
            end  
     
        end

    end
    
    fprintf('\n%d events processed in total.\n', pulsenum);
end