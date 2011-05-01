function [featureX, featureY, R] = rejectEdge(im, featureX, featureY, R, threshold)

    if( ~exist('threshold') )
	threshold = 10;
    end

    [row, col] = size(im);
    % convert the im into luminance
    dim = ndims(im);
    if( dim == 3 )
	I = rgb2gray(im);
    else
	I = im;
    end

    % convert the image to double
    if( ~isa(I, 'double'))
	I = double(I);
    end

    % 2nd derivative kernels 
    xx = [ 1 -2  1 ];
    yy = xx';
    xy = [ 1 0 -1; 0 0 0; -1 0 1 ]/4;

    newX = [];
    newY = [];

    for i = 1:numel(featureY)
	x = featureX(i);
	y = featureY(i);

	% Compute the entries of the Hessian matrix at the extrema location.
	Dxx = sum(I(y,x-1:x+1) .* xx);
	Dyy = sum(I(y-1:y+1,x) .* yy);
	Dxy = sum(sum(I(y-1:y+1,x-1:x+1) .* xy));

	% Compute the trace and the determinant of the Hessian.
	Tr_H = Dxx + Dyy;
	Det_H = Dxx*Dyy - Dxy^2;

	% Compute the ratio of the principal curvatures.
	curvature_ratio = (Tr_H^2)/Det_H;

	if ((Det_H >= 0) & (curvature_ratio < threshold))
	    newX = [newX x];
	    newY = [newY y];
	end
    end

    featureY = newY;
    featureX = newX;
end

