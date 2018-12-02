%% image_colour_change.m

tic

% replace colour values in image with new ones

clear
clc

close('all');

direct{1} = 'C:\Experiments\David Painter\conjunction baseline 6\checkerboards\counterphasing large (640x480)\1\';
direct{2} = 'C:\Experiments\David Painter\conjunction baseline 6\checkerboards\counterphasing large (640x480)\2\';
direct{3} = 'C:\Experiments\David Painter\conjunction baseline 6\checkerboards\counterphasing large (640x480)\3\';
direct{4} = 'C:\Experiments\David Painter\conjunction baseline 6\checkerboards\counterphasing large (640x480)\4\';
direct{5} = 'C:\Experiments\David Painter\conjunction baseline 6\checkerboards\counterphasing large (640x480)\5\';
direct{6} = 'C:\Experiments\David Painter\conjunction baseline 6\checkerboards\counterphasing large (640x480)\6\';

file{1} = 'aa00001.BMP';
file{2} = 'aa00002.BMP';
file{3} = 'aa00003.BMP';
file{4} = 'aa00004.BMP';
file{5} = 'aa00005.BMP';
file{6} = 'aa00006.BMP';
file{7} = 'aa00007.BMP';
file{8} = 'aa00008.BMP';

% r1 = 201; % old
% g1 = 90; % old
% b1 = 255; % old

r2 = 255; % new
g2 = 126; % new
b2 = 106; % new

g3 = 122; % new new
b3 = 101; % new new

for d = 1:length( direct )
    
    cd( direct{d} );
    disp( direct{d} );
    
    for f = 1:length(file)

        disp( ['file: ' num2str( file{f} ) ] );
        
        clear img
        
        img = imread( file{f} );

        % f1 = figure();
        % imshow(img);

        [r c z] = size(img);

        for i=1:r
            for j=1:c

%                 if img(i,j,1) == r1
%                    img(i,j,1) = r2;
%                 end

%                 if img(i,j,2) == g1
%                     img(i,j,2) = g2;
%                 end
                
                if img(i,j,2) == g2
                    img(i,j,2) = g3;
                end

%                 if img(i,j,3) == b1
%                     img(i,j,1) = b2;
%                     img(i,j,2) = b2;
%                     img(i,j,3) = b2;
%                 end

                if img(i,j,3) == b2
                    img(i,j,1) = b3;
                    img(i,j,2) = b3;
                    img(i,j,3) = b3;
                end

            end
        end

        % f1 = figure();
        % imshow(img);
        
        imwrite(img, file{f}, 'bmp');

    end
end

toc