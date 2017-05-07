function E = TwistEdges(E,move)

if iscell(move)
    for i=1:numel(move)
        E = TwistEdges(E,move{i});
    end
    return
end
if move(1)~='r' && numel(move)==2
    E = TwistEdges(E,{move(1),move(1)});
    if move(2)=='''' || move(2)=='3'
        E = TwistEdges(E,move(1));
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

if size(E,1)==2
    calc = 'both';
elseif max(E)==1 || min(E)==0
	E = [1:12;E];
    calc = 'orient';
else
	E = [E;ones(1,12)];
    calc = 'perm';
end

m = 'LRUDFBxyzpqr';
x = m==move(1);

M = ...
    [5 6 3 4 2 1 7 8 9 10 11 12;... L
     1 2 7 8 5 6 4 3 9 10 11 12;... R
     9 2 12 4 5 6 7 8 3 10 11 1;... U
     1 11 3 10 5 6 7 8 9 2 4 12;... D
     1 2 3 4 5 10 9 8 6 7 11 12;... F
     1 2 3 4 12 6 7 11 9 10 5 8;... B
     3 1 4 2 12 9 10 11 7 6 5 8;... x
     5 6 8 7 2 1 3 4 12 9 10 11;... y
     12 11 9 10 8 5 6 7 1 2 4 3;... z
     1 2 3 4 6 5 8 7 12 11 10 9;... rx
     3 4 1 2 8 7 6 5 9 10 11 12;... ry
     2 1 4 3 5 6 7 8 10 9 12 11];  %rz

%PERMUTATION
E(:,:) = E(:,M(x,:));
%ORIENTATION
if move(1)=='U'
	E(2,[1,3,9,12]) = ~E(2,[1,3,9,12]);
elseif move(1)=='D'
	E(2,[2,4,10,11]) = ~E(2,[2,4,10,11]);
end

switch calc
	case 'perm'
		E = E(1,:);
	case 'orient'
		E = E(2,:);
end
