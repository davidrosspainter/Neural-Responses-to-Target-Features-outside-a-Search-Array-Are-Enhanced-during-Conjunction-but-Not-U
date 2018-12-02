function build_checkerboards(bkcolour, testcheckerboards, dartmaxrad, ...
dartnumrings, dartnumarcs, dartcolour1, dartcolour2, dartcolour3, ...
dartcolour4, dartoccludeanglecode, dartoccludeanglenumarcs, ...
dartoccludecode, dartminrad, targetringouter, cutwidarc, ...
cutwidring, resolution, dir_cb, dir_exp)


cgfont('Arial',24);

% ----- derived checkerboard settings
delta_r = (dartmaxrad-dartminrad)/dartnumrings; % arc width
delta_theta = 360/dartnumarcs;
occludeangle = dartoccludeanglenumarcs*pi/dartnumarcs;

w = resolution(1);
h = resolution(2);

x = 1:w;
y = 1:h;
ox = w/2;
oy = h/2;

% ----- make the grid data for the dartboard
[X,Y] = meshgrid(x-ox,y-oy);		% cartesian coords
[TH,R] = cart2pol(X,Y);				% convert to polar coords
TH = rem(TH + 2*pi, 2*pi);			% shift from -pi:pi to 0:2pi
delta_theta = delta_theta*pi/180;   % convert to radians

% ----- make the quadrant occlude mask here; makes an occlude mask that has h rows and w columns

occlude = ones(h,w);
if strcmp(dartoccludecode,'TL')
   occlude(1:(h/2),1:(w/2)) = 0;
elseif strcmp(dartoccludecode,'TR')
    occlude(1:(h/2),(w/2):w) = 0;
elseif strcmp(dartoccludecode,'BL')
    occlude((h/2):h,1:(w/2)) = 0;
elseif strcmp(dartoccludecode,'BR')
    occlude((h/2):h,(w/2):w) = 0;
end

% ----- make the angle occlude mask
aoccludeV = ones(h,w);
aoccludeH = ones(h,w);

if strcmp(dartoccludeanglecode, 'V')
   aoccludeV = (abs(TH - pi/2)) > occludeangle & (abs(TH - 3*pi/2)) > occludeangle;
elseif strcmp(dartoccludeanglecode, 'H')
   aoccludeH = (abs(TH)) > occludeangle & (abs(TH-pi)) > occludeangle & (abs(TH-2*pi)) > occludeangle;
end

% ----- generate dartboards
annulus = (dartminrad <= R & R < dartmaxrad); % big thick donut mask
annulus = annulus & occlude & aoccludeH & aoccludeV;
squares = xor( rem( (R-dartminrad)/delta_r,2 ) < 1, rem( TH/delta_theta,2 ) < 1 ); % square pattern mask

backgnd = ~ annulus; % background colour outside the annulus mask
c1 = annulus & squares; % mask for colour 1
c2 = annulus & ~squares; % mask for colour 2

arcangle = 2*pi/dartnumarcs;

for key = 1:4

    switch key
        case 1    
            comp1{key} = c1*dartcolour1(1) +c2*dartcolour2(1) + backgnd*bkcolour(1);
            comp2{key} = c1*dartcolour1(2) +c2*dartcolour2(2) + backgnd*bkcolour(2);
            comp3{key} = c1*dartcolour1(3) +c2*dartcolour2(3) + backgnd*bkcolour(3);
        case 2
            comp1{key} = c1*dartcolour2(1) +c2*dartcolour1(1) + backgnd*bkcolour(1);
            comp2{key} = c1*dartcolour2(2) +c2*dartcolour1(2) + backgnd*bkcolour(2);
            comp3{key} = c1*dartcolour2(3) +c2*dartcolour1(3) + backgnd*bkcolour(3);
        case 3
            comp1{key} = c1*dartcolour3(1) +c2*dartcolour4(1) + backgnd*bkcolour(1);
            comp2{key} = c1*dartcolour3(2) +c2*dartcolour4(2) + backgnd*bkcolour(2);
            comp3{key} = c1*dartcolour3(3) +c2*dartcolour4(3) + backgnd*bkcolour(3);
        case 4
            comp1{key} = c1*dartcolour4(1) +c2*dartcolour3(1) + backgnd*bkcolour(1);
            comp2{key} = c1*dartcolour4(2) +c2*dartcolour3(2) + backgnd*bkcolour(2);
            comp3{key} = c1*dartcolour4(3) +c2*dartcolour3(3) + backgnd*bkcolour(3);
    end
