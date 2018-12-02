%% build_block_test.m


%% ----- data.present
% data.present(:,1) = trial number all
% data.present(:,2) = trial number mini block
% data.present(:,3) = block number

block_order = randperm(num_blocks);

temp1 = [];
temp2 = [];

for block = 1:num_blocks

    temp1 = [temp1; randperm(num_trials_block)'];
    temp2 = [temp2; block_order(block)*ones(num_trials_block,1)];

end

data.present(:,2) = temp1;
data.present(:,3) = temp2;

present_row = 0;

for block = 1:num_blocks
    
    for trial = 1:num_trials_block
        
        present_row = present_row + 1;

        data.present(   data.present(:,2) == trial & ...
                        data.present(:,3) == block, 1) = present_row; 
    end

end


%% ----- data.stimulus
% data.stimulus{trial,1}(:,1) = display numbers
% data.stimulus{trial,1}(:,2) = target present (1) and absent (0)
% data.stimulus{trial,2}(1,:) = letter
% data.stimulus{trial,2}(2,:) = colour
% data.stimulus{trial,2}(3,:) = orientation

data.stimulus = cell(num_trials,1);

for trial = 1:num_trials
    data.stimulus{trial,1} = NaN(num_displays,2);

    for a = 2:11
        data.stimulus{trial,a} = NaN(rows+2,cols);
    end
end

% - one target trials
temporal_locations{1} = 3:12;

% - two target trials
temporal_locations{2} = 3:10; % first target
temporal_locations{3} = 11:12; % second target


for trial = 1:num_trials

    if data.trial(trial,4) == 1
        popout = true;
    elseif data.trial(trial,4) == 2
        popout = false;
    end

    num_targs = data.trial(trial, col.num_tar);

    data.stimulus{trial,1}(:,1) = (1:num_displays)';
    data.stimulus{trial,1}(:,2) = 0;

    if num_targs == 1
        display = temporal_locations{1}(randperm(length(temporal_locations{1})));
        display = display(1);
        data.stimulus{trial,1}(display,2) = 1;
    
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
            data.stimulus{trial,1}(display,2) = 1;
            
        end

    end

    for display = 1:num_displays

        if popout == false

            data.stimulus{trial,display+1} = targets_conj(:,randperm(cols));

            if data.stimulus{trial,1}(display,2) == 1 % if there is a target

                target_id = find( data.stimulus{trial, display + 1}(1,:) == 2 & ... % letter = T
                                  data.stimulus{trial, display + 1}(2,:) == 2); % colour = target colour

                if rand() <= .5
                    target_id = target_id(1);
                else
                    target_id = target_id(2);
                end

                data.stimulus{trial,display+1}(3,target_id) = 0;
            end

        elseif popout == true

            data.stimulus{trial,display+1} = targets_pop(:,randperm(cols));

            if data.stimulus{trial,1}(display,2) ~= 1 % if there is no target
                 target_id = find( data.stimulus{trial, display + 1}(1,:) == 2 ...
                    &  data.stimulus{trial, display + 1}(2,:) == 2);

                data.stimulus{trial,display+1}(3,target_id) = 180;
            end 
        end


    end
end


%% data.check
data.check = [data.present, data.trial];
data.check = sortrows(data.check, 1);