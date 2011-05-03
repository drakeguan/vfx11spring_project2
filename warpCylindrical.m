function imout = warpCylindrical(im, focal_length)

    mid = size(im) / 2;
    s = focal_length;

    for x = 1:size(im, 2)
	for y = 1:size(im, 1)
            xp = x - mid(2);
	    yp = y - mid(1);
	    theta = atan(xp/focal_length);
	    h = yp / sqrt(xp*xp + focal_length*focal_length);

	    x_new = round(s*theta) + mid(2);
	    y_new = round(s*h) + mid(1);

	    imout(y_new, x_new, :) = im(y, x, :);
	end
    end
end
