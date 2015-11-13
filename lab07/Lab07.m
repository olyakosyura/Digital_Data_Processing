classdef Lab07 < handle
    properties (Constant = true)
        A = 1
        x0 = 5
    end
    
    properties
        m_x
    end
    
    methods
        function v = gauss(this, N, sigma, eps)
            dist = -eps*ones(1, N) + 2*eps*rand(1, N);
            v = (this.A * exp(-this.m_x .^ 2 / sigma)) + dist;
        end
        
        function alpha = get_alpha(this, u1, u2, sigma, eps, dx, N, T)
            rho = 0.01:0.001:0.3;
            a = rho;
            for j = 1:length(rho)
                alpha = rho(j);
                sum = 0;
                for m=1:N
                    sum = sum + ((abs(u2(m))^2 * dx^2 * abs(u1(m))^2 * (1 + (2*pi*(m-1)/T))^2) / (abs(u2(m))^2 * dx^2 + alpha*(1 + (2*pi*(m-1)/T)^2))^2);
                end
                gamma = dx / N * sum;
                sum = 0;
                for m=1:N
                    sum = sum + ((alpha^2 * abs(u1(m))^2 * (1 + (2*pi*(m-1)/T)^2)) / (abs(u2(m))^2 * dx^2 + alpha*(1 + (2*pi*(m-1)/T)^2))^2);
                end
                beta = dx / N * sum;
                rho(j) = beta - (sigma + eps * sqrt(gamma))^2;
            end
            plot(a, rho);

            p=1;
            min = abs(rho(p));
            for i=2:length(rho)
                if abs(rho(i)) < min
                    min = abs(rho(i));
                    p = i;
                end
            end
            alpha = a(p);
        end
            
        function main(this, step, sigma, eps)
            this.m_x = -this.x0:step:this.x0;
            dx = step;
            T = 2*this.x0;
            
            N = 2 * this.x0/step + 1;
            
            orig_signal = this.gauss(N, 2, sigma);
            deform_signal = this.gauss(N, 1, eps);
            
            u1 = fft(orig_signal);
            u2 = fft(deform_signal);
            
            alpha = this.get_alpha(u1, u2, sigma, eps, dx, N, T);
            disp(alpha);
            
            H = zeros(1, N);
            for k=1:N
                sum = 0;
                for m=1:N
                   sum = sum + ( (exp(2*pi*1i*k*(m-1)/N) * u1(m)* conj(u2(m))) / (abs(u2(m))^2 * dx^2 + alpha*(1 + (2*pi*(m-1)/T)^2)));
                end
                H(k)= dx / N * sum;
            end
            
%            restored_signal = abs(ifft(u2.*H));
%            restored_signal = abs(H);
            restored_signal = abs(this.swap(H));
            
            plot(this.m_x, orig_signal, 'r', ...
                 this.m_x, deform_signal, 'g', ...
                 this.m_x, restored_signal, 'b');
            legend('Исходный', 'Искаженный', 'Передаточная функция');
        end

        function H = swap(this, P)
            K = length(P);
            if (mod(K, 2) == 0) 
                K = fix(K/2);

                for i = 1:K
                    temp = P(i);
                    P(i) = P(K + i);
                    P(K + i) = temp;  
                end
            else
                K = fix(K/2);

                G = P(K+1);
                for i = K+1:(length(P)-1)
                    P(i) = P(i+1);
                end

                P(length(P))=G;
                for i = 1:K
                    temp = P(i);
                    P(i) = P(K + i);
                    P(K + i) = temp;  
                end
            end
            H = P;
        end
    end
end
