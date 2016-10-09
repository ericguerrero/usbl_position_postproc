function dif = trajDif(T1,T2)
tol = 10; % tolerance

t_1 = T1(:,1);
t_2 = T2(:,1);
p_1 = T1(:,2);
p_2 = T2(:,2);


len = length(t_1);
p_e = zeros(1,len);

for i = 1:len
    len_gt = length(t_2);
    for j = 1:len_gt
        if t_2(j) >= t_1(i)
            if j>1
                % Interpolate
                delta_t = t_2(j)-t_2(j-1);
                diff_t = t_2(j)-t_1(i);
                prop = diff_t/delta_t;
                delta_p = p_2(j)-p_2(j-1);
                diff_p = delta_p * prop;
                p_2_int = p_2(j) - diff_p;
            else
                p_2_int = p_2(j);
            end
            
            % Error
            p_e(i) = (p_2_int-p_1(i));
            
            % Remove
            if j>2*tol
                t_2(1:j-tol) = [];
                p_2(1:j-tol) = [];
            end
            break;
        end
    end
end
end