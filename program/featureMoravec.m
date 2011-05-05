function [featureX, featureY, R] = featureMoravec(image, w)

    % width(size) of the weighting function
    if( ~exist('w') )
	w = 5;
    end

    % convert the image into luminance
    dim = ndims(image);
    if( dim == 3 )
	I = rgb2gray(image);
    else
	I = image;
    end
    [row, col] = size(I);

    % convert the image to double
    if( ~isa(I, 'double'))
	I = double(I);
    end

    uv = [[1 0]; [1 1]; [0 1]; [-1 1]];
    E = zeros(size(uv, 1), row, col);
    weight = ones(w);
    %half = (w-1)/2;
    %[x, y] = meshgrid(-half:1:half, -half:1:half);
    %sigma = 2;
    %weight = exp(-((x.*x+y.*y)/(2*sigma*sigma)));

    % calculate E of Moravec corner detector
    for i = 1:4
	shiftI = circshift(I, uv(i,:));
	diffI = shiftI - I;
	ssdI = diffI .^ 2; % sum of squared differences
	E(i,:,:) = conv2(ssdI, weight, 'same'); % summation of weighted ssd
    end

    minE = reshape(min(E), row, col);

    % local maxima
    R = minE > imdilate(minE, [1 1 1; 1 0 1; 1 1 1]);
    [featureY, featureX] = find(R);
end
