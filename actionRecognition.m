function action = actionRecognition(handTraceQueue)
unknownActionID = 6;
turnOnActionID =0;
turnOffActionID =-1;
leftActionID = 3;
rightActionID = 4;
upActionID = 1;
downActionID = 2;

action = unknownActionID;

checktime = 1; %check 1 the trace in 1 seconds
minlength = 7; %check at least traces
%if there are less than minlength traces in the queue, do not check
if handTraceQueue.size() < minlength
    action = unknownActionID;
    return;
end
[corners times fieldsArea diagonallength] = TransFromQueue(handTraceQueue);

x = corners(:,1);
y = corners(:,2);
%minboundcircle
[c,r] = minboundcircle(double(x),double(y),false);

[p s] = polyfit(x,y,1);
%thread for the angle of line
threadAngleOfLine1 = tan(pi/6);
threadAngleOfLine2 = tan(pi/3);
%thread for the radio of circle
threadRadio = 40;
%thread for the diagonallength
ThreaddiagonallengthOn = 30;
%thread for the diagonallength
ThreaddiagonallengthOff =30;
%thread for left or right
threadForLR = 120;

lengthOfTraces = length(diagonallength);
%check turnOnAction
if r<threadRadio
    if diagonallength(lengthOfTraces)-diagonallength(1)>ThreaddiagonallengthOn
        action = turnOnActionID;
        
    end
end

%check turnOnAction
if r<threadRadio
    if diagonallength(lengthOfTraces)-diagonallength(1)<-ThreaddiagonallengthOff
        action = turnOffActionID;
    end
end

%check leftAction
if abs(p(1))<threadAngleOfLine1
    if corners(lengthOfTraces,1) - corners(1,1) >  threadForLR
        action = leftActionID;
    end
end

%check rightAction
if abs(p(1))<threadAngleOfLine1
    if corners(lengthOfTraces,1) - corners(1,1) < -threadForLR
        action = rightActionID;
    end
end

%check downAction
if abs(p(1))>threadAngleOfLine2
    if corners(lengthOfTraces,2) - corners(1,2) >  threadForLR
        action = downActionID;
    end
end

%check upAction
if abs(p(1))>threadAngleOfLine2
    if corners(lengthOfTraces,2) - corners(1,2) < -threadForLR
        action = upActionID;
    end
end

clear corners times fieldArea x y;
end

function [corners times fieldsArea diagonallength] = TransFromQueue(handTraceQueue)
 Traces = handTraceQueue.content();
 for i=1:length(Traces)
     trace = Traces{i};
     times(i) = trace.time;
     x = (trace.bboxPoints(1,1)+trace.bboxPoints(3,1))/2;
     y = (trace.bboxPoints(1,2)+trace.bboxPoints(3,2))/2;
     corners(i,:) = [floor(x) floor(y)];
     bps = trace.bboxPoints;
     fieldsArea(i) = sqrt((bps(1,1)-bps(2,1))*(bps(1,1)-bps(2,1))+(bps(1,2)-bps(2,2))*(bps(1,2)-bps(2,2)))*sqrt((bps(1,1)-bps(4,1))*(bps(1,1)-bps(4,1))+(bps(1,2)-bps(4,2))*(bps(1,2)-bps(4,2)));     
     diagonallength(i) = sqrt((bps(1,1)-bps(3,1))*(bps(1,1)-bps(3,1))+(bps(1,2)-bps(3,2))*(bps(1,2)-bps(3,2)));
 end 
end