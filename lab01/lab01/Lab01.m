classdef Lab01 < handle
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
            v = (this.A * exp(-this.m_x .^ 2 / sigma));
        end
        
        function v = restore(this, y, step)
           n = length(this.m_restore);
           v = zeros(1, n);
           for k=1:length(y)
                v = v + y(k) .* sinc((this.m_restore - this.m_x(k)) / step);
           end
        end
        
        function main(this, T, sigma, step, restorestep)
            this.m_restore = -this.x0:restorestep:this.x0;

            this.m_x = this.m_restore;
            orig_rect = this.impulse(T);
            orig_gauss = this.gauss(sigma);
            
            this.m_x = -this.x0:step:this.x0;
            sample_rect = this.impulse(T);
            sample_gauss = this.gauss(sigma);
            
            rest_rect = this.restore(sample_rect, step);
            rest_gauss = this.restore(sample_gauss, step);
            
            shg;

            figure(1);
            plot(this.m_restore, orig_rect, 'r', ...
                 this.m_x, sample_rect, 'g', ...
                 this.m_restore, rest_rect, 'b');
            legend('исходный', 'дискретизованный', 'восстановленный');
            title('Восстановление прямоугольного импульса');
            
            figure(2);
            plot(this.m_restore, orig_gauss, 'r', ...
                 this.m_x, sample_gauss, 'g', ...
                 this.m_restore, rest_gauss, 'b');
            legend('исходный', 'дискретизованный', 'восстановленный');
            title('Восстановление прямоугольного импульса');            
        end
    end
end
