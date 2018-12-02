
%% change_matrix_gen.m

cur_cb_buffer_all = [1,5,9,13,17,21]; % cb initial state numbers

% 1-4 (red inside, green outside) 1
% 5-8 (green inside, red outside) 2
% 9-12 (mixed, red outer left) 3
% 13-16 (mixed, green outer left) 4
% 17-20 (red left, green right) not used
% 21-24 (green right, red left) not used


% 1: r1 g1
% 2: r1 g2
% 3: r2 g1
% 4: r2 g2

%                      kk rg r g
% cb_change_array{1} = [  1,4,3,2;
%                         2,3,4,1;
%                         3,2,1,4;
%                         4,1,2,3];
% 
% cb_change_array{2} = [  5,8,7,6;
%                         6,7,8,5;
%                         7,6,5,8;
%                         8,5,6,7];

cb_change_array{3} = [  9,12,11,10;
                        10,11,12,9;
                        11,10,9,12;
                        12,9,10,11];

cb_change_array{4} = [  13,16,15,14;
                        14,15,16,13;
                        15,14,13,16;
                        16,13,14,15];
                    
% cb_change_array{5} = [  17,20,19,18;
%                         18,19,20,17;
%                         19,18,17,20;
%                         20,17,18,19];
% 
% cb_change_array{6} = [  21,24,23,22;
%                         22,23,24,21;
%                         23,22,21,24;
%                         24,21,22,23];

cb_comb = unique(data_trial(:,8)); % initial states for checkerboards (3 = green left inner - 9-12; 4 = red left inner - 13-16)
rate_comb = unique(data_trial(:,6:7),'rows'); % flicker rates
num_frames = f_display_dur*(num_displays_initial + num_displays);

for initial_state = 1:length(cb_comb)
    
    buffer = cb_comb(initial_state);
    
    for rate = 1:length(rate_comb)
        
        cur_cb_buffer = cur_cb_buffer_all( buffer ); % checkerboard initial state
        ff = [ frequency_frames( rate_comb(rate,1) ), frequency_frames( rate_comb(rate,2) ) ];
        nextdartflick = ff + 1; % first frame to flick checkerboard
        
        nextdisplayflick = f_display_dur*(num_displays_initial) + 1; % first frame to flick central display
        display = 0;

        % change_matrix(:,1) = kk
        % change_matrix(:,2) = display number
        % change_matrix(:,3) = checkerboard

        change_matrix{buffer,rate}(:,1) = (1:num_frames)';

        for kk = 1:f_display_dur*(num_displays_initial + num_displays)

            % ----- time to change the display?
            switch kk
                case nextdisplayflick
                    % waitkeydown(inf); % SUSIE!!!! comment this out - testing-pauses between displays ################################
                    display = display + 1;
                    nextdisplayflick = nextdisplayflick + f_display_dur;
            end

            change_matrix{buffer,rate}(kk,2) = display;

            % ----- time to change checkerboards?
            if kk == nextdartflick(1) || kk == nextdartflick(2)

                switch kk
                    case nextdartflick(1)

                        if kk == nextdartflick(2)
                            cb_change = 2;
                            nextdartflick(2) = nextdartflick(2) + ff(2);
                        else
                            cb_change = 3;
                        end

                        nextdartflick(1) = nextdartflick(1) + ff(1);

                    case nextdartflick(2)
                        cb_change = 4;
                        nextdartflick(2) = nextdartflick(2) + ff(2);
                end

                if ismember(cur_cb_buffer,cb_change_array{1})
                    arrangement = 1;
                    row_adjust = 0;
                elseif ismember(cur_cb_buffer,cb_change_array{2})
                    arrangement = 2;
                    row_adjust = -4;
                elseif ismember(cur_cb_buffer,cb_change_array{3})
                    arrangement = 3;
                    row_adjust = -8;
                elseif ismember(cur_cb_buffer,cb_change_array{4})
                    arrangement = 4;
                    row_adjust = -12;
%                 elseif ismember(cur_cb_buffer,cb_change_array{5})
%                     arrangement = 5;
%                     row_adjust = -16;
%                 elseif ismember(cur_cb_buffer,cb_change_array{6})
%                     arrangement = 6;
%                     row_adjust = -20;
                end

                cur_cb_buffer = cb_change_array{arrangement}(cur_cb_buffer + row_adjust, cb_change);

            end

            change_matrix{buffer,rate}(kk,3) = cur_cb_buffer;

        end
        
    end
    
end