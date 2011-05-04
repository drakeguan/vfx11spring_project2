function [pos, orient, desc] = descriptorSIFT(im, featureX, featureY)
    % borrowed and modified from Thomas F. El-Maraghi
    % May 2004

    pos = [];
    orient = [];
    desc = [];

    % convert the im into luminance
    dim = ndims(im);
    if( dim == 3 )
        I = rgb2gray(im);
    else
        I = im;
    end
    [row, col] = size(I);

    % convert the image to double
    if( ~isa(I, 'double'))
        I = double(I);
    end

    % gaussian-smoothed the image to remove some noise in advance
    L = filter2(fspecial('gaussian', [5 5]), I);    % FIXME

    % Compute x and y derivatives using pixel differences
    %   the first and the last elements are ignored to ease the computing.
    %	that is, it ranges from 2:(end-1)
    Dx = 0.5*(L(2:(end-1), 3:(end)) - L(2:(end-1), 1:(end-2)));
    Dy = 0.5*(L(3:(end), 2:(end-1)) - L(1:(end-2), 2:(end-1)));

    % Compute the magnitude of the gradient
    mag = zeros(size(I));
    mag(2:(end-1), 2:(end-1)) = sqrt(Dx.^2 + Dy.^2);

    % Compute the orientation of the gradient
    %   range: [-pi, pi)
    %	pi is not included to fit hist_orient
    grad = zeros(size(I));
    grad(2:(end-1), 2:(end-1)) = atan2( Dy, Dx );
    grad(find(grad == pi)) = -pi;

    % Set up the histogram bin centers for a 36 bin histogram.
    %   Columns 1 through 13:
    %   -3.14159  -2.96706  -2.79253  -2.61799  -2.44346  -2.26893  -2.09440  -1.91986  -1.74533  -1.57080  -1.39626  -1.22173  -1.04720
    %   Columns 14 through 26:
    %   -0.87266  -0.69813  -0.52360  -0.34907  -0.17453   0.00000   0.17453   0.34907   0.52360   0.69813   0.87266   1.04720   1.22173
    %   Columns 27 through 36:
    %   1.39626   1.57080   1.74533   1.91986   2.09440   2.26893   2.44346   2.61799   2.79253   2.96706
    num_bins = 36;
    hist_step = 2*pi/num_bins;
    hist_orient = [-pi:hist_step:(pi-hist_step)];

    % Create a gaussian weighting mask
    %   sigma = 1.5 * scale of the keypoint!
    sigma = 0.75;   % FIXME
    sz = 7;	    % FIXME
    hf_sz = floor(sz/2);
    g = fspecial('gaussian', [sz sz], sigma);

    for k = 1:numel(featureY)
        % Histogram the gradient orientations for this keypoint weighted by the
        % gradient magnitude and the gaussian weighting mask.
        x = featureX(k);
        y = featureY(k);

        %disp([y, x]);
        weightedMag = g .* mag((y-hf_sz):(y+hf_sz), (x-hf_sz):(x+hf_sz));
        grad_window = L((y-hf_sz):(y+hf_sz), (x-hf_sz):(x+hf_sz));
        orient_hist = zeros(length(hist_orient), 1);
        for bin = 1:num_bins
            % Compute the diference of the orientations mod pi
            diff = mod( grad_window - hist_orient(bin) + pi, 2*pi ) - pi;

            % Accumulate the histogram bins
            orient_hist(bin)=orient_hist(bin)+sum(sum(weightedMag.*max(1 - abs(diff)/hist_step,0)));
        end

        % Find peaks in the orientation histogram using nonmax suppression.
        %   get 2 rotated vector2, representing the left and the right elements.
        %   check inequality compared to each element's neighbors (left, right).
        peaks = orient_hist;        
        rot_right = [ peaks(end); peaks(1:end-1) ];
        rot_left = [ peaks(2:end); peaks(1) ];         
        peaks( find(peaks < rot_right) ) = 0;
        peaks( find(peaks < rot_left) ) = 0;

        % Extract the value and index of the largest peak. 
        [max_peak_val ipeak] = max(peaks);

        % Iterate over all peaks within 80% of the largest peak and add keypoints with
        % the orientation corresponding to those peaks to the keypoint list.
        peak_val = max_peak_val;
        while( peak_val > 0.8*max_peak_val )
            % Interpolate the peak by fitting a parabola to the three histogram values
            % closest to each peak.				            
            A = [];
            b = [];
            for j = -1:1
                A = [A; (hist_orient(ipeak)+hist_step*j).^2 (hist_orient(ipeak)+hist_step*j) 1];
                bin = mod( ipeak + j + num_bins - 1, num_bins ) + 1;
                b = [b; orient_hist(bin)];
            end
            c = pinv(A)*b;
            max_orient = -c(2)/(2*c(1));
            while( max_orient < -pi )
                max_orient = max_orient + 2*pi;
            end
            while( max_orient >= pi )
                max_orient = max_orient - 2*pi;
            end            

            % Store the keypoint position, orientation, and scale information
            pos = [pos; [x y]];
            orient = [orient; max_orient];

            % Get the next peak
            peaks(ipeak) = 0;
            [peak_val ipeak] = max(peaks);
        end
    end



    % The final of the SIFT algorithm is to extract feature descriptors for the keypoints.
    % The descriptors are a grid of gradient orientation histograms, where the sampling
    % grid for the histograms is rotated to the main orientation of each keypoint.  The
    % grid is a 4x4 array of 4x4 sample cells of 8 bin orientation histograms.  This 
    % procduces 128 dimensional feature vectors.

    % The orientation histograms have 8 bins
    orient_bin_spacing = pi/4;
    orient_angles = [-pi:orient_bin_spacing:(pi-orient_bin_spacing)];

    % The feature grid is has 4x4 cells - feat_grid describes the cell center positions
    grid_spacing = 4;
    [x_coords y_coords] = meshgrid( [-6:grid_spacing:6] );
    feat_grid = [x_coords(:) y_coords(:)]';
    [x_coords y_coords] = meshgrid( [-(2*grid_spacing-0.5):(2*grid_spacing-0.5)] );
    feat_samples = [x_coords(:) y_coords(:)]';
    feat_window = 2*grid_spacing;

    % Loop over all of the keypoints.
    for k = 1:size(pos,1)
        x = pos(k,1);
        y = pos(k,2);   

        % Rotate the grid coordinates.
        M = [cos(orient(k)) -sin(orient(k)); sin(orient(k)) cos(orient(k))];
        feat_rot_grid = M*feat_grid + repmat([x; y],1,size(feat_grid,2));
        feat_rot_samples = M*feat_samples + repmat([x; y],1,size(feat_samples,2));

        % Initialize the feature descriptor.
        feat_desc = zeros(1,128);

        % Histogram the gradient orientation samples weighted by the gradient magnitude and
        % a gaussian with a standard deviation of 1/2 the feature window.  To avoid boundary
        % effects, each sample is accumulated into neighbouring bins weighted by 1-d in
        % all dimensions, where d is the distance from the center of the bin measured in
        % units of bin spacing.
        for s = 1:size(feat_rot_samples,2)
            x_sample = feat_rot_samples(1,s);
            y_sample = feat_rot_samples(2,s);

            % Interpolate the gradient at the sample position
            [X Y] = meshgrid( (x_sample-1):(x_sample+1), (y_sample-1):(y_sample+1) );
            try
                G = interp2( I, X, Y, '*linear' );
            catch
                G = interp2( I, X, Y, 'linear' );
            end
            G(find(isnan(G))) = 0;
            Dx = 0.5*(G(2,3) - G(2,1));
            Dy = 0.5*(G(3,2) - G(1,2));
            mag_sample = sqrt( Dx^2 + Dy^2 );
            grad_sample = atan2( Dy, Dx );
            if grad_sample == pi
                grad_sample = -pi;
            end      

            % Compute the weighting for the x and y dimensions.
            x_wght = max(1 - (abs(feat_rot_grid(1,:) - x_sample)/grid_spacing), 0);
            y_wght = max(1 - (abs(feat_rot_grid(2,:) - y_sample)/grid_spacing), 0); 
            pos_wght = reshape(repmat(x_wght.*y_wght,8,1),1,128);

            % Compute the weighting for the orientation, rotating the gradient to the
            % main orientation to of the keypoint first, and then computing the difference
            % in angle to the histogram bin mod pi.
            diff = mod( grad_sample - orient(k) - orient_angles + pi, 2*pi ) - pi;
            orient_wght = max(1 - abs(diff)/orient_bin_spacing,0);
            orient_wght = repmat(orient_wght,1,16);         

            % Compute the gaussian weighting.
            g = exp(-((x_sample-x)^2+(y_sample-y)^2)/(2*feat_window^2))/(2*pi*feat_window^2);

            % Accumulate the histogram bins.
            feat_desc = feat_desc + pos_wght.*orient_wght*g*mag_sample;
        end

        % Normalize the feature descriptor to a unit vector to make the descriptor invariant
        % to affine changes in illumination.
        feat_desc = feat_desc / norm(feat_desc);

        % Threshold the large components in the descriptor to 0.2 and then renormalize
        % to reduce the influence of large gradient magnitudes on the descriptor.
        feat_desc( find(feat_desc > 0.2) ) = 0.2;
        feat_desc = feat_desc / norm(feat_desc);

        % Store the descriptor.
        desc = [desc; feat_desc];
    end
end

% vim: set et sw=4 sts=4 nu:
