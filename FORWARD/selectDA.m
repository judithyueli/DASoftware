function da = selectDA(param,fw)
% select DA methods
% input:
    % fw: an object of FW subclass
    % param: parameters provided by users
% output: 
    % da: an object of DA subclass
switch param.method
    case 'KF'
        da = KF(param,fw);
    case 'CSKF'
        da = CSKF(param,fw);
    %case 'SpecKF'
    %    da = SpecKF(param,fw);
    otherwise %add your own method class
        error('method does not exit');
end
end