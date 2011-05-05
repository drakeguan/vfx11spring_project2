function imout = blendImage(im1, im2, trans)

    % assumption
    %   trans = [dX, dY]; dX < 0;
    %   im1 and im2 are 3-channel images.
    %   images might be warpped.

    [row1, col1, channel] = size(im1);
    [row2, col2, channel] = size(im2);
    imout = zeros(row1+trans(2), col1+abs(trans(1)), channel);

    blendWidth = col2 + trans(1);

    % r1 & r2 are alpha layers.
    r1 = ones(1, col1);
    r2 = ones(1, col2);
    r1(1, (end-blendWidth):end) = [1:(-1/blendWidth):0];
    r2(1, 1:(blendWidth+1)) = [0:(1/blendWidth):1];

    % premultiply im1, im2 by r1, r2
    bim1 = double(im1);
    bim2 = double(im2);
    for c = 1:channel
        for y = 1:row1
            bim1(y,:,c) = bim1(y,:,c) .* r1;
        end
        for y = 1:row2
            bim2(y,:,c) = bim2(y,:,c) .* r2;
        end
    end

    % merge by 'plus'
    for y = 1:row1
        for x = 1:col1
            imout(y+trans(2),x,:) = bim1(y,x,:);
        end
    end
    for y = 1:row2
        for x = 1:col2 
            x1 = x + size(imout, 2) - col2;
            imout(y,x1,:) = imout(y,x1,:) + bim2(y,x,:);
        end
    end

    %imout(find(imout<0)) = 0;
    imout(find(imout>255)) = 255;
end

% vim: set et sw=4 sts=4 nu:
