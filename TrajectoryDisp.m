function [ ] = TrajectoryDisp( filepath )
%TRAJECTORYDISP 此函数用于打印由上位机测试平台输出文件中的加工轨迹
%   此处显示详细说明
data = importdata(filepath);
[length,~] = size(data);
figure(1);
h = waitbar(0, 'Please wait...');
for i = 1:length-1
    waitbar(i/length); 
    startpoint = data(i,3:5);
    endpoint = data(i+1,3:5);
    if (data(i+1,2) == 10) || (data(i+1,2) == 0),
        plot([startpoint(1),endpoint(1)],[startpoint(2),endpoint(2)]);
        hold on
    elseif (data(i+1,2) == 30 || data(i+1,2) == 20) %逆时针画圆弧
        center = data(i+1,6:8);%圆心位置
        R = data(i+1,9); %圆弧半径
        angle = data(i+1,10) * pi / 180;%圆弧张角
        startpoint_direct = startpoint - center;
        start_angle = acos((startpoint_direct * [1 0 0]') / norm(startpoint_direct)) ;
        if cross([1 0 0],startpoint_direct) * [0 0 1]' < 0, start_angle = 2 * pi - start_angle;end
        for j = 0:angle/1000:angle
            if data(i+1,2) == 30, 
                next_angle = start_angle + j; 
            elseif data(i+1,2) == 20
                next_angle = start_angle - j; 
            end
            arc = center + R * [cos(next_angle), sin(next_angle),0];
            plot(arc(1),arc(2));
            hold on
        end
    end
end
close(h);
axis equal
end

