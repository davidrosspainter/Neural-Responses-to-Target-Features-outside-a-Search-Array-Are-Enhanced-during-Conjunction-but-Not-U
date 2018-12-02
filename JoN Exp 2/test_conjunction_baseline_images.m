% test_conjunction_baseline images

clear
clc




file{1} = 'aa00001.BMP';
%file{2} = 'full.BMP';
%file{3} = 'equal.BMP';
%file{4} = 'CGSD00001.BMP';

num = length(file);

count = 0;

for n = 1:num


    img = imread( file{n} );
    
    [h, w, c] = size(img);
    
 
%     
%     
    img2 = reshape(img, h*w, c);
	cols = unique(img2, 'rows');

    
%     if n == 1
%         R = 255;
%         G = 119;
%     else
%         R = 201;
%         G = 90;
%     end
% 
%     B = 255;
%     
%     r = sum( img2(:,1) == R);
%     g = sum( img2(:,2) == G);
%     b = sum( img2(:,3) == B);
%     k = 768*1024 - r - g - b;
% 
%     disp(file{n});
%     disp( [r; g; b; k] )
    
end

