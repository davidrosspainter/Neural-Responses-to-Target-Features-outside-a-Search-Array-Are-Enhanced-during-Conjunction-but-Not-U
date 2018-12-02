%% EEG TRIGGERS - config the io for eeg triggers

io_obj = io32; % eeg trigger create an instance of the io32 object
status = io32(io_obj); % eeg trigger initialise the inpout32.dll system driver
io_address = hex2dec('378'); % physical address of the destinatio I/O port; 378 is standard LPT1 output port address
io32(io_obj, io_address, 0); % set the trigger port to 0 - i.e. no trigger
eeg_trigger_length = 2; % 2 ms long trigger

% ----- epoch frames
epoch_beg_frame = find( change_matrix{1}(:,2) == 3, 1, 'first' );
epoch_end_frame = find( change_matrix{1}(:,2) == 12, 1, 'first' );

% ----- big data block triggers
trig_exp = 77; % start/end of experiment
trig_rest = 88; % start/end of rest
trig_trial = 99;

% ----- response triggers
trig_correct = 33;
trig_incorrect = 34;

% ----- conditions triggers
trig_cond(1) = 123; % T1 D2 B3
trig_cond(2) = 132; % T1 D3 B2
trig_cond(3) = 213; % T2 D1 B3
trig_cond(4) = 231; % T2 D3 B1
trig_cond(5) = 312; % T3 D1 B2
trig_cond(6) = 321; % T3 D2 B1

for trial = 1:num_trials
    
   trial_rate = data.trial( trial, [col.f_tar, col.f_dis, col.f_bas] );
   rate = find( ismember( rate_comb, trial_rate, 'rows' ) ); 
   data.trial(trial, col.eeg) = trig_cond(rate);
   %disp(trig_cond(rate));
end



%% diode test

% 1 g b r
% 2 b r g
% 3 r g b
% 4 b g r
% 5 g r b
% 6 r b g

for T = 1:num_trials
    
    switch data.trial(T,col.peri_stim)
        case 1
            COL = 3;
        case 2
            COL = 1;
        case 3
            COL = 2;
        case 4
            COL = 2;
        case 5
            COL = 1;
        case 6
            COL = 3;
    end
    
    
    idx = find( data.trial(T,[col.col_tar,col.col_dis,col.col_bas]) == COL );
    
    temp = data.trial(T,[col.f_tar,col.f_dis,col.f_bas]);
    
    data.trial(T,col.diode) = temp(idx);
    
    
end

