function displayMatchInTerminal(pos1, pos2, match)
    for i = 1:size(match, 1)
	disp(sprintf('pos1: (%d, %d)  -->  pos2: (%d, %d)', pos1(match(i,1),1), pos1(match(i,1),2), pos2(match(i,2),1), pos2(match(i,2),2)));
    end
end
