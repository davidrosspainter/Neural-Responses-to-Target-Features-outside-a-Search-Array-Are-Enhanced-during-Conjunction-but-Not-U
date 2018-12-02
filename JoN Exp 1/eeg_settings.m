%% EEG TRIGGERS - config the io for eeg triggers

%io_obj = io32; % eeg trigger create an instance of the io32 object
%status = io32(io_obj); % eeg trigger initialise the inpout32.dll system driver
%io_address = hex2dec('378'); % physical address of the destinatio I/O port; 378 is standard LPT1 output port address
%io32(io_obj, io_address, 0); % set the trigger port to 0 - i.e. no trigger
eeg_trigger_length = 2; % 2 ms long trigger

% ----- big data block triggers
trig_exp = 77; % start/end of experiment
trig_rest = 88; % start/end of rest
trig_trial = 99;

% ----- response triggers
trig_correct = 33;
trig_incorrect = 34;

% ----- conditions triggers
trig_1 = 112; % SP, AC F1, UC F2
trig_2 = 121; % SP, AC F2, UC F1
trig_3 = 212; % SC, AC F1, UC F2
trig_4 = 221; % SC, AC F2, UC F1

% trig_1 = 111; % F 1 R
% trig_2 = 112; % F 1 G
% trig_3 = 121; % F 2 R
% trig_4 = 122; % F 2 G
% trig_5 = 211; % C 1 R
% trig_6 = 212; % C 1 G
% trig_7 = 221; % C 2 R
% trig_8 = 222; % C 2 G

[r,c] = size(data_trial);

data_trial(:,13) = NaN(r,1);
data_trial(:,14:19) = NaN(r,6);


if test_diode == false


    for a = 1:r

        switch data_trial(a,4)
            case 1
                search = 'feature';
            case 2
                search = 'conjunction';
        end

        switch data_trial(a,5)
            case 1
                colour = 'red';
            case 2
                colour = 'green';
        end

        switch colour
            case 'red'
                switch data_trial(a,7)
                    case 1
                        attended = 'frequency 1';
                    case 2
                        attended = 'frequency 2';
                end
            case 'green'
                switch data_trial(a,6)
                    case 1
                        attended = 'frequency 1';
                    case 2
                        attended = 'frequency 2';
                end
        end

%         if strcmp(search,'feature') && strcmp(attended,'frequency 1') && strcmp(colour,'red')
%             data_trial(a,13) = trig_1;
%         elseif strcmp(search,'feature') && strcmp(attended,'frequency 1') && strcmp(colour,'green')
%             data_trial(a,13) = trig_2;
%         elseif strcmp(search,'feature') && strcmp(attended,'frequency 2') && strcmp(colour,'red')
%             data_trial(a,13) = trig_3;
%         elseif strcmp(search,'feature') && strcmp(attended,'frequency 2') && strcmp(colour,'green')
%             data_trial(a,13) = trig_4;
%         elseif strcmp(search,'conjunction') && strcmp(attended,'frequency 1') && strcmp(colour,'red')
%             data_trial(a,13) = trig_5;
%         elseif strcmp(search,'conjunction') && strcmp(attended,'frequency 1') && strcmp(colour,'green')
%             data_trial(a,13) = trig_6;
%         elseif strcmp(search,'conjunction') && strcmp(attended,'frequency 2') && strcmp(colour,'red')
%             data_trial(a,13) = trig_7;
%         elseif strcmp(search,'conjunction') && strcmp(attended,'frequency 2') && strcmp(colour,'green')
%             data_trial(a,13) = trig_8;
%         end
            
%         trig_1 = 111; % F 1 R
%         trig_2 = 112; % F 1 G
%         trig_3 = 121; % F 2 R
%         trig_4 = 122; % F 2 G
%         trig_5 = 211; % C 1 R
%         trig_6 = 212; % C 1 G
%         trig_7 = 221; % C 2 R
%         trig_8 = 222; % C 2 G
        
        
        
        
        if strcmp(search,'feature') && strcmp(attended,'frequency 1')
           data_trial(a,13) = trig_1;
        elseif strcmp(search,'feature') && strcmp(attended,'frequency 2')
           data_trial(a,13) = trig_2;
        elseif strcmp(search,'conjunction') && strcmp(attended,'frequency 1')
          data_trial(a,13) = trig_3;
        elseif strcmp(search,'conjunction') && strcmp(attended,'frequency 2')
          data_trial(a,13) = trig_4;
        end

    end


elseif test_diode == true % test left outer frequency


    for a = 1:r
        switch data_trial(a,8)
    
            case 3 % left out green
                
                data_trial(a,13) = frequency_frames( data_trial(a,6) ); % left out frequency frames
                
            case 4 % left out red
    
                data_trial(a,13) = frequency_frames ( data_trial(a,7) ); % left out frequency frames
                
        end
    end

end


