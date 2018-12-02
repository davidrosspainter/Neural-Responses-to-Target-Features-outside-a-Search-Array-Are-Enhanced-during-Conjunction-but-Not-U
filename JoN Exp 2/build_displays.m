for display = 0:num_displays
        
    cgmakesprite( 100 + display, dartminrad*2, dartminrad*2, 0, 0, 0);
    cgsetsprite( 100 + display );

    cgtrncol(100 + display, 'n'); % set background to transparent

    if display ~= 0

        for target_id = 1:length(targets_conj)

            switch data.stimulus{present_row,display+1}(1,target_id)
                case 1
                    text = 'L';
                case 2
                    text = 'T';
            end

            switch data.stimulus{present_row,display+1}(2,target_id)
                
                case 1 % distractor
                    cgpencol( col_target( data.trial(present_row, col.col_dis), :) );                            
                case 2 % target
                    cgpencol( col_target( data.trial(present_row, col.col_tar), :) );
            end % 40 us

            rotation = data.stimulus{present_row,display+1}(3,target_id); % 20 us
            cgfont(font, font_height, rotation); % 80 us

            cgtext(text, X_letter(target_id), Y_letter(target_id) ); % 150 us 0

        end
    end

    cgpencol(col_dot);
    cgrect(0,0,dot_size,dot_size);

    cgsetsprite(0);

    if options.show_arrays == true

        cgdrawsprite(100 + display,0,0);
        cgflip(bkcolour);
        
        if options.print_arrays == true
            cd(dir_dis_sub);
            cgscrdmp;
            cd(dir_exp);
        else
            wait(500);
        end
    end

end

