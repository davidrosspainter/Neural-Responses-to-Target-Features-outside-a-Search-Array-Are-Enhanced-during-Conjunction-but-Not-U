%% conjunction_baseline6.m

clear
clc


% randomisation
if strcmp(version, '7.6.0.324 (R2008a)')
	rand('twister', sum( 100*clock() ) ); 
else
    RandStream.setDefaultStream( RandStream( 'mt19937ar', 'seed', sum(100*clock) ) ); % NEVER REMOVE THE FOLLOWING LINE - NEEDED FOR RANDOMISATION
end


%% experiment settings
subject = '20'; % subject number

mon.num = 1; % use identify screen on display properties to work out which number to use
mon.rate = 160; % ensure test monitor is set to the correct refresh rate
mon.res = [640 480]; % 1: 640 x 480, 2: 800 x 600, 3: 1024 x 768, 4: 1152 x 864, 5: 1280 x 1024, 6: 1600 x 1200

if mon.res(1) == 640 && mon.res(2) == 480
    mon.res_cg = 1;
    S_adjust = 640/1024;
elseif mon.res(1) == 800 && mon.res(2) == 600
    mon.res_cg = 2;
    S_adjust = 800/1024;
elseif mon.res(1) == 1024 && mon.res(2) == 768                        
    mon.res_cg = 3;
    S_adjust = 1;
end

% 6.3000  160.0000    1.4286    7.6190   13.3333   17.7778

freq.central = 1000/( (1000/160)*112 ); %  
freq.peripheral = [7.6190 13.3333 17.7778]; % desired frequencies (Hz) 10 12.5 50/3

%freq.peripheral = [2 10 20];

keys.zero = 97; % response keys (to find ID numbers for each key, type getkeymap into the main MATLAB window)
keys.one = 100;
keys.two = 98;
keys.escape = 52;
keys.pause = 16;

%% options

options.cb = 'counterphasing large (640x480)'; % stimulus folder name (no slashes)

options.practice = false; % set to true to run practice; set to false to run test

options.rest = true;
options.music = true;


track{1} = '05 Take Five 2.wav'; 
track{2} = '02 Two Step 1.wav';                 
track{3} = '08 Soul Bossa Nova 1.wav';                   
track{4} = '01 Don''t Stop ''Til You Get Enough 1.wav';
track{5} = 'That''s Good 1.wav';                  
track{6} = '01 Galvanize 1.wav';                         
track{7} = '07 Any Colour You Like 1.wav';
track{8} = '11 19-2000 1.wav';

playlist = randperm( length( track ) );

options.randomise = true; % if you want the trial presentation to be options.randomised
options.trial_info = false; % print trial information to the screen

options.show_arrays = false; % show displays before the trial begins 
options.test_arrays = false; % show displays within a trial
options.print_arrays = false; % save displays to .bmp
   
if options.print_arrays == true
    options.show_arrays = true;
end

options.test_frames = false; % require button press after each frame
options.wait_response = true; % require button press to advance to next trial
options.wait_response_rest = true;
options.diode = false;

%% data.trial col numbers

col.trial_all = 1; % trial number all
col.trial_block = 2; % trial number block
col.block_num = 3; % block number
col.search_type = 4; % search type (1 = pop-out, 2 = conjunction)
col.peri_stim = 5; % peripheral stimulus (1:8)
col.col_tar = 6; % colour target
col.col_dis = 7; % colour distractor
col.col_bas = 8; % colour baseline
col.f_tar = 9; % frequency target
col.f_dis = 10; % frequency distractor
col.f_bas = 11; % frequency baseline
col.num_tar = 12; % number of targets
col.eeg = 13; % eeg trigger
col.response = 14; % response key
col.accuracy = 16; % accuracy (0 = incorrect, 1 = correct)
col.clock = 17;

col.diode = 18;



