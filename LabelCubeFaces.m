function [R] = LabelCubeFaces(faceImages, numColorClusters)

warning('off','MATLAB:colon:nonIntegerIndex')

numFaces = 6;
R = zeros(3, 3, numFaces); 

minCol = inf;
maxCol = eps;
for x=1:numFaces
    img = faceImages{x};
    %img = imcrop(img, [102 0 size(img,2)-205 size(img,1)]);
    [col_, row_, chan_] = size(img);
    if col_ < minCol 
        minCol = col_;
    elseif col_ > maxCol 
        maxCol = col_;
    end
end

colAvg = (minCol + maxCol) / 2;
imgAppend = [];
sections = zeros(6,4);
xpix = 1;
ypix = 1;
for x=1:numFaces
    img = faceImages{x};
    imgR = imresize(img, colAvg/size(img,1));
    sections(x,:) = [xpix, ypix, size(imgR,1), (ypix-1)+size(imgR,2)];
    ypix = ypix + size(imgR,2);
    imgAppend = [imgAppend imgR];
end

LAB = rgb2lab(imgAppend);
L = LAB(:,:,1)/100;
Sc = 2;
LAB(:,:,1) = adapthisteq(L,'NumTiles',...
                         [Sc Sc],'ClipLimit',0.005)*100;
imgAppend = lab2rgb(LAB);

%imshow(imgAppend);
[imgIndAll, colorMap] = rgb2ind(imgAppend, numColorClusters, 'nodither'); % 8 colors per RGB channel (512 = 8^3)
imgQuant = uint8(ind2rgb(imgIndAll, colorMap)*255);
%figure(3), imshow(imgAppend);
%figure(4), imshow(imgQuant);

labelMatrix = zeros(3, 3, numFaces);
hsvMatrix = zeros(3*numFaces, 3, 3);

for y=1:numFaces
    imgQuantHSV = rgb2hsv(imgQuant(sections(y,1):sections(y,3), sections(y,2):sections(y,4), :));
    %figure(3+y), imshow(imgQuant(sections(y,1):sections(y,3), sections(y,2):sections(y,4), :));
    [col, row, chan] = size(imgQuantHSV);
    imgInd = imgIndAll(sections(y,1):sections(y,3), sections(y,2):sections(y,4));
    xStep = col / 3;
    yStep = row / 3;
    xOff = xStep / 2;
    for i=1:3
        yOff = yStep / 2;
        for j=1:3
           sectionLabels = imgInd((xOff-(xStep/2)+1):(xOff+(xStep/2)), (yOff-(yStep/2)+1):(yOff+(yStep/2)));
           labelMatrix(j,i,y) = mode(mode(sectionLabels, 2)); % j first, then i for label reshape
           sectionHSV = imgQuantHSV((xOff-(xStep/2)+1):(xOff+(xStep/2)), (yOff-(yStep/2)+1):(yOff+(yStep/2)), :);
           hsvMatrix(i+(y-1)*3,j,:) = mode(mode(sectionHSV, 2));
           yOff = yOff + yStep;
        end
        xOff = xOff + xStep;
    end
    
    H1D = reshape(hsvMatrix(:,:,1)', [1 size(hsvMatrix,2)*size(hsvMatrix,1)]);
    S1D = reshape(hsvMatrix(:,:,2)', [1 size(hsvMatrix,2)*size(hsvMatrix,1)]);
    V1D = reshape(hsvMatrix(:,:,3)', [1 size(hsvMatrix,2)*size(hsvMatrix,1)]);
    %L1D = reshape(labelMatrix, [1 size(labelMatrix,3)*size(labelMatrix,2)*size(labelMatrix,1)]);
    X = [H1D; S1D; V1D];% L1D];
    
    [idx, ~] = kmeans(X',6);
    
    for i=1:6 
        R(:, :, i) = reshape(idx((1+(i-1)*9):(9+(i-1)*9)), [3, 3])'; 
    end
end

warning('on','MATLAB:colon:nonIntegerIndex')

end

