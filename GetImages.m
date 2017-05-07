function [ inputImages, faceCorners, faceImages ] = GetImages()

cam = webcam(1);%webcam(length(webcamlist));
myfig = figure(1);
hImage = image(zeros(size(snapshot(cam))));
prevObject = preview(cam, hImage);
%prevObject.Parent.XDir='reverse';
prevObject.Parent.DataAspectRatio=[1 1 1];
prevObject.Parent.Position=[0 0 1 1];

i=1;
while i<=6
    %fprintf('looping\n');
    set(myfig,'Name',['Press any key to take/retake image ',num2str(i),'. Click to proceed.'])
    pause
    inputImages{i} = snapshot(cam);
    
    try 
        [faceCorners(:,:,i)] = DetectCorners(inputImages{i});
        faceImages{i} = Rectify(inputImages{i}, faceCorners(:,:,i));
        q = waitforbuttonpress;
        if q == 0
            i = i + 1;
        else
            %close figure 2
        end
    catch error
        %do nothing
    end
end

%cleanup
try
    closePreview(cam)
    close all force
    delete(cam)
catch
    %do nothing
end

end