%% directories/logfiles
dir.exp = cd; % experiment directory (current directory)
dir.log = [dir.exp '\logfiles']; % logfile directory
dir.cb = [dir.exp '\checkerboards\' options.cb]; % checkerboard screenshot directory
dir.dis = [dir.exp '\displays']; % display screenshot directory
dir.frames = [dir.exp '\frames']; % screenshots of frames in the actual experiment
dir.music = [dir.exp '\music'];

temp = clock;
dir.sub_name = [subject ' ' num2str(temp(1)) ' ' num2str(temp(2)) ,' ' num2str(temp(3)) ' ' num2str(temp(4)) ' ' num2str(temp(5)) ' ' num2str(temp(6)) ];
dir.log_sub = [dir.log '\' dir.sub_name];

cd(dir.log);
mkdir(dir.sub_name);
cd(dir.exp); 


%% timing information
speed = 1; % set to less than one if you want a quick view of the ex

% convert Hz values into frames 
frequency_frames = round ( (1000./freq.peripheral) / (1000/mon.rate) ); 

num_displays_initial = 1; % without search array
num_displays = 12; % number of search displays

display_dur = 1000/freq.central*speed; % put in value from mocs ##############################
f_display_dur = round ( display_dur / (1000/mon.rate) );
num_frames = f_display_dur*(num_displays_initial + num_displays);

pause_computation = (display_dur/1000)*speed;
num_frames_instruct = f_display_dur; % ms
num_frames_feed = f_display_dur; % ms

if options.music == true
    pause_rest = 30000; % ms (before key can be pressed to progress to the next block
else 
    pause_rest = 30000*speed;
end


%% colours
bkcolour = [0,0,0]; % black background colour
col_dot(1,:) = [1 1 1]; % fixation dot
dot_size = 10*S_adjust;

% red = [201/255 0 0];
% green = [0 90/255 0];
% blue = [0 0 255/255];

red = [255/255 0 0];
green = [0 126/255 0];
blue = [106/255 106/255 106/255];

col_target(1,:) = red; % red
col_target(2,:) = green; % green
col_target(3,:) = blue; % blue


%% central display
font = 'Arial Black';
font_height = 75*S_adjust;

central_size = 235*S_adjust; % size of the central ellipse (height and width)
R_inner = 35*S_adjust; % inner letters (40)
R_outer = 90*S_adjust; % outer letters (90)

dartnumrings = 5;
dartmaxrad = 375*S_adjust;

temp = ( dartmaxrad + (central_size*dartnumrings)/2 ) / (dartnumrings + 1 ) - central_size/2; % size of gap for gaps to be equal to one ring width    
dartminrad = central_size/2 + temp;

% ----- target settings

% TH = [45, 135, 225, 315, 0, 45, 90, 135, 180, 225, 270 315]; (degrees)
TH = [pi/4, 3/4*pi, 5/4*pi, 7/4*pi, 0, pi/4, pi/2, 3/4*pi, pi, 5/4*pi, 3/2*pi 7/4*pi];

R = [R_inner*ones(1,4), R_outer*ones(1,8)];
[X_letter,Y_letter] = pol2cart(TH,R);

targets_conj = [ 001 001 001 001 001 001 001 001 002 002 002 002; % letter
                 001 001 001 001 002 002 002 002 001 001 002 002; % colour
                 000 090 180 270 000 090 180 270 000 180 180 180]; % rotation
             
targets_pop = [ 001 001 001 001 001 001 001 001 002 002 002 002; % letter
                001 001 001 001 001 001 001 001 002 001 001 001; % colour
                000 090 180 270 000 090 180 270 000 000 180 180]; % rotation
            
[rows,cols] = size(targets_conj);


%% build_block


if options.practice == true
    
    data.trial1 = importdata('practice.txt'); % import data
    data.trial = data.trial1.data();
    [num_trials, not_used] = size(data.trial);
    
    % randomise number of targets across peripheral frequencies and
    % peripheral stimuli
    
    if options.randomise == false
        data.tar_seq = [0 0 1 1 2 2];

        data.tar = [];

        for R = 1:num_trials/6
            data.tar = [ data.tar; data.tar_seq ( randperm(6) ) ];
        end    
    end
        
else
	data.trial1 = importdata('test.txt');
    data.trial = data.trial1.data();
    [num_trials, not_used] = size(data.trial);
end


% randomise peripheral stimulus for both practice and test sequences

if options.randomise == true
    data.peri = [];

    for R = 1:num_trials/6
        data.peri = [ data.peri; randperm(6)' ];
    end

    data.trial(:,col.peri_stim) = data.peri;
end

num_blocks = max( data.trial(:,col.block_num) );
num_trials_block = max( data.trial(:,col.trial_block) );

build_block;
    
if options.randomise == false
    data.present(:,1) = 1:num_trials;
end

save_run; % save presentation info
change_matrix_gen; % generate change matrix (with timings)
eeg_settings;


%% start cogent
cgloadlib;
cogstd('spriority','high')
config_keyboard;
cgopen(mon.res_cg, 0, mon.rate, mon.num); % x pixels, y pixels, refresh, monitor

%config_display( 1, 1, [0 0 0], [1 1 1], font, font_height, 48 )

start_cogent_dp;
cgscrdmp('./shot',1);

%check screen refresh rate
gpd = cggetdata('GPD');
cg_ref_rate = round(gpd.RefRate100/100);

if abs( cg_ref_rate - mon.rate ) > 1
    error('Refresh rate not correctly set.'); 
end

if gpd.PixWidth ~= mon.res(1) || gpd.PixHeight ~= mon.res(2)
    error('Resolution not correctly set');
end

cgsound('open',2,16,48000,-50,0);


%% load checkerboads

count = 0;

for peri_stim = 1:6
    cd( [ dir.cb '\' num2str( peri_stim ) ] );

    for cb = 1:8
        count = count + 1;
            myfile = [ 'aa0000' num2str(cb) '.bmp'];        
            cgloadbmp(count, myfile);
            %disp(count)
    end

    %disp( cd );
    cd(dir.exp);

end


%% begin experiment/trial routine

toc_loop = NaN(num_frames, num_trials);

eeg_trigger(io_obj, io_address, trig_exp, eeg_trigger_length); % ----- EEG trigger experiment

B = 1;

for trial = 1:num_trials % numtrials

    
    %% initialise trial ( 6 ms  )

    cgfont(font, font_height, 0); % set font; rotation needs to be put back to 0 degrees
    
    present_row = find(data.present(:,1) == trial); % find trial information
    data.trial(present_row, col.clock) = datenum( clock );
        
    trial_rate = data.trial(present_row, [col.f_tar, col.f_dis, col.f_bas] );
    rate = find(ismember(rate_comb, trial_rate, 'rows'));
    
    trial_cc = data.trial(present_row, [col.col_tar, col.col_dis, col.col_bas] );
    cc = find(ismember(col_comb, trial_cc, 'rows'));

    disp( [ 'current trial = ' num2str(trial) ', ' ...
            'trials remaining = ' num2str(num_trials-trial) ', '...
            'trigger no.: ' num2str( data.trial(present_row, col.eeg) ) ] ); % print current trial number to command window
    
    
    if options.rest == true

        %% rest ( .005 ms to evaluate )

        if ( (trial-1)/num_trials_block == round( (trial-1)/num_trials_block ) )

            cgfont(font, font_height, 0); % set font; rotation needs to be put back to 0 degrees
            cgpencol( col_target( data.trial(present_row, col.col_tar), :) );
            cgtext('T',0,0);
            cgflip(bkcolour);
            
            % ----- EEG trigger rest
            eeg_trigger(io_obj, io_address, trig_rest, eeg_trigger_length); % #################### EEG

            if options.music == true
                
                cd( dir.music );
                
                B = B + 1;
                
                cgsound('WavFilSND',6, track{ playlist( B ) } );
                cgsound('play',6);

                if options.practice == true
                    wait(pause_rest/6);
                else
                    wait(pause_rest);
                end
                
                cgsound('stop',6);
                cd( dir.exp );
                
            else
                wait(4000);
            end

            if options.wait_response_rest == true
                waitkeydown(inf);
            end

            % ----- EEG trigger rest
            eeg_trigger(io_obj, io_address, trig_rest, eeg_trigger_length); % #################### EEG
        end
        
    end
    
    
    %% make sprites for the central search displays ( 610 ms )
    
    tic_computation = tic;

    build_displays; % 40 ms
    
    toc_computation = 0;
    
    while toc_computation < pause_computation % keeps pause for computation a consistent length
        toc_computation = toc(tic_computation); 
    end


    %% pre-trial displays
    
    % .4 ms (next two lines)
    cgfont(font, font_height, 0); % set font; rotation needs to be put back to 0 degrees
    
    cgpencol( col_target( data.trial(present_row, col.col_tar), :) );
    
    % ----- cue (610 ms)
    for kk = 1:num_frames_instruct 
        cgtext('T',0,0);
        cgflip(bkcolour);
        
        if kk == 1
            eeg_trigger(io_obj, io_address, trig_trial, eeg_trigger_length); % #################### EEG
        end
    end
    
    % ----- fixation dot (610 ms)
    for kk = 1:num_frames_instruct

        cgpencol(col_dot);
        cgrect(0,0,dot_size,dot_size)

        cgflip(bkcolour);
    end


    %% main animation loop ( 3 ms maximum )
   
    
    
    for kk = 1:num_frames
    
%         clearkeys;
        
        tic_loop = tic;
        
        % .2 ms (to  update displays - ready checkerboards and search arrays
        display = change_matrix{rate,cc}(kk,2);
        cur_cb_buffer = change_matrix{rate,cc}(kk,3);
        cur_cb_buffer = cur_cb_buffer + ( data.trial(present_row,col.peri_stim) - 1 )*8; % update peripheral stimulus
        
        
        cgdrawsprite(cur_cb_buffer,0,0); % ready checkerboard for display
        cgdrawsprite(100 + display,0,0);

        % .01 ms (to evaluate next three if statements)
        if options.trial_info == true
            cgfont(font, 30*S_adjust, 0); % set font; rotation needs to be put back to 0 degrees

            cgtext( ['trial no.: ' num2str( trial ) ], 300*S_adjust, 350*S_adjust);
            cgtext( ['trigger no.: ' num2str( data.trial(present_row, col.eeg) ) ], 300*S_adjust, 300*S_adjust);
            cgtext( ['target col.: ' num2str( data.trial(present_row, col.col_tar) ) ], 300*S_adjust, 250*S_adjust);
            cgtext( ['distractor col.: ' num2str( data.trial(present_row, col.col_dis) ) ], 300*S_adjust, 200*S_adjust);
            cgtext( ['baseline col.: ' num2str( data.trial(present_row, col.col_bas) ) ], 300*S_adjust, 150*S_adjust);
            cgtext( ['target Hz: ' num2str( data.trial(present_row, col.f_tar) ) ], 300*S_adjust, 100*S_adjust);
            cgtext( ['distractor Hz: ' num2str( data.trial(present_row, col.f_dis) ) ], 300*S_adjust, 50*S_adjust);
            cgtext( ['baseline Hz: ' num2str( data.trial(present_row, col.f_bas) ) ], 300*S_adjust, 0*S_adjust);
            cgtext( ['no. targets: ' num2str( data.trial(present_row, col.num_tar) ) ], 300*S_adjust, -50*S_adjust);
            cgtext( ['peri. stim.: ' num2str( data.trial(present_row, col.peri_stim) ) ], 300*S_adjust, -100*S_adjust);
            cgtext( ['frame no.: ' num2str( kk ) ], 300*S_adjust, -150*S_adjust);
        end

        if options.test_frames == true
            disp(kk);
        	waitkeydown(inf);
        end
        
        if options.test_arrays == true
            if kk/f_display_dur == round(kk/f_display_dur)
                waitkeydown(inf);
            end
        end

        % ----- EEG trigger analysis ( 2 ms to run when sending the trigger )
        if kk == epoch_beg_frame || kk == epoch_end_frame
            
            if options.diode == false
                eeg_trigger(io_obj, io_address, data.trial(present_row,col.eeg), eeg_trigger_length); % #################### EEG
            else
                eeg_trigger(io_obj, io_address, data.trial(present_row,col.diode), eeg_trigger_length);
            end
            %cgscrdmp;
        end
        
        toc_loop(kk,present_row) = toc(tic_loop); % computations should be < 1e-002 s; to be safe, should be less than 6e-003 s
        
        cgflip(bkcolour);

%         readkeys;
% 
%         [response.key, response.time, response.num] = getkeydown; % get the (cogent) key ID and time (in ms) of keypresses
% 
%         if response.num > 0
% 
%             if response.key(1) == keys.pause
%                 waitkeydown(inf, keys.pause);
%             end
%         end
        
        
    end

    if speed == 1 && options.wait_response == true

        
        %% response screen
        cgfont(font, font_height, 0);
        cgpencol(1,1,1);
        cgtext('0, 1, or 2?', 0, 0);
        cgflip(bkcolour);

        response = waitkeydown(inf, [keys.zero, keys.one, keys.two, keys.escape]);

        if length(response) > 1
            response = response(1);
        end

        data.trial(present_row,col.response) = response;
        
        if ( response == keys.zero && data.trial(present_row, col.num_tar) == 0 ) || ...
           ( response == keys.one && data.trial(present_row, col.num_tar) == 1 ) || ...     
           ( response == keys.two && data.trial(present_row, col.num_tar) == 2 )

                data.trial(present_row, col.accuracy) = 1;
                txt_feedback = 'correct';
                trig_response = trig_correct;
        else
                data.trial(present_row,col.accuracy) = 0;
                txt_feedback = 'incorrect';
                trig_response = trig_incorrect;
        end
        
        % ----- EEG trigger response; correct or incorrect?
        if ~exist('trig_response','var')
            trig_response = trig_incorrect;
        end
        
        if response == keys.escape
            break
        end


        %% feedback screen (610 ms)
        
        for kk = 1:num_frames_feed

            cgfont(font, font_height, 0);
            cgpencol(1,1,1);
            cgtext(txt_feedback, 0, 0);
            cgflip(bkcolour);
            
            if kk == 1
                eeg_trigger(io_obj, io_address, trig_response, eeg_trigger_length); % #################### EEG
            end

        end
    end
end


%% shut down/save

% ----- EEG trigger experiment
eeg_trigger(io_obj, io_address, trig_exp, eeg_trigger_length);

cgshut;

if options.music == true
    B = B + 1;
    
    cd(dir.music);
    
    cgsound('WavFilSND',6, track{ playlist( B ) } );
    cgsound('play',6);
end

cogstd('spriority','normal')

cd(dir.exp);
save_run; % save run