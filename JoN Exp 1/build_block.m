%% build_block_test.m


%% ----- data_present
% data_present(:,1) = trial number all
% data_present(:,2) = trial number mini block
% data_present(:,3) = block number

block_order = randperm(num_blocks);

temp1 = [];
temp2 = [];

for block = 1:num_blocks

    temp1 = [temp1; randperm(num_trials_block)'];
    temp2 = [temp2; block_order(block)*ones(num_trials_block,1)];

end

data_present(:,2) = temp1;
data_present(:,3) = temp2;

present_row = 0;

for block = 1:num_blocks
    
    for trial = 1:num_trials_block
        
        present_row = present_row + 1;

        data_present(   data_present(:,2) == trial & ...
                        data_present(:,3) == block, 1) = present_row; 
    end

end


%% ----- data_stimulus
% data_stimulus{trial,1}(:,1) = display numbers
% data_stimulus{trial,1}(:,2) = target present (1) and absent (0)
% data_stimulus{trial,2}(1,:) = letter
% data_stimulus{trial,2}(2,:) = colour
% data_stimulus{trial,2}(3,:) = orientation

data_stimulus = cell(num_trials,1);

for trial = 1:num_trials
    data_stimulus{trial,1} = NaN(num_displays,2);

    for a = 2:11
        data_stimulus{trial,a} = NaN(rows+2,cols);
    end
end

% - one target trials
temporal_locations{1} = 3:12;

% - two target trials
temporal_locations{2} = 3:10; % first target
temporal_locations{3} = 11:12; % second target


for trial = 1:num_trials

    if data_trial(trial,4) == 1
        popout = true;
    elseif data_trial(trial,4) == 2
        popout = false;
    end

    num_targs = data_trial(trial,9); 

    data_stimulus{trial,1}(:,1) = (1:num_displays)';
    data_stimulus{trial,1}(:,2) = 0;

    if num_targs == 1
        display = temporal_locations{1}(randperm(length(temporal_locations{1})));
        display = display(1);
        data_stimulus{trial,1}(display,2) = 1;
    
    elseif num_targs == 2

        for a = 2:3
                            
            display = temporal_locations{a}( randperm( length(temporal_locations{a} ) ) );
            display = display(1);
            
            if a == 2
                temp = display;
            elseif a == 3
                if temp == 10
                    display = 12;
                else
                    display = 11;
                end
            end
            data_stimulus{trial,1}(display,2) = 1;
            
        end

    end

    for display = 1:num_displays

        if popout == false

            data_stimulus{trial,display+1} = targets_conj(:,randperm(cols));

            if data_stimulus{trial,1}(display,2) == 1 % if there is a target

                target_id = find( data_stimulus{trial, display + 1}(1,:) == 2 ...
                    &  data_stimulus{trial, display + 1}(2,:) == 2);

                if rand() <= .5
                    target_id = target_id(1);
                else
                    target_id = target_id(2);
                end

                data_stimulus{trial,display+1}(3,target_id) = 0;
            end

        elseif popout == true

            data_stimulus{trial,display+1} = targets_pop(:,randperm(cols));

            if data_stimulus{trial,1}(display,2) ~= 1 % if there is no target
                 target_id = find( data_stimulus{trial, display + 1}(1,:) == 2 ...
                    &  data_stimulus{trial, display + 1}(2,:) == 2);

                data_stimulus{trial,display+1}(3,target_id) = 180;
            end 
        end

        if data_trial(trial,5) == 2 % is search target is green
            data_stimulus{trial,display+1}(2,:) = abs ( data_stimulus{trial,display+1}(2,:) - 3 ); % change 2 to 1 and 1 to 2 (colours)
        end


        % ------ jitter
        % data_stimulus{trial,display+1}(4,:) = x jitter (columns: pos 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12) 
        % data_stimulus{trial,display+1}(5,:) = y jitter (columns: pos 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12)

%         for target_id = 1:length(targets_conj)
%             data_stimulus{trial,display+1}(4,target_id) = round(rand()*jitter_amount); % x jitter
%             data_stimulus{trial,display+1}(5,target_id) = round(rand()*jitter_amount); % y jitter
%         end

    end
end


%% data_check
data_check = [data_present, data_trial];
data_check = sortrows(data_check, 1);