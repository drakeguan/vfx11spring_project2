function plotFeaturesOverImage(image, featureX, featureY, filename)

% refs:
%   http://stackoverflow.com/questions/1860760/how-can-i-draw-a-circle-on-an-image-in-matlab
%   http://stackoverflow.com/questions/1848176/how-do-i-save-a-plotted-image-and-maintain-the-original-image-size-in-matlab/1848995#1848995

[row, col, channel] = size(image);

imshow(image);
set(gca,'Units','normalized','Position',[0 0 1 1]);  %# Modify axes size
set(gcf,'Units','pixels','Position',[1 1 col row]);  %# Modify figure size
num = size(featureX);
hold on;
for i = 1:num
    plot(featureX(i), featureY(i), '+');
end
hold off;
f = getframe(gcf);
imwrite(f.cdata, filename);

end
