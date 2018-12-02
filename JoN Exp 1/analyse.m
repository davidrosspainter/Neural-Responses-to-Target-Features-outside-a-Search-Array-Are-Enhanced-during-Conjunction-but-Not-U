%% ----- save

% ----- print some basic accuracy information to the command window
['overall accuracy = ' num2str(sum(data_trial(:,11)==1)/sum(~isnan(data_trial(:,11)) ) )]
['overall number wrong = ' num2str( sum(data_trial(:,11)==0) )]

['time for experiment = ' num2str(toc/60) ' minutes']


if method_constant_stimuli == false
    
    'accuracy - popout; conjunction:'
    % grpstats(data_trial(:,12),data_trial(:,5) )
    
    'number correct - popout; conjunction:'
    % grpstats(data_trial(:,12),data_trial(:,5),'sum' )
    
    'number wrong - popout; conjunction:'
    % [240; 240] - grpstats(data_trial(:,12),data_trial(:,5),'sum' )
    
end

    
temp = clock;

% ----- save data_trial, data_present, data_stimulus
for a = 1:3
    
    out_name = [subject ' ' out_names{a} ' ' num2str(temp(1)) '-' num2str(temp(2)) '-' num2str(temp(3)) '-' num2str(temp(4)) '-' num2str(temp(5)) '.txt'];    
    fid = fopen(out_name,'a+');
    fprintf(fid, headers{a});
    fprintf(fid,'\n');

    if a ~= 3
        if a == 1
            dlmwrite(out_name, data_trial,'-append','delimiter','	');
        elseif a == 2
            dlmwrite(out_name, data_present,'-append','delimiter','	');
        end
    else

        for trial = 1:num_trials
            for display = 1:num_displays

                dlmwrite(out_name, [repmat(data_stimulus{trial,1}(display,1:2),5,1) data_stimulus{trial,display+1}], ...
                    '-append','delimiter','	');
            end
        end

    end
    fclose('all');
end


if method_constant_stimuli == true

    results(:,1) = display_durations;

	for a = 1:length(display_durations)
        
        results(a,2) = sum ( data_trial(data_trial(:,12) == f_display_durations(a), 11) == 1 );
        results(a,3) = sum(sum(data_trial(:,12) == f_display_durations(a) ));
    end
    
    % results = [15,20,32;25,23,32;35,25,32;45,28,32;55,30,32;];

    pfit(results, 'shape', 'logistic', 'cuts', [0.10 0.50 0.90], 'n_intervals', 3, 'runs', 99)
    fit = pfit(results, 'shape', 'logistic', 'cuts', [0.10 0.50 0.90], 'n_intervals', 3, 'runs', 99);
    ['estimated during for 90% correct ' num2str(fit.thresholds.est(3)) ' ms']

    
    % ----- save mocs results
    
    out_name = [subject ' ' out_names{4} ' ' num2str(temp(1)) '-' num2str(temp(2)) '-' num2str(temp(3)) '-' num2str(temp(4)) '-' num2str(temp(5)) '.txt'];
    
    fid = fopen(out_name,'a+');
    fprintf(fid, headers{4} );
    fprintf(fid,'\n');
    dlmwrite(out_name, results,'-append','delimiter','	');
    fprintf(fid,'\n');
    fprintf(fid, headers{5} );
    fprintf(fid,'\n');
    dlmwrite(out_name, fit.thresholds.est,'-append','delimiter','	');
    fclose('all');

end


% ----- descriptives from first trial run (david 2010 - 1 - 3)

% overall accuracy = 0.94792
% overall number wrong = 25
% time for experiment = 73.1766 minutes
% 
% accuracy - popout; conjunction:
% 0.9750
% 0.9208
% 
% number correct - popout; conjunction:
% 234
% 221
% 
% number wrong - popout; conjunction:
%  6
% 19