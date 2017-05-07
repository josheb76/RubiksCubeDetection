function R = rubrot(R,varargin)
%
% Syntax R = rubrot(R,move)
% move is a string: move = [dir,i,n], e.g. move = 'x11'.
% Twists a rubiks cube R in direction dir, row i, n times 90 degrees. 
% 'R' must be a dxdx6 matrix representing the 6-faced dxdxd cube.
% 'dir' must be a string: 'x', 'y' or 'z', representing the axis around which
% the rotation takes place.
% 'i' = 0,1,...,d determines the i-th row that is rotated.
% 'n' = 0,1,...,4 determines the number of rotations, 4 being the same as 0
% because of symmetry. Animation can be toggled on by setting rubrot(R,move,'Animation',1). This
% is the same as calling rubplot(R,move).

d = size(R,1);
temp = ceil(log(d+1)/log(10))+2;

if nargin==2 || nargin==4
    move = varargin{1};
    if iscell(move)
        test = cell2mat(move);
    else 
        test = move;
    end
    if nargin==4 && (strcmpi(varargin{2},'animate') && varargin{3} == 1)
        if ~any(test=='x') && ~any(test=='y') && ~any(test=='z')
            move = rub2move(move,d);
        end
        R = rubplot(R,move);
        return
    else
        if iscell(move)
            for i = 1:numel(move)
                R = rubrot(R,move{i});
            end
            return
        end
        if any(move(1)=='FBLRUDfblrud')
            move = rub2move(move,d);
        end
        dir =move(1);
        i = str2double(move(2:end-1));
        n = str2double(move(end));
    end
elseif nargin~=1
    error('Invalid input')
end

if size(R,1)~=size(R,2) || size(R,3)~=6
    error('R must be dxdx6')
end
if min(i)<=0 || max(i)>size(R,1)
    error('This row does not exist, your cube is %dx%d.',size(R,1),size(R,1))
end
if n<0 || n>4
    error('n must lie between 0 and 4')
end

A = R(:,:,1); AT = A';
B = R(:,:,2); BT = B';
C = R(:,:,3); CT = C';
D = R(:,:,4); DT = D';
E = R(:,:,5); ET = E';
F = R(:,:,6); FT = F';

x = [E,BT(end:-1:1,:),F(end:-1:1,end:-1:1),DT(:,end:-1:1)];
y = [AT(:,end:-1:1),ET(:,end:-1:1),CT(end:-1:1,:),FT(:,end:-1:1)];
z = [A B C D]; z = z(:,end:-1:1);

switch dir
    case 'x'
        temp = [x(i,:) x(i,:)];
        temp = temp(d*n+1:d*(n+4));
        x(i,:) = temp;
        
        E = x(:,1:d);
        B = x(:,d+1:2*d);
        B = B(end:-1:1,:)';
        F = x(:,2*d+1:3*d);
        F = F(end:-1:1,end:-1:1);
        D = x(:,3*d+1:end);
        D = D(:,end:-1:1)';
        
        if i==1
            for j = 1:n
                C = CT(:,end:-1:1);
                CT= C';
            end
        elseif i==d
            for j = 1:n
                A = A(:,end:-1:1)';
            end
        end
            
    case 'y'
        temp = [y(i,:) y(i,:)];
        temp = temp(d*n+1:d*(n+4));
        y(i,:) = temp;
        
        A = y(:,1:d);
        A = A(:,end:-1:1)';
        E = y(:,d+1:2*d);
        E = E(:,end:-1:1)';
        C = y(:,2*d+1:3*d);
        C = C(end:-1:1,:)';
        F = y(:,3*d+1:end);
        F = F(:,end:-1:1)';
        
        if i==1
            for j = 1:n
                D = DT(:,end:-1:1);
                DT= D';
            end
        elseif i==d
            for j = 1:n
                B = B(:,end:-1:1)';
            end
        end
        
    case 'z'
        temp = [z(i,:) z(i,:)];
        temp = temp(d*n+1:d*(n+4));
        z(i,:) = temp;
        z = z(:,end:-1:1);
        
        A = z(:,1:d);
        B = z(:,d+1:2*d);
        C = z(:,2*d+1:3*d);
        D = z(:,3*d+1:end);
        
        if i==1
            for j = 1:n
                E = E(:,end:-1:1)';
            end
        elseif i==d
            for j = 1:n
                F = FT(:,end:-1:1);
                FT= F';
            end
        end
        
    otherwise
        error('Invalid direction')
end

R = cat(3,A,B,C,D,E,F);

end

