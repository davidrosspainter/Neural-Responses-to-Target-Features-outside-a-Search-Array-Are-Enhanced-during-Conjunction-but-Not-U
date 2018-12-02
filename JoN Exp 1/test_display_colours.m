display = imread('aa00003.BMP');



[py,px,dim] = size(display);

display_2 = reshape(display, py*px, dim);

unique(display_2,'rows') == [0  124 0; 128 128 128; 255 0 0; 255 255 255]