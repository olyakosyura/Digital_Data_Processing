classdef Lab08 < handle
    properties (Constant = true)
        A = 1
        x0 = 2
    end
    
    properties
        m_x
        m_source_i
    end
    
    methods
        function v = impulse(this, num, impnum)
            v = zeros(1, num);
            for i=1:impnum
                v(ceil(rand*num))=rand*(this.A);
            end
        end
        
        function v = gauss(this, sigma)
            v = (this.A * exp(-this.m_x .^ 2 / sigma));
        end
                        
        function dofilter(this, N, M, dp)
            subplot(1,3, 1);
            plot(this.m_x, this.m_source_i);
            title('Сигнал с шумом (импульс)');

            u = this.m_source_i;
            for i=2:N
               var = sort(u(M*(i-1):M*i));
               med = var(ceil(M/2));
               for j = M*(i-1):M*i
                   if abs(u(j) - med) > dp
                       u(j) = med;
                   end
               end
            end
        
            subplot(1,3, 2);
            plot(this.m_x, u);
            title('Сигнал восстановленный (med)');
            
            u = this.m_source_i;
            for i=2:N
               var = sort(u(M*(i-1):M*i));
               mean = sum(var)/M;
               for j = M*(i-1):M*i
                   if abs(u(j) - mean) > dp
                       u(j) = mean;
                   end
               end
            end
            
            subplot(1,3, 3);
            plot(this.m_x, u);
            title('Сигнал восстановленный (mean)');
        end
        
        function main(this, sigma, N, impnum, M, dp)
            dx = 2*this.x0 / (N*M - 1);
            this.m_x = -this.x0:dx:this.x0;
            
            this.m_source_i = this.gauss(sigma) + this.impulse(N*M, impnum);
            
            this.dofilter(N, M, dp);
        end
    end
end
