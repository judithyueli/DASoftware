function kernel = getKernel(param)
% Interpret user specified kernel parameter into a function handle
% INPUT:
% param: structure with subfield
%        cov_type
%        cov_power
%        cov_len
% OUTPUT:
% kernel: function handle

	if isfield(param,'cov_type')
		switch param.cov_type
			case 'gaussian'
				if isfield(param,'cov_len')
					l = param.cov_len;
					kernel = @(h) exp(-(h./l).^2);
				else
					error('cannot find lenghth scale parameter cov_len')
				end
			case 'exponential'
				if isfield(param,'cov_power') && isfield(param,'cov_len')
					p = param.cov_power;
					l = param.cov_len;
					kernel = @(h) exp(-(h./l).^p);
				else
					error('cannot find lenghth scale and power parameter cov_len and cov_power')
				end
			otherwise
				error('not a valid kernel type')
        end
    else
        disp('No Kernel input')
        kernel = [];
    end
end