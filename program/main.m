%function main(src_img_file, filename)
%    if ~exist('src_img_file')
%        src_img_file = '/tmp/drake/thumb/01.jpg';
%    end
%
%    if ~exist('filename')
%        filename = '/tmp/feature_result.png';
%    end

    debug_ = 1;
    N = 22;
    rootPath = '/tmp/drake/thumb';
    for i = 1:N
        src_img_file = sprintf('%s/%02d.jpg', rootPath, i);
        disp(sprintf('processing %s...', src_img_file));

        im = warpCylindrical(imRead(src_img_file), 800);
%        [fx, fy, pos, orient, desc, im, R] = featureDetection(src_img_file, debug_);
%

        load(sprintf('mat/fx_%02d.mat', i));
        load(sprintf('mat/fy_%02d.mat', i));
        load(sprintf('mat/pos_%02d.mat', i));
        load(sprintf('mat/orient_%02d.mat', i));
        load(sprintf('mat/desc_%02d.mat', i));

        ims{i} = im;
        fxs{i} = fx;
        fys{i} = fy;
        poss{i} = pos;
        orients{i} = orient;
        descs{i} = desc;

%        save(sprintf('mat/fx_%02d.mat', i), 'fx');
%        save(sprintf('mat/fy_%02d.mat', i), 'fy');
%        save(sprintf('mat/pos_%02d.mat', i), 'pos');
%        save(sprintf('mat/orient_%02d.mat', i), 'orient');
%        save(sprintf('mat/desc_%02d.mat', i), 'desc');
    end
%    save('mat/fxs.mat', 'fxs');
%    save('mat/fys.mat', 'fys');
%    save('mat/poss.mat', 'poss');
%    save('mat/orients.mat', 'orients');
%    save('mat/descs.mat', 'descs');
%    return;

    for i = 1:(N-1)
%        match = featureMatching(descs{i}, descs{i+1}, poss{i}, poss{i+1});
%        matchCompact = ransac(match, poss{i}, orients{i}, descs{i}, poss{i+1}, orients{i+1}, descs{i+1});
        load(sprintf('mat/match_%02d.mat', i));
        load(sprintf('mat/matchCompact_%02d.mat', i));
        tran = solverTranslation(matchCompact, poss{i}, poss{i+1});
        matchs{i} = match;
        matchCompacts{i} = matchCompact;
        trans{i} = tran;
%        save(sprintf('mat/match_%02d.mat', i), 'match');
%        save(sprintf('mat/matchCompact_%02d.mat', i), 'matchCompact');
    end
%    save('mat/matchs.mat', 'matchs');
%    save('mat/matchCompacts.mat', 'matchCompacts');
%    save('mat/trans.mat', 'trans');

%    load('mat/matchs.mat');
%    load('mat/matchCompacts.mat');
%    load('mat/trans.mat');

%    %[featureX, featureY, pos, orient, desc, im, R] = featureDetection(src_img_file, debug_);
%    %plotFeaturesOverImage(im, featureX, featureY, '+', filename);
%    %pause;
%
%    %figure(1);
%    %imshow(R);
%
%    tic;
%    src_img_file1 = '/tmp/drake/prtn00.jpg';
%    src_img_file2 = '/tmp/drake/prtn01.jpg';
%    [featureX1, featureY1, pos1, orient1, desc1, im1, R1] = featureDetection(src_img_file1, debug_);
%    [featureX2, featureY2, pos2, orient2, desc2, im2, R2] = featureDetection(src_img_file2, debug_);
%    disp(sprintf('[feature detection] elapsed sec: %.2f', toc()));
%
%    tic;
%    match = featureMatching(desc1, desc2, pos1, pos2);
%    disp(sprintf('[feature matching] elapsed sec: %.2f', toc()));
%
%    tic;
%    matchCompact = ransac(match, pos1, orient1, desc1, pos2, orient2, desc2);
%    disp(sprintf('[ransac on features] elapsed sec: %.2f', toc()));
%
%    disp('matching...');
%    displayMatchInTerminal(pos1, pos2, matchCompact);
%    %disp('matching...');
%    %displayMatchInTerminal(pos1, pos2, matchCompact);
%    %display2MatchingImage(im1, im2, pos1, pos2, match);

%end

% vim: set et sw=4 sts=4 nu:
