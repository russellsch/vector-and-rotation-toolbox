function q = ea2q(ea, seq)

% ea2q

% Copyright 2016 An Uncommon Lab

%#codegen

    % Default to the aerospace sequence.
    if nargin < 2, seq = [3 2 1]; end;
    
    % Check dims and make sure it's a valid Euler angle sequence.
    assert(size(ea, 1) == 3, ...
           '%s: The Euler angles must be 3-by-n.', mfilename);
    assert(size(seq, 1) == 1 && size(seq, 2) == 3, ...
           '%s: The Euler angle rotation sequence must be 1-by-3.', ...
           mfilename);
    assert(seq(1) ~= seq(2) && seq(2) ~= seq(3), ...
           ['%s: The Euler angle sequence cannot repeat rotations ' ...
            'about the same axis.'], mfilename);

    % Determine signs.
    i = seq(1);
    j = seq(2);
    if    (i == 1 && j == 2) ...
       || (i == 2 && j == 3) ...
       || (i == 3 && j == 1)
        alpha = 1;
    else
        alpha = -1;
    end
    
    % Preallocate.
    n = size(ea, 2);
    q = zeros(4, n, class(ea));
    
    % If symmetric...
    if seq(1) == seq(3)
       
        % Determine the other axis.
        if (i == 1 && j == 2) || (i == 2 && j == 1)
            k = 3;
        elseif (i == 1 && j == 3) || (i == 3 && j == 1)
            k = 2;
        else
            k = 1;
        end
        
        a = cos(0.5*ea(2,:));
        q(i,:) =         a .* sin(0.5*(ea(1,:) + ea(3,:)));
        q(4,:) =         a .* cos(0.5*(ea(1,:) + ea(3,:)));
        a = sin(0.5*ea(2,:));
        q(j,:) =         a .* cos(0.5*(ea(1,:) - ea(3,:)));
        q(k,:) = alpha * a .* sin(0.5*(ea(1,:) - ea(3,:)));
    
    % Otherwise, must be asymmetric.
    else
        
        k = seq(3);
            
        cphi   = cos(0.5*ea(1,:));
        ctheta = cos(0.5*ea(2,:));
        cpsi   = cos(0.5*ea(3,:));

        sphi   = sin(0.5*ea(1,:));
        stheta = sin(0.5*ea(2,:));
        spsi   = sin(0.5*ea(3,:));
        
        q(i,:) = cpsi .* ctheta .* sphi + alpha * spsi .* stheta .* cphi;
        q(j,:) = cpsi .* stheta .* cphi - alpha * spsi .* ctheta .* sphi;
        q(k,:) = spsi .* ctheta .* cphi + alpha * cpsi .* stheta .* sphi;
        q(4,:) = cpsi .* ctheta .* cphi - alpha * spsi .* stheta .* sphi;
        
    end
    
end % ea2q
