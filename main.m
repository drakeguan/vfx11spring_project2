function main(source)
    if ~exist('source')
	source = '/tmp/drake/denny00.jpg';
    end

    filename = 'featuresOverImage.png';
    image = imread(source);

    %[featureX, featureY] = featureMoravec(image);
    [featureX, featureY] = featureHarris(image, 5, 4);
    numel(featureX)
    %disp(sprintf('feature #: %d', numel(featureX));
    plotFeaturesOverImage(image, featureX, featureY, filename);

end
