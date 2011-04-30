function [featureX, featureY, R] = rejectLowContrast(im, featureX, featureY, R)

    [row, col] = size(I);
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
end
