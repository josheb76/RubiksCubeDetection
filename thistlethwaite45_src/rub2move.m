function move2 = rub2move(move,varargin)
%
% Convert a rubik coded move to 'x11'-notation.
%
if ~ischar(move)
    n = numel(move); %number of moves to convert
    seq = move;
else 
    n = 1;
    seq{1} = move;
end

if nargin==2 
    d = varargin{1};
else
    d = 3;
end

if d<4 && (any(cell2mat(seq)=='f') || ...
           any(cell2mat(seq)=='b') || ...
           any(cell2mat(seq)=='u') || ...
           any(cell2mat(seq)=='d') || ...
           any(cell2mat(seq)=='l') || ...
           any(cell2mat(seq)=='r'))
   for i=1:numel(seq)
       seq{i}(seq{i}=='f') = 'F';
       seq{i}(seq{i}=='b') = 'B';
       seq{i}(seq{i}=='u') = 'U';
       seq{i}(seq{i}=='d') = 'D';
       seq{i}(seq{i}=='l') = 'L';
       seq{i}(seq{i}=='r') = 'R';
   end
end

A = 'xxxxyyyyzzzz';
B = [1 2 d d-1 1 2 d d-1 1 2 d d-1];
C = [1 1 3 3 1 1 3 3 3 3 1 1;...
     3 3 1 1 3 3 1 1 1 1 3 3;...
     2 2 2 2 2 2 2 2 2 2 2 2];

x = 'BbFfLlRrUuDd';
y = '''2';

for k=1:n
    move = seq{k};
    side = move(1);
    j = find(x==side);
    move2{k}(1:2) = [A(j) num2str(B(j))];
    if numel(move)>1
        app = move(2);
        i = find(y==app)+1;    
        move2{k}(3) = num2str(C(i,j));
    else
        move2{k}(3) = num2str(C(1,j));
    end
end

if n==1
    move2 = move2{1};
end
end