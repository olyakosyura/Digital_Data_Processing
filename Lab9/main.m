I = im2double(imread('bimage2.bmp'));
%figure(1); imshow(I); title('Origin image');

cepstrum = mean(I, 3);
cepstrum = fftshift((fft2(cepstrum)));
cepstrum = log(1 + abs(cepstrum).^2);

figure(2);
imshow(cepstrum, [min(min(cepstrum)), max(max(cepstrum))]);
title('cepstrum');

noise_var = 0.0001;
estimated_nsr = noise_var / var(I(:));

PSF = fspecial('motion',52,25);
I = edgetaper(I, PSF);
J = deconvwnr(I, PSF, estimated_nsr);
%J = deconvlucy(I, PSF);


%figure(3); imshow(J); title('Result');
imwrite(J, 'result.png');
disp('done');