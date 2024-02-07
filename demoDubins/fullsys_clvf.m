[g2d, data2d] = proj(g, data1, [0,0,1]);
%visFuncIm(g2d,data2d,'blue',0.5);
visFuncIm(g2d,data2d,'blue', 0.5);
mindata = min(data1,[],'all');
disp(mindata);