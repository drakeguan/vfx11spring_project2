function match = featureMatching(desc1, desc2, pos1, pos2, threshold)

    if ~exist('threshold')
        threshold = 20;     % FIXME
    end

    match = [];

    for i = 1:size(desc1, 1)
        dists = [];
        for j = 1:size(desc2, 1)
            dists = [dists; sqrt(sum((desc1(i,:) - desc2(j,:)) .^ 2))];
        end
        [min1 min1_idx] = min(dists);
        dists(min1_idx) = [];
        min2 = min(dists);
        if (min1/min2) < 0.8
            if abs(pos1(i, 2) - pos2(min1_idx, 2)) < threshold
                match = [match; [i min1_idx]];
            end
        end
    end
end
% vim: set et sw=4 sts=4 nu:
