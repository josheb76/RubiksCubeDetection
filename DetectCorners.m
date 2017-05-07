function [ faceCorners ] = DetectCorners(im)
 
F1 = [-1 -1 -1 -1 -1 -1 -1;
     -1 +1 +1 +1 +1 +1 -1;
     -1 +1 +1 +1 +1 +1 -1;
     -1 +1 +1 +1 +1 +1 -1;
     -1 +1 +1 +1 +1 +1 -1;
     -1 -1 -1 -1 -1 -1 -1];
F2 = F1';

BW1 = imfilter(rgb2gray(im), F1);
BW2 = imfilter(rgb2gray(im), F2);
BW = (BW1 + BW2) / 2;

% Create a binary image.
BW = im2bw(BW, 0.01);
edge = 4;
BW = imcrop(BW, [edge edge size(BW,2)-2*edge size(BW,1)-2*edge]); 

%Create the Hough transform using the binary image.
[H,T,R] = hough(BW);
% imshow(H,[],'XData',T,'YData',R,'InitialMagnification','fit');
% xlabel('\theta'), ylabel('\rho');
% axis on, axis normal, hold on;

%Find peaks in the Hough transform of the image.
P = houghpeaks(H,40,'threshold',ceil(0.15*max(H(:))));
x = T(P(:,2)); y = R(P(:,1));
%plot(x,y,'s','color','white');

%Find lines
lines = houghlines(BW,T,R,P);
ptsA = reshape([lines.point1],[2,size(lines,2)])';
ptsB = reshape([lines.point2],[2,size(lines,2)])';
thetas = [lines.theta]';

% %Plot lines on image
% figure, imshow(im), hold on
% for k = 1:length(lines)
%    xy = [lines(k).point1; lines(k).point2];
%    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
%    plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
%    plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
% end

%find angle with most matches
dThetaAllow = 3;
maxMatches = 0;
indMaxMatches = 0;
for i=-30:30
    inds1 = thetas>(i-dThetaAllow) & thetas<(i+dThetaAllow);
    inds2 = ( thetas>(i+90-dThetaAllow) & thetas<(i+90+dThetaAllow) ) |...
            ( thetas>(i-90-dThetaAllow) & thetas<(i-90+dThetaAllow) );
    
    numMatches = sum(inds1) * sum(inds2);
    if numMatches > maxMatches
        maxMatches = numMatches;
        indMaxMatches = i;
    end
end

%find set1 (vertical), set2 (horizontal), thetas1, thetas2 for angle with max matches
combPts = [ptsA,ptsB];
inds1 = thetas>(indMaxMatches-dThetaAllow) & thetas<(indMaxMatches+dThetaAllow);
inds2 = ( thetas>(indMaxMatches+90-dThetaAllow) & thetas<(indMaxMatches+90+dThetaAllow) ) |...
        ( thetas>(indMaxMatches-90-dThetaAllow) & thetas<(indMaxMatches-90+dThetaAllow) );
set1 = combPts(inds1,:);
set2 = combPts(inds2,:);
%thetas1 = thetas(inds1,:);
%thetas2 = thetas(inds2,:);

%Plot relevent lines on image
figure(2), imshow(im), hold on
for k = 1:length(set1)
   xy = [set1(k,1:2); set1(k,3:4)];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
end
for k = 1:length(set2)
   xy = [set2(k,1:2); set2(k,3:4)];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','blue');
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
end

%find possible squares
maxEdgeLength = 0;
int1Best = zeros(1,2);
int2Best = zeros(1,2);
int3Best = zeros(1,2);
int4Best = zeros(1,2);
for s1l1_iter=1:sum(inds1)-1
    for s1l2_iter=s1l1_iter+1:sum(inds1)
        for s2l1_iter=1:sum(inds2)-1
            for s2l2_iter=s2l1_iter+1:sum(inds2)
                %get 4 lines
                s1l1 = set1(s1l1_iter,:);
                s1l2 = set1(s1l2_iter,:);
                s2l1 = set2(s2l1_iter,:);
                s2l2 = set2(s2l2_iter,:);
                
                %convert to ax+by+c=0 form
                s1l1_abc = cross([s1l1(1:2) 1],[s1l1(3:4) 1]);
                s1l2_abc = cross([s1l2(1:2) 1],[s1l2(3:4) 1]);
                s2l1_abc = cross([s2l1(1:2) 1],[s2l1(3:4) 1]);
                s2l2_abc = cross([s2l2(1:2) 1],[s2l2(3:4) 1]);
                
                %get intersection vectors
                int1v = cross(s1l1_abc,s2l1_abc);
                int2v = cross(s1l1_abc,s2l2_abc);
                int3v = cross(s1l2_abc,s2l1_abc);
                int4v = cross(s1l2_abc,s2l2_abc);
                
                %get intersections
                int1 = [int1v(1)/int1v(3), int1v(2)/int1v(3)];
                int2 = [int2v(1)/int2v(3), int2v(2)/int2v(3)];
                int3 = [int3v(1)/int3v(3), int3v(2)/int3v(3)];
                int4 = [int4v(1)/int4v(3), int4v(2)/int4v(3)];
                
                %compute distances from int1 to all other intersections
                d12 = sqrt((int1(1)-int2(1))^2+(int1(2)-int2(2))^2);
                d13 = sqrt((int1(1)-int3(1))^2+(int1(2)-int3(2))^2);
                d14 = sqrt((int1(1)-int4(1))^2+(int1(2)-int4(2))^2);
                dists = sort([d12 d13 d14]);
                
                %check if distances indicate a square (edges are equal and diagonal satisfies trig)
                edgeThresh = 5;
                edgeLength = mean( [dists(1),dists(2)] );
                if abs( dists(1)-dists(2) ) < edgeThresh ...
                        && abs( dists(3)-edgeLength*sqrt(2) ) < edgeThresh*sqrt(2)
                    if edgeLength > maxEdgeLength
                        maxEdgeLength = edgeLength;
                        int1Best = int1;
                        int2Best = int2;
                        int3Best = int3;
                        int4Best = int4;
                    end
                end
            end
        end
    end
end

%identify points
cornersUnsorted = [int1Best; int2Best; int3Best; int4Best];
[Y,I] = sort(cornersUnsorted(:,2));
I_u = I(1:2,:);
I_d = I(3:4,:);

[~,I_ul] = min(cornersUnsorted(I_u,1)); %up-left,    1
[~,I_ur] = max(cornersUnsorted(I_u,1)); %up-right,   2
[~,I_dl] = min(cornersUnsorted(I_d,1)); %down-left,  3
[~,I_dr] = max(cornersUnsorted(I_d,1)); %down-right, 4

faceCorners(1,:) = cornersUnsorted(I_u(I_ul),:);
faceCorners(2,:) = cornersUnsorted(I_u(I_ur),:);
faceCorners(3,:) = cornersUnsorted(I_d(I_dl),:);
faceCorners(4,:) = cornersUnsorted(I_d(I_dr),:);

orderedCorners(1,:) = faceCorners(1,:);
orderedCorners(2,:) = faceCorners(2,:);
orderedCorners(3,:) = faceCorners(4,:);
orderedCorners(4,:) = faceCorners(3,:);
orderedCorners(5,:) = faceCorners(1,:);
plot(orderedCorners(:,1), orderedCorners(:,2),'r-','LineWidth', 5)
plot(faceCorners(:,1), faceCorners(:,2),'k.','MarkerSize', 40)

end