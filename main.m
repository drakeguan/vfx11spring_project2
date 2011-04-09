function main(source)
    if ~exist('source')
	source = '/tmp/drake/denny00.jpg';
    end

    %filename = 'featuresOverImage.png';
    image = imread(source);

    %[featureX, featureY] = featureMoravec(image);
    [featureX, featureY, R] = featureHarris(image, 7, 1, 5);
    disp(sprintf('feature number: %d.', numel(featureX)));
    plotFeaturesOverImage(image, featureX, featureY, '+');

    %figure(1);
    %imshow(R);
end
