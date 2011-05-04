function imout = blendImage(im1, im2, trans)

    % assumption
    %   trans = [dX, dY]; dX < 0;
    %   im1 and im2 are 3-channel images.
    %   images might be warpped.

    [row1, col1, channel] = size(im1);
    [row2, col2, channel] = size(im2);
    imout = zeros(row1, col1+col2+trans(1), channel);
    r1 = ones(1, col1);
    r1(1, (end+trans(1)):end) = [1:(1/trans(1)):0];
    r2 = ones(1, col2);
    r2(1, 1:(1+abs(trans(1)))) = [0:(-1/trans(1)):1];

    bim1 = double(im1);
    bim2 = double(im2);
    for c = 1:channel
        for y = 1:row1
            bim1(y,:,c) = bim1(y,:,c) .* r1;
            bim2(y,:,c) = bim2(y,:,c) .* r2;
        end
    end

    for y = 1:row1
        for x = 1:col1
            imout(y,x,:) = bim1(y,x,:);
        end
        for x = 1:col2 
            x1 = (col1+x+trans(1));
            imout(y,x1,:) = imout(y,x1,:) + bim2(y,x,:);
        end
    end

    imshow(uint8(imout));
end

% vim: set et sw=4 sts=4 nu:
