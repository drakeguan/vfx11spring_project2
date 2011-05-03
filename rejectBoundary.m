function [featureX, featureY] = rejectBoundary(im, featureX, featureY, R, boundaryWidth)

    if ~exist('boundaryWidth')
	boundaryWidth = 3;
    end

    newX = [];
    newY = [];

    % convert the im into luminance
    dim = ndims(im);
    if( dim == 3 )
	I = rgb2gray(im);
    else
	I = im;
    end
    [row, col] = size(I);

    for i = 1:numel(featureY)
	x = featureX(i);
	y = featureY(i);
	if( (x>boundaryWidth) & (x<=(col-boundaryWidth)) & (y>boundaryWidth) & (y<=(row-boundaryWidth)) )
	    newX = [newX, x];
	    newY = [newY, y];
	end
    end

    featureX = newX;
    featureY = newY;
end
