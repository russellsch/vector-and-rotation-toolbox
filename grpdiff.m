function [p_CB, s] = grpdiff(p_CA, p_BA, varargin)

% grperr
% 
%   theta = grpdiff(p_CA, p_BA)
%   theta = grpdiff(p_CA, p_BA, a)
%   theta = grpdiff(p_CA, p_BA, a, f)
%   theta = grpdiff(p_CA, p_BA, a, f, s)

% Copyright 2016 An Uncommon Lab

%#codegen

    n = size(p_CA, 2);
    if isempty(coder.target)
        [p_CB, s] = grpcomp(p_CA, -p_BA, varargin{:});
    else
        p_CB = zeros(3, n, class(p_CA));
        if length(varargin) >= 3
            s = varargin{3};
            for k = 1:n
                p_CB(:,k) = grpcomp(p_CA(:,k), -p_BA(:,k), ...
                                    varargin{1:2}, s(k));
            end
        else
            for k = 1:n
                p_CB(:,k) = grpcomp(p_CA(:,k), -p_BA(:,k), varargin{:});
            end
            if nargout >= 2
                s = false(1, n);
            end
        end
    end
    
end % grpdiff
