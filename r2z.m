function z = r2z(r)

% Z = R2Z(R) takes as input a single value or a correlation R and
% applies a Fisher transformation. The resulting z-values are ouput in
% matrix Z.
%
% Written by Juan Manuel Contreras (juan.manuel.contreras.87@gmail.com) on
% April 27, 2012.

matrixDims = length(size(r));

if matrixDims == 1

    z = fisher(r)

elseif matrixDims == 2
    
    [a b] = size(r);
    z = nan(a, b);
    for ai = 1:a
        for bi = 1:b
            z(ai, bi) = fisher(r(ai, bi));
        end
    end
    
elseif matrixDims == 3
    
    [a b c] = size(r);
    z = nan(a, b, c);
    for ai = 1:a
        for bi = 1:b
            for ci = 1:c
                z(ai, bi, ci) = fisher(r(ai, bi, ci));
            end
        end
    end
    
else
    
    error('Cannot process %.f-dimensional matrices.', matrixDims)
    
end

end

function z = fisher(r)

z = 0.5 * log((1 + r) / (1 - r))

end
