function imout = warpCylindrical(im, focal_length)

    [row, col] = size(im);
    mid = [row, col] / 2;
    s = focal_length;
    imout = zeros(size(im));

    for x = 1:size(im, 2)
	for y = 1:size(im, 1)
	    posC = [y, x] - mid;
	    theta = atan(posC(2)/focal_length);
	    h = posC(1) / sqrt(posC(2)^2 + focal_length^2);
	    
	    xw = round(s*theta) + mid(2);
	    yw = round(s*h) + mid(1);

	    imout(yw, xw, :) = im(y, x, :);
	end
    end
end
