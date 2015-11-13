function main
    mInputImage = imread('bimage2.bmp');
    mInputImage = double(mInputImage) / 255;
    mInputImage = mean(mInputImage, 3);

    mImageDft = fftshift((fft2(mInputImage)));

    mImageCepstrum = log(1 + abs(mImageDft).^2);

    %mImageCepstrum = abs(fftshift(ifft2(mImageDft)));

    %mImageCepstrum = mImageCepstrum / max(mImageCepstrum(:));

    figure();
    imshow(mImageCepstrum, [min(min(mImageCepstrum)), max(max(mImageCepstrum))])
end