function main(src_img_file, filename)
    if ~exist('src_img_file')
	src_img_file = '/tmp/drake/denny00.jpg';
    end

    if ~exist('filename')
	filename = '/tmp/featureHarris_result.png';
    end
    im = imread(src_img_file);
    %figure;
    %imshow(im);
    im = warpCylindrical(im, 1000);
    %figure;
    %imshow(uint8(im));

    %[featureX, featureY] = featureMoravec(im);
    [featureX, featureY, R] = featureHarris(im, 7, 1, 5);
    disp(sprintf('feature number: %d.', numel(featureX)));

    [featureX, featureY] = rejectBoundary(im, featureX, featureY, R);
    disp(sprintf('feature number after rejection of boundary: %d.', numel(featureX)));
    [featureX, featureY, R] = rejectLowContrast(im, featureX, featureY, R);
    disp(sprintf('feature number after rejection of low-contrast: %d.', numel(featureX)));
    [featureX, featureY, R] = rejectEdge(im, featureX, featureY, R);
    disp(sprintf('feature number after rejection of edge: %d.', numel(featureX)));
    [pos, orient, desc] = descriptorSIFT(im, featureX, featureY);
    disp(sprintf('number of SIFT descriptors: %d.', size(pos, 1)));

    plotFeaturesOverImage(im, featureX, featureY, '+', filename);

    %figure(1);
    %imshow(R);
end
