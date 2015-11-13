function main
    I = double(rgb2gray(imread('bimage2.bmp'))) / 255;
    figure(1);
    imshow(I);
	title('Original image');
    
    PSF = fspecial('motion', 54, 65);
    figure(2);
    imshow(deconvblind(I, PSF));
	title('Deblurred image');
    
    %figure(3);
    %imshow(PSF, [min(min(PSF)), max(max(PSF))]);
end


