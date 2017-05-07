function [ sol ] = Thistlethwaite45( R )

%Credit for Thistlethwaite 45 implementation:
%https://www.mathworks.com/matlabcentral/fileexchange/31672-rubik-s-cube-simulator-and-solver
%
% 1 (front) - red
% 2 (right) - blue
% 3 (back)  - orange
% 4 (left)  - green
% 5 (up)    - white
% 6 (down)  - yellow
%
%         .-------.
%         | W W W |
%         | W W W |
%         | W W W |
% .-------.-------.-------.-------.
% | G G G | R R R | B B B | O O O |
% | G G G | R R R | B B B | O O O |
% | G G G | R R R | B B B | O O O |
% .-------.-------.-------.-------.
%         | Y Y Y |
%         | Y Y Y |
%         | Y Y Y |
%         .-------.

addpath('thistlethwaite45_src');

% %test scramble
% %R' U F' L2 R U
% R=zeros(3,3,6,'uint8');
% R(:,:,1)=[6 6 1; 3 1 1; 4 1 1];
% R(:,:,2)=[2 4 2; 2 2 3; 2 2 3];
% R(:,:,3)=[3 4 4; 5 3 2; 5 3 2];
% R(:,:,4)=[3 5 4; 3 4 4; 3 1 1];
% R(:,:,5)=[6 6 5; 2 5 5; 1 1 5];
% R(:,:,6)=[5 4 6; 5 6 6; 6 6 4];

solCell = Solve45(R);
sol = [sprintf('%s, ',solCell{1:end-1}),solCell{end}];

end