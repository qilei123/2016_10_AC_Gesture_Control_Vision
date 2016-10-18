clear cam;
cam = webcam();
runLoop = 0;
figure;
while runLoop < 1000
    videoFrame = snapshot(cam);
    [out bin] = generate_skinmap(videoFrame);
    L = bwlabeln(bin, 8);
    S = regionprops(L, 'Area');
    P = 1000;
    bw2 = ismember(L, find([S.Area] >= P));
    L2 = bwlabeln(bw2, 8);
    S2 = regionprops(L2);
    STATS = regionprops(L2,'Centroid','MajorAxisLength','MinorAxisLength');
    %imshow(img_orig);
    %imshow(out);
    imshow(bw2);
    runLoop = runLoop+1;
end

clear cam;