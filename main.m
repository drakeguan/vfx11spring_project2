function main(source, filename)
    if ~exist('source')
	source = '/tmp/drake/denny00.jpg';
    end

    if ~exist('filename')
	filename = '/tmp/featureHarris_result.png';
    end
    image = imread(source);

    %[featureX, featureY] = featureMoravec(image);
    [featureX, featureY, R] = featureHarris(image, 7, 1, 5);
    disp(sprintf('feature number: %d.', numel(featureX)));
    plotFeaturesOverImage(image, featureX, featureY, '+', filename);

    %figure(1);
    %imshow(R);
end
