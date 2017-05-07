function C = GetCorners(R,varargin)
%
% This function is used to aquire the Corner Orientation/Permuation of a
% 3x3x3 cube.
%
if nargin==1
    Co = GetOrientation(R);
    Cp = GetPermutation(R);
    C = [Cp;Co];
elseif varargin{1}=='O'
    C = GetOrientation(R);
elseif varargin{1}=='P'
    C = GetPermutation(R);
end


function Co = GetOrientation(R)

Co = zeros(1,8);
right = R(2,2,2);
left = R(2,2,4);
x = [1 3 1;... facelets to check in order to determine orientation
     1 3 6;...
     1 3 5;...
     3 1 3;...
     1 3 3;...
     3 1 6;...
     3 1 5;...
     3 1 1];
t = 1;
for i = [2,4]
    A = R(:,:,i);
    for j = [1 3 7 9];
        if A(j)~=right && A(j)~=left
            if R(x(t,1),x(t,2),x(t,3))==right || R(x(t,1),x(t,2),x(t,3))==left
                Co(t) = 1;
            else
                Co(t) = 2;
            end
        end
        t = t+1;
    end
end

%use Thistlethwaite's numbering of corners
p = [5 8 4 1 7 6 2 3];
Co = Co(p);

function Cp = GetPermutation(R)

%Corners on current cube (Thisthlethwaite's order)
x = [R(1,1,5) R(1,1,4) R(1,3,3);... %ULB
     R(1,1,6) R(3,3,4) R(3,1,1);... %DLF
     R(3,3,6) R(3,3,2) R(3,1,3);... %DRB
     R(3,3,5) R(1,1,2) R(1,3,1);... %URF

     R(3,1,5) R(1,3,4) R(1,1,1);... %ULF
     R(3,1,6) R(3,1,4) R(3,3,3);... %DLB
     R(1,3,6) R(3,1,2) R(3,3,1);... %DRF
     R(1,3,5) R(1,3,2) R(1,1,3)];   %URB

%Corners on solved cube 
y = [R(2,2,5) R(2,2,4) R(2,2,3);... %ULB
     R(2,2,6) R(2,2,4) R(2,2,1);... %DLF
     R(2,2,6) R(2,2,2) R(2,2,3);... %DRB
     R(2,2,5) R(2,2,2) R(2,2,1);... %URF

     R(2,2,5) R(2,2,4) R(2,2,1);... %ULF
     R(2,2,6) R(2,2,4) R(2,2,3);... %DLB
     R(2,2,6) R(2,2,2) R(2,2,1);... %DRF
     R(2,2,5) R(2,2,2) R(2,2,3)];   %URB
 
x = sort(x,2);
y = sort(y,2);
Cp = zeros(1,8);
 
for i=1:8
    Cp(i)= find(y(:,1)==x(i,1) & y(:,2)==x(i,2) & y(:,3)==x(i,3));
end
