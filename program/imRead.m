function im = imRead(im_filename)
    if exist('jpgread')
        im = jpgread(im_filename);
    else
        im = imread(im_filename);
    end
end
