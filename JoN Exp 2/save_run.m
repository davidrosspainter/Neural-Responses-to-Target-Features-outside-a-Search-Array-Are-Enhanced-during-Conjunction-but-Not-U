cd(dir.log_sub);


%% save workspace

temp = clock;
fname = [subject ' ' num2str(temp(1)) ' ' num2str(temp(2)) ,' ' num2str(temp(3)) ' ' num2str(temp(4)) ' ' num2str(temp(5)) ' ' num2str(temp(6)) ];
save([fname '.mat']);


%% save data.trial, data.present, data.stimulus, data.check

out_names = {   'data.trial', 'data.present', 'data.stimulus', 'data.check'};
headers =    {  'trial no all	trial no block	block no	search (1 = P, 2 = C)	search (1 = R, 2 = G)	freq (green)	frequency (red)	peri stim (3 = LeftOutGreen, 4=LeftOutRed)	num targets	response	accuracy (0 = incorrect, 1 = correct)	display duration (frames)', ...
                'trial no all	trial no block	block no', ...
                'trial no all	block no	trial no block	display no	target (0 = abs, 1 = pres)	pos 1	pos 2	pos 3	pos 4	pos 5	pos 6	pos 7	pos 8	pos 9	pos 10	pos 11	pos 12', ...
                'trial no all (p)	trial no block (p)	block no (p)	trial no all	trial no block	block no	search (1 = P, 2 = C)	search (1 = R, 2 = G)	freq (green)	freq (red)	peri stim (3 = LeftOutGreen, 4=LeftOutRed)	num targets	response	accuracy (0 = incorrect, 1 = correct)	display duration (frames)'};

% delete 'data.trial.txt' 'data.present.txt' 'data.stimulus.txt' 'data.check.txt'

for a = 1:4

    out_name = [fname ' ' out_names{a} '.txt'];    
    fid = fopen(out_name,'a+');
    fprintf(fid, headers{a});
    fprintf(fid,'\n');

    switch a
        case 1
             dlmwrite(out_name, data.trial,'-append','delimiter','	');
        case 2
            dlmwrite(out_name, data.present,'-append','delimiter','	');
        case 3
        
            temp1 = [];

            for block = 1:num_blocks % block nos
                temp1 = [temp1; block*ones(num_trials_block*12*3,1)];    
            end

            temp2 = [];  
            count = 0;

            for trialcount = 1:num_trials % trial nos (mini)

                if count == num_trials_block
                    count = 1;
                else
                    count = count + 1;
                end

                temp2 = [temp2; count*ones(12*3,1)];
            end

            my_data = [sort(repmat( (1:num_trials)',36,1)), temp1, temp2]; % trial nos (all)
 
            temp1 = [];
            
            for trialcount = 1:num_trials
                for display = 1:num_displays
                    temp1 = [ temp1; [ repmat(data.stimulus{trialcount,1}(display,1:2),3,1), data.stimulus{trialcount,display+1} ] ];
                end
            end
            
            my_data = [my_data, temp1];
            dlmwrite(out_name, my_data,'-append','delimiter','	');
            
        case 4
            dlmwrite(out_name, data.check,'-append','delimiter','	');
    end
    
    fclose('all');
    
end


cd(dir.exp);