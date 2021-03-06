classdef Lab05 < handle
    properties (Constant = true)
        A = 1
        x0 = 2
    end
    
    properties
        m_x
        m_orig_gauss
        m_source_i
        m_source_g
    end
    
    methods
        function v = impulse(this, num, impnum)
            v = zeros(1, num+1);
            for i=1:impnum
                v(ceil(rand*num))=rand*(this.A);
            end
        end
        
     
        
      
        function v = gauss(this, sigma)
            v = (this.A * exp(-this.m_x .^ 2 / sigma));
        end
        
        function dobutter(this, num, cut)
            [b, a] = butter(2, 0.1, cut);   
            n = 6;
            
            window = hann(n+1);
            iir_filtered_i = filter(b, a, this.m_source_i);
            iir_filtered_g = filter(b, a, this.m_source_g);
            iir_filtered_i2 = fir1(n, this.m_source_i, cut, window);
            iir_filtered_g2 = fir1(n, 0.5, window);
            
            figure(num);
            subplot(2, 3, 1);
            plot(this.m_x, this.m_source_i);
            title(strcat('������ � ����� (�������)-', cut));

            subplot(2, 3, 2);
            plot(this.m_x, iir_filtered_i);
            title(strcat('���-������-', cut));

            subplot(2, 3, 3);
            plot(this.m_x, iir_filtered_i2);
            title(strcat('���-������-', cut));
            
            subplot(2, 3, 4);
            plot(this.m_x, this.m_source_g);
            title(strcat('������ � ����� (�����)-', cut));

            
            subplot(2, 3, 5);
            plot(this.m_x, iir_filtered_g);
            title(strcat('���-������-', cut));
            
            subplot(2, 3, 6);
            plot(this.m_x, iir_filtered_g2);
            title(strcat('���-������-', cut));
            
            
            
        end
        
        function dowinner(this, num)
            alpha = this.m_source_i;
            beta = this.m_source_i - this.m_orig_gauss;

            R1 = fft(alpha);
            R2 = fft(beta);
            H = ((abs(R1).*abs(R1)) - (abs(R2).*abs(R2)))./(abs(R1).*abs(R1));

            figure(num);
            subplot(2, 2, 1);
            plot(this.m_x, this.m_source_i);
            title('������ � ����� (�������)');

            subplot(2, 2, 2);
            plot(this.m_x, ifft(R1.*H));
            title('������ ���������������');

            alpha = this.m_source_g;
            beta = this.m_source_g - this.m_orig_gauss;

            R1 = fft(alpha);
            R2 = fft(beta);
            H = ((abs(R1).*abs(R1)) - (abs(R2).*abs(R2)))./(abs(R1).*abs(R1));

            subplot(2, 2, 3);
            plot(this.m_x, this.m_source_g);
            title('������ � ����� (�����)');

            subplot(2, 2, 4);
            plot(this.m_x, ifft(R1.*H));
            title('������ ���������������');
        end
        
        function main(this, sigma, step, impnum)
            this.m_x = -this.x0:step:this.x0;
            
            N = 2 * this.x0/step;
            
            this.m_orig_gauss = this.gauss(sigma);
            
            this.m_source_i = this.m_orig_gauss + this.impulse(N, impnum);
            this.m_source_g = awgn(this.m_orig_gauss, 20, 'measured');
            
            this.dobutter(1, 'low');
            this.dobutter(2, 'high');
           % this.dowinner(3);
        end
    end
end
