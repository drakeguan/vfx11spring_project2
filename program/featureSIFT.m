function [featureX, featureY, R] = featureSIFT(im, octaves, intervals)

    % arguments default
    if ~exist('octaves')
	octaves = 4;
    end
    if ~exist('intervals')
	intervals = 2;
    end

    % convert the image to double
    if( ~isa(I, 'double'))
	I = double(I);
    end

    % normalize the image
    if( max(im(:)) > 1)
	im = im ./ 255.;
end

