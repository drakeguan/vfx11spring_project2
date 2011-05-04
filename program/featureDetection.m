function [featureX, featureY, pos, orient, desc, im, R] = featureDetection(im_name, debug_)

    if ~exist('debug_')
        debug_ = 0;
    end

    im = imRead(im_name);
    %figure;
    %imshow(im);
    im = warpCylindrical(im, 800);     % FIXME
    %figure;
    %imshow(uint8(im));

    %[featureX, featureY] = featureMoravec(im);
    %%%%%  featureHarris(im, w, sigma, threshold, radius, k)
    [featureX, featureY, R] = featureHarris(im, 7, 1, 5);   % FIXME
    if debug_
        disp(sprintf('feature number: %d.', numel(featureX)));
    end

    [featureX, featureY] = rejectBoundary(im, featureX, featureY, R);
    if debug_
        disp(sprintf('feature number after rejection of boundary: %d.', numel(featureX)));
    end
    [featureX, featureY, R] = rejectLowContrast(im, featureX, featureY, R);
    if debug_
        disp(sprintf('feature number after rejection of low-contrast: %d.', numel(featureX)));
    end
    [featureX, featureY, R] = rejectEdge(im, featureX, featureY, R);
    if debug_
        disp(sprintf('feature number after rejection of edge: %d.', numel(featureX)));
    end
    [pos, orient, desc] = descriptorSIFT(im, featureX, featureY);
    if debug_
        disp(sprintf('number of SIFT descriptors: %d.', size(pos, 1)));
    end
end

% vim: set et sw=4 sts=4 nu:
