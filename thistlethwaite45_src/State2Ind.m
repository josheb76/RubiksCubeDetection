function X = State2Ind(Y, varargin)
%
% Convert permutation or orientation to unique index
%

n = numel(Y);

if nargin == 1
    if n==8
        v = 3;
    else
        v = 2;
    end
else
    v = varargin{1};
end

if max(Y)==numel(Y)
    %%PERMUTATION
    X = 0;
    for i = 1:n-1
        X = X*(n+1-i);
        for j=i+1:n
            if Y(i) > Y(j)
                X = X+1;
            end
        end
    end
else
    %%ORIENTATION
    X = 0;
    for i = 1:n-1
        X = X*v;
        X = X + Y(i);
    end
end

