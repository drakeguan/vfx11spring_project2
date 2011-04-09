function [featureX, featureY, R] = featureHarris(image, w, sigma, threshold, radius, k)
    
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

    % Compute derivatives and elements of the structure tensor.
    [Ix, Iy] = gradient(filterGaussian(I, sigma, w));
    Sx2 = filterGaussian(Ix.^2, sigma, w);
    Sy2 = filterGaussian(Iy.^2, sigma, w);    
    Sxy = filterGaussian(Ix.*Iy, sigma, w);    

    % R = det(M) - k*trace(M)^2
    %   = Sx2*Sy2 - Sxy*Sxy - k*(Sx2+Sy2)^2
    R = (Sx2.*Sy2 - Sxy.^2) - k*(Sx2 + Sy2).^2; % Original Harris measure.

    R2 = (R > threshold);
    
    [featureY, featureX] = find(R2);                % Find row,col coords.
end
