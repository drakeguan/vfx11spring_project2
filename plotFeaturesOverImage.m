% refs:
%   http://stackoverflow.com/questions/1860760/how-can-i-draw-a-circle-on-an-image-in-matlab
%   http://stackoverflow.com/questions/1848176/how-do-i-save-a-plotted-image-and-maintain-the-original-image-size-in-matlab/1848995#1848995

function plotFeaturesOverImage(im, featureX, featureY, style, filename)

    if ~exist('style')
	style = '+';
    end

    [row, col, channel] = size(im);
    close all;
    imshow(im);
    set(gca,'Units','normalized','Position',[0 0 1 1]);  %# Modify axes size
    set(gcf,'Units','pixels','Position',[1 1 col row]);  %# Modify figure size

    hold on;
    plot(featureX, featureY, style);
    hold off;

    if exist('filename')
	f = getframe(gcf);
	imwrite(f.cdata, filename);
    end
end
