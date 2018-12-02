%% change_matrix_gen.m
clc

start_buffer = 08; % cb initial state numbers

% 1 - blank
% 2 - blue
% 3 - green
% 4 - green, blue
% 5 - red
% 6 - red, blue
% 7 - red, green
% 8 - red, green, blue

% kk - current cb
% r - change of red
% g - change of green
% b - change of blue
% rg - change of red, green
% rb - change of red, blue
% gb - change of green, blue
% rgb - change of red, green, blue

                   %kk r- g- b- rg rb gb rgb
cb_change_array = [ 01 05 03 02 07 06 04 08
                    02 06 04 01 08 05 03 07 
                    03 07 01 04 05 08 02 06 	
                    04 08 02 03 06 07 01 05	
                    05 01 07 06 03 02 08 04	
                    06 02 08 05 04 01 07 03
                    07 03 05 08 01 04 06 02 	
                    08 04 06 07 02 03 05 01];

rate_comb = unique( data.trial(:, [col.f_tar, col.f_dis, col.f_bas] ),'rows' ); % flicker rates
col_comb = unique( data.trial(:, [col.col_tar, col.col_dis, col.col_bas] ),'rows' ); % colour combinations



for rate = 1:length(rate_comb)
    
    for cc = 1:length(col_comb)
        
        swap_count = 1;
        cur_cb_buffer = start_buffer;
        
        col_tar  = col_comb(cc,1);
        col_dis  = col_comb(cc,2);
        col_bas  = col_comb(cc,3);
        
        f_tar  = rate_comb(rate,1);
        f_dis  = rate_comb(rate,2);
        f_bas  = rate_comb(rate,3);
        
        if col_tar == 1 && col_dis == 2
            ff = [frequency_frames(f_tar), frequency_frames(f_dis), frequency_frames(f_bas)]; 
        elseif col_tar == 1 && col_dis == 3
            ff = [frequency_frames(f_tar), frequency_frames(f_bas), frequency_frames(f_dis)];
        elseif col_tar == 2 && col_dis == 1
            ff = [frequency_frames(f_dis), frequency_frames(f_tar), frequency_frames(f_bas)];
        elseif col_tar == 2 && col_dis == 3
            ff = [frequency_frames(f_bas), frequency_frames(f_tar), frequency_frames(f_dis)];
        elseif col_tar == 3 && col_dis == 1
            ff = [frequency_frames(f_dis), frequency_frames(f_bas), frequency_frames(f_tar)];
        elseif col_tar == 3 && col_dis == 2
            ff = [frequency_frames(f_bas), frequency_frames(f_dis), frequency_frames(f_tar)];
        end

%         disp(ff);
%         disp(f_tar);
%         disp(f_dis);
%         disp(f_bas);
        
        nextdartflick = ff + 1; % first frame to flick checkerboard

        display = 0;
        nextdisplayflick = f_display_dur + 1; % first frame to flick central display

        % change_matrix(:,1) = kk
        % change_matrix(:,2) = display number
        % change_matrix(:,3) = checkerboard

        change_matrix{rate,cc}(:,1) = (1:num_frames)';

        for kk = 1:num_frames

            % ----- time to change the display?
            if kk == nextdisplayflick
                display = display + 1;
                nextdisplayflick = nextdisplayflick + f_display_dur;
            end

            change_matrix{rate,cc}(kk,2) = display;

            % ----- time to change checkerboards?


            % kk - current cb
            % r - change of red
            % g - change of green
            % b - change of blue
            % rg - change of red, green
            % rb - change of red, blue
            % gb - change of green, blue
            % rgb - change of red, green, blue

            if kk == nextdartflick(1) && kk == nextdartflick(2) && kk == nextdartflick(3)

                nextdartflick(1) = nextdartflick(1) + ff(1);
                nextdartflick(2) = nextdartflick(2) + ff(2);
                nextdartflick(3) = nextdartflick(3) + ff(3);
                
                C = 8;
                
                swap_count = swap_count + 1;

            elseif kk == nextdartflick(2) && kk == nextdartflick(3)

                nextdartflick(2) = nextdartflick(2) + ff(2);
                nextdartflick(3) = nextdartflick(3) + ff(3);
                C = 7;

            elseif kk == nextdartflick(1) && kk == nextdartflick(3)

                nextdartflick(1) = nextdartflick(1) + ff(1);
                nextdartflick(3) = nextdartflick(3) + ff(3);
                C = 6;

            elseif kk == nextdartflick(1) && kk == nextdartflick(2)

                nextdartflick(1) = nextdartflick(1) + ff(1);
                nextdartflick(2) = nextdartflick(2) + ff(2);
                C = 5;

            elseif kk == nextdartflick(3)

                nextdartflick(3) = nextdartflick(3) + ff(3);
                C = 4;

            elseif kk == nextdartflick(2)

                nextdartflick(2) = nextdartflick(2) + ff(2);
                C = 3;

            elseif kk == nextdartflick(1)

                nextdartflick(1) = nextdartflick(1) + ff(1);
                C = 2;

            else
                C = 1;
            end

            row = find( cb_change_array(:,1) == cur_cb_buffer );

            cur_cb_buffer = cb_change_array(row, C);
            change_matrix{rate,cc}(kk,3) = cur_cb_buffer;
            change_matrix{rate,cc}(kk,4) = swap_count;

        end 
    end
end