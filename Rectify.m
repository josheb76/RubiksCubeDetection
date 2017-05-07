function [ imRectified ] = Rectify( im, faceCorners )

dim = max(size(im));

%https://www.mathworks.com/matlabcentral/answers/69442-stretch-quadrilateral-roi-to-pre-definded-rectangle-size
tform = cp2tform(faceCorners,[1 1; dim 1; 1 dim; dim dim],'projective');
imRectified = imtransform(im,tform,'XData',[1 dim],'YData',[1 dim],'XYScale',[1 1]);

% figure
% subplot(1,2,1), imshow(im)
% subplot(1,2,2), imshow(imRectified)

end