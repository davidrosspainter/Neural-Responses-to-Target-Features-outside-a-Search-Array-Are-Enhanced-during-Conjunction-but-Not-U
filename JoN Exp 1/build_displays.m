for display = 0:num_displays
        
    cgmakesprite( 100 + display, dartminrad*2, dartminrad*2, 0, 0, 0);
    cgsetsprite( 100 + display );

    cgtrncol(100 + display, 'n'); % set background to transparent

    if display ~= 0

        for target_id = 1:length(targets_conj)

            switch data_stimulus{present_row,display+1}(1,target_id)
                case 1
                    text = 'L';
                case 2
                    text = 'T';
            end

            switch data_stimulus{present_row,display+1}(2,target_id)
                case 1
                    cgpencol ( col_target_1 );
                case 2
                    cgpencol ( col_target_2 );
            end % 40 us

            rotation = data_stimulus{present_row,display+1}(3,target_id); % 20 us
            cgfont(font, font_height, rotation); % 80 us

            % jitter
%             cgtext(text,    X_letter(target_id) + data_stimulus{present_row,display+1}(4,target_id), ...
%                             Y_letter(target_id) +
%                             data_stimulus{present_row,display+1}(5,target_id) ); % 150 us 0; 
                        
            cgtext(text, X_letter(target_id), Y_letter(target_id) ); % 150 us 0
                   

        end
    end

    cgpencol(col_dot);
    cgrect(0,0,10,10);

    cgsetsprite(0);

    if test_displays == true
        
        cd(dir_dis_sub);
        
        cgdrawsprite(100 + display,0,0);
        cgflip(bkcolour);
        cgscrdmp;
    end

end

cd(dir_exp);