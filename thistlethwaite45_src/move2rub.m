function move2 = move2rub(move,varargin)
%
% Converts a move to official Rubik's Code
% Input move must be a 3-character string: 'x11', or a cell containing
% strings of this form. Middle piece is not allowed to move -> 'x21' not
% permitted for d=3!
%

if nargin==2
    d = varargin{1};
else
    d = 3;
end

if ~ischar(move)
    n = numel(move); %number of moves to convert
    seq = move;
else 
    n = 1;
    seq{1} = move;
end

A = ['BLU';'blu';'frd';'FRD'];
B{1} = ['  ''';'  ''';''''' ';''''' '];
B{2} = ['222';'222';'222';'222'];
B{3} = [''''' ';''''' ';'  ''';'  '''];

for i=1:n    
    move = seq{i};
    x = double(move(1))-119;
    y = str2double(move(2));
    z = str2double(move(3));

    if move(3)=='0'
        move2{i} = '';
        continue
    end
    
    if y==2 && d==3
        error('Middle part is not allowed to move')
    elseif y==d
        y = 4;
    end
    move2{i}(1) = A(y,x);
    move2{i}(2) = B{z}(y,x);       
end

for i=1:numel(move2)
    move2{i}(move2{i}==' ')=[];
end

end
    