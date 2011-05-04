function trans = solverTranslation(match, pos1, pos2)

    n = size(match, 1);
    A = zeros(n*2+1, 3);
    b = zeros(n*2+1, 1);

    % x
    for i = 1:n
        A(i, 1) = 1;
        A(i, 3) = pos1(match(i, 1), 1);
        b(i, 1) = pos2(match(i, 2), 1);
    end
    % y
    for i = 1:n
        j = i + n;
        A(j, 2) = 1;
        A(j, 3) = pos1(match(i, 1), 2);
        b(j, 1) = pos2(match(i, 2), 2);
    end
    % constraints
    A(n*2+1, 3) = 1;
    b(n*2+1, 1) = 1;

    trans = A\b;
    trans = round(trans);
    trans(3) = [];
end

% vim: set et sw=4 sts=4 nu:
