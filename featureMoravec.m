function [featureX, featureY] = featureMoravec(image, window)
    uv = [[1 0]; [1 1]; [0 1]; [-1 1]];

    % convert the image into luminance
    [row, col, channel] = size(image);
    if(channel == 3)
	I = rgb2gray(image);
    else
	I = image;
    end

    E = zeros(size(uv, 1), row, col);

    % weighting function
    if( ~exist('window') )
	window = 5;
    end
    w = ones(window);
    %half = (window-1)/2;
    %[x, y] = meshgrid(-half:1:half, -half:1:half);
    %sigma = 2;
    %w = exp(-((x.*x+y.*y)/(2*sigma*sigma)));

    % calculate E of Moravec corner detector
    for i = 1:4
	shiftI = circshift(I, uv(i,:));
	diffI = shiftI - I;
	ssdI = diffI .* diffI; % sum of squared differences
	E(i,:,:) = conv2(ssdI, w, 'same'); % summation of weighted ssd
    end

    minE = reshape(min(E), row, col);

    % local maxima
    peakI = minE > imdilate(minE, [1 1 1; 1 0 1; 1 1 1]);
    [featureY, featureX] = find(peakI);
end
