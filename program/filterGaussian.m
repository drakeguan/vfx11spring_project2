function result = filterGaussian(im, sigma, w)
 
    if ~exist('w')
	w = 5;
    elseif ~mod(w, 2)
        w = w + 1;
    end
    if ~exist('sigma')
	sigma = 1;
    end
    
    filter = fspecial('gaussian', [w w], sigma);
    result = filter2(filter, im);
end
