clear all
close all
clc

disp('Getting input images...')
[inputImages, faceCorners, faceImages] = GetImages();

disp('Clustering colors...')
tic
for i=9:20
    R = LabelCubeFaces(faceImages,i);
    try
        sol = Thistlethwaite45(R);
        break
    catch
        %do nothing
    end
end
t=toc;

if exist('sol','var')
    disp(['Clustering converged at ',num2str(i),' colors and took ',num2str(t),' seconds to get there'])
    disp(sprintf(['To solve the cube, apply:\n',sol]))
    PlotCubeState(R)
else
    disp('No solution found')
end