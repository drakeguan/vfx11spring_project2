function [xo, yo] = unwarpCylindrical(x, y, f, im)

    [row, col, c] = size(im);
    my = round(row/2);
    mx = round(col/2);
    s = f;

    theta = (x - mx)/s;
    h = (y - my)/s;
    xp = tan(theta)*f;
    yp = h*sqrt(xp*xp + f*f);
    xo = round(xp + mx);
    yo = round(yp + my);
end

% vim: set et:
