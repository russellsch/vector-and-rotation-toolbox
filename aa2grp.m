function [p, s] = aa2grp(r, theta, a, f)

% aa2grp

% Copyright 2016 An Uncommon Lab

%#codegen

    % Set defaults so that for small angles, the GRPs will approach the 
    % rotation vector.
    if nargin < 3 || isempty(a), a = 1;       end;
    if nargin < 4 || isempty(f), f = 2*(a+1); end;

    % Check dimensions.
    assert(nargin >= 2, ...
           '%s: At least two inputs are required.', mfilename);
    assert(size(r, 1) == 3, ...
           '%s: The axes must be 3-by-n.', mfilename);
    assert(size(r, 2) == size(theta, 2), ...
           ['%s: The number of input axes must match the number of ' ...
            'input angles.'], mfilename);
    assert(all(size(a) == 1 & size(f) == 1), ...
           '%s: The ''a'' and ''f'' factors must be scalars.');

    % If running in regular MATLAB, vectorize.
    if isempty(coder.target)

        % Use a special form if possible. Otherwise, go through the 
        % quaternion (still plenty fast).
        % TODO: a == 0?
        if a == 1
            p = bsxfun(@times, tan(0.25 * theta), r);
            if f ~= 1
                p = f * p;
            end
            s = theta > pi | theta < -pi;
        else
            [p, s] = q2grp(aa2q(r, theta), a, f);
        end
            
    % Otherwise, write the loops.
    else

        n = size(r, 2);
        p = zeros(3, n, class(theta));
        s = false(1, n);
        
        % Use a special form if possible. Otherwise, go through the 
        % quaternion (still plenty fast).
        % TODO: a == 0?
        if a == 1
            for k = 1:n
                p(:,k) = tan(0.25 * theta(k)) * r(:,k);
                s(k) = theta(k) > pi || theta(k) < -pi;
            end
            if f ~= 1
                p = f * p;
            end
        else
            for k = 1:n
                [p(:,k), s(:,k)] = q2grp(aa2q(r(:,k), theta(k)), a, f);
            end
        end

    end

end % aa2grp
