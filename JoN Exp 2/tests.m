clear
clc


%% test peripheral stimulus configuration numbers

a = 1:3;
a = full_fact(a,a,a);
a = unique(a,'rows');

[rows,cols] = size(a);

for R = 1:rows
   
    if length( unique( a( rows + 1 - R,: ) ) ) < 3
        a( rows + 1 - R,: ) = [];
    end
    
end

disp( [ 'Number of peripheral combinations = ' num2str( length(a) ) ] );


% top left, top centre, top right

% 1 2 3
% 1 3 2
% 2 1 3
% 2 3 1
% 3 1 2
% 3 2 1

% R G B - 3
% R B G - 6
% G R B - 5
% G B R - 1
% B R G - 2
% B G R - 4


%% counterbalancing

data_trial1 = importdata('test.txt');
data_trial = data_trial1.data();
[rows,cols] = size(data_trial);

for C = 1:cols
    
    disp( ['Grouped by column ' num2str( C ) ': ' data_trial1.textdata{C}] );
    disp( grpstats(data_trial, data_trial(:,C) ) );
end

disp('--------------------------------------------------');

data_trial22 = importdata('practice.txt');
data_trial2 = data_trial22.data();
[rows,cols] = size(data_trial2);

for C = 1:cols
    
    disp( ['Grouped by column ' num2str( C ) ': ' data_trial22.textdata{C}] );
    disp( grpstats(data_trial2, data_trial2(:,C) ) );
end
