function lab6()
	sigma = 0.5;
	step = 0.01;
	x0 = 2;

	xs = -x0:step:x0;
	ys = gauss(xs, sigma);

	gn_ys = awgn(ys, 30);
	in_ys = add_impulse_noise(ys, 1, 7);
	gn_in_ys = add_impulse_noise(gn_ys, 1, 7);

	figure(1);
    

	subplot(2, 3, 1);
	plot(xs, gn_ys, 'r');
	title('Гауссовский шум');

	subplot(2, 3, 2);
	plot(xs, in_ys, 'r');
	title('Импульсный шум');

	subplot(2, 3, 3);
	plot(xs, gn_in_ys, 'r');
	title('Гауссовский и импульсный шум');

	subplot(2, 3, 4);
	plot(xs, winner(ys, gn_ys));
	title('Фильтр (Гаусс)');

	subplot(2, 3, 5);
	plot(xs, winner(ys, in_ys));
	title('Фильтр (импульс)');

	subplot(2, 3, 6);
	plot(xs, winner(ys, gn_in_ys));
	title('Фильтр (Гаусс и импульс)');
end

function v = gauss(xs, sigma)
	v = exp(-xs .^ 2 / sigma);
end

function v = add_impulse_noise(ys, amplitude, count)
	v = ys;

	for i=1:count
		idx = ceil(rand * length(ys));
		v(idx) = v(idx) + rand * amplitude;
	end
end

function v = winner(ys, ys_noise)
	alpha = ys_noise;
	beta = ys_noise - ys;

	R1 = fft(alpha);
	R2 = fft(beta);
	H = ((abs(R1).*abs(R1)) - (abs(R2).*abs(R2)))./(abs(R1).*abs(R1));

	v = ifft(R1.*H);
end
