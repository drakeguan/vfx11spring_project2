%function main(src_img_file, filename)
    if ~exist('src_img_file')
	src_img_file = '/tmp/drake/prtn00.jpg';
    end

    if ~exist('filename')
	filename = '/tmp/feature_result.png';
    end

    debug_ = 1;

    %[featureX, featureY, pos, orient, desc, im, R] = featureDetection(src_img_file, debug_);
    %plotFeaturesOverImage(im, featureX, featureY, '+', filename);

    %figure(1);
    %imshow(R);

    tic;
    src_img_file1 = '/tmp/drake/prtn00.jpg';
    src_img_file2 = '/tmp/drake/prtn01.jpg';
    [featureX1, featureY1, pos1, orient1, desc1, im1, R1] = featureDetection(src_img_file1, debug_);
    [featureX2, featureY2, pos2, orient2, desc2, im2, R2] = featureDetection(src_img_file2, debug_);
    disp(sprintf('[feature detection] elapsed sec: %.2f', toc()));

    tic;
    match = featureMatching(desc1, desc2, pos1, pos2);
    disp(sprintf('[feature matching] elapsed sec: %.2f', toc()));

    tic;
    matchCompact = ransac(match, pos1, orient1, desc1, pos2, orient2, desc2);
    disp(sprintf('[ransac on features] elapsed sec: %.2f', toc()));

    disp('matching...');
    displayMatchInTerminal(pos1, pos2, matchCompact);
    %disp('matching...');
    %displayMatchInTerminal(pos1, pos2, matchCompact);
    %display2MatchingImage(im1, im2, pos1, pos2, match);

%end
