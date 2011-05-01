function main(src_img_file, filename)
    if ~exist('src_img_file')
	src_img_file = '/tmp/drake/denny00.jpg';
    end

    if ~exist('filename')
	filename = '/tmp/featureHarris_result.png';
    end
    im = imread(src_img_file);

    %[featureX, featureY] = featureMoravec(im);
    [featureX, featureY, R] = featureHarris(im, 7, 1, 5);
    [featureX, featureY, R] = rejectLowContrast(im, featureX, featureY, R);
    [featureX, featureY, R] = rejectEdge(im, featureX, featureY, R);

    disp(sprintf('feature number: %d.', numel(featureX)));
    plotFeaturesOverImage(im, featureX, featureY, '+', filename);

    %figure(1);
    %imshow(R);
end
