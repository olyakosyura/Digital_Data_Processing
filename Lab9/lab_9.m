function lab_9
    I = double(rgb2gray(imread('bimage2.bmp'))) / 255;
    
    cepstrum = mean(I, 3);
    cepstrum = fftshift((fft2(cepstrum)));
    cepstrum = log(1 + abs(cepstrum).^2);    
    figure(1);
    imshow(cepstrum, [min(min(cepstrum)), max(max(cepstrum))]);
	title('Cepstrum');
    
    PSF = fspecial('motion', 17, 20);
    figure(2);
    imshow(deconvblind(I, PSF));
	title('Deblurred image');
    
    figure(3);
    imshow(PSF, [min(min(PSF))
        , max(max(PSF))]);
end


