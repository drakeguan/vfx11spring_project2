function [featureX, featureY, R] = rejectLowContrast(im, featureX, featureY, R, threshold)

    if( ~exist('threshold') )
	threshold = 20; % 15/255
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

    % Weber contrast (local)
    %Ib = mean(mean(I));
    %contrast = (I - Ib) ./ Ib;

    k = fspecial('average', 5);
    contrast = abs(filter2(k, I, 'same') - I);

    newX = [];
    newY = [];
    for i = 1:numel(featureX)
	if( contrast(featureY(i), featureX(i)) > threshold )
	    newY = [newY featureY(i)];
	    newX = [newX featureX(i)];
	end
    end

    featureY = newY;
    featureX = newX;
end
