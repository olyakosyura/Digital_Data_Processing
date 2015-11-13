classdef Lab02 < handle
    properties (Constant = true)
        A = 1
        x0 = 2
    end
    
    properties
        m_x
        m_restore
    end
    
    methods
        function v = impulse(this, T)
           n = length(this.m_x);
           v = zeros(1, n);
           for k=1:n
               if abs(this.m_x(k)) <= T
                    v(k) = 1;
               end
           end
        end
        
        function v = gauss(this, sigma)
            v = this.A * exp(-this.m_x .^ 2 / sigma);
        end
                
        function v = dft(this, y)
           l = length(y);
           v = zeros(1, l);
           t = -2 * pi * 1i / l;
           for k=1:l
               for n=1:l
                   v(k) = v(k) + y(n) * exp(t * (n - 1) * (k - 1));
               end
           end
        end
        
        function dofft(this, y, num)
            l = length(y);
            y_mod = zeros(1, l);
            for n=1:l
                y_mod(n) = y(n) * (-1)^n;
            end
            figure(num);
            
            subplot(2, 2, 1);
            plot(this.m_x, y, 'r');
            title('Исходный сигнал');
            
            subplot(2, 2, 2);
            plot(this.m_x, y_mod, 'r');
            title('Модифицированный сигнал');
            
            subplot(2, 2, 3);
            plot(this.m_x, abs(this.dft(y)), 'r');
            title('ПФ');
            
            t = cputime;
            rdft = this.dft(y_mod);
            t = cputime - t;
            disp('dft time:');
            disp(t);
            
            t = cputime;
            for i=1:100
            rfft = fft(y_mod);
            end
            t = cputime - t;
            disp('fft time:');
            disp(t);

            subplot(2, 2, 4);
            plot(this.m_x, abs(rdft), 'r', ...
            	 this.m_x, abs(rfft), 'b');
            legend('ПФ', 'БПФ');
            title('ПФ/БПФ');
        end
        
        function main(this, T, sigma, step)
            this.m_x = -this.x0:step:this.x0;
            sample_rect = this.impulse(T);
            sample_gauss = this.gauss(sigma);
            
            shg;
            
            this.dofft(sample_gauss, 1);
            this.dofft(sample_rect, 2);
        end
    end
end
