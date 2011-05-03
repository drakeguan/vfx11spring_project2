function [featureX, featureY, R] = featureHarris(image, w, sigma, threshold, radius, k)
    
    disp('Harris corner detector.');

    if( ~exist('w') )
	w = 5;
    elseif(rem(w, 2) == 0)
	w = w + 1;
    end
    if( ~exist('sigma') )
	sigma = 1;
    end
    if( ~exist('threshold') )
	threshold = 3;
    end
    if( ~exist('radius') )
	radius = 1;
    end
    if( ~exist('k') )
	k = 0.04;
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

    % smooth the image to remove noise
    sI = filterGaussian(I, sigma, w);

    % derivatives
    [Ix, Iy] = gradient(sI);

    % products of derivatives
    Ix2 = Ix .^ 2;
    Iy2 = Iy .^ 2;
    Ixy = Ix .* Iy;
    
    % elements for the matrix M
    Sx2 = filterGaussian(Ix2, sigma, w);
    Sy2 = filterGaussian(Iy2, sigma, w);    
    Sxy = filterGaussian(Ixy, sigma, w);    

    % the response of the detector
    %
    % R = det(M) - k*trace(M)^2
    %   = Sx2*Sy2 - Sxy*Sxy - k*(Sx2+Sy2)^2
    R = (Sx2 .* Sy2 - Sxy .^ 2) - k * (Sx2 + Sy2) .^ 2;

    % threshold on value of R
    R2 = (R > threshold);
    % compute nonmax suppression.
    R2 = R2 & (R > imdilate(R, [1 1 1; 1 0 1; 1 1 1]));
    
    [featureY, featureX] = find(R2);
end
