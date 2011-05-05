function display2MatchingImage(im1, im2, pos1, pos2, match)

    p1 = pos1(match(:,1),:);
    p2 = pos2(match(:,2),:);

    imshow([im1, im2]);
    for i = 1:size(match, 1)
        line([p1(i,1) (p2(i,1)+size(im1,2))], [p1(i,2) p2(i,2)]);
    end
end

% vim: set et sw=4 sts=4 nu:
