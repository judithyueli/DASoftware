function Q0 = getQ(loc,kernelfun)
% Each column of loc saves the coordinates of each point
% For 2D cases, loc = [x y]
% For 3D cases, loc = [x y z]
% np: number of points
% nd: number of dimension
[np,nd] = size(loc);
h = zeros(np,np); % seperation between two points
for i = 1:nd
    xi = loc(:,i);
    [xj,xl]=meshgrid(xi(:),xi(:));
    h = h + ((xj-xl)).^2;
end
h = sqrt(h);
Q0 = kernelfun(h);
end
