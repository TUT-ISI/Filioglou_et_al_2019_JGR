function [d] = SpherConv (Cord,unLAT,unLON)

% Radius of Earth
R = 6371; % km

d(1:length(unLAT)) = NaN;
for i=1:length(unLAT)
dLat = (unLAT(i)-Cord(1))*pi/180;
dLon = (unLON(i)-Cord(2))*pi/180;
a = sin(dLat/2)^2 + cos(Cord(1)*pi/180)*cos(unLAT(i)*pi/180)*sin(dLon/2)^2;
c = 2*atan2(sqrt(a), sqrt(1-a));
d(i) = R*c;
end