end


% %% set all inner same, all outer same checkerboards
comb1 = ...
[1,3;
1,4;
2,3;
2,4
...
3,1;
4,1;
3,2;
4,2];

[rows,cols] = size(comb1); % needed to generate correct keys below, regardless of whether want all inner/outer checkerboards
% 
% for key = 1:rows
%     new1 = NaN(resolution(2),resolution(1));
%     new2 = NaN(resolution(2),resolution(1));
%     new3 = NaN(resolution(2),resolution(1));
% 
%     new1(R < dartminrad+delta_r*(4-cutwidring) ) = comp1{comb1(key,1)}( R < dartminrad+delta_r*(4-cutwidring) );
%     new2(R < dartminrad+delta_r*(4-cutwidring) ) = comp2{comb1(key,1)}( R < dartminrad+delta_r*(4-cutwidring) );
%     new3(R < dartminrad+delta_r*(4-cutwidring) ) = comp3{comb1(key,1)}( R < dartminrad+delta_r*(4-cutwidring) );
% 
%     new1(R > dartminrad+delta_r*(4-cutwidring)) = comp1{comb1(key,2)}(R > dartminrad+delta_r*(4-cutwidring) );
%     new2(R > dartminrad+delta_r*(4-cutwidring)) = comp2{comb1(key,2)}(R > dartminrad+delta_r*(4-cutwidring) );
%     new3(R > dartminrad+delta_r*(4-cutwidring)) = comp3{comb1(key,2)}(R > dartminrad+delta_r*(4-cutwidring) );
% 
%     % ---- holes
%     new1( TH <= pi + arcangle*(cutwidarc) & TH >= pi - arcangle*(cutwidarc) & ...
%     R > dartminrad+delta_r*(targetringouter-cutwidring) & R < dartminrad+delta_r*targetringouter ) = bkcolour(1);
%     new2( TH <= pi + arcangle*(cutwidarc) & TH >= pi - arcangle*(cutwidarc) & ...
%     R > dartminrad+delta_r*(targetringouter-cutwidring) & R < dartminrad+delta_r*targetringouter ) = bkcolour(2);
%     new3( TH <= pi + arcangle*(cutwidarc) & TH >= pi - arcangle*(cutwidarc) & ...
%     R > dartminrad+delta_r*(targetringouter-cutwidring) & R < dartminrad+delta_r*targetringouter ) = bkcolour(3);
%     
%     transfer1 = reshape(new1', w*h, 1);
%     transfer2 = reshape(new2', w*h, 1);
%     transfer3 = reshape(new3', w*h, 1);
% 
%     bmp{key} = [transfer1 transfer2 transfer3];
%     cgloadarray(key, w, h, bmp{key} );
% 
%     if testcheckerboards == true
%         cgdrawsprite(key,0,0);
%         cgpencol(1,1,1);
%         cgtext(num2str(key),0,0);
%         cgflip(0,0,1);
%         %cgscrdmp;
%         wait(500);
%     end
% 
%     clear new1 new2 new3 transfer1 transfer2 transfer3 bmp
% end


%% set other types of checkerboards (red/green mixed inner/outer; half red, half green) 
comb2 = [1 3 1 3;
        1 4 1 4;
        2 3 2 3;
        2 4 2 4;
        ...
        3 1 3 1;
        4 1 4 1;
        3 2 3 2;
        4 2 4 2];
%         ...
%         1 1 3 3;
%         1 1 4 4;
%         2 2 3 3;
%         2 2 4 4];
% %         ...
%         3 3 1 1;
%         4 4 1 1;
%         3 3 2 2;
%         4 4 2 2]; % left and right all one colour

for key = rows+1:rows+length(comb2);
    new1 = NaN(resolution(2),resolution(1));
    new2 = NaN(resolution(2),resolution(1));
    new3 = NaN(resolution(2),resolution(1));

    % ------ left outer
    new1( TH >= 2*pi/4 & TH <= 3/4*2*pi & R > dartminrad+delta_r*(4-cutwidring) ) = comp1{ comb2(key-rows,1) }( TH >= 2*pi/4 & TH <= 3/4*2*pi & R > dartminrad+delta_r*(4-cutwidring) ); % left outer
    new2( TH >= 2*pi/4 & TH <= 3/4*2*pi & R > dartminrad+delta_r*(4-cutwidring) ) = comp2{ comb2(key-rows,1) }( TH >= 2*pi/4 & TH <= 3/4*2*pi & R > dartminrad+delta_r*(4-cutwidring) ); % left outer
    new3( TH >= 2*pi/4 & TH <= 3/4*2*pi & R > dartminrad+delta_r*(4-cutwidring) ) = comp3{ comb2(key-rows,1) }( TH >= 2*pi/4 & TH <= 3/4*2*pi & R > dartminrad+delta_r*(4-cutwidring) ); % left outer
    
%     new1( TH > 2*pi/4 & TH < 3/4*2*pi & R > dartminrad+delta_r*(4-cutwidring) ) = 1;
%     new2( TH > 2*pi/4 & TH < 3/4*2*pi & R > dartminrad+delta_r*(4-cutwidring) ) = 0;
%     new3( TH > 2*pi/4 & TH < 3/4*2*pi & R > dartminrad+delta_r*(4-cutwidring) ) = 0;
    
    % ------ left inner
    new1( TH >= 2*pi/4 & TH <= 3/4*2*pi & R < dartminrad+delta_r*(4-cutwidring) ) = comp1{ comb2(key-rows,2) }( TH >= 2*pi/4 & TH <= 3/4*2*pi & R < dartminrad+delta_r*(4-cutwidring) ); % left inner
    new2( TH >= 2*pi/4 & TH <= 3/4*2*pi & R < dartminrad+delta_r*(4-cutwidring) ) = comp2{ comb2(key-rows,2) }( TH >= 2*pi/4 & TH <= 3/4*2*pi & R < dartminrad+delta_r*(4-cutwidring) ); % left inner
    new3( TH >= 2*pi/4 & TH <= 3/4*2*pi & R < dartminrad+delta_r*(4-cutwidring) ) = comp3{ comb2(key-rows,2) }( TH >= 2*pi/4 & TH <= 3/4*2*pi & R < dartminrad+delta_r*(4-cutwidring) ); % left inner
    
%     new1( TH > 2*pi/4 & TH < 3/4*2*pi & R < dartminrad+delta_r*(4-cutwidring) ) = 0;
%     new2( TH > 2*pi/4 & TH < 3/4*2*pi & R < dartminrad+delta_r*(4-cutwidring) ) = 1;
%     new3( TH > 2*pi/4 & TH < 3/4*2*pi & R < dartminrad+delta_r*(4-cutwidring) ) = 0;

    % ----- right inner
    new1( ( TH < 2*pi/4 | TH > 3/4*2*pi ) & R < dartminrad+delta_r*(4-cutwidring) ) = comp1{ comb2(key-rows,3) }( ( TH < 2*pi/4 | TH > 3/4*2*pi ) & R < dartminrad+delta_r*(4-cutwidring) ); % right inner
    new2( ( TH < 2*pi/4 | TH > 3/4*2*pi ) & R < dartminrad+delta_r*(4-cutwidring) ) = comp2{ comb2(key-rows,3) }( ( TH < 2*pi/4 | TH > 3/4*2*pi ) & R < dartminrad+delta_r*(4-cutwidring) ); % right inner
    new3( ( TH < 2*pi/4 | TH > 3/4*2*pi ) & R < dartminrad+delta_r*(4-cutwidring) ) = comp3{ comb2(key-rows,3) }( ( TH < 2*pi/4 | TH > 3/4*2*pi ) & R < dartminrad+delta_r*(4-cutwidring) ); % right inner
    
%     new1( ( TH < 2*pi/4 | TH > 3/4*2*pi ) & R < dartminrad+delta_r*(4-cutwidring) ) = 0;
%     new2( ( TH < 2*pi/4 | TH > 3/4*2*pi ) & R < dartminrad+delta_r*(4-cutwidring) ) = 0;
%     new3( ( TH < 2*pi/4 | TH > 3/4*2*pi ) & R < dartminrad+delta_r*(4-cutwidring) ) = 1;
    
    % ------ right outer
    new1( ( TH < 2*pi/4 | TH > 3/4*2*pi ) & R > dartminrad+delta_r*(4-cutwidring) ) = comp1{ comb2(key-rows,4) }( ( TH < 2*pi/4 | TH > 3/4*2*pi ) & R > dartminrad+delta_r*(4-cutwidring) ); % right outer
    new2( ( TH < 2*pi/4 | TH > 3/4*2*pi ) & R > dartminrad+delta_r*(4-cutwidring) ) = comp2{ comb2(key-rows,4) }( ( TH < 2*pi/4 | TH > 3/4*2*pi ) & R > dartminrad+delta_r*(4-cutwidring) ); % right outer
    new3( ( TH < 2*pi/4 | TH > 3/4*2*pi ) & R > dartminrad+delta_r*(4-cutwidring) ) = comp3{ comb2(key-rows,4) }( ( TH < 2*pi/4 | TH > 3/4*2*pi ) & R > dartminrad+delta_r*(4-cutwidring) ); % right outer
    
%     new1( ( TH < 2*pi/4 | TH > 3/4*2*pi ) & R > dartminrad+delta_r*(4-cutwidring) ) = 1;
%     new2( ( TH < 2*pi/4 | TH > 3/4*2*pi ) & R > dartminrad+delta_r*(4-cutwidring) ) = 0;
%     new3( ( TH < 2*pi/4 | TH > 3/4*2*pi ) & R > dartminrad+delta_r*(4-cutwidring) ) = 1;
    
    % ----- holes
    new1( TH <= pi + arcangle*(cutwidarc) & TH >= pi - arcangle*(cutwidarc) & ...
    R > dartminrad+delta_r*(targetringouter-cutwidring) & R < dartminrad+delta_r*targetringouter ) = bkcolour(1);
    new2( TH <= pi + arcangle*(cutwidarc) & TH >= pi - arcangle*(cutwidarc) & ...
    R > dartminrad+delta_r*(targetringouter-cutwidring) & R < dartminrad+delta_r*targetringouter ) = bkcolour(2);
    new3( TH <= pi + arcangle*(cutwidarc) & TH >= pi - arcangle*(cutwidarc) & ...
    R > dartminrad+delta_r*(targetringouter-cutwidring) & R < dartminrad+delta_r*targetringouter ) = bkcolour(3);

    transfer1 = reshape(new1', w*h, 1);
    transfer2 = reshape(new2', w*h, 1);
    transfer3 = reshape(new3', w*h, 1);

    bmp{key} = [transfer1 transfer2 transfer3];
    cgloadarray(key, w, h, bmp{key} );

    if testcheckerboards == true
        
        cd(dir_cb);
        
        cgdrawsprite(key,0,0);
        cgpencol(1,1,1);
        cgtext(num2str(key),0,0);
        cgflip(bkcolour);
        cgscrdmp;
        pause(.5);
    end
    
    clear new1 new2 new3 transfer
end

cd(dir_exp);