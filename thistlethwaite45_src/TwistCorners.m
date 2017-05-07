function C = TwistCorners(C,move)

if iscell(move)
    for i=1:numel(move)
        C = TwistCorners(C,move{i});
    end
    return
end

if numel(move)==2 && move(2)=='0'
	return
end
if move(1)~='r' && numel(move)==2
	if move(2)=='1'
    	C = TwistCorners(C,move(1));
	elseif move(2)=='2'
    	C = TwistCorners(C,{move(1),move(1)});
    elseif move(2)=='''' || move(2)=='3'
        C = TwistCorners(C,{move(1),move(1),move(1)});
    end
    return
elseif move(1)=='r'
    switch move(2)
        case 'x'
            move = 'p';
        case 'y'
            move = 'q';
        case 'z'
            move = 'r';
    end
end

if size(C,1)==2
    calc = 'both';
elseif max(C)==2 || min(C)==0
	C = [1:8;C];
    calc = 'orient';
else
	C = [C;ones(1,8)];
    calc = 'perm';
end

m = 'LRUDFBxyzpqr';
x = m==move(1);

M1 = ...
    [6 5 3 4 1 2 7 8;... L
     1 2 8 7 5 6 3 4;... R
     5 2 3 8 4 6 7 1;... U
     1 6 7 4 5 3 2 8;... D
     1 7 3 5 2 6 4 8;... F
     8 2 6 4 5 1 7 3;... B
     8 5 6 7 4 1 2 3;... x
     6 5 7 8 1 2 4 3;... y
     8 6 7 5 1 3 2 4;... z
     5 6 7 8 1 2 3 4;... rx
     8 7 6 5 4 3 2 1;... ry
     6 5 8 7 2 1 4 3];  %rz

M2 = ...
    [5 8 1 4;... U
     6 7 2 3;... D
     2 4 5 7;... F
     1 3 6 8];  %B

y = [1 1 -1 -1];

%ORIENTATION
x = find(x)-2;
if x<=4 && x>=1
    flip = M2(x,:);
    C(2,flip) = mod(C(2,flip)+y,3);
elseif x>=8
	C(2,:) = mod(2*C(2,:),3);
end
%PERMUTATION
x = x+2;
C(:,:) = C(:,M1(x,:));

switch calc
    case 'perm'
		C = C(1,:);
    case 'orient'
		C = C(2,:);
end
