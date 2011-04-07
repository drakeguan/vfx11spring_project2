function [featureX, featureY] = featureHarris(image, window)

    % convert the image into luminance
    [row, col, channel] = size(image);
    if(channel == 3)
	I = rgb2gray(image);
    else
	I = image;
    end

    % prepare the gaussian kernel
    if( ~exist('window') )
	window = 5;
    end
    half = (window-1)/2;
    [x, y] = meshgrid(-half:1:half, -half:1:half);
    sigma = 2;
    gaussian = exp(-((x.*x+y.*y)/(2*sigma*sigma)));

    % x and y derivatives of image
    smoothI = conv2(I, gaussian, 'same'); % smooth
    [Ix, Iy] = gradient(smoothI); % gradient

    % products of derivatives
    Ix2 = Ix .* Ix;
    Iy2 = Iy .* Iy;
    Ixy = Ix .* Iy;

    % sums of the products of derivatives
    sigma = 2;
    gaussian = exp(-((x.*x+y.*y)/(2*sigma*sigma)));

    Sx2 = conv2(Ix2, gaussian, 'same');
    Sy2 = conv2(Iy2, gaussian, 'same');
    Sxy = conv2(Ixy, gaussian, 'same');

    % define the matrix

    % the response of the detector
    k = 0.04;
    R(:, :) = det(M(:, :)) - k * trace(M(:, :)) .^ 2;

    % threshold on value of R
    threshold = 2;
    [featureY, featureX] = find(R > threshold);
end
