function main(src_img_file, filename)
    if ~exist('src_img_file')
	src_img_file = '/tmp/drake/prtn00.jpg';
    end

    if ~exist('filename')
	filename = '/tmp/feature_result.png';
    end

    debug_ = 1;

    [featureX, featureY, pos, orient, desc, im, R] = featureDetection(src_img_file, debug_);
    plotFeaturesOverImage(im, featureX, featureY, '+', filename);

    %figure(1);
    %imshow(R);
end
