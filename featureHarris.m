function [featureX, featureY] = featureHarris(image, window, threshold)

    if( ~exist('window') )
	window = 5;
    elseif(rem(window, 2) == 0)
	window = window + 1;
    end
    if( ~exist('threshold') )
	threshold = 3;
    end

    % convert the image into luminance
    [row, col, channel] = size(image);
    if(channel == 3)
	I = rgb2gray(image);
    else
	I = image;
    end
    %I = I / 255;

    % prepare the gaussian kernel
    half = (window-1)/2;
    [x, y] = meshgrid(-half:1:half, -half:1:half);
    sigma = 2;
    gaussian = exp(-((x.*x+y.*y)/(2*sigma*sigma)));

    % x and y derivatives of image
    smoothI = conv2(double(I), gaussian, 'same'); % smooth
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
    % method 1
    %M1 = [Sx2 Sxy; Sxy Sy2];
    %M2 = reshape(M1, [row 2 col 2]);
    %M = permute(M2, [1 3 2 4]);
    % method 2
    M = reshape([Sx2 ; Sxy ; Sxy ; Sy2], [size(Ix) 2 2]);

    % the response of the detector
    k = 0.04;
    R = zeros(row, col);
    for i = 1:row
	for j = 1:col
	    m = reshape(M(i, j, :, :), [2 2]);
	    R(i, j) = det(m) - k * trace(m) .^ 2;
	end
    end

    % threshold on value of R
    [featureY, featureX] = find(R > threshold);
end
