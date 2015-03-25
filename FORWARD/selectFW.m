function fw = selectFW(param)
% select Forward models
% input:
    % param: parameters provided by users
% output: 
    % fw: an object of FW subclass
switch param.model
    case 'Saetrom'
        fw = Saetrom(param);
    %add your own class
    otherwise
        error('foward model does not exist');
end
end