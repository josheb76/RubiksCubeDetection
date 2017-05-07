function R = rubrot2(R,move,varargin)
%
% Rotates the entire cube, animation can be set to 1.

R1 = R;
DefaultCam = [33.12 11.73 10.74];

% if strcmp(get(gcf,'Name'),'Rubik')
%     campos = get(gca,'CameraPosition');
% else
%     campos = DefaultCam;
%     set(gcf,'Name','Rubik')
% end

map =   [255   0   0;...          %red
           0   0 255;...          %blue    
         255 165   0;...          %orange  
           0 255   0;...          %green
         255 255 255;...          %white
         255 255   0]./255;       %yellow

d = size(R,1);

if nargin > 2
    if strcmpi(varargin{1},'animate') && varargin{2} == 1
        animate = 1;
    else
        animate = 0;
    end
else 
    animate = 0;
end

if iscell(move)
    n = numel(move);
    for i=1:n
        R = rubrot2(R,move{i},'animate',animate);
    end
    return
end

for i=1:d
    x = [move(1) num2str(i) move(2)];
    R = rubrot(R,x);
end

num = str2double(move(2));
dir = double(move(1))-119;

if animate && num~=0
    RM{1} = @(x)([1 0 0;0 cos(x) -sin(x);0 sin(x) cos(x)]);
    RM{2} = @(x)([cos(x) 0 sin(x);0 1 0;-sin(x) 0 cos(x)]);         
    RM{3} = @(x)([cos(x) -sin(x) 0;sin(x) cos(x) 0;0 0 1]);

    angle = [pi/2 pi -pi/2 0]; 
    step = 3*[1 2 1];
    step  = step(num);
    angle = angle(num)/step;  

    S = rubcoord(d);
    for frame = 1:step        
        hold off
        for i=1:6
            s = S(:,:,i);
            for j = 1:d^2
                s{j} = (RM{dir}(angle)*s{j}')';
                r = R1(:,:,i);
                fill3(s{j}(:,1),s{j}(:,2),s{j}(:,3),map(r(j),:))
                hold on
            end
            S(:,:,i) = s;
        end
        axis([-1 1 -1 1 -1 1]*d/sqrt(2))
        set(gca,'CameraPosition',campos)
        axis off
        axis square
        hold off        
        pause(0.01)
    end
end
end


function S = rubcoord(d)
%
% Returns the vertex coordinates of each patch that makes up the cube (in
% correct order to be compatible with the fill-function.
%

S = cell(d,d,6);
faces = 'ABCDEF';

for i = 1:6                 %for all faces
    s = S(:,:,i);
    c = zeros(4,3);
    face = faces(i);
    switch face
        case 'A'
            c(:,1) = d;
            for j = 1:d^2
                s{j} = c;
                s{j}(:,2) = [0 0 1 1] + (ceil(j/d)-1);
                s{j}(:,3) = [d d-1 d-1 d] - mod(j-1,d);
                s{j} = s{j}-d/2;
            end
        case 'B'
            c(:,2) = d;
            for j = 1:d^2
                s{j} = c;
                s{j}(:,3) = [d d-1 d-1 d] - mod(j-1,d);
                s{j}(:,1) = [d d d-1 d-1] - (ceil(j/d)-1);
                s{j} = s{j}-d/2;
            end  
        case 'C'
            c(:,1) = 0;
            for j = 1:d^2
                s{j} = c;
                s{j}(:,2) = [d d d-1 d-1] - (ceil(j/d)-1);
                s{j}(:,3) = [d d-1 d-1 d] - mod(j-1,d);   
                s{j} = s{j}-d/2;
            end
        case 'D'
            c(:,2) = 0;
            for j = 1:d^2
                s{j} = c;
                s{j}(:,3) = [d d-1 d-1 d] - mod(j-1,d);
                s{j}(:,1) = [0 0 1 1] + (ceil(j/d)-1);
                s{j} = s{j}-d/2;
            end
        case 'E'
            c(:,3) = d;
            for j = 1:d^2
                s{j} = c;
                s{j}(:,2) = [0 0 1 1] + (ceil(j/d)-1);
                s{j}(:,1) = [0 1 1 0] + mod(j-1,d);
                s{j} = s{j}-d/2;
            end
        case 'F'
            c(:,3) = 0;
            for j = 1:d^2
                s{j} = c;
                s{j}(:,2) = [0 0 1 1] + (ceil(j/d)-1);
                s{j}(:,1) = [d d-1 d-1 d] - mod(j-1,d);
                s{j} = s{j}-d/2;
            end
    end
    S(:,:,i) = s;
end

end
