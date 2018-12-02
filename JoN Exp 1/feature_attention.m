clear
clc



%% experiment settings

subject = 's23'; % subject's name ############################## input('Please enter subject name:','s');

monitor = 0; % use identify screen on display properties to work out which number to use (right click on
ref_rate = 60;  % refresh rate
resolution = [1024 768]; % monitor resolution
frequency_desired = [12.5 50/3]; % desired frequencies (Hz) 1.667, 12.5, 16.667, analysis period 6 seconds; % frequency increments for fft are .167

 

%       00 01 02 esc pause
keys = [97 100 98 52 25]; % key codes; button for 0, button for 1, button for 2, button for escape (formally 75 76 77 - numberpad 0, 1, 2; now left, down, right)
                          % note. to find out the ID numbers for each key, type getkeymap into the main MATLAB window

practice = false; %CHANGE THIS ONE!!!! set to true to run practice; set to false to run test

if practice == true % do not change this!!!! this should always be if practice == true
    subject = [subject ' practice'];
end
 

%% test?

% To check that everything is working properly, just run the cells before Cogent starts, 
% print out  data_trial, data_stimulus, and data_present; adjust the randomise variable above (to false) to make
% checking easier

randomise = true; % if you want the trial presentation to be randomised

% ----- use the following line for randomisation - NEVER remove
rand('twister', sum( 100*clock() ) ); %% needed for randomisation! 24/02/10 DP

speed_factor = 1; % set to less than one if you want a quick view of the ex

testcheckerboards = false;
test_displays = false;
test_frames = false;
test_diode = false; % ########################### !!!!!!!!!!!!!!!!!!!!!!!!!!!!!! ########## set to false to test

WaitForResponse = true;


%% directories/logfiles
dir_exp = cd; % experiment directory (current directory)
dir_log = [dir_exp '\logfiles']; % logfile directory
dir_cb = [dir_exp '\checkerboards']; % checkerboard screenshot directory
dir_dis = [dir_exp '\displays']; % display screenshot directory
dir_frames = [dir_exp '\frames']; % screenshots of frames in the actual experiment

 if exist(dir_log,'dir') ~= 7
    mkdir(dir_log);
end

if exist(dir_cb,'dir') ~= 7
    mkdir(dir_cb);
end

if exist(dir_dis,'dir') ~= 7
    mkdir(dir_dis);
end

if exist(dir_frames,'dir') ~= 7
    mkdir(dir_frames);
end

temp = clock;
dir_sub_name = [subject ' ' num2str(temp(1)) ' ' num2str(temp(2)) ,' ' num2str(temp(3)) ' ' num2str(temp(4)) ' ' num2str(temp(5)) ' ' num2str(temp(6)) ];

dir_log_sub = [dir_log '\' dir_sub_name];

cd(dir_log);
mkdir(dir_sub_name);
cd(dir_exp); 

if test_displays == true
    dir_dis_sub = [dir_dis '\' dir_sub_name];
    mkdir(dir_dis_sub);
end
   
if test_frames == true
    dir_frames_sub = [dir_frames '\' dir_sub_name];
    mkdir(dir_frames_sub);
end


%% timing information

frequency_frames(1) = round ( (1000/frequency_desired(1))/(1000/ref_rate) );
frequency_frames(2) = round ( (1000/frequency_desired(2))/(1000/ref_rate) ); % flicker frequency in frames

num_displays = 12; % number of search displays
num_displays_initial = 1;

display_dur = 600*speed_factor; % put in value from mocs ##############################
f_display_dur = round ( display_dur / (1000/ref_rate) );

pause_computation = (display_dur/1000)*speed_factor; % s
pause_instruction = display_dur*speed_factor; % ms
pause_feedback = display_dur*speed_factor; % ms

pause_rest = 2000*speed_factor; % ms (before key can be pressed to progress to the next block


%% colours

bkcolour = [0,0,0]; % background colour
col_dot(1,:) = [1 1 1]; % fixation dot

col_target_1 = [0,119/255,0]; % distractor 1, target 2
col_target_2 = [1,0,0]; % distractor 2, target 1

dartcolour1 = col_target_1; % checkerboard colour 1
dartcolour2 = bkcolour; % checkerboard colour 2
dartcolour3 = col_target_2; % checkerboard colour 3
dartcolour4 = bkcolour; % checkerboard colour 4


%% central display
font = 'Arial Black';
font_height = 75;

central_size = 235; % size of the central ellipse (height and width)

R_inner = 35; % inner letters (40)
R_outer = 90; % outer letters (90)

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

jitter_amount = 0; % set to 0 for no jitter; jitter is disabled in build_block, need to re-enable the commented code to have jitter


%% checkerboard settings

dartnumrings = 5;
dartnumarcs = 44;
dartmaxrad = 375;

temp = ( dartmaxrad + (central_size*dartnumrings)/2 ) / (dartnumrings + 1 ) - central_size/2; % size of gap for gaps to be equal to one ring width    
dartminrad = central_size/2 + temp;
 
dartoccludeanglecode = 'V'; % the angle occlude code if needed V_H
dartoccludeanglenumarcs = 4; % width in arcs
dartoccludecode = 'TL_BL'; % TL_BL, TL_BL_BR_TR, etc.

% ----- set holes
targetringouter = 3;
cutwidarc = 22; %cut width in number of arcs
cutwidring = 1; % cut width in number of rings


%% build_block

switch practice
    case false
        num_trials = 288;
        num_blocks = 8; % test
        num_trials_block = 36;

        data_trial = importdata('test.csv');
        data_trial = data_trial.data();
    case true
        num_trials = 24;
        num_blocks = 4; % test
        num_trials_block = 6;

        data_trial = importdata('PracticeTrials.csv');
        data_trial = data_trial.data();
end
        
data_trial(:,12) = f_display_dur; % overwrite display duration in file with any duration you desire (in frames)
build_block;
    
if randomise == false
    data_present(:,1) = 1:num_trials;
end

save_run; % save presentation info
change_matrix_gen; % generate change matrix (with timings)
eeg_settings;


%% start_cogent
cgloadlib;
cogstd('spriority','high')
config_keyboard;
cgopen(3, 0, ref_rate, monitor); % x pixels, y pixels, refresh, monitor
start_cogent;
cgflip(bkcolour);

% check screen refresh rate
gpd = cggetdata('GPD');
cg_ref_rate = round(gpd.RefRate100/100);

if cg_ref_rate ~= ref_rate && gpd.PixWidth == 1024 && gpd.PixHeight == 768
    error('Screen refresh rate or monitor resolution set incorrectly.');
end



%%cgscrdmp('./shot',1);

% build_checkerboards
build_checkerboards(bkcolour, testcheckerboards, dartmaxrad, ...
dartnumrings, dartnumarcs, dartcolour1, dartcolour2, dartcolour3, ...
dartcolour4, dartoccludeanglecode, dartoccludeanglenumarcs, ...
dartoccludecode, dartminrad, targetringouter, cutwidarc, ...
cutwidring, resolution, dir_cb, dir_exp);


% ----- initialise experiment variables
escape = false;
toc_loop = NaN(num_frames, num_trials);


%% begin experiment/trial routine

% % ----- EEG trigger experiment
% % eeg_trigger(io_obj, io_address, trig_exp, % eeg_trigger_length);


for trial = 1:num_trials % numtrials


    %% rest
    if ( (trial-1)/num_trials_block == round( (trial-1)/num_trials_block ) ) && trial ~= 1

        % ----- EEG trigger rest
        
        cgpencol(1,1,1);
        cgtext('rest',0,0);
        cgflip(bkcolour);
       
        % eeg_trigger(io_obj, io_address, trig_rest, % eeg_trigger_length); % #################### EEG
        
        
        wait(pause_rest);
        
        if speed_factor == 1
            waitkeydown(inf);
        end
        
        % ----- EEG trigger rest
        % eeg_trigger(io_obj, io_address, trig_rest, % eeg_trigger_length); % #################### EEG
        

    end


    %% initialise trial
    
    ['current trial = ' num2str(trial)] % print current trial number to command window
    ['trials remaining = ' num2str(num_trials-trial)] % prints number of trials remaining to command window
    
	% ----- EEG trigger trial
    
    cgflip(bkcolour); % start with background colour
    
    cgfont(font, font_height, 0); % set font; rotation needs to be put back to 0 degrees
    
    present_row = find(data_present(:,1) == trial); % find trial information
    data_trial(present_row,14:19) = clock;
    buffer = data_trial(present_row,8); % checkerboard location
    rate = data_trial(present_row,6); % flicker rate of checkerboard 1    


    %% make sprites for the central search displays

    tic_computation = tic;

    build_displays; % 0.0549 s EEG computer; % 0.0209 s TMS computer

    toc_computation = 0;

    while toc_computation < pause_computation % keeps pause for computation a consistent length
        toc_computation = toc(tic_computation); 
    end


    %% cue
    cgfont(font, font_height, 0); % set font; rotation needs to be put back to 0 degrees

    switch data_trial(present_row,5)
        case 1
            cgpencol(col_target_2);
        case 2
            cgpencol(col_target_1);
    end

    cgtext('T',0,0);
    cgflip(bkcolour);
    % eeg_trigger(io_obj, io_address, trig_trial, % eeg_trigger_length); % #################### EEG

    %%cgscrdmp;
    
    wait(pause_instruction);

    cgpencol(col_dot);
    cgrect(0,0,10,10);
    cgflip(bkcolour);
    
    %%cgscrdmp;
    
    wait(pause_instruction);

    
    dumper = 1:60:780;

    %% checkerboard loop
    for kk = 1:num_frames % main animation loop
        
%         if kk/f_display_dur == round(kk/f_display_dur)
%             waitkeydown(inf);
%         end
        

        if ismember(kk, dumper)
            %%cgscrdmp;
        end

        tic_loop = tic;

        display = change_matrix{buffer,rate}(kk,2);
        cur_cb_buffer = change_matrix{buffer,rate}(kk,3);

        cgdrawsprite(cur_cb_buffer,0,0); % ready checkerboard for display
        cgdrawsprite(100 + display,0,0);

        % pause_key; % for checking purposes only! ensure this is unselected before testing for minimal computation time

        toc_loop(kk,present_row) = toc(tic_loop); % computations should be < 1e-002 s; to be safe, should be less than 6e-003 s
        
        cgflip(bkcolour);
        
        if test_frames == true
            waitkeydown(inf, keys);
        end
        
                % ----- EEG trigger analysis
        if kk == 181 || kk == num_frames % recode later to be more sensible - not a number!!!!!!!!!!!!!
            % eeg_trigger(io_obj, io_address, data_trial(present_row,13), % eeg_trigger_length); % #################### EEG   
        end
        
    end

    
    if speed_factor == 1 && WaitForResponse == true


        %% response screen
        cgflip(bkcolour);
        cgfont(font, font_height, 0);
        cgpencol(1,1,1);
        cgtext('0, 1, or 2?', 0, 0);
        cgflip(bkcolour);
        % %%cgscrdmp;

        response = waitkeydown(inf, keys);

        if length(response) > 1
            response = response(1);
        end

        data_trial(present_row,10) = response;

        if ( response == keys(1) && data_trial(present_row,9) == 0 ) || ...
           ( response == keys(2) && data_trial(present_row,9) == 1 ) || ...     
           ( response == keys(3) && data_trial(present_row,9) == 2 )

                data_trial(present_row,11) = 1;
                txt_feedback = 'correct';
                trig_response = trig_correct;
        else
                data_trial(present_row,11) = 0;
                txt_feedback = 'incorrect';
                trig_response = trig_incorrect;
        end

        
        % ----- EEG trigger response; correct or incorrect?
        if ~exist('trig_response','var')
            trig_response = trig_incorrect;
        end
        
        if response == keys(4)
                break
        end


        %% feedback screen
        cgfont(font, font_height, 0);
        cgpencol(1,1,1);
        cgtext(txt_feedback, 0, 0);
        cgflip(bkcolour);
        % eeg_trigger(io_obj, io_address, trig_response, % eeg_trigger_length); % #################### EEG
        
        wait(pause_feedback);
        
    end
    


end


%% shut down/save

cgshut;
cogstd('spriority','normal')
save_run; % save run