function z = r2z(r)

% Z = R2Z(R) takes as input a matrix of correlation coefficients R and
% applies a Fisher transformation. The resulting z-values are ouput in
% matrix Z.
%
% Written by Juan Manuel Contreras (juan.manuel.contreras.87@gmail.com) on
% April 27, 2012.

matrixDims = length(size(r));

if matrixDims == 2
    
    [a b] = size(r);
    z = zeros(a, b);
    for ai = 1:a
        for bi = 1:b
            num = 1 + r(ai, bi);
            den = 1 - r(ai, bi);
            z(ai, bi) = 0.5 * log(num / den);
        end
    end
    
elseif matrixDims == 3
    
    [a b c] = size(r);
    z = zeros(a, b, c);
    for ai = 1:a
        for bi = 1:b
            for ci = 1:c
                num = 1 + r(ai, bi, ci);
                den = 1 - r(ai, bi, ci);
                z(ai, bi, ci) = 0.5 * log(num / den);
            end
        end
    end
    
else
    
    error('Cannot process %.f-dimensional matrices.', matrixDims)
    
end
