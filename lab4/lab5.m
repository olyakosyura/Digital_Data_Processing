function lab5() % low
	sigma = 0.5;
	step = 0.01;
	x0 = 2;

	xs = -x0:step:x0;
	ys = gauss(xs, sigma);

	gn_ys = awgn(ys, 30);
	in_ys = add_impulse_noise(ys, 1, 7);
	gn_in_ys = add_impulse_noise(gn_ys, 1, 7);

    figure(2);
	draw(1, step, xs, gn_ys);
	draw(2, step, xs, in_ys);
	draw(3, step, xs, gn_in_ys);
end

function draw(fig, step, xs, ys)
	

    if fig == 1
        minus = 0;
    end;
     if fig == 2
        minus = 4;
    end;
     if fig == 3
        minus = 8;
    end;
    
	subplot(3, 4, 1+minus);
	plot(xs, ys);
	title('noise');

	subplot(3,4,2+minus);
	plot(xs, do_filter(ys, step, @iir_butterworth_filter));
	title('filter iir butter');

	subplot(3,4, 3+minus);
	plot(xs, do_filter(ys, step, @fir_butterworth_filter));
	title('filter fir butter');

	subplot(3,4, 4+minus);
	plot(xs, do_filter(ys, step, @fir_gauss_filter));
	title('filter fir gauss');
end

function v = do_filter(ys, step, func)
	count = length(ys);

	H = zeros(count);
	for k=1:count
		f = (count - k) ./ step ./ count;
		if k < count ./ 2
			f = k ./ step ./ count;
		end

		H(k) = func(f, step);
    end

    fft_ys = fft(ys);
    for i=1:length(fft_ys)
        H(i) = fft_ys(i) .* H(i);
    end
    
    v = ifft(H);
end

function v = gauss(xs, sigma)
	v = exp(-xs .^ 2 / sigma);
end

function v = add_impulse_noise(ys, amplitude, count)
	v = ys;

	for i=1:count
		idx = ceil(rand .* length(ys));
		v(idx) = v(idx) + rand .* amplitude;
	end
end

function v = iir_butterworth_filter(f, step)
	v = sqrt(1 ./ (1 + (sin(pi .* f .*step + pi./2) ./ sin(pi .* 1 * step)).^4))
end

function v = fir_butterworth_filter(f, step)
	if f == 0
		v = 0
	else
		v = 1 ./ (1 + (1.4 ./ f) .^ (2 .* 2))
	end
end

function v = fir_gauss_filter(f, step)
	v = 1 - exp(-f .^ 2 ./ (2.*3 .^ 2))
end
