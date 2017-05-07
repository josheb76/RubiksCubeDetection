function seq = rubopt(seq,varargin)

if ~iscell(seq)
    return
end

if nargin==1
    d = 3;
else
    d = varargin{1};
end

convert_back = false;
if any(seq{1}(1)=='FfBbLlRrUuDd')
    seq = rub2move(seq,d);
    convert_back = true;
end
if iscell(seq)    
    N = numel(seq);
else
    N = 1;
    seq = {seq};
end 
M = N+1;

while N<M
    M = N;
    %put parallel-face moves in right order
    change = true;
    while change
        change = false;
        count = 1;
        while count < numel(seq)
            a = seq{count};
            b = seq{count+1};
            if strcmp(a(1),b(1)) && str2double(a(2)) > str2double(b(2));
                seq{count} = b;
                seq{count+1} = a;
                change = true;
            end
            count = count+1;
        end
    end
    %remove double moves
    count = 1;
    while count < numel(seq)
        a = seq{count};
        b = seq{count+1};
        if strcmp(a(1:end-1),b(1:end-1))
            n = mod(str2double(a(3))+str2double(b(3)),4);
            seq(count+1) = [];
            seq{count}(3) = num2str(n);
            if n == 0
                seq(count) = [];
            end
        end
        count = count+1;
    end
    N = numel(seq);
end

if convert_back
    if ~isempty(seq)
        seq = move2rub(seq,d);
    else
        seq = {};
    end
end