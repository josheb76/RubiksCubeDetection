function E = GetEdges(R,varargin)
%
% Finds the Edge Orientation/Permuation of a 3x3x3 cube
%
if nargin==1
    Eo = GetOrientation(R);
    Ep = GetPermutation(R);
    E = [Ep;Eo];
elseif varargin{1}=='O'
    E = GetOrientation(R);
elseif varargin{1}=='P'
    E = GetPermutation(R);
end


function Eo = GetOrientation(R)
%
% An Edge Piece is GOOD (1) in these 2 cases:
% 1) The front color belongs to F or B
% 2) The front color belongs to U or D && the side color to L or R
%

Rtemp = rubrot2(R,'z1');
Eo = zeros(1,12);
t  = 1;
A = [4,8;5,6;6,4;2,2];
for i=1:4
    Rtemp = rubrot2(Rtemp,'z3');
    F = Rtemp(:,:,1);
    B = Rtemp(2,2,3);
    L = Rtemp(2,2,4);
    R = Rtemp(2,2,2);
    U = Rtemp(2,2,5);
    D = Rtemp(2,2,6);
    for j=4:2:8
        if F(j)==F(2,2) || F(j)==B
            Eo(t) = 1;
        elseif F(j)==U || F(j)==D
            Q = Rtemp(:,:,A(j/2,1));
            Q = Q(A(j/2,2));
            if Q==L || Q==R
                Eo(t) = 1;
            end
        end
        t = t+1;
    end
end

%Use numbering as in Thistlethwaite's convention
p = [10 11 4 5 9 12 3 6 1 2 8 7];
Eo = Eo(p);

function Ep = GetPermutation(R)

%Edges on current cube (Thistlethwaite's order of edges)
x = ... %FB-slice
    [R(1,2,4) R(2,1,5);... %LU
     R(3,2,4) R(2,1,6);... %LD
     R(1,2,2) R(2,3,5);... %RU
     R(3,2,2) R(2,3,6);... %RD
        %UD-slice
     R(2,1,4) R(2,3,3);... %LB
     R(2,3,4) R(2,1,1);... %LF
     R(2,1,2) R(2,3,1);... %RF
     R(2,3,2) R(2,1,3);... %RB
        %LR-slice
     R(1,2,1) R(3,2,5);... %FU
     R(3,2,1) R(1,2,6);... %FD
     R(3,2,3) R(3,2,6);... %BD
     R(1,2,3) R(1,2,5)];   %BU
 
%Edges on solved cube 
y =  ... %FB-slice
    [R(2,2,4) R(2,2,5);... %LU
     R(2,2,4) R(2,2,6);... %LD
     R(2,2,2) R(2,2,5);... %RU
     R(2,2,2) R(2,2,6);... %RD
        %UD-slice
     R(2,2,4) R(2,2,3);... %LB
     R(2,2,4) R(2,2,1);... %LF
     R(2,2,2) R(2,2,1);... %RF
     R(2,2,2) R(2,2,3);... %RB
        %LR-slice
     R(2,2,1) R(2,2,5);... %FU
     R(2,2,1) R(2,2,6);... %FD
     R(2,2,3) R(2,2,6);... %BD
     R(2,2,3) R(2,2,5)];   %BU
 
 x = sort(x,2);
 y = sort(y,2);
 Ep = zeros(1,12);
 
 for i=1:12
     Ep(i)= find(y(:,1)==x(i,1) & y(:,2)==x(i,2));
 end

     
