function main()

    sequence = 'taipei_maple';      % sequence name
    rootPath = ['../image/original/' sequence];     % root path of the sequence
    outFile = 'stitched.png';       % output stitched file.
    N = 22;     % number of images in the sequence
    focal_length = 800;     % pseudo focal length
    debug_ = 1;     % output debug msg?
    cache = 1;      % cache mode? use saved .mat files.
    saveCache = 0;  % save the result to the cache files?



    disp('[image loading] begin...');
    tic;
    for i = 1:N
        src_img_file = sprintf('%s/%02d.jpg', rootPath, i);
        disp(sprintf('loading... %s', src_img_file));

        if cache
            im = warpCylindrical(imRead(src_img_file), focal_length);
            ims{i} = im;
        end
    end
    toc;
    disp('[image loading] end...');
    disp(' ');




    disp('[feature detection] begin...');
    tic;
    for i = 1:N
        src_img_file = sprintf('%s/%02d.jpg', rootPath, i);
        disp(sprintf('processing... %s', src_img_file));

        if cache
            load(sprintf('mat/fx_%02d.mat', i));
            load(sprintf('mat/fy_%02d.mat', i));
            load(sprintf('mat/pos_%02d.mat', i));
            load(sprintf('mat/orient_%02d.mat', i));
            load(sprintf('mat/desc_%02d.mat', i));
        else
            [fx, fy, pos, orient, desc, im, R] = featureDetection(src_img_file, focal_length, 1, debug_);

            if saveCache
                save(sprintf('mat/fx_%02d.mat', i), 'fx');
                save(sprintf('mat/fy_%02d.mat', i), 'fy');
                save(sprintf('mat/pos_%02d.mat', i), 'pos');
                save(sprintf('mat/orient_%02d.mat', i), 'orient');
                save(sprintf('mat/desc_%02d.mat', i), 'desc');
            end

            ims{i} = im;
            fxs{i} = fx;
            fys{i} = fy;
            poss{i} = pos;
            orients{i} = orient;
            descs{i} = desc;
        end
    end
    if saveCache
        save('mat/fxs.mat', 'fxs');
        save('mat/fys.mat', 'fys');
        save('mat/poss.mat', 'poss');
        save('mat/orients.mat', 'orients');
        save('mat/descs.mat', 'descs');
    end
    toc;
    disp('[feature detection] end...');
    disp(' ');




    disp('[feature matching] begin...');
    tic;
    for i = 1:(N-1)
        if cache
            load(sprintf('mat/match_%02d.mat', i));
            load(sprintf('mat/matchCompact_%02d.mat', i));
        else
            match = featureMatching(descs{i}, descs{i+1}, poss{i}, poss{i+1});
            matchCompact = ransac(match, poss{i}, orients{i}, descs{i}, poss{i+1}, orients{i+1}, descs{i+1});
            if saveCache
                save(sprintf('mat/match_%02d.mat', i), 'match');
                save(sprintf('mat/matchCompact_%02d.mat', i), 'matchCompact');
            end
        end
        matchs{i} = match;
        matchCompacts{i} = matchCompact;
    end
    %load('mat/matchs.mat');
    %load('mat/matchCompacts.mat');
    if saveCache
        save('mat/matchs.mat', 'matchs');
        save('mat/matchCompacts.mat', 'matchCompacts');
    end
    toc;
    disp('[feature matching] end...');
    disp(' ');



    disp('[image matching] begin...');
    tic;
    if cache
        load('mat/trans.mat');
    else
        for i = 1:(N-1)
            tran = solverTranslation(matchCompact, poss{i}, poss{i+1});
            trans{i} = tran;
        end
    end
    if saveCache
        save('mat/trans.mat', 'trans');
    end
    toc;
    disp('[image matching] end...');
    disp(' ');




    disp('[image blending] begin...');
    tic;
    imNow = ims{1};
    for i  = 2:N
        imNow = blendImage(imNow, ims{i}, trans{i-1});
    end
    imwrite(uint8(imNow), outFile);
    disp(sprintf('save to file:%s', outFile));
    toc;
    disp('[image blending] end...');
    disp(' ');

    disp('done!');

end

% vim: set et sw=4 sts=4 nu:
